Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76903101CE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403871; cv=none; b=IIn6+l+JQdf/p1eO/Rxgb05QmXE6yqPkw9m8s9I0whHN/r3sSEjHBcLJFzaz8b+aed/cAEx4A2YxBwBBniDkAkiGEsVdqQRm+N0NSDlfZ0wcm+LElrjW32J1yKqtBtkLKEGqOLEOwPVY5xIQrbnpa0tZ24wm0bzKE455u3+Hi/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403871; c=relaxed/simple;
	bh=ZPwx9h3DmU7+E21N38onoWfjibhLVdfjxZ2uNXVFzXI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M3Q5JYn0FmDCx4V4uC4wGD7pWPvxHvYu7XNnGy142FcrU1NiWPBC6DY9JXMDXB251ObFaTSHD9s//aImg4YWJFoDrx3GW2tXvlduJFGoN3XXUTQedVplcNIXete7wyKpOuLc55XUl2M5vR5yHOalC9h2xyfTgYsY0z3EVxwqvsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=O6VdMkxY; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="O6VdMkxY"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6674834U872825;
	Mon, 6 Jul 2026 22:57:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=f
	A1e11qL3A2lgnPKPDyXNMPe7K90Bj2uKfzlC9DEOU8=; b=O6VdMkxYXPXEm0VZH
	HgA+mCWp3TAhfd3bGyZlocQRTwnpeTZ/j7PfNqQlljv0PSY01h+ube/U9RDGs8ez
	U3zSbYRsfQghjv/Rs1BBl7JJwmWRO3q/ahBa3Vx1qQEFY5mPeuYI98DepiB+cBHt
	6MGVHFmnQHNYJfZYva3jR+M1hrQYNvwWn8tEUU+vMoD9wCp14L9BzKTOtBrbum4P
	reZPzy9wQ2+bg4WbhfHd3Cze8/SmNbvKisD+KnMj+9E1VAudHJg9PGZ6wuLrNTJX
	q6RP2l4wrOs2c9DodawVUMGh/XNnSjX6mpOjzko1awaSAmGS3oMpSJZREcIxrP9b
	PwDgg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waa7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:46 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:46 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 754763F7066;
	Mon,  6 Jul 2026 22:57:43 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 57/88] scsi: qla2xxx: Improve firmware dump data capture
Date: Tue, 7 Jul 2026 11:24:04 +0530
Message-ID: <20260707055435.2680300-58-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: W0Zfhy3EJx3fdIuN-vcKZlm4SmMob_Z4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXwSsc2FEeRGyj
 dIt9RAkzCfugoWDLHnYXe5Mxc2YaYDUMbTr7aD8+TsJIJ9fXyB7iWtdw0C/uW2Tkyp5+bTFvxDi
 JeY+8RzRV/STD0DCJf4ZjyVv+Uo0VSgurK1EycoSzNN3KwMHTFWoNTSt94swPoTwClHw0oHlaqn
 1201v+XWqMJ7NTi7BQ87RcQZD8SQaDo7kJkFrBsAfOVYpYllVPKhPJnjtiD/7tJdX+ibB1/DqwF
 oRiDDe7rtfmagiW+bfuLvi7q4WRnP2Ht5J1q1rTJgd3oP1CNJf+iWwvLsWjmbnsl9W3TUqMHD5i
 w0XYYyzFk3k8i3TZ8HN7YhCUAXaTys7Xl/Awi8ZMVbEe9wzoIOuw72hsMSZMWw3/Dj9UMvMK9H4
 MDh3g8qWxRHM8PcMunjT16bG0qpxbiW2Hc408HMWuwy+0JAjKeCPA28KVhb6DAXRq2xXLyGueaL
 ih4HnaOBrDP/ReyJLXg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXxuVPaOA1cLqJ
 t6UPfuuZAQuK5wRyvW3F1CVIXX8bHkooYq4t4PYWPq8PDXIMJ+BhB19nlbAucroviKBigvNWNdc
 FEwIoBGvp35LGmijnmLoStqAUmVOhAw=
X-Proofpoint-GUID: W0Zfhy3EJx3fdIuN-vcKZlm4SmMob_Z4
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c955a cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=rgYw3m88d1YSIQjO3UwA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

From: Quinn Tran <qutran@marvell.com>

Capture as much firmware dump data as possible. Save the mailbox
registers at start-of-day, before firmware execution, so they are
available in the dump, and allocate a guestimate dump buffer early
during driver load to capture failures that happen before the final
dump buffer is sized.

