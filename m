From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] zfcp: drop open coded assignments of
 timer_list.function
Date: Thu, 16 Nov 2017 13:38:18 +0100
Message-ID: <cb2bd7ca-f240-285e-a804-90fa6f74b682@linux.vnet.ibm.com>
References: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
 <20171108141709.79074-4-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934648AbdKPMiY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Nov 2017 07:38:24 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAGCYe1w094748
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2017 07:38:24 -0500
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2e9aca1fv7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2017 07:38:23 -0500
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Thu, 16 Nov 2017 12:38:21 -0000
In-Reply-To: <20171108141709.79074-4-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Remus <jremus@linux.vnet.ibm.com>

If this has not been picked/merged yet (it's not in Linus' tree yet),
could you please drop it because it's buggy?

This would buy me time to come up with a proper solution,
otherwise I would be forced to fix it within 4.15-rc and
am not sure I can make it.

On 11/08/2017 03:17 PM, Steffen Maier wrote:
> The majority of requests is regular SCSI I/O on the hot path.
> Since these use a timeout owned by the block layer, zfcp does not use
> zfcp_fsf_req.timer. Hence, the very early unconditional and even
> incomplete (handler function yet unknown) timer initialization in
> zfcp_fsf_req_create() is not necessary.
> 
> Instead defer the timer initialization to when we know zfcp needs to use
> its own request timeout in zfcp_fsf_start_timer() and
> zfcp_fsf_start_erp_timer().

This means, we no longer always initialize the timer for
any request type, but only for some request types.

However, we still do have 2 unconditional del_timer() calls
independent of the request type.

I don't understand yet why I haven't seen the following on function testing,
but I see it now while working on something else:

[  325.908536] scsi host2: scsi_eh_2: sleeping
[  325.908707] scsi host2: zfcp
[  325.912974] qdio: 0.0.1900 ZFCP on SC 11 using AI:1 QEBSM:1 PRI:1 TDD:1 SIGA: W A 
[  331.112469] scsi 2:0:0:0: scsi scan: INQUIRY pass 1 length 36
[  331.122253] ODEBUG: assert_init not available (active state 0) object type: timer_list hint:           (null)
[  331.122319] ------------[ cut here ]------------
[  331.122332] WARNING: CPU: 0 PID: 2195 at lib/debugobjects.c:291 debug_print_object+0xb4/0xd8
[  331.122339] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter sunrpc qeth_l2 rng_core ghash_s390 prng aes_s390 des_s390 des_generic sha512_s390 zfcp sha256_s390 scsi_transport_fc sha1_s390 sha_common dm_multipath qeth qdio scsi_mod vmur ccwgroup dm_mod vhost_net tun vhost tap sch_fq_codel kvm ip_tables x_tables autofs4
[  331.122503] CPU: 0 PID: 2195 Comm: chccwdev Not tainted 4.14.0localversion+ #1
[  331.122510] Hardware name: IBM 2964 N96 702 (z/VM 6.4.0)
[  331.122518] task: 000000004c673200 task.stack: 000000005fdac000
[  331.122599] Krnl PSW : 0704d00180000000 00000000007828cc (debug_print_object+0xb4/0xd8)
[  331.122693]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
[  331.122748] Krnl GPRS: 0000200088a4a0f0 0000000080000100 0000000000000061 0000000000c215b6
[  331.122753]            00000000007828c8 0000000000000000 0000000000c158da 000000004cf57200
[  331.122766]            000000005e462548 000000000201d608 0000000000c65888 0000000000e8dc08
[  331.122830]            000000006fbfb808 0000000000aac910 00000000007828c8 000000006fbfb708
[  331.122843] Krnl Code: 00000000007828bc: c02000271779        larl    %r2,c657ae
                          00000000007828c2: c0e5ffd25793        brasl   %r14,1cd7e8
                         #00000000007828c8: a7f40001            brc     15,7828ca
                         >00000000007828cc: c41d003655b4        lrl     %r1,e4d434
                          00000000007828d2: e340f0e80004        lg      %r4,232(%r15)
                          00000000007828d8: a71a0001            ahi     %r1,1
                          00000000007828dc: eb6ff0a80004        lmg     %r6,%r15,168(%r15)
                          00000000007828e2: c41f003655a9        strl    %r1,e4d434
