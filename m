From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH 01/10] fcoe: avoid getting into dev_queue_xmit with
 bottom halves disabled
Date: Sun, 11 Mar 2012 20:25:30 -0700
Message-ID: <4F5D6CAA.7050304@broadcom.com>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
 <20120309224942.6515.83069.stgit@localhost6.localdomain6>
 <4F5A9754.6080009@broadcom.com>
 <20120311174332.GA3518@neilslaptop.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2665 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab2CLDZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2012 23:25:43 -0400
In-Reply-To: <20120311174332.GA3518@neilslaptop.think-freely.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Robert Love <robert.w.love@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 3/11/2012 10:43 AM, Neil Horman wrote:
> On Fri, Mar 09, 2012 at 03:50:44PM -0800, Bhanu Prakash Gollapudi wrote:
>> On 3/9/2012 2:49 PM, Robert Love wrote:
>>> From: Neil Horman<nhorman@tuxdriver.com>
>>>
>>> Recieved this warning recently:
>>>
>>> WARNING: at kernel/softirq.c:143 local_bh_enable+0x7d/0xb0() (Not tainted)
>>> Hardware name: C6100
>>> Modules linked in: autofs4 bnx2fc cnic uio fcoe libfcoe libfc scsi_transport_fc
>>> scsi_tgt 8021q garp stp llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table
>>> mperf ipv6 ixgbe mdio igb dcdbas microcode i2c_i801 i2c_core sg iTCO_wdt
>>> iTCO_vendor_support ioatdma dca i7core_edac edac_core shpchp ext4 mbcache jbd2
>>> sd_mod crc_t10dif ahci dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
>>> scsi_wait_scan]
>>> Pid: 4926, comm: fc_rport_eq Not tainted 2.6.32 #2
>>> Call Trace:
>>>   [<ffffffff81069c67>] ? warn_slowpath_common+0x87/0xc0
>>>   [<ffffffff81069cba>] ? warn_slowpath_null+0x1a/0x20
>>>   [<ffffffff8107216d>] ? local_bh_enable+0x7d/0xb0
>>>   [<ffffffff81433567>] ? dev_queue_xmit+0x177/0x6c0
>>>   [<ffffffffa0293a34>] ? vlan_dev_hwaccel_hard_start_xmit+0x84/0xb0 [8021q]
>>>   [<ffffffff8142f46c>] ? dev_hard_start_xmit+0x2bc/0x3f0
>>>   [<ffffffff8143392e>] ? dev_queue_xmit+0x53e/0x6c0
>>>   [<ffffffff8142348e>] ? __skb_clone+0x2e/0x120
>>>   [<ffffffffa02ea83d>] ? fcoe_clean_pending_queue+0xcd/0x100 [libfcoe]
>>>   [<ffffffff810559ca>] ? find_busiest_group+0x9aa/0xb20
>>>   [<ffffffffa02f7624>] ? fcoe_port_send+0x24/0x50 [fcoe]
>>>   [<ffffffffa02f9568>] ? fcoe_xmit+0x228/0x3e0 [fcoe]
>>>   [<ffffffffa02c1896>] ? fc_seq_send+0xb6/0x160 [libfc]
>>>   [<ffffffffa02c1a76>] ? fc_exch_abort_locked+0x136/0x1c0 [libfc]
>>>   [<ffffffffa02c1ca7>] ? fc_exch_mgr_reset+0x147/0x2a0 [libfc]
>>>   [<ffffffff814f2c7e>] ? _spin_unlock_irq+0xe/0x20
>>>   [<ffffffffa02c91d3>] ? fc_rport_work+0x123/0x5f0 [libfc]
>>>   [<ffffffffa02c90b0>] ? fc_rport_work+0x0/0x5f0 [libfc]
>>>   [<ffffffff8108b559>] ? worker_thread+0x179/0x2a0
>>>   [<ffffffff81090ea0>] ? autoremove_wake_function+0x0/0x40
>>>   [<ffffffff8108b3e0>] ? worker_thread+0x0/0x2a0
>>>   [<ffffffff81090b56>] ? kthread+0x96/0xa0
>>>   [<ffffffff8100c10a>] ? child_rip+0xa/0x20
>>>   [<ffffffff81090ac0>] ? kthread+0x0/0xa0
>>>   [<ffffffff8100c100>] ? child_rip+0x0/0x20
>>>
>>> fc_exch_abort_locked attempts to send an abort frame, but it does so with a
>>> spinlock held and irqs/bh's disabled.  Because of this dev_queue_xmit issues a
>>> warning. This patch allows the fc_exch_abort_locked to drop and re-acquire the
>>> lock so that the warning is suppressed.
>>>
>>> Note this isn't a great fix, given that we need to free and re-acquire the
>>> ex_lock during the fc_exch_abort_locked operation, but any other solution is
>>> going to be a fairly major undertaking I think.  This should work until a proper
>>> fix can be found.
>>>
>>> Signed-off-by: Neil Horman<nhorman@tuxdriver.com>
>>> Signed-off-by: Robert Love<robert.w.love@intel.com>
>>
>> Robert,  This patch is not required based on what we discussed in
>> this thread..
>> http://lists.open-fcoe.org/pipermail/devel/2012-February/011946.html
>>
>> Neil provided "fcoe: Ensure fcoe_recv_frame is always called in
>> process context" instead of the two patches he submitted initially.
>> http://lists.open-fcoe.org/pipermail/devel/2012-February/011962.html
>>
>> Neil, correct me if I'm wrong.
>>
> Bhanu, This is not quite right (although that was a very confusing thread).  The
> ema_list fix that I was proposing is no longer necessecary, because after that
> conversation we realized the whole issue cold be avoided by making sure that we
> never allowed fcoe_recv_frame to be called in process context.
>
> This patch is still necessecary.


Neil, The reason you saw this (WARNING) stack trace (in softirq.c) was 
because of using spin_lock_irqsave() instead of spin_lock_bh() in 
fc_exch_reset() as part of  "[PATCH 1/2] fcoe: provide exclusion to 
concurrent ema_list access", which was not eventually submitted.

Because of using spin_lock_irqsave(), the following WARN_ON is hit in 
_local_bh_enable_ip().

static inline void _local_bh_enable_ip(unsigned long ip)
{
          WARN_ON_ONCE(in_irq() || irqs_disabled());

I don't think you will see this WARNING with the existing code.


  Its needed beacuse fc_exch_abort_locked is (by
> definition) called with the ex_lock held.  fc_exch_abort_locked however calls
> fc_seq_send, which can lock the same ex_lock, causing deadlock.


This is NOT an issue. Although fc_seq_send takes ex_lock, 
fc_exch_abort_locked() code path does not come here, as we return from 
this function if fh_type is BLS.

         if (fh_type == FC_TYPE_BLS)
                 return error;

         /*
          * Update the exchange and sequence flags,
          * assuming all frames for the sequence have been sent.
          * We can only be called to send once for each sequence.
          */
         spin_lock_bh(&ep->ex_lock);
	...


Thanks,
Bhanu
>
> So yes, we need a fix for this.  That said, I'd just as soon you drop this
> patch, as I was looking at this code and realized that I can make a much more
> efficient fix for this problem.  So let me know how you want to handle this: If
> you want to drop this patch, I'll have an improved fix for you early this week.
> If you want to keep this patch in place, thats fine with me too.  My new fix
> will just revert these bits.  Let me know how you want to play it.
>
> Thank you for bringing this up though, I'd been meaning to review this and see
> if I could fix it a bit better.
>
> Best
> Neil
>
>
>


