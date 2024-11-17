Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17A81D279C;
	Sun, 17 Nov 2024 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731851548; cv=none; b=agr7xWmef9Wg+54pISyYMwkZa47VTDqLfFA0Z//iSqJ7DNtuxMW5m3ef2kp6OPd6M6pp9swOzOl3s8ffT2R7b4xzcctb7QaMhc+jrWZlV0NfZkbZW4NoZjiryqU95gnSyO74fzhFduzrHHy/ILu19jH+eAso5pChy35yb/pttDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731851548; c=relaxed/simple;
	bh=SdM0gr5ZnGZetFxnq8Bvz290hg24qmrzZGg+7mjxsNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA9e7Qb2xrg29Fp4dBGmxWMFJ/TTEymLg/51PxIveDwDRn58HHFu8r0W6ZSBICRS4L6F1UGzxnsAkd/9FgiNNNuCjisC1hBz7TI8zUn5XMqclmeTe8cIhLBnmPFU/zgNqDY5SItPvI0QBHIXSV/K5xXw2jG7YwJJXdH4JHMhqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=jWit/9Ba; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="jWit/9Ba"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=NuA3nU7Mljj4Skwk5AEWAw2DtXarZnwqjHoZmt4O0YY=; b=jWit/9BaXp8jTn1f
	ScG6OE5NFPuvriRl2bOSdxIU1c7KAACD5JQTQcnMxcBypAb9OodHvVra08JgUsUiyLVsUVmZGXz13
	zbHtYj/tRDoVZYEAitRuu8gPfkMAF9LIg47n7aypcDGeQx92vrW59Sg/E7917HV6fSLMTQ950aRkQ
	fZ6T/GZhm7WVvFwjeFFqMrsM2Qc7Bg4GmVnedqYDP5Jx+ZwKyA0fhbOYrZpWmtf6gGaqgkWaKCB4Q
	MpTy1j4q1Ms/AfQPNd1bxrDAuKuMP8qctKvEZl+vdoFtqOpvpb+oU7XPOjKEZR/4K5LCjz7jeBRKf
	KQ2kfRd2hOXuCesJGg==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tCfhK-000MsI-0m;
	Sun, 17 Nov 2024 13:52:18 +0000
From: linux@treblig.org
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 2/2] scsi: bfa: Remove unused parsers
Date: Sun, 17 Nov 2024 13:52:15 +0000
Message-ID: <20241117135215.38771-3-linux@treblig.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241117135215.38771-1-linux@treblig.org>
References: <20241117135215.38771-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

bfa has a set of structure parsers, of which quite a few are unused.
Remove the unused set.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/bfa/bfa_fcbuild.c | 134 ---------------------------------
 drivers/scsi/bfa/bfa_fcbuild.h |  17 -----
 2 files changed, 151 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 0f5d8a9cdf14..c44fd096ee68 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -259,40 +259,6 @@ fc_plogi_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 				node_name, pdu_size, bb_cr, FC_ELS_ACC);
 }
 
-enum fc_parse_status
-fc_plogi_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
-{
-	struct fc_els_cmd_s *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
-	struct fc_logi_s *plogi;
-	struct fc_ls_rjt_s *ls_rjt;
-
-	switch (els_cmd->els_code) {
-	case FC_ELS_LS_RJT:
-		ls_rjt = (struct fc_ls_rjt_s *) (fchs + 1);
-		if (ls_rjt->reason_code == FC_LS_RJT_RSN_LOGICAL_BUSY)
-			return FC_PARSE_BUSY;
-		else
-			return FC_PARSE_FAILURE;
-	case FC_ELS_ACC:
-		plogi = (struct fc_logi_s *) (fchs + 1);
-		if (len < sizeof(struct fc_logi_s))
-			return FC_PARSE_FAILURE;
-
-		if (!wwn_is_equal(plogi->port_name, port_name))
-			return FC_PARSE_FAILURE;
-
-		if (!plogi->class3.class_valid)
-			return FC_PARSE_FAILURE;
-
-		if (be16_to_cpu(plogi->class3.rxsz) < (FC_MIN_PDUSZ))
-			return FC_PARSE_FAILURE;
-
-		return FC_PARSE_OK;
-	default:
-		return FC_PARSE_FAILURE;
-	}
-}
-
 enum fc_parse_status
 fc_plogi_parse(struct fchs_s *fchs)
 {
@@ -365,21 +331,6 @@ fc_prli_rsp_parse(struct fc_prli_s *prli, int len)
 	return FC_PARSE_OK;
 }
 
