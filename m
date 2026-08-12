Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2ED47FAE8
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558415; cv=none; b=QjZ6nyavLyreZAwca3HMpKDUyTSWoS6qzr77cBkL70laXiI8drTyfk5Q4y9u3nbRNuQRbNxerSnkCNSEU7FvUwIxLZcyXKtlrmpAVw3QWieVzyI0V1+0k6xTmx+RhwHE4UslUTJr1PpPtLjtCqkavjTGWdbMrerWkJVXONBDtfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558415; c=relaxed/simple;
	bh=e96OchnMFlBTwf3U2/LWDJ4Y9aNe68TSW4kWJDZbJ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwT0rb7NXMqdl5UAgdmzeVAsWMM9WaiPR3lZbJSIoBnLxEaPUGnSnzwDK9CctdsqCPmj/Y3T7GfIHTQNfkMQ2Lpvjzcqu9HdJvt0cLUy8DHDcgLgpsYPM+TorE2HVREkiVihP4rrBFWpUGhqUf67mBgJKvLD90gJNkldoON/g+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BzWI6wjp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BzWI6wjp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/YMUpa8YvLLphIeGGv9+ehR4AWWW5XS1l0L51yHfUSk=;
	b=BzWI6wjpoc2yKqryxvgAeRiMQHaH61oy2gdUOnIKRTMtq+mtdUL+qfV3kEfuFN8CcvVwgZ
	kBCb3X0CFJtkBaliNj2+Km4H8uwqyTqz0LtoMd+p+OrsID1ETaSDNQt+ZNf0eu9y4uHyMh
	fHW2LjiDHvixJiE6YFB4VGbg5/rbgYA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-2ytLjSLVPEeotdv85Wpz9A-1; Wed,
 12 Aug 2026 14:13:26 -0400
X-MC-Unique: 2ytLjSLVPEeotdv85Wpz9A-1
X-Mimecast-MFC-AGG-ID: 2ytLjSLVPEeotdv85Wpz9A_1786558396
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9030E1956089;
	Wed, 12 Aug 2026 18:13:15 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D456180034F;
	Wed, 12 Aug 2026 18:13:08 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Hannes Reinecke <hare@suse.de>,
	Jesse Taube <jtaubepe@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	shinichiro.kawasaki@wdc.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 01/13] fc_els: use 'union fc_tlv_desc'
Date: Wed, 12 Aug 2026 14:12:48 -0400
Message-ID: <20260812181300.3712426-2-jtaubepe@redhat.com>
In-Reply-To: <20260812181300.3712426-1-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Hannes Reinecke <hare@kernel.org>

Introduce 'union fc_tlv_desc' to have a common structure for all FC
ELS TLV structures and avoid type casts.

Commit 44b6169ada7f ("scsi: fc: Avoid -Wflex-array-member-not-at-end
warnings")
conflicts with this change. To solve the problem I moved the
fc_els_rdf_hdr and fc_els_rdf_resp_hdr definitions out of fc_els.h and
into lpfc_hw4.h.

Fixes: 44b6169ada7f ("scsi: fc: Avoid -Wflex-array-member-not-at-end warnings")
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Co-developed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Tested-by: Bryan Gurney <bgurney@redhat.com>
---
V10 -> V11:
 - No change/Rebase
---
 drivers/scsi/lpfc/lpfc_els.c     |  77 +++++++-------
 drivers/scsi/lpfc/lpfc_hw4.h     |  12 ++-
 drivers/scsi/scsi_transport_fc.c |  27 ++---
 include/uapi/scsi/fc/fc_els.h    | 174 ++++++++++++++++---------------
 4 files changed, 146 insertions(+), 144 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 52fc5058976d..11143da24b54 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3888,7 +3888,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 	memset(prdf, 0, cmdsize);
 	prdf->rdf.fpin_cmd = ELS_RDF;
 	prdf->rdf.desc_len = cpu_to_be32(sizeof(struct lpfc_els_rdf_req) -
-					 sizeof(struct fc_els_rdf_hdr));
+					 offsetof(struct fc_els_rdf, desc));
 	prdf->reg_d1.reg_desc.desc_tag = cpu_to_be32(ELS_DTAG_FPIN_REGISTER);
 	prdf->reg_d1.reg_desc.desc_len = cpu_to_be32(
 				FC_TLV_DESC_LENGTH_FROM_SZ(prdf->reg_d1));