[  331.123056] Call Trace:
[  331.123065] ([<00000000007828c8>] debug_print_object+0xb0/0xd8)
[  331.123074]  [<0000000000783900>] debug_object_assert_init+0x148/0x180 
[  331.123085]  [<00000000001e8e2c>] del_timer+0x34/0x90 
[  331.123106]  [<000003ff8032fad2>] zfcp_fsf_req_complete+0x2b2/0x7a8 [zfcp] 
[  331.123122]  [<000003ff80331e2e>] zfcp_fsf_reqid_check+0xe6/0x150 [zfcp] 
[  331.123151]  [<000003ff80332be0>] zfcp_qdio_int_resp+0x138/0x180 [zfcp] 
[  331.123167]  [<000003ff801df19e>] qdio_kick_handler+0x1be/0x2c0 [qdio] 
[  331.123178]  [<000003ff801e1ca6>] __tiqdio_inbound_processing+0x466/0xd00 [qdio] 
[  331.123191]  [<000000000014f5e0>] tasklet_action+0x100/0x188 
[  331.123203]  [<0000000000a56af2>] __do_softirq+0x2ca/0x5e0 
[  331.123215]  [<000000000014ec24>] irq_exit+0x74/0xd8 
[  331.123228]  [<000000000010c5c4>] do_IRQ+0xbc/0xf0 
[  331.123278]  [<0000000000a55c2c>] io_int_handler+0x104/0x2d4 
[  331.123354]  [<0000000000168ca6>] queue_work_on+0x8e/0xa8 
[  331.123393] ([<0000000000168ca2>] queue_work_on+0x8a/0xa8)
[  331.123443]  [<000000000080a932>] pty_write+0x62/0x88 
[  331.123454]  [<0000000000801c64>] n_tty_write+0x284/0x4b8 
[  331.123463]  [<00000000007febb6>] tty_write+0x34e/0x378 
[  331.123473]  [<0000000000386db4>] __vfs_write+0x3c/0x178 
[  331.123481]  [<00000000003870dc>] vfs_write+0xbc/0x1a0 
[  331.123490]  [<0000000000387366>] SyS_write+0x66/0xc0 
[  331.123501]  [<0000000000a55900>] system_call+0x290/0x2b0 
[  331.123510] 4 locks held by chccwdev/2195:
[  331.123519]  #0:  (&tty->ldisc_sem){++++}, at: [<0000000000805dc6>] tty_ldisc_ref_wait+0x46/0x70
[  331.123559]  #1:  (&tty->atomic_write_lock){+.+.}, at: [<00000000007fc798>] tty_write_lock+0x38/0x80
[  331.123585]  #2:  (&o_tty->termios_rwsem/1){++++}, at: [<0000000000801a6e>] n_tty_write+0x8e/0x4b8
[  331.123622]  #3:  (&ldata->output_lock){+.+.}, at: [<0000000000801b34>] n_tty_write+0x154/0x4b8
[  331.123735] Last Breaking-Event-Address:
[  331.123742]  [<00000000007828c8>] debug_print_object+0xb0/0xd8
[  331.123750] ---[ end trace 5a8f0aa586510aed ]---
[  331.123977] scsi 2:0:0:0: scsi scan: INQUIRY successful with code 0x0
[  331.124031] scsi 2:0:0:0: scsi scan: INQUIRY pass 2 length 164

> At that point in time we also know the handler
> function. So drop open coded assignments of timer_list.function and
> instead use the new timer API wrapper function timer_setup().
> 
> This way, we don't have to touch zfcp again, when the cast macro
> TIMER_FUNC_TYPE gets removed again after the global conversion to
> timer_setup() is complete.
> 
> Depends-on: v4.14-rc3 commit 686fef928bba ("timer: Prepare to change timer callback argument type")
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Reviewed-by: Jens Remus <jremus@linux.vnet.ibm.com>
> ---
>   drivers/s390/scsi/zfcp_fsf.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
> index 51b81c0a0652..c8e368f0f299 100644
> --- a/drivers/s390/scsi/zfcp_fsf.c
> +++ b/drivers/s390/scsi/zfcp_fsf.c
> @@ -34,7 +34,7 @@ static void zfcp_fsf_request_timeout_handler(struct timer_list *t)
>   static void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req,
>   				 unsigned long timeout)
>   {
> -	fsf_req->timer.function = (TIMER_FUNC_TYPE)zfcp_fsf_request_timeout_handler;
> +	timer_setup(&fsf_req->timer, zfcp_fsf_request_timeout_handler, 0);
>   	fsf_req->timer.expires = jiffies + timeout;
>   	add_timer(&fsf_req->timer);
>   }
> @@ -42,7 +42,7 @@ static void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req,
>   static void zfcp_fsf_start_erp_timer(struct zfcp_fsf_req *fsf_req)
>   {
>   	BUG_ON(!fsf_req->erp_action);
> -	fsf_req->timer.function = (TIMER_FUNC_TYPE)zfcp_erp_timeout_handler;
> +	timer_setup(&fsf_req->timer, zfcp_erp_timeout_handler, 0);
>   	fsf_req->timer.expires = jiffies + 30 * HZ;
>   	add_timer(&fsf_req->timer);
>   }
> @@ -692,7 +692,6 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
>   		adapter->req_no++;
> 
>   	INIT_LIST_HEAD(&req->list);
> -	timer_setup(&req->timer, NULL, 0);
>   	init_completion(&req->completion);
> 
>   	req->adapter = adapter;
> 

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
