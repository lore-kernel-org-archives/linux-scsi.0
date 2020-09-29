Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA615C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F345208FE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fIrvwbal"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgI2KX5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:23:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62274 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgI2KX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 06:23:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TAKSaf004826
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:23:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EqZXroTSL1k5H1I9d7jidjW6GNJDwpPsaX6Isac9Zbw=;
 b=fIrvwbalDkhUREmCbQBlbrQ5YnVWwtL9M8CPTJ30K9q7coqGIDRcLdPNvyB6buk5Tlx0
 62xNk9oAtnBVU7u2KZgZsgPI4IcYQJSlB+KEHq8np4h7UM5kjUFhRBrwW/1SD9FwXFcK
 YqgBhSF0C5YGGW9IAaEM0zlg3HR7/+BYaGzJ19x3tZ+KBG5hW5evN1G7af6RpzSX1MGc
 XsGez7CQmTqHh/DkZYsOZhGGanxtIEVABIiRUKut8AdbBqFvxUHKwyzgKc8x3ylAD3x/
 3Jm7FnMVPmiZ6LausMKQJ+vsxhkuHzCLJLnDTwOrXLEo2yvapy0Oa8Z7ekwfUlprboTC vQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55p5g3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:23:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 03:23:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 03:23:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 03:23:53 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E38463F703F;
        Tue, 29 Sep 2020 03:23:52 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08TANqWT032345;
        Tue, 29 Sep 2020 03:23:52 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08TANqBI032344;
        Tue, 29 Sep 2020 03:23:52 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 4/7] qla2xxx: Fix reset of MPI firmware
Date:   Tue, 29 Sep 2020 03:21:49 -0700
Message-ID: <20200929102152.32278-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200929102152.32278-1-njavali@marvell.com>
References: <20200929102152.32278-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Normally, the MPI firmware is reset when an MPI dump is collected.
If an unsaved MPI dump exists in the driver, though, an alternate
mechanism is used. This mechanism, which was not fully correct, is
not recommended and instead an MPI dump template walk is suggested
to perform the MPI reset.

To allow for the MPI dump template walk, extra space is reserved
in the MPI dump buffer, which gets used only when there is already
an MPI dump in place.

Fixes: cbb01c2f2f630 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 10 +++++--
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 -
 drivers/scsi/qla2xxx/qla_init.c |  2 ++
 drivers/scsi/qla2xxx/qla_tmpl.c | 49 +++++++++------------------------
 4 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 1ee747ba4ecc..284b1cc91c80 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -157,6 +157,14 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 			       vha->host_no);
 		}
 		break;
+	case 10:
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+			ql_log(ql_log_info, vha, 0x70e9,
+			       "Issuing MPI firmware dump on host#%ld.\n",
+			       vha->host_no);
+			ha->isp_ops->mpi_fw_dump(vha, 0);
+		}
+		break;
 	}
 	return count;
 }
@@ -744,8 +752,6 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 			qla83xx_idc_audit(vha, IDC_AUDIT_TIMESTAMP);
 			qla83xx_idc_unlock(vha, 0);
 			break;
-		} else if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-			qla27xx_reset_mpi(vha);
 		} else {
 			/* Make sure FC side is not in reset */
 			WARN_ON_ONCE(qla2x00_wait_for_hba_online(vha) !=
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 9c4d077edf9e..26dc055d93b3 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -945,6 +945,5 @@ extern void qla2x00_dfs_remove_rport(scsi_qla_host_t *vha, struct fc_port *fp);
 
 /* nvme.c */
 void qla_nvme_unregister_remote_port(struct fc_port *fcport);
-void qla27xx_reset_mpi(scsi_qla_host_t *vha);
 void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4659c8bc8c0d..e493c2df8aad 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3288,6 +3288,8 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			    j, fwdt->dump_size);
 			dump_size += fwdt->dump_size;
 		}
+		/* Add space for spare MPI fw dump. */
+		dump_size += ha->fwdt[1].dump_size;
 	} else {
 		req_q_size = req->length * sizeof(request_t);
 		rsp_q_size = rsp->length * sizeof(response_t);
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 591df89a4d13..0af3e7fa31f0 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -12,33 +12,6 @@
 #define IOBASE(vha)	IOBAR(ISPREG(vha))
 #define INVALID_ENTRY ((struct qla27xx_fwdt_entry *)0xffffffffffffffffUL)
 
-/* hardware_lock assumed held. */
-static void
-qla27xx_write_remote_reg(struct scsi_qla_host *vha,
-			 u32 addr, u32 data)
-{
-	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
-
-	ql_dbg(ql_dbg_misc, vha, 0xd300,
-	       "%s: addr/data = %xh/%xh\n", __func__, addr, data);
-
-	wrt_reg_dword(&reg->iobase_addr, 0x40);
-	wrt_reg_dword(&reg->iobase_c4, data);
-	wrt_reg_dword(&reg->iobase_window, addr);
-}
-
-void
-qla27xx_reset_mpi(scsi_qla_host_t *vha)
-{
-	ql_dbg(ql_dbg_misc + ql_dbg_verbose, vha, 0xd301,
-	       "Entered %s.\n", __func__);
-
-	qla27xx_write_remote_reg(vha, 0x104050, 0x40004);
-	qla27xx_write_remote_reg(vha, 0x10405c, 0x4);
-
-	vha->hw->stat.num_mpi_reset++;
-}
-
 static inline void
 qla27xx_insert16(uint16_t value, void *buf, ulong *len)
 {
@@ -1028,7 +1001,6 @@ void
 qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	ulong flags = 0;
-	bool need_mpi_reset = true;
 
 #ifndef __CHECKER__
 	if (!hardware_locked)
@@ -1036,14 +1008,20 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 #endif
 	if (!vha->hw->mpi_fw_dump) {
 		ql_log(ql_log_warn, vha, 0x02f3, "-> mpi_fwdump no buffer\n");
-	} else if (vha->hw->mpi_fw_dumped) {
-		ql_log(ql_log_warn, vha, 0x02f4,
-		       "-> MPI firmware already dumped (%p) -- ignoring request\n",
-		       vha->hw->mpi_fw_dump);
 	} else {
 		struct fwdt *fwdt = &vha->hw->fwdt[1];
 		ulong len;
 		void *buf = vha->hw->mpi_fw_dump;
+		bool walk_template_only = false;
+
+		if (vha->hw->mpi_fw_dumped) {
+			/* Use the spare area for any further dumps. */
+			buf += fwdt->dump_size;
+			walk_template_only = true;
+			ql_log(ql_log_warn, vha, 0x02f4,
+			       "-> MPI firmware already dumped -- dump saving to temporary buffer %p.\n",
+			       buf);
+		}
 
 		ql_log(ql_log_warn, vha, 0x02f5, "-> fwdt1 running...\n");
 		if (!fwdt->template) {
@@ -1058,9 +1036,10 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 			ql_log(ql_log_warn, vha, 0x02f7,
 			       "-> fwdt1 fwdump residual=%+ld\n",
 			       fwdt->dump_size - len);
-		} else {
-			need_mpi_reset = false;
 		}
+		vha->hw->stat.num_mpi_reset++;
+		if (walk_template_only)
+			goto bailout;
 
 		vha->hw->mpi_fw_dump_len = len;
 		vha->hw->mpi_fw_dumped = 1;
@@ -1072,8 +1051,6 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 	}
 
 bailout:
-	if (need_mpi_reset)
-		qla27xx_reset_mpi(vha);
 #ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
-- 
2.19.0.rc0