@@ -4075,7 +4075,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	IOCB_t *irsp_iocb;
 	struct fc_els_edc_resp *edc_rsp;
-	struct fc_tlv_desc *tlv;
+	union fc_tlv_desc *tlv;
 	struct fc_diag_cg_sig_desc *pcgd;
 	struct fc_diag_lnkflt_desc *plnkflt;
 	struct lpfc_dmabuf *pcmd, *prsp;
@@ -4166,7 +4166,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		}
 
-		dtag = be32_to_cpu(tlv->desc_tag);
+		dtag = be32_to_cpu(tlv->hdr.desc_tag);
 		switch (dtag) {
 		case ELS_DTAG_LNK_FAULT_CAP:
 			if (bytes_remain < FC_TLV_DESC_SZ_FROM_LENGTH(tlv) ||
@@ -4181,7 +4181,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					sizeof(struct fc_diag_lnkflt_desc));
 				goto out;
 			}
-			plnkflt = (struct fc_diag_lnkflt_desc *)tlv;
+			plnkflt = &tlv->lnkflt;
 			lpfc_printf_log(phba, KERN_INFO,
 				LOG_ELS | LOG_LDS_EVENT,
 				"4617 Link Fault Desc Data: 0x%08x 0x%08x "
@@ -4208,7 +4208,7 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				goto out;
 			}
 