-enum fc_parse_status
-fc_prli_parse(struct fc_prli_s *prli)
-{
-	if (prli->parampage.type != FC_TYPE_FCP)
-		return FC_PARSE_FAILURE;
-
-	if (!prli->parampage.imagepair)
-		return FC_PARSE_FAILURE;
-
-	if (!prli->parampage.servparams.initiator)
-		return FC_PARSE_FAILURE;
-
-	return FC_PARSE_OK;
-}
-
 u16
 fc_logo_build(struct fchs_s *fchs, struct fc_logo_s *logo, u32 d_id, u32 s_id,
 	      u16 ox_id, wwn_t port_name)
@@ -450,55 +401,6 @@ fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len, wwn_t port_name,
 	return FC_PARSE_OK;
 }
 
-enum fc_parse_status
-fc_adisc_parse(struct fchs_s *fchs, void *pld, u32 host_dap, wwn_t node_name,
-	       wwn_t port_name)
-{
-	struct fc_adisc_s *adisc = (struct fc_adisc_s *) pld;
-
-	if (adisc->els_cmd.els_code != FC_ELS_ACC)
-		return FC_PARSE_FAILURE;
-
-	if ((adisc->nport_id == (host_dap))
-	    && wwn_is_equal(adisc->orig_port_name, port_name)
-	    && wwn_is_equal(adisc->orig_node_name, node_name))
-		return FC_PARSE_OK;
-
-	return FC_PARSE_FAILURE;
-}
-
-enum fc_parse_status
-fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name, wwn_t port_name)
-{
-	struct fc_logi_s *pdisc = (struct fc_logi_s *) (fchs + 1);
-
-	if (pdisc->class3.class_valid != 1)
-		return FC_PARSE_FAILURE;
-
-	if ((be16_to_cpu(pdisc->class3.rxsz) <
-		(FC_MIN_PDUSZ - sizeof(struct fchs_s)))
-	    || (pdisc->class3.rxsz == 0))
-		return FC_PARSE_FAILURE;
-
-	if (!wwn_is_equal(pdisc->port_name, port_name))
-		return FC_PARSE_FAILURE;
-
-	if (!wwn_is_equal(pdisc->node_name, node_name))
-		return FC_PARSE_FAILURE;
-
-	return FC_PARSE_OK;
-}
-
-enum fc_parse_status
-fc_abts_rsp_parse(struct fchs_s *fchs, int len)
-{
-	if ((fchs->cat_info == FC_CAT_BA_ACC)
-	    || (fchs->cat_info == FC_CAT_BA_RJT))
-		return FC_PARSE_OK;
-
-	return FC_PARSE_FAILURE;
-}
-
 u16
 fc_logo_acc_build(struct fchs_s *fchs, void *pld, u32 d_id, u32 s_id,
 		  __be16 ox_id)
@@ -666,29 +568,6 @@ fc_rpsc_acc_build(struct fchs_s *fchs, struct fc_rpsc_acc_s *rpsc_acc,
 	return sizeof(struct fc_rpsc_acc_s);
 }
 
