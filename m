From: Eddie Wai <eddie.wai@broadcom.com>
Subject: Re: [Open-FCoE] [PATCH] bnx2fc: Improve stats update mechanism
Date: Sat, 31 May 2014 05:13:11 +0000
Message-ID: <DBC33EB2-5AB1-4DFC-B7DE-EAAC47C0E978@broadcom.com>
References: <1401462115-8072-1-git-send-email-nhorman@tuxdriver.com>
 <1401487183.3956.28.camel@lbirv-waie-lx2.broadcom.com>,<20140531024754.GB27184@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:45626 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaEaFNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 May 2014 01:13:12 -0400
In-Reply-To: <20140531024754.GB27184@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>, "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On May 30, 2014, at 7:48 PM, "Neil Horman" <nhorman@tuxdriver.com> wrote:

> On Fri, May 30, 2014 at 02:59:43PM -0700, Eddie Wai wrote:
>> Thanks for fixing this.  The patch generally looks good, but I do have a
>> few comments.
>> 
>> On Fri, 2014-05-30 at 11:01 -0400, Neil Horman wrote:
>>> Recently had this warning reported:
>>> 
>>> [  290.489047] Call Trace:
>>> [  290.489053]  [<ffffffff8169efec>] dump_stack+0x19/0x1b
>>> [  290.489055]  [<ffffffff810ac7a9>] __might_sleep+0x179/0x230
>>> [  290.489057]  [<ffffffff816a4ad5>] mutex_lock_nested+0x55/0x520
>>> [  290.489061]  [<ffffffffa01b9905>] ? bnx2fc_l2_rcv_thread+0xc5/0x4c0 [bnx2fc]
>>> [  290.489065]  [<ffffffffa0174c1a>] fc_vport_id_lookup+0x3a/0xa0 [libfc]
>>> [  290.489068]  [<ffffffffa01b9a6c>] bnx2fc_l2_rcv_thread+0x22c/0x4c0 [bnx2fc]
>>> [  290.489070]  [<ffffffffa01b9840>] ? bnx2fc_vport_destroy+0x110/0x110 [bnx2fc]
>>> [  290.489073]  [<ffffffff8109e0cd>] kthread+0xed/0x100
>>> [  290.489075]  [<ffffffff8109dfe0>] ? insert_kthread_work+0x80/0x80
>>> [  290.489077]  [<ffffffff816b2fec>] ret_from_fork+0x7c/0xb0
>>> [  290.489078]  [<ffffffff8109dfe0>] ? insert_kthread_work+0x80/0x80
>>> 
>>> Its due to the fact that we call a potentially sleeping function from the bnx2fc
>>> rcv path with preemption disabled (via the get_cpu call embedded in the per-cpu
>>> variable stats lookup in bnx2fc_l2_rcv_thread.
>>> 
>>> Easy enough fix, we can just move the stats collection later in the function
>>> where we are sure we won't preempt or sleep.  This also allows us to not have to
>>> enable pre-emption when doing a per-cpu lookup, since we're certain not to get
>> You mean this allows us to not have to 'disable' pre-emption, right? 
>> 
>> Can you elaborate on how we can be sure that we won't get preempted
>> immediately after retrieving the CPU variable?  I would think it'll be
>> okay to call get_cpu at this stage as there won't be any sleepable mutex
>> lock calls before the put_cpu.
> We can't be sure, but I would assert it doesn't really matter at this point.
> The area in which we update stats is so small that, even if we do hit the
> unlikely chance that we get pre-empted, and then rescheduled on a different cpu,
> it won't matter.  We could add the get_cpu/put_cpu back if you're really intent
> on it, but I'm not sure its worthwhile given that this is a hot path.
I agree with your assessment.  But code wise just so bnx2fc is consistent to the software FCoE counterpart, I would advice to use the same get_cpu to retrieve that stats CPU variable.  Thanks.
> 
> Neil
> 
>>> rescheduled.
>>> 
>>> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
>>> CC: linux-scsi@vger.kernel.org
>>> CC: Robert Love <robert.w.love@intel.com>
>>> CC: Vasu Dev <vasu.dev@intel.com>
>>> ---
>>> drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 16 ++++------------
>>> 1 file changed, 4 insertions(+), 12 deletions(-)
>>> 
>>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>>> index 9b94850..475eee5 100644
>>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>>> @@ -516,23 +516,17 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
>>>    skb_pull(skb, sizeof(struct fcoe_hdr));
>>>    fr_len = skb->len - sizeof(struct fcoe_crc_eof);
>>> 
>>> -    stats = per_cpu_ptr(lport->stats, get_cpu());
>>> -    stats->RxFrames++;
>>> -    stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
>>> -
>>>    fp = (struct fc_frame *)skb;
>>>    fc_frame_init(fp);
>>>    fr_dev(fp) = lport;
>>>    fr_sof(fp) = hp->fcoe_sof;
>>>    if (skb_copy_bits(skb, fr_len, &crc_eof, sizeof(crc_eof))) {
>>> -        put_cpu();
>>>        kfree_skb(skb);
>>>        return;
>>>    }
>>>    fr_eof(fp) = crc_eof.fcoe_eof;
>>>    fr_crc(fp) = crc_eof.fcoe_crc32;
>>>    if (pskb_trim(skb, fr_len)) {
>>> -        put_cpu();
>>>        kfree_skb(skb);
>>>        return;
>>>    }
>>> @@ -544,7 +538,6 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
>>>        port = lport_priv(vn_port);
>>>        if (!ether_addr_equal(port->data_src_addr, dest_mac)) {
>>>            BNX2FC_HBA_DBG(lport, "fpma mismatch\n");
>>> -            put_cpu();
>>>            kfree_skb(skb);
>>>            return;
>>>        }
>>> @@ -552,7 +545,6 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
>>>    if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
>>>        fh->fh_type == FC_TYPE_FCP) {
>>>        /* Drop FCP data. We dont this in L2 path */
>>> -        put_cpu();
>>>        kfree_skb(skb);
>>>        return;
>>>    }
>>> @@ -562,7 +554,6 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
>>>        case ELS_LOGO:
>>>            if (ntoh24(fh->fh_s_id) == FC_FID_FLOGI) {
>>>                /* drop non-FIP LOGO */
>>> -                put_cpu();
>>>                kfree_skb(skb);
>>>                return;
>>>            }
>>> @@ -572,22 +563,23 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
>>> 
>>>    if (fh->fh_r_ctl == FC_RCTL_BA_ABTS) {
>>>        /* Drop incoming ABTS */
>>> -        put_cpu();
>>>        kfree_skb(skb);
>>>        return;
>>>    }
>>> 
>>> +    stats = per_cpu_ptr(lport->stats, smp_processor_id());
>>> +    stats->RxFrames++;
>>> +    stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
>>> +
>>>    if (le32_to_cpu(fr_crc(fp)) !=
>>>            ~crc32(~0, skb->data, fr_len)) {
>>>        if (stats->InvalidCRCCount < 5)
>>>            printk(KERN_WARNING PFX "dropping frame with "
>>>                   "CRC error\n");
>>>        stats->InvalidCRCCount++;
>>> -        put_cpu();
>>>        kfree_skb(skb);
>>>        return;
>>>    }
>>> -    put_cpu();
>>>    fc_exch_recv(lport, fp);
>>> }
>> 
>> 
>> 
