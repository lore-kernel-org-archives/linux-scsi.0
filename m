Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AE6C001DC
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 10:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjGZKMp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 06:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjGZKMn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 06:12:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBFEBF
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 03:12:41 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q3WqiY024359
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 03:12:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=qSnXL9FXhb6b9Hw1xvouxYo0lNU8aKeY26kU2hTgSAY=;
 b=d8PI74lE1toFZDNYG8yeRsBtPo1/ujCeRBxzKekrEBmWdOG7qQVCFi6mBxIKOUy7i2IA
 pUusVEVw18RWHhpmn3EisX6LnbPdHclxpdSJ0Ee0rjQQZie/HeK7kg9znZhLm7kdaPRB
 NM3wNVaKmmxBPWm7RP7iPMPbRviSYxEi7dBRTXXJcWaE7uqZTvb6MO9xcmh2o7Dlme9O
 1QzSaOUrncCl0XE5ncaEcNkrhQnZnAsW4hJVV2Q67PLkWgg2yoPRS7zb8sj8FvQ293Eo
 E7S2lfbzw8C9qL/EfrVmcgAOIyEq7fImAICzkdV8oIf6cSig36zxZhgCtkstr6h6UuHe eQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3s18r29s37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 03:12:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 26 Jul
 2023 03:12:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 26 Jul 2023 03:12:38 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id CAAA93F7075;
        Wed, 26 Jul 2023 03:12:37 -0700 (PDT)
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH] qedf: Changed string copy method for "stop_io_on_error" from sprintf to put_user
Date:   Wed, 26 Jul 2023 15:42:36 +0530
Message-ID: <20230726101236.11922-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: zKuyHgj2XnVxv7x9TMMeEHV7Hish5nok
X-Proofpoint-ORIG-GUID: zKuyHgj2XnVxv7x9TMMeEHV7Hish5nok
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_04,2023-07-25_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

Changed string copy method for "stop_io_on_error" from sprintf to put_user

