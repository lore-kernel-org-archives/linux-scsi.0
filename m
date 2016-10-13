From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] [4.9-rc] ipr: Fix async error WARN_ON
Date: Thu, 13 Oct 2016 14:45:24 -0500
Message-ID: <20161013194524.EA0286A03C@b03ledav003.gho.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756609AbcJMTqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 15:46:30 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9DJhjHQ036953
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:45:30 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 262fh2aw97-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:45:29 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Thu, 13 Oct 2016 13:45:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Commit afc3f83cb4a5 ("scsi: ipr: Add asynchronous error notification")
introduced the warn on shown below. To fix this, rather than attempting
to send the KOBJ_CHANGE uevent from interrupt context, which is what is
causing the WARN_ON, just wake the ipr worker thread which will send a
KOBJ_CHANGE uevent.

[  142.278120] WARNING: CPU: 15 PID: 0 at kernel/softirq.c:161 __local_bh_enable_ip+0x7c/0xd0
[  142.278124] Modules linked in: ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw iptable_filter ses enclosure scsi_transport_sas sg pseries_rng nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sr_mod sd_mod cdrom ipr libata ibmvscsi scsi_transport_srp ibmveth dm_mirror dm_region_hash dm_log dm_mod
[  142.278208] CPU: 15 PID: 0 Comm: swapper/15 Not tainted 4.8.0.ipr+ #21
[  142.278213] task: c00000010cf24480 task.stack: c00000010cfec000
[  142.278217] NIP: c0000000000c0c7c LR: c000000000881778 CTR: c0000000003c5bf0
[  142.278221] REGS: c00000010cfef080 TRAP: 0700   Not tainted  (4.8.0.ipr+)
[  142.278224] MSR: 8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28008022  XER: 2000000f
[  142.278236] CFAR: c0000000000c0c20 SOFTE: 0 
GPR00: c000000000706c78 c00000010cfef300 c000000000f91d00 c000000000706c78 
GPR04: 0000000000000200 c000000000f7bc80 0000000000000000 00000000024000c0 
GPR08: 0000000000000000 0000000000000001 c000000000ee1d00 c000000000a9bdd0 
GPR12: c0000000003c5bf0 c00000000eb22d00 c000000100ca3880 c00000020ed38400 
GPR16: 0000000000000000 0000000000000000 c000000100940508 0000000000000000 
GPR20: 0000000000000000 0000000000000000 0000000000000000 00000000024000c0 
GPR24: c0000000004588e0 c00000010863bd00 c00000010863bd00 c0000000013773f8 
GPR28: c000000000f7bc80 0000000000000000 ffffffffffffffff c000000000f7bcd8 
[  142.278290] NIP [c0000000000c0c7c] __local_bh_enable_ip+0x7c/0xd0
[  142.278296] LR [c000000000881778] _raw_spin_unlock_bh+0x38/0x60
[  142.278299] Call Trace:
[  142.278303] [c00000010cfef300] [c000000000f7bc80] init_net+0x0/0x1900 (unreliable)
[  142.278310] [c00000010cfef320] [c000000000706c78] peernet2id+0x58/0x80
[  142.278316] [c00000010cfef370] [c00000000075caec] netlink_broadcast_filtered+0x30c/0x550
[  142.278323] [c00000010cfef430] [c000000000459078] kobject_uevent_env+0x588/0x780
[  142.278331] [c00000010cfef510] [d000000003163a6c] ipr_process_error+0x11c/0x240 [ipr]
[  142.278337] [c00000010cfef5c0] [d000000003152298] ipr_fail_all_ops+0x108/0x220 [ipr]
[  142.278343] [c00000010cfef670] [d0000000031643f8] ipr_reset_restore_cfg_space+0xa8/0x240 [ipr]
[  142.278350] [c00000010cfef6f0] [d000000003158a00] ipr_reset_ioa_job+0x80/0xe0 [ipr]
[  142.278356] [c00000010cfef720] [d000000003153f78] ipr_reset_timer_done+0xa8/0xe0 [ipr]
[  142.278363] [c00000010cfef770] [c000000000149c88] call_timer_fn+0x58/0x1c0
[  142.278368] [c00000010cfef800] [c000000000149f60] expire_timers+0x140/0x200
[  142.278373] [c00000010cfef870] [c00000000014a0e8] run_timer_softirq+0xc8/0x230
[  142.278379] [c00000010cfef900] [c0000000000c0844] __do_softirq+0x164/0x3c0
[  142.278384] [c00000010cfef9f0] [c0000000000c0f18] irq_exit+0x1a8/0x1c0
[  142.278389] [c00000010cfefa20] [c000000000020b54] timer_interrupt+0xa4/0xe0
[  142.278394] [c00000010cfefa50] [c000000000002414] decrementer_common+0x114/0x180


Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_async_err_fixup drivers/scsi/ipr.c
--- linux-2.6.git/drivers/scsi/ipr.c~ipr_async_err_fixup	2016-10-13 09:57:47.634920565 -0500
+++ linux-2.6.git-bjking1/drivers/scsi/ipr.c	2016-10-13 14:42:25.654418345 -0500
@@ -2586,7 +2586,6 @@ static void ipr_process_error(struct ipr
 	struct ipr_hostrcb *hostrcb = ipr_cmd->u.hostrcb;
 	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
 	u32 fd_ioasc;
-	char *envp[] = { "ASYNC_ERR_LOG=1", NULL };
 
 	if (ioa_cfg->sis64)
 		fd_ioasc = be32_to_cpu(hostrcb->hcam.u.error64.fd_ioasc);
@@ -2607,8 +2606,8 @@ static void ipr_process_error(struct ipr
 	}
 
 	list_add_tail(&hostrcb->queue, &ioa_cfg->hostrcb_report_q);
+	schedule_work(&ioa_cfg->work_q);
 	hostrcb = ipr_get_free_hostrcb(ioa_cfg);
-	kobject_uevent_env(&ioa_cfg->host->shost_dev.kobj, KOBJ_CHANGE, envp);
 
 	ipr_send_hcam(ioa_cfg, IPR_HCAM_CDB_OP_CODE_LOG_DATA, hostrcb);
 }
_

