Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C53F11712
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 00:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758844941; cv=none; b=HidHiMDmkTRjozQfFuBN94+/rrqxDsmG1tFufQxi4XI7pK1h9294GbOfd7W35MwLsLn7bJN2dK/NCswTRGfI8vAHRAU4Qr/47KbL5Q5iP1+YoA+MfW4McwDXuuSUCLOJVQLhjCKZO6y4jdi+4LVs+zZbGGWZhcgjYn3YRNf7sg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758844941; c=relaxed/simple;
	bh=R7FFyqn9kXUmQUEBoms5q8YdJYQ9ZQOcGYupqV56ZbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=JA3mdEE0XDrfEeNhKhZcB3Tk4GiFam55+SN8QXXcdtzkXnTebcwZ9IhitIyQ6fr8RI5DQ0eiP5YOaKiRL93sDxVeRl+muDGwtzkRXefWshGSD0UA78IxvloQjCjXzkxBjms0MAT/vxs3KYnrZ0aY1Q44e8vje5ld+/zHX2yxUw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gwvMJkY1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gwvMJkY1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758844936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWNknXaQBV+314sS4VIZ7Rhk2F5wUSQQ5U/7e7OXcuU=;
	b=gwvMJkY1cUF94X2PimwrNOMw47oOLgAWxB6nMgkj0NMv9jlQZcvBpY0S2jQ53fIQXDnL6j
	T9+lZgmHvuG0/9nRedLsCN9iv4C6sxIJB60usWNUi1IOlBDAGQqsT9CpH9vMA9nD9cRz+F
	dNyAYj/+Pzq0OASzKl5IpOLA67zLgLg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-Y8eodPNwMuuXkaMHvhCrKw-1; Thu,
 25 Sep 2025 20:02:12 -0400