[ 5023.463399] BUG: unable to handle kernel paging request at 00007f6ad554c000
[ 5023.463404] PGD 8433e5067 P4D 8433e5067 PUD 87e36c067 PMD 87ef03067 PTE 0
[ 5023.463409] Oops: 0002 [#1] SMP NOPTI
[ 5023.463412] CPU: 56 PID: 12121 Comm: cat Kdump: loaded Not tainted 4.18.0-372.9.1.el8.x86_64 #1
[ 5023.463414] Hardware name: HPE ProLiant DL560 Gen10/ProLiant DL560 Gen10, BIOS U34 10/26/2020
[ 5023.463415] RIP: 0010:string_nocheck+0x3f/0x70
[ 5023.463423] Code: 0a 45 84 c9 74 46 83 ee 01 41 b8 01 00 00 00 48 8d 7c 37 01 eb 0f 49 83 c0 01 46 0f b6 4c 02 ff 45 84 c9 74 1c 49 39 c2 76 03 <44> 88 08 48 83 c0 01 44 89 c6 48 39 f8 75 dd 4c 89 d2 e9 1a ff ff
[ 5023.463425] RSP: 0018:ffffb6034770fd88 EFLAGS: 00010206
[ 5023.463427] RAX: 00007f6ad554c000 RBX: 00007f6b5554bfff RCX: ffff0a00ffffff04
[ 5023.463429] RDX: ffffffffc06a5d3f RSI: 00000000fffffffe RDI: 00007f6bd554bfff
[ 5023.463430] RBP: ffffffffc06a5d3f R08: 0000000000000001 R09: 0000000000000066
[ 5023.463432] R10: 00007f6b5554bfff R11: 0000000000000001 R12: ffff0a00ffffff04
[ 5023.463433] R13: ffffffffc06a5d50 R14: 000000007fffffff R15: ffffffffc06a5d50
[ 5023.463434] FS:  00007f6ad557d680(0000) GS:ffff8b9d9fc00000(0000) knlGS:0000000000000000
[ 5023.463436] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5023.463437] CR2: 00007f6ad554c000 CR3: 0000000882d24004 CR4: 00000000007706e0
[ 5023.463439] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5023.463440] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 5023.463441] PKRU: 55555554
[ 5023.463442] Call Trace:
[ 5023.463445]  string+0x40/0x50
[ 5023.463449]  vsnprintf+0x33c/0x520
[ 5023.463452]  sprintf+0x56/0x70
[ 5023.463456]  qedf_dbg_stop_io_on_error_cmd_read+0x65/0x80 [qedf]
[ 5023.463466]  full_proxy_read+0x53/0x80
[ 5023.463474]  vfs_read+0x91/0x140
[ 5023.463481]  ksys_read+0x4f/0xb0
[ 5023.463483]  do_syscall_64+0x5b/0x1a0
[ 5023.463490]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[ 5023.463494] RIP: 0033:0x7f6ad50ac525
[ 5023.463496] Code: fe ff ff 50 48 8d 3d 02 ca 06 00 e8 25 ee 01 00 0f 1f 44 00 00 f3 0f 1e fa 48 8d 05 75 40 2a 00 8b 00 85 c0 75 0f 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 53 c3 66 90 41 54 49 89 d4 55 48 89 f5 53 89
[ 5023.463497] RSP: 002b:00007ffd29ed3b38 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 5023.463499] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f6ad50ac525
[ 5023.463501] RDX: 0000000000020000 RSI: 00007f6ad554c000 RDI: 0000000000000003
[ 5023.463502] RBP: 00007f6ad554c000 R08: 00000000ffffffff R09: 0000000000000000
[ 5023.463503] R10: 0000000000000022 R11: 0000000000000246 R12: 00007f6ad554c000
[ 5023.463504] R13: 0000000000000003 R14: 0000000000000fff R15: 0000000000020000
[ 5023.463505] Modules linked in: xt_CHECKSUM ipt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bridge stp llc nft_compat nft_counter nf_tables nfnetlink bnx2fc cnic sunrpc vfat fat dm_service_time dm_multipath intel_rapl_msr intel_rapl_common isst_if_common nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul qedi crc32_pclmul iscsi_boot_sysfs libiscsi ghash_clmulni_intel scsi_transport_iscsi rapl mei_me uio intel_cstate pcspkr mei intel_uncore joydev ipmi_ssif ses enclosure hpwdt hpilo acpi_tad acpi_ipmi wmi lpc_ich ioatdma dca ipmi_si acpi_power_meter xfs libcrc32c sd_mod t10_pi sg qedf mgag200 qede drm_kms_helper qed libfcoe syscopyarea crc32c_intel sysfillrect i40e sysimgblt libfc fb_sys_fops smartpqi drm tg3 scsi_transport_sas scsi_transport_fc uas crc8 usb_storage i2c_algo_bit dm_mirror dm_region_hash dm_log dm_mod ipmi_devintf ipmi_msghandler fuse
[ 5023.463585] CR2: 00007f6ad554c000

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_debugfs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index a3ed681c8ce3..8b9c4cf2953f 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -185,15 +185,23 @@ qedf_dbg_stop_io_on_error_cmd_read(struct file *filp, char __user *buffer,
 				   size_t count, loff_t *ppos)
 {
 	int cnt;
+	char *q_true = "true\n";
+	char *q_false = "false\n";
 	struct qedf_dbg_ctx *qedf_dbg =
 				(struct qedf_dbg_ctx *)filp->private_data;
 	struct qedf_ctx *qedf = container_of(qedf_dbg,
 	    struct qedf_ctx, dbg_ctx);
 
 	QEDF_INFO(qedf_dbg, QEDF_LOG_DEBUGFS, "entered\n");
-	cnt = sprintf(buffer, "%s\n",
-	    qedf->stop_io_on_error ? "true" : "false");
 
+	if (qedf->stop_io_on_error)
+		for (cnt = 0; cnt < sizeof(q_true); cnt++)
+			put_user(*(q_true++), buffer++);
+	else
+		for (cnt = 0; cnt < sizeof(q_true); cnt++)
+			put_user(*(q_false++), buffer++);
+
+	cnt--;
 	cnt = min_t(int, count, cnt - *ppos);
 	*ppos += cnt;
 	return cnt;
-- 
2.23.1

