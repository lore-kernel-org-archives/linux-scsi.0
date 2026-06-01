Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF2C33BBAF
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309870; cv=none; b=dP/PzSzP7asaqKezTeWriyMud7lowinDkm6kXYIxYDkGJ9FKcVTx8T9NpzsvHBfZcFaPyL4odzgr2sc9Znj4686Z8CN1tNLngZMnthptyVCwt9mSCcjGQTjCkH7bfeb2l6aG2oNi7g2RK6FaHplQImtHLLcK/dI1GrpZH8qcTrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309870; c=relaxed/simple;
	bh=bg5FJbIDlDS12RpiGDLJoomSFa/GzvVX4hrGz6l0K2c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D3ibaN7eEsE7xTVSCkDH4JcVimkraCP50+mvU326syI1Yngl0J5uBHPXyRBVPs3s11z0+wZjf4K/KeIwSoHPZYmyTv6MR2xHw8baWxT8BCvFDUaNa3J28Zf3qCR9rINAxdzhjjQOJQQuOLM9jEHgDRq2nUm2fWIh/ZgfKhS2t68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=g6R9j7SX; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="g6R9j7SX"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLsEuN1222214;
	Mon, 1 Jun 2026 03:31:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=n
	3EhYbm6GGGojFrWamFzjIFrNkK/t95xmtZxNgKHReA=; b=g6R9j7SXs33K1pjOK
	WeEOF/Y7wYULrAPpZtMZoAh6hoI1wY/hhfhu4fPRpXwh768vJtgfMzjGshW3YjVD
	ZDMyosWcYp8Py55Z/qJggkOeez+tl0O6wVvp0128ohwaMsKqpkULjBsMLWBoEg3V
	58HcQYSo/h6tm5lxYDc2W24mmjDsvqMOwE10nV2ohyBDXywTHkFgwUMeL7ZIFv28
	Xfk/2uQwwJK1w0m4lL0B02sfkdvi/F3pIrusp0b3G5YskGqww3tMj5nOwewzeJUU
	jTXSEDgxXktr1Lc+H5tfDsvRAot2K52Vvd9EJMWCw1jV3UIidz4XF02CVmb+YU3b
	GL2Og==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:31:04 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:31:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:31:03 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id CD4C03F7053;
	Mon,  1 Jun 2026 03:31:00 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 35/44] scsi: qla2xxx: Enhance task management IOCB handling for 29xx series
Date: Mon, 1 Jun 2026 15:58:44 +0530
Message-ID: <20260601102853.328426-36-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX/s+MBplHK6pM
 iFhhhURAfDBIhAjThTszAlzYtjMKlFFl6kGo0ZypRRSZSjIxImPDVg6SSeKyepVbNHqugfDNgvD
 iRFZkyOwNvTTO75D+v6wyeSyapMmNDk/p2ofMyTT/jKXoB60WTjuzBvkKDxHoRHT4JLrrX0u91b
 8Y8ljuK6xS98b4lfd86L+fBz2m7yllv3Qpg/qswizbbbI6Qt5XUXGvl1wv0K3xzLXcbX4SKfUVK
 T0mf/9d/2nTj65rLPnZ6rA0Ka4DaQ8Rsm+I47K4uxpeDRDP3hp7KTu2+VaYANfn6i/nzUiZiLMG
 SEJ8YYu6BcUlHEg1BlPFFm1p/esEMYcqvWz5dUlG7mP+tNzNtKX6r2Zu4gc3sMczC7fqHSMfl5R
 jfk8sIv7xG7+uahbPebbBkOwuNWHbV8lsEj4t4J/gnANEQhXKSnksQGUOyvIBkS4LS9mi1gH0X4
 QE5hM9E9x8E06jJySew==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f68 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=GCX_fLWMEB1gCRu7i1AA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: aeyZwSTF5UHfFCn-14Vlhc_Y3oiuz7y7
X-Proofpoint-GUID: aeyZwSTF5UHfFCn-14Vlhc_Y3oiuz7y7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Update qla24xx_tm_iocb() and __qla24xx_issue_tmf() to support the
extended task management structure (tsk_mgmt_entry_ext) for 29xx
adapters.

tsk_mgmt_entry_ext overlays tsk_mgmt_entry through control_flags
(offsets 0-27 are byte-identical): entry_type, entry_count, handle,
nport_handle, timeout, lun and control_flags sit at the same offsets
and widths.  The layouts diverge only after that point:

  - the 24xx layout has port_id[3] + u8 vp_index;
  - the ext layout has __le16 vp_index and no port_id.

Factor the common IOCB header writes through a single tsk_mgmt_entry *
view and branch on IS_QLA29XX() only for the diverging port_id /
vp_index assignments.  Change qla24xx_tm_iocb() to accept void *pkt
to allow casting to either structure type.

Add tsk_ext member to the tsk_mgmt_cmd union and a BUILD_BUG_ON size
check for the 128-byte extended structure.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 31 ++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_mbx.c  | 18 ++++++++++++++----
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b67ecf8ad00d..1327b04d23ad 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2670,7 +2670,7 @@ qla2x00_adisc_iocb(srb_t *sp, struct mbx_entry *mbx)
 }
 
 static void
-qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
+qla24xx_tm_iocb(srb_t *sp, void *pkt)
 {
 	uint32_t flags;
 	uint64_t lun;
@@ -2679,26 +2679,39 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 	struct qla_hw_data *ha = vha->hw;
 	struct srb_iocb *iocb = &sp->u.iocb_cmd;
 	struct req_que *req = sp->qpair->req;
+	struct tsk_mgmt_entry *tsk;
 
 	flags = iocb->u.tmf.flags;
 	lun = iocb->u.tmf.lun;
 
+	/*
+	 * tsk_mgmt_entry_ext overlays tsk_mgmt_entry through control_flags
+	 * (offsets 0-27 are byte-identical), so the common header writes
+	 * go through one struct tsk_mgmt_entry * view.  The ext layout
+	 * has no port_id and uses a wider __le16 vp_index at a different
+	 * offset, so port_id / vp_index assignments diverge per stride.
+	 */
+	tsk = pkt;
 	tsk->entry_type = TSK_MGMT_IOCB_TYPE;
 	tsk->entry_count = 1;
 	tsk->handle = make_handle(req->id, tsk->handle);
 	tsk->nport_handle = cpu_to_le16(fcport->loop_id);
 	tsk->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	tsk->control_flags = cpu_to_le32(flags);
-	tsk->port_id[0] = fcport->d_id.b.al_pa;
-	tsk->port_id[1] = fcport->d_id.b.area;
-	tsk->port_id[2] = fcport->d_id.b.domain;
-	tsk->vp_index = fcport->vha->vp_idx;
+	if (IS_QLA29XX(ha)) {
+		((struct tsk_mgmt_entry_ext *)pkt)->vp_index =
+		    cpu_to_le16(fcport->vha->vp_idx);
+	} else {
+		tsk->port_id[0] = fcport->d_id.b.al_pa;
+		tsk->port_id[1] = fcport->d_id.b.area;
+		tsk->port_id[2] = fcport->d_id.b.domain;
+		tsk->vp_index = fcport->vha->vp_idx;
+	}
 
-	if (flags & (TCF_LUN_RESET | TCF_ABORT_TASK_SET|
-	    TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA)) {
+	if (flags & (TCF_LUN_RESET | TCF_ABORT_TASK_SET |
+	    TCF_CLEAR_TASK_SET | TCF_CLEAR_ACA)) {
 		int_to_scsilun(lun, &tsk->lun);
-		host_to_fcp_swap((uint8_t *)&tsk->lun,
-			sizeof(tsk->lun));
+		host_to_fcp_swap((uint8_t *)&tsk->lun, sizeof(tsk->lun));
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ea8f4dddbc99..b30c88d2a505 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3419,6 +3419,7 @@ qla24xx_abort_command(srb_t *sp)
 struct tsk_mgmt_cmd {
 	union {
 		struct tsk_mgmt_entry tsk;
+		struct tsk_mgmt_entry_ext tsk_ext;
 		struct sts_entry_24xx sts;
 		struct sts_entry_24xx_ext sts_ext;
 	} p;
@@ -3458,16 +3459,25 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
+	/*
+	 * tsk_mgmt_entry_ext overlays tsk_mgmt_entry through control_flags;
+	 * the common-header writes go through tsk->p.tsk and only port_id
+	 * (24xx-only) and vp_index width / offset diverge.
+	 */
 	tsk->p.tsk.entry_type = TSK_MGMT_IOCB_TYPE;
 	tsk->p.tsk.entry_count = 1;
 	tsk->p.tsk.handle = make_handle(req->id, tsk->p.tsk.handle);
 	tsk->p.tsk.nport_handle = cpu_to_le16(fcport->loop_id);
 	tsk->p.tsk.timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	tsk->p.tsk.control_flags = cpu_to_le32(type);
-	tsk->p.tsk.port_id[0] = fcport->d_id.b.al_pa;
-	tsk->p.tsk.port_id[1] = fcport->d_id.b.area;
-	tsk->p.tsk.port_id[2] = fcport->d_id.b.domain;
-	tsk->p.tsk.vp_index = fcport->vha->vp_idx;
+	if (IS_QLA29XX(ha)) {
+		tsk->p.tsk_ext.vp_index = cpu_to_le16(fcport->vha->vp_idx);
+	} else {
+		tsk->p.tsk.port_id[0] = fcport->d_id.b.al_pa;
+		tsk->p.tsk.port_id[1] = fcport->d_id.b.area;
+		tsk->p.tsk.port_id[2] = fcport->d_id.b.domain;
+		tsk->p.tsk.vp_index = fcport->vha->vp_idx;
+	}
 	if (type == TCF_LUN_RESET) {
 		int_to_scsilun(l, &tsk->p.tsk.lun);
 		host_to_fcp_swap((uint8_t *)&tsk->p.tsk.lun,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e128e3dee4b5..eca6b1cab8d9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8418,6 +8418,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct sts_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct sts_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry) != 64);
+	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
-- 
2.47.3

