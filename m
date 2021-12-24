Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815B3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351758AbhLXHHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:07:53 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44404 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351733AbhLXHHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:52 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2o6Aa008389
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Oy4EmjzKEEsT4y5uAjoej5zZEr3PKVXTMWU08yxMXII=;
 b=hLwAQySLpf7wvjZUBoC+bCCtzEiN8TUuLDDegG365FwzSKnZXe2sFemc+qMxHr1pBsMS
 crCQHxNbd5gFKg2hq9cNIp7HdfzcXbwUCkBdZdfOEJ32vB4b89rei42PobWlzGBQMXxT
 g37hhyfRDgkvl5gB14MdoflHsc1Q3w+vGE3dnAVQVDuN+QoeVzdpZC2tuPZ0h9/1lVzH
 wcjUnhUa3U98L/Qx9OUPrwCHXvnDejhJO/iARcb4WMLxz8O+2Y98AxaAoiVt/qnfOj6N
 Z+5IrwftU9Lp++JSU5qQWkFRiP3B8Fkg2tsKTG9c+1FQgTXpi/YcjAHBFMuy6Nk7wAhs Sg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:50 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Dec
 2021 23:07:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:48 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0E4983F7078;
        Thu, 23 Dec 2021 23:07:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77mt0017964;
        Thu, 23 Dec 2021 23:07:48 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77mh7017963;
        Thu, 23 Dec 2021 23:07:48 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/16] qla2xxx: Fix warning message due to adisc is being flush
Date:   Thu, 23 Dec 2021 23:07:00 -0800
Message-ID: <20211224070712.17905-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: -Qyiy37mXWzU4tsMS8fsbgVusg0Gi4XP
X-Proofpoint-ORIG-GUID: -Qyiy37mXWzU4tsMS8fsbgVusg0Gi4XP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Fix warning message due to adisc is being flush.
Linux kernel triggered a warning message where a different
error code type is not matching up with the expected type. This
patch adds additional translation of one error code type to another.

WARNING: CPU: 2 PID: 1131623 at drivers/scsi/qla2xxx/qla_init.c:498
qla2x00_async_adisc_sp_done+0x294/0x2b0 [qla2xxx]
CPU: 2 PID: 1131623 Comm: drmgr Not tainted 5.13.0-rc1-autotest #1
..
GPR28: c000000aaa9c8890 c0080000079ab678 c00000140a104800 c00000002bd19000
NIP [c00800000790857c] qla2x00_async_adisc_sp_done+0x294/0x2b0 [qla2xxx]
LR [c008000007908578] qla2x00_async_adisc_sp_done+0x290/0x2b0 [qla2xxx]
Call Trace:
[c00000001cdc3620] [c008000007908578] qla2x00_async_adisc_sp_done+0x290/0x2b0 [qla2xxx] (unreliable)
[c00000001cdc3710] [c0080000078f3080] __qla2x00_abort_all_cmds+0x1b8/0x580 [qla2xxx]
[c00000001cdc3840] [c0080000078f589c] qla2x00_abort_all_cmds+0x34/0xd0 [qla2xxx]
[c00000001cdc3880] [c0080000079153d8] qla2x00_abort_isp_cleanup+0x3f0/0x570 [qla2xxx]
[c00000001cdc3920] [c0080000078fb7e8] qla2x00_remove_one+0x3d0/0x480 [qla2xxx]
[c00000001cdc39b0] [c00000000071c274] pci_device_remove+0x64/0x120
[c00000001cdc39f0] [c0000000007fb818] device_release_driver_internal+0x168/0x2a0
[c00000001cdc3a30] [c00000000070e304] pci_stop_bus_device+0xb4/0x100
[c00000001cdc3a70] [c00000000070e4f0] pci_stop_and_remove_bus_device+0x20/0x40
[c00000001cdc3aa0] [c000000000073940] pci_hp_remove_devices+0x90/0x130
[c00000001cdc3b30] [c0080000070704d0] disable_slot+0x38/0x90 [rpaphp] [
c00000001cdc3b60] [c00000000073eb4c] power_write_file+0xcc/0x180
[c00000001cdc3be0] [c0000000007354bc] pci_slot_attr_store+0x3c/0x60
[c00000001cdc3c00] [c00000000055f820] sysfs_kf_write+0x60/0x80 [c00000001cdc3c20]
[c00000000055df10] kernfs_fop_write_iter+0x1a0/0x290
[c00000001cdc3c70] [c000000000447c4c] new_sync_write+0x14c/0x1d0
[c00000001cdc3d10] [c00000000044b134] vfs_write+0x224/0x330
[c00000001cdc3d60] [c00000000044b3f4] ksys_write+0x74/0x130
[c00000001cdc3db0] [c00000000002df70] system_call_exception+0x150/0x2d0
[c00000001cdc3e10] [c00000000000d45c] system_call_common+0xec/0x278

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0b641a803f7c..e54c31296fab 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -295,6 +295,8 @@ static void qla2x00_async_login_sp_done(srb_t *sp, int res)
 		ea.iop[0] = lio->u.logio.iop[0];
 		ea.iop[1] = lio->u.logio.iop[1];
 		ea.sp = sp;
+		if (res)
+			ea.data[0] = MBS_COMMAND_ERROR;
 		qla24xx_handle_plogi_done_event(vha, &ea);
 	}
 
@@ -557,6 +559,8 @@ static void qla2x00_async_adisc_sp_done(srb_t *sp, int res)
 	ea.iop[1] = lio->u.logio.iop[1];
 	ea.fcport = sp->fcport;
 	ea.sp = sp;
+	if (res)
+		ea.data[0] = MBS_COMMAND_ERROR;
 
 	qla24xx_handle_adisc_event(vha, &ea);
 	/* ref: INIT */
@@ -1237,6 +1241,8 @@ static void qla2x00_async_prli_sp_done(srb_t *sp, int res)
 		ea.sp = sp;
 		if (res == QLA_OS_TIMER_EXPIRED)
 			ea.data[0] = QLA_OS_TIMER_EXPIRED;
+		else if (res)
+			ea.data[0] = MBS_COMMAND_ERROR;
 
 		qla24xx_handle_prli_done_event(vha, &ea);
 	}
-- 
2.23.1