-			pcgd = (struct fc_diag_cg_sig_desc *)tlv;
+			pcgd = &tlv->cg_sig;
 			lpfc_printf_log(
 				phba, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
 				"4616 CGN Desc Data: 0x%08x 0x%08x "
@@ -4263,10 +4263,8 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -4279,10 +4277,8 @@ lpfc_format_edc_lft_desc(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 }
 
 static void
-lpfc_format_edc_cgn_desc(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
+lpfc_format_edc_cgn_desc(struct lpfc_hba *phba, struct fc_diag_cg_sig_desc *cgd)
 {
-	struct fc_diag_cg_sig_desc *cgd = (struct fc_diag_cg_sig_desc *)tlv;
-
 	/* We are assuming cgd was zero'ed before calling this routine */
 
 	/* Configure the congestion detection capability */
@@ -4381,7 +4377,7 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_iocbq *elsiocb;
 	struct fc_els_edc *edc_req;
-	struct fc_tlv_desc *tlv;
+	union fc_tlv_desc *tlv;
 	u16 cmdsize;
 	struct lpfc_nodelist *ndlp;
 	u8 *pcmd = NULL;
@@ -4420,13 +4416,13 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
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
@@ -5999,7 +5995,7 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct fc_els_edc_resp *edc_rsp;
-	struct fc_tlv_desc *tlv;
+	union fc_tlv_desc *tlv;
 	struct lpfc_iocbq *elsiocb;
 	IOCB_t *icmd, *cmd;
 	union lpfc_wqe128 *wqe;
@@ -6043,10 +6039,10 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
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
@@ -9439,7 +9435,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_hba  *phba = vport->phba;
 	struct fc_els_edc *edc_req;
-	struct fc_tlv_desc *tlv;
+	union fc_tlv_desc *tlv;
 	uint8_t *payload;
 	uint32_t *ptr, dtag;
 	const char *dtag_nm;
@@ -9482,7 +9478,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		}
 
-		dtag = be32_to_cpu(tlv->desc_tag);
+		dtag = be32_to_cpu(tlv->hdr.desc_tag);
 		switch (dtag) {
 		case ELS_DTAG_LNK_FAULT_CAP:
 			if (bytes_remain < FC_TLV_DESC_SZ_FROM_LENGTH(tlv) ||
@@ -9497,7 +9493,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 					sizeof(struct fc_diag_lnkflt_desc));
 				goto out;
 			}
-			plnkflt = (struct fc_diag_lnkflt_desc *)tlv;
+			plnkflt = &tlv->lnkflt;
 			lpfc_printf_log(phba, KERN_INFO,
 				LOG_ELS | LOG_LDS_EVENT,
 				"4626 Link Fault Desc Data: x%08x len x%x "
@@ -9534,7 +9530,7 @@ lpfc_els_rcv_edc(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			phba->cgn_sig_freq = lpfc_fabric_cgn_frequency;
 
 			lpfc_least_capable_settings(
-				phba, (struct fc_diag_cg_sig_desc *)tlv);
+				phba, &tlv->cg_sig);
 			break;
 		default:
 			dtag_nm = lpfc_get_tlv_dtag_nm(dtag);
@@ -10124,14 +10120,13 @@ lpfc_display_fpin_wwpn(struct lpfc_hba *phba, __be64 *wwnlist, u32 cnt)
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
 
@@ -10155,14 +10150,13 @@ lpfc_els_rcv_fpin_li(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
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
@@ -10193,14 +10187,14 @@ lpfc_els_rcv_fpin_del(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
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
 
@@ -10228,7 +10222,7 @@ lpfc_els_rcv_fpin_peer_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 /**
  * lpfc_els_rcv_fpin_cgn - Process an FPIN Congestion notification
  * @phba: Pointer to hba object.
- * @tlv:  Pointer to the Congestion Notification Descriptor TLV
+ * @cgn:  Pointer to the Congestion Notification Descriptor TLV
  *
  * This function processes an FPIN Congestion Notifiction.  The notification
  * could be an Alarm or Warning.  This routine feeds that data into driver's
@@ -10237,10 +10231,9 @@ lpfc_els_rcv_fpin_peer_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
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
@@ -10341,7 +10334,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct fc_els_fpin *fpin = (struct fc_els_fpin *)p;
-	struct fc_tlv_desc *tlv, *first_tlv, *current_tlv;
+	union fc_tlv_desc *tlv, *first_tlv, *current_tlv;
 	const char *dtag_nm;
 	int desc_cnt = 0, bytes_remain, cnt;
 	u32 dtag, deliver = 0;
@@ -10366,7 +10359,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 		return;
 	}
 
-	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
+	tlv = &fpin->fpin_desc[0];
 	first_tlv = tlv;
 	bytes_remain = fpin_length - offsetof(struct fc_els_fpin, fpin_desc);
 	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
@@ -10374,22 +10367,22 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
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
@@ -10402,12 +10395,12 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
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
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 41fa8f3329da..10490b3a05cd 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4926,12 +4926,20 @@ struct lpfc_els_rdf_reg_desc {
 };
 
 struct lpfc_els_rdf_req {
-	struct fc_els_rdf_hdr		rdf;	   /* hdr up to descriptors */
+	struct {
+		__u8		fpin_cmd;	/* command (0x19) */
+		__u8		fpin_zero[3];	/* specified as zero - part of cmd */
+		__be32		desc_len;	/* Length of Descriptor List (in bytes) */
+	} rdf;	   /* hdr up to descriptors */
 	struct lpfc_els_rdf_reg_desc	reg_d1;	/* 1st descriptor */
 };
 
 struct lpfc_els_rdf_rsp {
-	struct fc_els_rdf_resp_hdr	rdf_resp;  /* hdr up to descriptors */
+	struct {
+		struct fc_els_ls_acc	acc_hdr;
+		__be32			desc_list_len;	/* Length of response (in bytes) */
+		struct fc_els_lsri_desc	lsri;
+	} rdf_resp;  /* hdr up to descriptors */
 	struct lpfc_els_rdf_reg_desc	reg_d1;	/* 1st descriptor */
 };
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 173ed6373f04..02c58f4591d8 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -776,12 +776,11 @@ fc_fpin_pname_stats_update(struct Scsi_Host *shost,
  *
  */
 static void
-fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
+fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_fn_li_desc *li_desc)
 {
 	struct fc_rport *rport = NULL;
 	struct fc_rport *attach_rport = NULL;
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
-	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
 	u16 event_type = be16_to_cpu(li_desc->event_type);
 
 	rport = fc_find_rport_by_wwpn(shost,
@@ -812,12 +811,11 @@ fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
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
@@ -843,12 +841,10 @@ fc_fpin_delivery_stats_update(struct Scsi_Host *shost,
  */
 static void
 fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
-				struct fc_tlv_desc *tlv)
+				struct fc_fn_peer_congn_desc *pc_desc)
 {
 	struct fc_rport *rport = NULL;
 	struct fc_rport *attach_rport = NULL;
-	struct fc_fn_peer_congn_desc *pc_desc =
-	    (struct fc_fn_peer_congn_desc *)tlv;
 	u16 event_type = be16_to_cpu(pc_desc->event_type);
 
 	rport = fc_find_rport_by_wwpn(shost,
@@ -876,10 +872,9 @@ fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
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
@@ -899,32 +894,32 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf,
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
index dca6a28f4e86..b5653e1dee13 100644
--- a/include/uapi/scsi/fc/fc_els.h
+++ b/include/uapi/scsi/fc/fc_els.h
@@ -259,12 +259,12 @@ enum fc_ls_tlv_dtag {
 
 
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
@@ -273,36 +273,6 @@ struct fc_tlv_desc {
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
@@ -1100,19 +1070,6 @@ struct fc_fn_congn_desc {
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
 	/* New members MUST be added within the __struct_group() macro below. */
@@ -1136,42 +1093,6 @@ struct fc_df_desc_fpin_reg {
 _Static_assert(offsetof(struct fc_df_desc_fpin_reg, desc_tags) == sizeof(struct fc_df_desc_fpin_reg_hdr),
 	      "struct member likely outside of __struct_group()");
 
-/*
- * ELS_RDF - Register Diagnostic Functions
- */
-struct fc_els_rdf {
-	/* New members MUST be added within the __struct_group() macro below. */
-	__struct_group(fc_els_rdf_hdr, __hdr, /* no attrs */,
-		__u8		fpin_cmd;	/* command (0x19) */
-		__u8		fpin_zero[3];	/* specified as zero - part of cmd */
-		__be32		desc_len;	/* Length of Descriptor List (in bytes).
-						 * Size of ELS excluding fpin_cmd,
-						 * fpin_zero and desc_len fields.
-						 */
-	);
-	struct fc_tlv_desc	desc[];	/* Descriptor list */
-};
-_Static_assert(offsetof(struct fc_els_rdf, desc) == sizeof(struct fc_els_rdf_hdr),
-	       "struct member likely outside of __struct_group()");
-
-/*
- * ELS RDF LS_ACC Response.
- */
-struct fc_els_rdf_resp {
-	/* New members MUST be added within the __struct_group() macro below. */
-	__struct_group(fc_els_rdf_resp_hdr, __hdr, /* no attrs */,
-		struct fc_els_ls_acc	acc_hdr;
-		__be32			desc_list_len;	/* Length of response (in
-							 * bytes). Excludes acc_hdr
-							 * and desc_list_len fields.
-							 */
-		struct fc_els_lsri_desc	lsri;
-	);
-	struct fc_tlv_desc	desc[];	/* Supported Descriptor list */
-};
-_Static_assert(offsetof(struct fc_els_rdf_resp, desc) == sizeof(struct fc_els_rdf_resp_hdr),
-	       "struct member likely outside of __struct_group()");
-
 /*
  * Diagnostic Capability Descriptors for EDC ELS
  */
@@ -1241,6 +1162,65 @@ struct fc_diag_cg_sig_desc {
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
@@ -1251,10 +1231,37 @@ struct fc_els_edc {
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
@@ -1265,9 +1272,8 @@ struct fc_els_edc_resp {
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
2.54.0