Make template entry processing more robust: skip over any entry that
fails to capture and continue with the next one, and skip entries that
time out instead of aborting the whole dump. Notify udev once sysfs
nodes are available in case a dump was captured before they existed.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |   4 +-
 drivers/scsi/qla2xxx/qla_def.h  |   3 +
 drivers/scsi/qla2xxx/qla_init.c | 120 +++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_os.c   |   8 +++
 drivers/scsi/qla2xxx/qla_tmpl.c |  48 ++++++++++---
 5 files changed, 116 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index acb58daacf35..4f756468ea64 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -172,7 +172,7 @@ qla27xx_dump_mpi_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
 
 		if (!test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
 			/* no interrupt, timed out*/
-			return rval;
+			return QLA_FUNCTION_TIMEOUT;
 		}
 		if (rval) {
 			/* error completion status */
@@ -255,7 +255,7 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
 
 		if (!test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
 			/* no interrupt, timed out*/
-			return rval;
+			return QLA_FUNCTION_TIMEOUT;
 		}
 		if (rval) {
 			/* error completion status */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 4fd2a28af7e4..bb4305f6a364 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4176,6 +4176,7 @@ struct qla_hw_data {
 #define SRB_MIN_REQ     128
 	mempool_t       *srb_mempool;
 	u8 port_name[WWN_SIZE];
+	u16 mbregs[32];
 
 	volatile struct {
 		uint32_t	mbox_int		:1;
@@ -4246,6 +4247,8 @@ struct qla_hw_data {
 		uint32_t	eeh_flush:2;
 #define EEH_FLUSH_RDY  1
 #define EEH_FLUSH_DONE 2
+		uint32_t	t262_fail:1;
+		uint32_t	t272_fail:1;
 		uint32_t	secure_mcu:1;
 		uint32_t	valid_flt:1;
 	} flags;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ae9bf6871079..9d6b229bd352 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3275,47 +3275,37 @@ qla81xx_reset_mpi(scsi_qla_host_t *vha)
 	return qla81xx_write_mpi_register(vha, mb);
 }
 
-static int
-qla_chk_risc_recovery(scsi_qla_host_t *vha)
+/* save MB regs at start of day for fw dump */
+static void
+qla_save_mbregs(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	__le16 __iomem *mbptr = &reg->mailbox0;
 	int i;
-	u16 mb[32];
-	int rc = QLA_SUCCESS;
-
-	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
-		return rc;
+	u16 *mb = ha->mbregs;
 
-	/* this check is only valid after RISC reset */
-	mb[0] = rd_reg_word(mbptr);
-	mbptr++;
-	if (mb[0] == 0xf) {
-		rc = QLA_FUNCTION_FAILED;
+	if ((!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha)) ||
+	    vha->flags.init_done)
+		return;
 
-		for (i = 1; i < 32; i++) {
-			mb[i] = rd_reg_word(mbptr);
-			mbptr++;
-		}
-
-		ql_log(ql_log_warn, vha, 0x1015,
-		       "RISC reset failed. mb[0-7] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
-		       mb[0], mb[1], mb[2], mb[3], mb[4], mb[5], mb[6], mb[7]);
-		ql_log(ql_log_warn, vha, 0x1015,
-		       "RISC reset failed. mb[8-15] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
-		       mb[8], mb[9], mb[10], mb[11], mb[12], mb[13], mb[14],
-		       mb[15]);
-		ql_log(ql_log_warn, vha, 0x1015,
-		       "RISC reset failed. mb[16-23] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
-		       mb[16], mb[17], mb[18], mb[19], mb[20], mb[21], mb[22],
-		       mb[23]);
-		ql_log(ql_log_warn, vha, 0x1015,
-		       "RISC reset failed. mb[24-31] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
-		       mb[24], mb[25], mb[26], mb[27], mb[28], mb[29], mb[30],
-		       mb[31]);
+	for (i = 0; i < 32; i++) {
+		mb[i] = rd_reg_word(mbptr);
+		mbptr++;
 	}
-	return rc;
+
+	ql_log(ql_log_info, vha, 0x1015,
+	    "mb[0-7] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
+	    mb[0], mb[1], mb[2], mb[3], mb[4], mb[5], mb[6], mb[7]);
+	ql_log(ql_log_info, vha, 0x1015,
+	    "mb[8-15] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
+	    mb[8], mb[9], mb[10], mb[11], mb[12], mb[13], mb[14], mb[15]);
+	ql_log(ql_log_info, vha, 0x1015,
+	    "mb[16-23] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
+	    mb[16], mb[17], mb[18], mb[19], mb[20], mb[21], mb[22], mb[23]);
+	ql_log(ql_log_info, vha, 0x1015,
+	    "mb[24-31] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
+	    mb[24], mb[25], mb[26], mb[27], mb[28], mb[29], mb[30], mb[31]);
 }
 
 /**
@@ -3334,7 +3324,6 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 	uint16_t wd;
 	static int abts_cnt; /* ISP abort retry counts */
 	int rval = QLA_SUCCESS;
-	int print = 1;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -3431,9 +3420,6 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 		barrier();
 		if (cnt) {
 			mdelay(1);
-			if (print && qla_chk_risc_recovery(vha))
-				print = 0;
-
 			wd = rd_reg_word(&reg->mailbox0);
 		} else {
 			rval = QLA_FUNCTION_TIMEOUT;
@@ -3453,6 +3439,8 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+	qla_save_mbregs(vha);
+
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x015f,
 	    "Driver in %s mode\n",
 	    IS_NOPOLLING_TYPE(ha) ? "Interrupt" : "Polling");
@@ -3813,18 +3801,11 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 	struct rsp_que *rsp = ha->rsp_q_map[0];
-	struct qla2xxx_fw_dump *fw_dump;
+	struct qla2xxx_fw_dump *fw_dump, *prev_fw_dump;
+	void *prev_mpi_fw_dump;
 	size_t req_entry_size = qla_req_entry_size(ha);
 	size_t rsp_entry_size = qla_rsp_entry_size(ha);
 
-	if (ha->fw_dump) {
-		ql_dbg(ql_dbg_init, vha, 0x00bd,
-		    "Firmware dump already allocated.\n");
-		return;
-	}
-
-	ha->fw_dumped = 0;
-	ha->fw_dump_cap_flags = 0;
 	dump_size = fixed_size = mem_size = eft_size = fce_size = mq_size = 0;
 	req_q_size = rsp_q_size = 0;
 
@@ -3907,13 +3888,11 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 				ha->exlogin_size;
 	}
 
-	if (!ha->fw_dump_len || dump_size > ha->fw_dump_alloc_len) {
-
-		ql_dbg(ql_dbg_init, vha, 0x00c5,
-		    "%s dump_size %d fw_dump_len %d fw_dump_alloc_len %d\n",
-		    __func__, dump_size, ha->fw_dump_len,
-		    ha->fw_dump_alloc_len);
+	ql_dbg(ql_dbg_init, vha, 0x00c5,
+	    "%s dump_size %d fw_dump_len %d fw_dump_alloc_len %d\n",
+	    __func__, dump_size, ha->fw_dump_len, ha->fw_dump_alloc_len);
 
+	if (!ha->fw_dump_len || dump_size > ha->fw_dump_alloc_len) {
 		fw_dump = vmalloc(dump_size);
 		if (!fw_dump) {
 			ql_log(ql_log_warn, vha, 0x00c4,
@@ -3921,9 +3900,26 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			    dump_size / 1024);
 		} else {
 			mutex_lock(&ha->optrom_mutex);
-			if (ha->fw_dumped) {
-				memcpy(fw_dump, ha->fw_dump, ha->fw_dump_len);
-				vfree(ha->fw_dump);
+
+			if (ha->fw_dumped || ha->mpi_fw_dumped) {
+				prev_fw_dump = ha->fw_dump;
+
+				if (ha->fw_dumped)
+					memcpy(fw_dump, prev_fw_dump,
+					    ha->fw_dump_len);
+
+				if (IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+				    IS_QLA29XX(ha)) {
+					prev_mpi_fw_dump = ha->mpi_fw_dump;
+					ha->mpi_fw_dump = (char *)fw_dump +
+						ha->fwdt[0].dump_size;
+
+					if (ha->mpi_fw_dumped)
+						memcpy(ha->mpi_fw_dump,
+						    prev_mpi_fw_dump,
+						    ha->mpi_fw_dump_len);
+				}
+				vfree(prev_fw_dump);
 				ha->fw_dump = fw_dump;
 				ha->fw_dump_alloc_len =  dump_size;
 				ql_dbg(ql_dbg_init, vha, 0x00c5,
@@ -3942,7 +3938,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 				if (IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
 				    IS_QLA29XX(ha)) {
 					ha->mpi_fw_dump = (char *)fw_dump +
-						ha->fwdt[1].dump_size;
+						ha->fwdt[0].dump_size;
 					mutex_unlock(&ha->optrom_mutex);
 					return;
 				}
@@ -4339,6 +4335,16 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 
 		rval = qla2x00_verify_checksum(vha, srisc_address);
 		if (rval == QLA_SUCCESS) {
+			/*
+			 * Alloc a guestimate dump buffer to capture any failure
+			 * during early phase of driver load.
+			 */
+			if (ql2xallocfwdump &&
+			    (IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+			     IS_QLA29XX(ha)) &&
+			    !vha->flags.init_done)
+				qla2x00_alloc_fw_dump(vha);
+
 			/* Start firmware execution. */
 			ql_dbg(ql_dbg_init, vha, 0x00ca,
 			    "Starting firmware.\n");
@@ -4928,6 +4934,8 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_init, vha, 0x00d3,
 		    "Init Firmware -- success.\n");
 		vha->u_ql2xexchoffld = vha->u_ql2xiniexchg = 0;
+		vha->hw->flags.t262_fail = 0;
+		vha->hw->flags.t272_fail = 0;
 	}
 
 	return (rval);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5209dda45459..62c9bd0fe06d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3721,6 +3721,14 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (test_bit(UNLOADING, &base_vha->dpc_flags))
 		return -ENODEV;
 
+	/*
+	 * FW dump can happens before sysfs nodes are created.  If sysfs nodes
+	 * are unavailable then udev script will not be able to read the fw dump.
+	 * Notify udev to read again, now that sysfs nodes are available.
+	 */
+	if (ha->fw_dumped || ha->mpi_fw_dumped)
+		qla2x00_post_uevent_work(base_vha, QLA_UEVENT_CODE_FW_DUMP);
+
 	return 0;
 
 probe_failed:
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index b0a74b036cf4..fd3984127497 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -306,6 +306,12 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 		goto done;
 	}
 
+	if (vha->hw->flags.t262_fail) {
+		ql_dbg(ql_dbg_misc, vha, 0xd045,
+		    "%s: failed previously\n", __func__);
+		qla27xx_skip_entry(ent, buf);
+		goto done;
+	}
 	dwords = end - start + 1;
 	if (buf) {
 		buf += *len;
@@ -314,7 +320,12 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 			ql_dbg(ql_dbg_async, vha, 0xffff,
 			    "%s: dump ram MB failed. Area %xh start %lxh end %lxh\n",
 			    __func__, area, start, end);
-			return INVALID_ENTRY;
+
+			if (rc == QLA_FUNCTION_TIMEOUT)
+				vha->hw->flags.t262_fail = 1;
+
+			qla27xx_skip_entry(ent, buf);
+			goto done;
 		}
 	}
 	*len += dwords * sizeof(uint32_t);
@@ -536,13 +547,12 @@ qla27xx_fwdt_entry_t269(struct scsi_qla_host *vha,
 {
 	ql_dbg(ql_dbg_misc, vha, 0xd20d,
 	    "%s: scratch [%lx]\n", __func__, *len);
-	qla27xx_insert32(0xaaaaaaaa, buf, len);
-	qla27xx_insert32(0xbbbbbbbb, buf, len);
-	qla27xx_insert32(0xcccccccc, buf, len);
-	qla27xx_insert32(0xdddddddd, buf, len);
-	qla27xx_insert32(*len + sizeof(uint32_t), buf, len);
+
+	/* The data format is based on entry type t260. */
+	qla27xx_insert32(offsetof(struct device_reg_24xx, mailbox0), buf, len);
+	qla27xx_insertbuf(vha->hw->mbregs, sizeof(vha->hw->mbregs), buf, len);
 	if (buf)
-		ent->t269.scratch_size = 5 * sizeof(uint32_t);
+		ent->t269.scratch_size = sizeof(uint32_t) + sizeof(vha->hw->mbregs);
 
 	return qla27xx_next_entry(ent);
 }
@@ -589,17 +599,37 @@ qla27xx_fwdt_entry_t272(struct scsi_qla_host *vha,
 {
 	ulong dwords = le32_to_cpu(ent->t272.count);
 	ulong start = le32_to_cpu(ent->t272.addr);
+	int rc;
 
 	ql_dbg(ql_dbg_misc, vha, 0xd210,
 	    "%s: rdremram [%lx]\n", __func__, *len);
+
+	if (vha->hw->flags.t272_fail) {
+		ql_dbg(ql_dbg_misc, vha, 0xd04f,
+		    "%s: failed previously\n", __func__);
+		qla27xx_skip_entry(ent, buf);
+		goto done;
+	}
+
 	if (buf) {
 		ql_dbg(ql_dbg_misc, vha, 0xd02c,
 		    "%s: @%lx -> (%lx dwords)\n", __func__, start, dwords);
 		buf += *len;
-		qla27xx_dump_mpi_ram(vha->hw, start, buf, dwords, &buf);
+		rc = qla27xx_dump_mpi_ram(vha->hw, start, buf, dwords, &buf);
+		if (rc != QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0xd01b,
+			    "%s: dump mpi MB failed. Start %lxh dwords %lxh\n",
+			    __func__, start, dwords);
+
+			if (rc == QLA_FUNCTION_TIMEOUT)
+				vha->hw->flags.t272_fail = 1;
+
+			qla27xx_skip_entry(ent, buf);
+			goto done;
+		}
 	}
 	*len += dwords * sizeof(uint32_t);
-
+done:
 	return qla27xx_next_entry(ent);
 }
 
-- 
2.47.3