-u16
-fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name)
-{
-	struct fc_logi_s *pdisc = (struct fc_logi_s *) (fchs + 1);
-
-	if (len < sizeof(struct fc_logi_s))
-		return FC_PARSE_LEN_INVAL;
-
-	if (pdisc->els_cmd.els_code != FC_ELS_ACC)
-		return FC_PARSE_ACC_INVAL;
-
-	if (!wwn_is_equal(pdisc->port_name, port_name))
-		return FC_PARSE_PWWN_NOT_EQUAL;
-
-	if (!pdisc->class3.class_valid)
-		return FC_PARSE_NWWN_NOT_EQUAL;
-
-	if (be16_to_cpu(pdisc->class3.rxsz) < (FC_MIN_PDUSZ))
-		return FC_PARSE_RXSZ_INVAL;
-
-	return FC_PARSE_OK;
-}
-
 static void
 fc_gs_cthdr_build(struct ct_hdr_s *cthdr, u32 s_id, u16 cmd_code)
 {
@@ -752,19 +631,6 @@ fc_gpnid_build(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 	return sizeof(fcgs_gpnid_req_t) + sizeof(struct ct_hdr_s);
 }
 
-u16
-fc_ct_rsp_parse(struct ct_hdr_s *cthdr)
-{
-	if (be16_to_cpu(cthdr->cmd_rsp_code) != CT_RSP_ACCEPT) {
-		if (cthdr->reason_code == CT_RSN_LOGICAL_BUSY)
-			return FC_PARSE_BUSY;
-		else
-			return FC_PARSE_FAILURE;
-	}
-
-	return FC_PARSE_OK;
-}
-
 u16
 fc_gs_rjt_build(struct fchs_s *fchs,  struct ct_hdr_s *cthdr,
 		u32 d_id, u32 s_id, u16 ox_id, u8 reason_code,
diff --git a/drivers/scsi/bfa/bfa_fcbuild.h b/drivers/scsi/bfa/bfa_fcbuild.h
index 26646106da4c..51da37b2ae6b 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.h
+++ b/drivers/scsi/bfa/bfa_fcbuild.h
@@ -139,8 +139,6 @@ u16        fc_plogi_build(struct fchs_s *fchs, void *pld, u32 d_id,
 
 enum fc_parse_status fc_plogi_parse(struct fchs_s *fchs);
 
-enum fc_parse_status fc_abts_rsp_parse(struct fchs_s *buf, int len);
-
 u16        fc_rspnid_build(struct fchs_s *fchs, void *pld, u32 s_id,
 				u16 ox_id, u8 *name);
 u16	fc_rsnn_nn_build(struct fchs_s *fchs, void *pld, u32 s_id,
@@ -174,9 +172,6 @@ u16        fc_adisc_build(struct fchs_s *fchs, struct fc_adisc_s *adisc,
 			u32 d_id, u32 s_id, __be16 ox_id, wwn_t port_name,
 			       wwn_t node_name);
 
-enum fc_parse_status fc_adisc_parse(struct fchs_s *fchs, void *pld,
-			u32 host_dap, wwn_t node_name, wwn_t port_name);
-
 enum fc_parse_status fc_adisc_rsp_parse(struct fc_adisc_s *adisc, int len,
 				 wwn_t port_name, wwn_t node_name);
 
@@ -230,14 +225,6 @@ void		fc_get_fc4type_bitmask(u8 fc4_type, u8 *bit_mask);
 void		fc_els_req_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
 					 __be16 ox_id);
 
-enum fc_parse_status	fc_plogi_rsp_parse(struct fchs_s *fchs, int len,
-					wwn_t port_name);
-
-enum fc_parse_status	fc_prli_parse(struct fc_prli_s *prli);
-
-enum fc_parse_status	fc_pdisc_parse(struct fchs_s *fchs, wwn_t node_name,
-					wwn_t port_name);
-
 u16 fc_ba_acc_build(struct fchs_s *fchs, struct fc_ba_acc_s *ba_acc, u32 d_id,
 		u32 s_id, __be16 ox_id, u16 rx_id);
 
@@ -246,12 +233,8 @@ int fc_logout_params_pages(struct fchs_s *fc_frame, u8 els_code);
 u16 fc_prlo_acc_build(struct fchs_s *fchs, struct fc_prlo_acc_s *prlo_acc,
 		u32 d_id, u32 s_id, __be16 ox_id, int num_pages);
 
-u16 fc_pdisc_rsp_parse(struct fchs_s *fchs, int len, wwn_t port_name);
-
 u16 fc_tprlo_build(struct fchs_s *fchs, u32 d_id, u32 s_id,
 		u16 ox_id, int num_pages, enum fc_tprlo_type tprlo_type,
 		u32 tpr_id);
 
-u16 fc_ct_rsp_parse(struct ct_hdr_s *cthdr);
-
 #endif
-- 
2.47.0