X-MC-Unique: Y8eodPNwMuuXkaMHvhCrKw-1
X-Mimecast-MFC-AGG-ID: Y8eodPNwMuuXkaMHvhCrKw_1758844930
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 974CE195609F;
	Fri, 26 Sep 2025 00:02:10 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen7.rmtusnh.csb (unknown [10.22.81.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4B166180057C;
	Fri, 26 Sep 2025 00:02:07 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: hare@suse.de,
	kbusch@kernel.org,
	martin.petersen@oracle.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com,
	axboe@kernel.dk,
	emilne@redhat.com,
	gustavoars@kernel.org,
	hch@lst.de,
	james.smart@broadcom.com,
	jmeneghi@redhat.com,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	njavali@marvell.com,
	sagi@grimberg.me
Subject: [PATCH v10 01/11] fc_els: use 'union fc_tlv_desc'
Date: Thu, 25 Sep 2025 20:01:50 -0400
Message-ID: <20250926000200.837025-2-jmeneghi@redhat.com>
In-Reply-To: <20250926000200.837025-1-jmeneghi@redhat.com>
References: <20250926000200.837025-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Hannes Reinecke <hare@kernel.org>

Introduce 'union fc_tlv_desc' to have a common structure for all FC
ELS TLV structures and avoid type casts.

[bgurney: The cast inside the union fc_tlv_next_desc() has "u8",
which causes a failure to build.  Use "__u8" instead.]

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Tested-by: Bryan Gurney <bgurney@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c     |  75 +++++++-------
 drivers/scsi/scsi_transport_fc.c |  27 +++--
 include/uapi/scsi/fc/fc_els.h    | 165 +++++++++++++++++--------------
 3 files changed, 135 insertions(+), 132 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fca81e0c7c2e..1511cabac636 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3937,7 +3937,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	IOCB_t *irsp_iocb;
 	struct fc_els_edc_resp *edc_rsp;
-	struct fc_tlv_desc *tlv;
+	union fc_tlv_desc *tlv;
 	struct fc_diag_cg_sig_desc *pcgd;
 	struct fc_diag_lnkflt_desc *plnkflt;
 	struct lpfc_dmabuf *pcmd, *prsp;
@@ -4028,7 +4028,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		}
 
-		dtag = be32_to_cpu(tlv->desc_tag);
+		dtag = be32_to_cpu(tlv->hdr.desc_tag);
 		switch (dtag) {
 		case ELS_DTAG_LNK_FAULT_CAP:
 			if (bytes_remain < FC_TLV_DESC_SZ_FROM_LENGTH(tlv) ||
@@ -4043,7 +4043,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					sizeof(struct fc_diag_lnkflt_desc));
 				goto out;
 			}
-			plnkflt = (struct fc_diag_lnkflt_desc *)tlv;
+			plnkflt = &tlv->lnkflt;
 			lpfc_printf_log(phba, KERN_INFO,
 				LOG_ELS | LOG_LDS_EVENT,
 				"4617 Link Fault Desc Data: 0x%08x 0x%08x "
@@ -4070,7 +4070,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				goto out;
 			}
 
-			pcgd = (struct fc_diag_cg_sig_desc *)tlv;
+			pcgd = &tlv->cg_sig;
 			lpfc_printf_log(
 				phba, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
 				"4616 CGN Desc Data: 0x%08x 0x%08x "
@@ -4125,10 +4125,8 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 static void
-lpfc_format_edc_lft_desc(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
+lpfc_format_edc_lft_desc(struct lpfc_hba *phba, struct fc_diag_lnkflt_desc *lft)
 {
-	struct fc_diag_lnkflt_desc *lft = (struct fc_diag_lnkflt_desc *)tlv;
-
 	lft->desc_tag = cpu_to_be32(ELS_DTAG_LNK_FAULT_CAP);
 	lft->desc_len = cpu_to_be32(
 		FC_TLV_DESC_LENGTH_FROM_SZ(struct fc_diag_lnkflt_desc));
@@ -4141,10 +4139,8 @@ lpfc_format_edc_lft_desc(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 }
 
 static void
-lpfc_format_edc_cgn_desc(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
+lpfc_format_edc_cgn_desc(struct lpfc_hba *phba, struct fc_diag_cg_sig_desc *cgd)
 {
-	struct fc_diag_cg_sig_desc *cgd = (struct fc_diag_cg_sig_desc *)tlv;
-
 	/* We are assuming cgd was zero'ed before calling this routine */
 
 	/* Configure the congestion detection capability */
@@ -4233,7 +4229,7 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_iocbq *elsiocb;
 	struct fc_els_edc *edc_req;
-	struct fc_tlv_desc *tlv;
+	union fc_tlv_desc *tlv;
 	u16 cmdsize;
 	struct lpfc_nodelist *ndlp;
 	u8 *pcmd = NULL;
@@ -4272,13 +4268,13 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 	tlv = edc_req->desc;
 
 	if (cgn_desc_size) {
-		lpfc_format_edc_cgn_desc(phba, tlv);
+		lpfc_format_edc_cgn_desc(phba, &tlv->cg_sig);
 		phba->cgn_sig_freq = lpfc_fabric_cgn_frequency;
 		tlv = fc_tlv_next_desc(tlv);
 	}
 
 	if (lft_desc_size)
-		lpfc_format_edc_lft_desc(phba, tlv);
+		lpfc_format_edc_lft_desc(phba, &tlv->lnkflt);
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
 			 "4623 Xmit EDC to remote "
@@ -5824,7 +5820,7 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct fc_els_edc_resp *edc_rsp;
-	struct fc_tlv_desc *tlv;
+	union fc_tlv_desc *tlv;
 	struct lpfc_iocbq *elsiocb;
 	IOCB_t *icmd, *cmd;
 	union lpfc_wqe128 *wqe;
@@ -5868,10 +5864,10 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		FC_TLV_DESC_LENGTH_FROM_SZ(struct fc_els_lsri_desc));
 	edc_rsp->lsri.rqst_w0.cmd = ELS_EDC;
 	tlv = edc_rsp->desc;
-	lpfc_format_edc_cgn_desc(phba, tlv);
+	lpfc_format_edc_cgn_desc(phba, &tlv->cg_sig);
 	tlv = fc_tlv_next_desc(tlv);
 	if (lft_desc_size)
-		lpfc_format_edc_lft_desc(phba, tlv);
+		lpfc_format_edc_lft_desc(phba, &tlv->lnkflt);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 			      "Issue EDC ACC:      did:x%x flg:x%lx refcnt %d",
@@ -9263,7 +9259,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct fc_els_edc *edc_req;
-	struct fc_tlv_desc *tlv;
+	union fc_tlv_desc *tlv;
 	uint8_t *payload;
 	uint32_t *ptr, dtag;
 	const char *dtag_nm;
@@ -9306,7 +9302,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		}
 
-		dtag = be32_to_cpu(tlv->desc_tag);
+		dtag = be32_to_cpu(tlv->hdr.desc_tag);
 		switch (dtag) {
 		case ELS_DTAG_LNK_FAULT_CAP:
 			if (bytes_remain < FC_TLV_DESC_SZ_FROM_LENGTH(tlv) ||
@@ -9321,7 +9317,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 					sizeof(struct fc_diag_lnkflt_desc));
 				goto out;
 			}
-			plnkflt = (struct fc_diag_lnkflt_desc *)tlv;
+			plnkflt = &tlv->lnkflt;
 			lpfc_printf_log(phba, KERN_INFO,
 				LOG_ELS | LOG_LDS_EVENT,
 				"4626 Link Fault Desc Data: x%08x len x%x "
@@ -9358,7 +9354,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			phba->cgn_sig_freq = lpfc_fabric_cgn_frequency;
 
 			lpfc_least_capable_settings(
-				phba, (struct fc_diag_cg_sig_desc *)tlv);
+				phba, &tlv->cg_sig);
 			break;
 		default:
 			dtag_nm = lpfc_get_tlv_dtag_nm(dtag);
@@ -9949,14 +9945,13 @@ lpfc_display_fpin_wwpn(struct lpfc_hba *phba, __be64 *wwnlist, u32 cnt)
 /**
  * lpfc_els_rcv_fpin_li - Process an FPIN Link Integrity Event.
  * @phba: Pointer to phba object.
- * @tlv:  Pointer to the Link Integrity Notification Descriptor.
+ * @li:  Pointer to the Link Integrity Notification Descriptor.
  *
  * This function processes a Link Integrity FPIN event by logging a message.
  **/
 static void
-lpfc_els_rcv_fpin_li(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
+lpfc_els_rcv_fpin_li(struct lpfc_hba *phba, struct fc_fn_li_desc *li)
 {
-	struct fc_fn_li_desc *li = (struct fc_fn_li_desc *)tlv;
 	const char *li_evt_str;
 	u32 li_evt, cnt;
 
@@ -9980,14 +9975,13 @@ lpfc_els_rcv_fpin_li(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 /**
  * lpfc_els_rcv_fpin_del - Process an FPIN Delivery Event.
  * @phba: Pointer to hba object.
- * @tlv:  Pointer to the Delivery Notification Descriptor TLV
+ * @del:  Pointer to the Delivery Notification Descriptor TLV
  *
  * This function processes a Delivery FPIN event by logging a message.
  **/
 static void
-lpfc_els_rcv_fpin_del(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
+lpfc_els_rcv_fpin_del(struct lpfc_hba *phba, struct fc_fn_deli_desc *del)
 {
-	struct fc_fn_deli_desc *del = (struct fc_fn_deli_desc *)tlv;
 	const char *del_rsn_str;
 	u32 del_rsn;
 	__be32 *frame;
@@ -10018,14 +10012,14 @@ lpfc_els_rcv_fpin_del(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 /**
  * lpfc_els_rcv_fpin_peer_cgn - Process a FPIN Peer Congestion Event.
  * @phba: Pointer to hba object.
- * @tlv:  Pointer to the Peer Congestion Notification Descriptor TLV
+ * @pc:  Pointer to the Peer Congestion Notification Descriptor TLV
  *
  * This function processes a Peer Congestion FPIN event by logging a message.
  **/
 static void
-lpfc_els_rcv_fpin_peer_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
+lpfc_els_rcv_fpin_peer_cgn(struct lpfc_hba *phba,
+			   struct fc_fn_peer_congn_desc *pc)
 {
-	struct fc_fn_peer_congn_desc *pc = (struct fc_fn_peer_congn_desc *)tlv;
 	const char *pc_evt_str;
 	u32 pc_evt, cnt;
 
@@ -10053,7 +10047,7 @@ lpfc_els_rcv_fpin_peer_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 /**
  * lpfc_els_rcv_fpin_cgn - Process an FPIN Congestion notification
  * @phba: Pointer to hba object.
- * @tlv:  Pointer to the Congestion Notification Descriptor TLV
+ * @cgn:  Pointer to the Congestion Notification Descriptor TLV
  *
  * This function processes an FPIN Congestion Notifiction.  The notification
  * could be an Alarm or Warning.  This routine feeds that data into driver's
@@ -10062,10 +10056,9 @@ lpfc_els_rcv_fpin_peer_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
  * to the upper layer or 0 to indicate don't deliver it.
  **/
 static int
-lpfc_els_rcv_fpin_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
+lpfc_els_rcv_fpin_cgn(struct lpfc_hba *phba, struct fc_fn_congn_desc *cgn)
 {
 	struct lpfc_cgn_info *cp;
-	struct fc_fn_congn_desc *cgn = (struct fc_fn_congn_desc *)tlv;
 	const char *cgn_evt_str;
 	u32 cgn_evt;
 	const char *cgn_sev_str;
@@ -10168,7 +10161,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_els_fpin *fpin = (struct fc_els_fpin *)p;
-	struct fc_tlv_desc *tlv, *first_tlv, *current_tlv;
+	union fc_tlv_desc *tlv, *first_tlv, *current_tlv;
 	const char *dtag_nm;
 	int desc_cnt = 0, bytes_remain, cnt;
 	u32 dtag, deliver = 0;
@@ -10193,7 +10186,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 		return;
 	}
 
-	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
+	tlv = &fpin->fpin_desc[0];
 	first_tlv = tlv;
 	bytes_remain = fpin_length - offsetof(struct fc_els_fpin, fpin_desc);
 	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
@@ -10201,22 +10194,22 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 	/* process each descriptor separately */
 	while (bytes_remain >= FC_TLV_DESC_HDR_SZ &&
 	       bytes_remain >= FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
-		dtag = be32_to_cpu(tlv->desc_tag);
+		dtag = be32_to_cpu(tlv->hdr.desc_tag);
 		switch (dtag) {
 		case ELS_DTAG_LNK_INTEGRITY:
-			lpfc_els_rcv_fpin_li(phba, tlv);
+			lpfc_els_rcv_fpin_li(phba, &tlv->li);
 			deliver = 1;
 			break;
 		case ELS_DTAG_DELIVERY:
-			lpfc_els_rcv_fpin_del(phba, tlv);
+			lpfc_els_rcv_fpin_del(phba, &tlv->deli);
 			deliver = 1;
 			break;
 		case ELS_DTAG_PEER_CONGEST:
-			lpfc_els_rcv_fpin_peer_cgn(phba, tlv);
+			lpfc_els_rcv_fpin_peer_cgn(phba, &tlv->peer_congn);
 			deliver = 1;
 			break;
 		case ELS_DTAG_CONGESTION:
-			deliver = lpfc_els_rcv_fpin_cgn(phba, tlv);
+			deliver = lpfc_els_rcv_fpin_cgn(phba, &tlv->congn);
 			break;
 		default:
 			dtag_nm = lpfc_get_tlv_dtag_nm(dtag);
@@ -10229,12 +10222,12 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 			return;
 		}
 		lpfc_cgn_update_stat(phba, dtag);
-		cnt = be32_to_cpu(tlv->desc_len);
+		cnt = be32_to_cpu(tlv->hdr.desc_len);
 
 		/* Sanity check descriptor length. The desc_len value does not
 		 * include space for the desc_tag and the desc_len fields.
 		 */
-		len -= (cnt + sizeof(struct fc_tlv_desc));
+		len -= (cnt + sizeof(struct fc_tlv_desc_hdr));
 		if (len < 0) {
 			dtag_nm = lpfc_get_tlv_dtag_nm(dtag);
 			lpfc_printf_log(phba, KERN_WARNING, LOG_CGN_MGMT,
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3a821afee9bc..f31fdc840191 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -743,13 +743,12 @@ fc_cn_stats_update(u16 event_type, struct fc_fpin_stats *stats)
  *
  */
 static void
-fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
+fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_fn_li_desc *li_desc)
 {
 	u8 i;
 	struct fc_rport *rport = NULL;
 	struct fc_rport *attach_rport = NULL;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
-	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
 	u16 event_type = be16_to_cpu(li_desc->event_type);
 	u64 wwpn;
 
@@ -792,12 +791,11 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
  */
 static void
 fc_fpin_delivery_stats_update(struct Scsi_Host *shost,
-			      struct fc_tlv_desc *tlv)
+			      struct fc_fn_deli_desc *dn_desc)
 {
 	struct fc_rport *rport = NULL;
 	struct fc_rport *attach_rport = NULL;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
-	struct fc_fn_deli_desc *dn_desc = (struct fc_fn_deli_desc *)tlv;
 	u32 reason_code = be32_to_cpu(dn_desc->deli_reason_code);
 
 	rport = fc_find_rport_by_wwpn(shost,
@@ -823,13 +821,11 @@ fc_fpin_delivery_stats_update(struct Scsi_Host *shost,
  */
 static void
 fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
-				struct fc_tlv_desc *tlv)
+				struct fc_fn_peer_congn_desc *pc_desc)
 {
 	u8 i;
 	struct fc_rport *rport = NULL;
 	struct fc_rport *attach_rport = NULL;
-	struct fc_fn_peer_congn_desc *pc_desc =
-	    (struct fc_fn_peer_congn_desc *)tlv;
 	u16 event_type = be16_to_cpu(pc_desc->event_type);
 	u64 wwpn;
 
@@ -869,10 +865,9 @@ fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
  */
 static void
 fc_fpin_congn_stats_update(struct Scsi_Host *shost,
-			   struct fc_tlv_desc *tlv)
+			   struct fc_fn_congn_desc *congn)
 {
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
-	struct fc_fn_congn_desc *congn = (struct fc_fn_congn_desc *)tlv;
 
 	fc_cn_stats_update(be16_to_cpu(congn->event_type),
 			   &fc_host->fpin_stats);
@@ -892,32 +887,32 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf,
 		u8 event_acknowledge)
 {
 	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
-	struct fc_tlv_desc *tlv;
+	union fc_tlv_desc *tlv;
 	u32 bytes_remain;
 	u32 dtag;
 	enum fc_host_event_code event_code =
 		event_acknowledge ? FCH_EVT_LINK_FPIN_ACK : FCH_EVT_LINK_FPIN;
 
 	/* Update Statistics */
-	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
+	tlv = &fpin->fpin_desc[0];
 	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
 	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
 
 	while (bytes_remain >= FC_TLV_DESC_HDR_SZ &&
 	       bytes_remain >= FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
-		dtag = be32_to_cpu(tlv->desc_tag);
+		dtag = be32_to_cpu(tlv->hdr.desc_tag);
 		switch (dtag) {
 		case ELS_DTAG_LNK_INTEGRITY:
-			fc_fpin_li_stats_update(shost, tlv);
+			fc_fpin_li_stats_update(shost, &tlv->li);
 			break;
 		case ELS_DTAG_DELIVERY:
-			fc_fpin_delivery_stats_update(shost, tlv);
+			fc_fpin_delivery_stats_update(shost, &tlv->deli);
 			break;
 		case ELS_DTAG_PEER_CONGEST:
-			fc_fpin_peer_congn_stats_update(shost, tlv);
+			fc_fpin_peer_congn_stats_update(shost, &tlv->peer_congn);
 			break;
 		case ELS_DTAG_CONGESTION:
-			fc_fpin_congn_stats_update(shost, tlv);
+			fc_fpin_congn_stats_update(shost, &tlv->congn);
 		}
 
 		bytes_remain -= FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
index 16782c360de3..3598dc553f4d 100644
--- a/include/uapi/scsi/fc/fc_els.h
+++ b/include/uapi/scsi/fc/fc_els.h
@@ -253,12 +253,12 @@ enum fc_ls_tlv_dtag {
 
 
 /*
- * Generic Link Service TLV Descriptor format
+ * Generic Link Service TLV Descriptor header
  *
  * This structure, as it defines no payload, will also be referred to
  * as the "tlv header" - which contains the tag and len fields.
  */
-struct fc_tlv_desc {
+struct fc_tlv_desc_hdr {
 	__be32		desc_tag;	/* Notification Descriptor Tag */
 	__be32		desc_len;	/* Length of Descriptor (in bytes).
 					 * Size of descriptor excluding
@@ -267,36 +267,6 @@ struct fc_tlv_desc {
 	__u8		desc_value[];  /* Descriptor Value */
 };
 
-/* Descriptor tag and len fields are considered the mandatory header
- * for a descriptor
- */
-#define FC_TLV_DESC_HDR_SZ	sizeof(struct fc_tlv_desc)
-
-/*
- * Macro, used when initializing payloads, to return the descriptor length.
- * Length is size of descriptor minus the tag and len fields.
- */
-#define FC_TLV_DESC_LENGTH_FROM_SZ(desc)	\
-		(sizeof(desc) - FC_TLV_DESC_HDR_SZ)
-
-/* Macro, used on received payloads, to return the descriptor length */
-#define FC_TLV_DESC_SZ_FROM_LENGTH(tlv)		\
-		(__be32_to_cpu((tlv)->desc_len) + FC_TLV_DESC_HDR_SZ)
-
-/*
- * This helper is used to walk descriptors in a descriptor list.
- * Given the address of the current descriptor, which minimally contains a
- * tag and len field, calculate the address of the next descriptor based
- * on the len field.
- */
-static inline void *fc_tlv_next_desc(void *desc)
-{
-	struct fc_tlv_desc *tlv = desc;
-
-	return (desc + FC_TLV_DESC_SZ_FROM_LENGTH(tlv));
-}
-
-
 /*
  * Link Service Request Information Descriptor
  */
@@ -1094,19 +1064,6 @@ struct fc_fn_congn_desc {
 	__u8		resv[3];	/* reserved - must be zero */
 };
 
-/*
- * ELS_FPIN - Fabric Performance Impact Notification
- */
-struct fc_els_fpin {
-	__u8		fpin_cmd;	/* command (0x16) */
-	__u8		fpin_zero[3];	/* specified as zero - part of cmd */
-	__be32		desc_len;	/* Length of Descriptor List (in bytes).
-					 * Size of ELS excluding fpin_cmd,
-					 * fpin_zero and desc_len fields.
-					 */
-	struct fc_tlv_desc	fpin_desc[];	/* Descriptor list */
-};
-
 /* Diagnostic Function Descriptor - FPIN Registration */
 struct fc_df_desc_fpin_reg {
 	__be32		desc_tag;	/* FPIN Registration (0x00030001) */
@@ -1125,33 +1082,6 @@ struct fc_df_desc_fpin_reg {
 					 */
 };
 
-/*
- * ELS_RDF - Register Diagnostic Functions
- */
-struct fc_els_rdf {
-	__u8		fpin_cmd;	/* command (0x19) */
-	__u8		fpin_zero[3];	/* specified as zero - part of cmd */
-	__be32		desc_len;	/* Length of Descriptor List (in bytes).
-					 * Size of ELS excluding fpin_cmd,
-					 * fpin_zero and desc_len fields.
-					 */
-	struct fc_tlv_desc	desc[];	/* Descriptor list */
-};
-
-/*
- * ELS RDF LS_ACC Response.
- */
-struct fc_els_rdf_resp {
-	struct fc_els_ls_acc	acc_hdr;
-	__be32			desc_list_len;	/* Length of response (in
-						 * bytes). Excludes acc_hdr
-						 * and desc_list_len fields.
-						 */
-	struct fc_els_lsri_desc	lsri;
-	struct fc_tlv_desc	desc[];	/* Supported Descriptor list */
-};
-
-
 /*
  * Diagnostic Capability Descriptors for EDC ELS
  */
@@ -1221,6 +1151,65 @@ struct fc_diag_cg_sig_desc {
 	struct fc_diag_cg_sig_freq	rcv_signal_frequency;
 };
 
+/*
+ * Generic Link Service TLV Descriptor format
+ *
+ * This structure, as it defines no payload, will also be referred to
+ * as the "tlv header" - which contains the tag and len fields.
+ */
+union fc_tlv_desc {
+	struct fc_tlv_desc_hdr hdr;
+	struct fc_els_lsri_desc lsri;
+	struct fc_fn_li_desc li;
+	struct fc_fn_deli_desc deli;
+	struct fc_fn_peer_congn_desc peer_congn;
+	struct fc_fn_congn_desc congn;
+	struct fc_df_desc_fpin_reg fpin_reg;
+	struct fc_diag_lnkflt_desc lnkflt;
+	struct fc_diag_cg_sig_desc cg_sig;
+};
+
+/* Descriptor tag and len fields are considered the mandatory header
+ * for a descriptor
+ */
+#define FC_TLV_DESC_HDR_SZ	sizeof(struct fc_tlv_desc_hdr)
+
+/*
+ * Macro, used when initializing payloads, to return the descriptor length.
+ * Length is size of descriptor minus the tag and len fields.
+ */
+#define FC_TLV_DESC_LENGTH_FROM_SZ(desc)	\
+		(sizeof(desc) - FC_TLV_DESC_HDR_SZ)
+
+/* Macro, used on received payloads, to return the descriptor length */
+#define FC_TLV_DESC_SZ_FROM_LENGTH(tlv)		\
+		(__be32_to_cpu((tlv)->hdr.desc_len) + FC_TLV_DESC_HDR_SZ)
+
+/*
+ * This helper is used to walk descriptors in a descriptor list.
+ * Given the address of the current descriptor, which minimally contains a
+ * tag and len field, calculate the address of the next descriptor based
+ * on the len field.
+ */
+static inline union fc_tlv_desc *fc_tlv_next_desc(union fc_tlv_desc *desc)
+{
+	return (union fc_tlv_desc *)((__u8 *)desc + FC_TLV_DESC_SZ_FROM_LENGTH(desc));
+}
+
+
+/*
+ * ELS_FPIN - Fabric Performance Impact Notification
+ */
+struct fc_els_fpin {
+	__u8		fpin_cmd;	/* command (0x16) */
+	__u8		fpin_zero[3];	/* specified as zero - part of cmd */
+	__be32		desc_len;	/* Length of Descriptor List (in bytes).
+					 * Size of ELS excluding fpin_cmd,
+					 * fpin_zero and desc_len fields.
+					 */
+	union fc_tlv_desc	fpin_desc[];	/* Descriptor list */
+};
+
 /*
  * ELS_EDC - Exchange Diagnostic Capabilities
  */
@@ -1231,10 +1220,37 @@ struct fc_els_edc {
 					 * Size of ELS excluding edc_cmd,
 					 * edc_zero and desc_len fields.
 					 */
-	struct fc_tlv_desc	desc[];
+	union fc_tlv_desc	desc[];
 					/* Diagnostic Descriptor list */
 };
 
+/*
+ * ELS_RDF - Register Diagnostic Functions
+ */
+struct fc_els_rdf {
+	__u8		fpin_cmd;	/* command (0x19) */
+	__u8		fpin_zero[3];	/* specified as zero - part of cmd */
+	__be32		desc_len;	/* Length of Descriptor List (in bytes).
+					 * Size of ELS excluding fpin_cmd,
+					 * fpin_zero and desc_len fields.
+					 */
+	union fc_tlv_desc	desc[];	/* Descriptor list */
+};
+
+/*
+ * ELS RDF LS_ACC Response.
+ */
+struct fc_els_rdf_resp {
+	struct fc_els_ls_acc	acc_hdr;
+	__be32			desc_list_len;	/* Length of response (in
+						 * bytes). Excludes acc_hdr
+						 * and desc_list_len fields.
+						 */
+	struct fc_els_lsri_desc	lsri;
+	union fc_tlv_desc	desc[];	/* Supported Descriptor list */
+};
+
+
 /*
  * ELS EDC LS_ACC Response.
  */
@@ -1245,9 +1261,8 @@ struct fc_els_edc_resp {
 						 * and desc_list_len fields.
 						 */
 	struct fc_els_lsri_desc	lsri;
-	struct fc_tlv_desc	desc[];
+	union fc_tlv_desc	desc[];
 				    /* Supported Diagnostic Descriptor list */
 };
 
-
 #endif /* _FC_ELS_H_ */
-- 
2.51.0

