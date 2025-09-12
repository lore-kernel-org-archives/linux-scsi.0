Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373443009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701762; cv=none; b=TSUnqMi44dlKRoX1WMG3qOz0+8xV5LTkRcjNqIqlB7Ve4Lq9ApHzJ1R/QwbMLk/WP0Hulfk1KbTwEUnm3xcohbKjwWRJEw4b9B7p4Vup+NzQ7xIiLHcbujI7fEVeIOHMwPcepAOvdYTa8a4M7iR4JUOpI5TJOcksD9D4fSxQWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701762; c=relaxed/simple;
	bh=Wc//8VcEIcH4DZHHbhyzFbJCxdG1uqdKQ+SF0Lib2xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDJHWtYX8traQaspyODgZfh4Z8K2inU49VzerDp6GXkkJRqmDZg8HC3JLU4AncQpiD1PpKH3z6sQxXYAqyM7yKTtk+cZDbrHqRYBrL5W21b4ULAy3WRrMmPQYwYHIyEBBWILcd3Fl/RGWecfhycFg5laLQvU4Hcur43EGMSr4/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FKURdt9R; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FKURdt9R"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjcv3MLszlrwg0;
	Fri, 12 Sep 2025 18:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701758; x=1760293759; bh=27Vgx
	eBbJVKYSuVDKFQlC3NLtoyRjL97gMfSF0JWyWo=; b=FKURdt9RvOOVPfoukcHW8
	DK37YhGbbXtHFnFv83ZoylRUqdryBPC5ahXFtF8d/+AO5+cheQCh/aw9GGoccYbz
	dB/FfpcNDMOI/sKV2E5FHZ/Jdpb/QRBDB1E6BWLvgO9D8xlKQNzQt1gT2kza7Pqo
	CFCN3q64eJXqHtjHJyoiaXXMiMs0q+KkiJ1KvvIhSu8gywsTtxpavo3/WSqrr5e+
	dYPwN+i0YUHK+E0U611jFS1IP0YU42l5aI0Jo6rGGX/uQ+LU9yI/G/mFPKOcpuNM
	23k2Gl+GTqS1y9vlQhGBDIO/X8vsAdFLbxrkwFAlxdM1kB9L9V+x2vn7Akwo9p7v
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fp4eSmNlgZfq; Fri, 12 Sep 2025 18:29:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjcn4XwPzlgqTs;
	Fri, 12 Sep 2025 18:29:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 28/29] ufs: core: Rework the ufshcd_issue_dev_cmd() callers
Date: Fri, 12 Sep 2025 11:21:49 -0700
Message-ID: <20250912182340.3487688-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Move the code for initializing requests and also the code for extracting
results into new functions. No functionality has been changed. This
change prepares for switching to scsi_execute_cmd() for submitting
device management commands.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 318 +++++++++++++++++++++++++++-----------
 1 file changed, 226 insertions(+), 92 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6e346fe59014..6b713caba7ea 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3351,6 +3351,23 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hb=
a, struct scsi_cmnd *cmd,
 	return err;
 }
=20
+struct ufshcd_exec_dev_cmd_args {
+	struct scsi_exec_args args;
+	struct ufs_hba *hba;
+	enum dev_cmd_type cmd_type;
+};
+
+static int ufshcd_init_dev_cmd(struct scsi_cmnd *cmd,
+			       const struct scsi_exec_args *args)
+{
+	const struct ufshcd_exec_dev_cmd_args *uea =3D
+		container_of(args, typeof(*uea), args);
+	struct request *rq =3D scsi_cmd_to_rq(cmd);
+	unsigned int tag =3D rq->tag;
+
+	return ufshcd_compose_dev_cmd(uea->hba, cmd, uea->cmd_type, tag);
+}
+
 /**
  * ufshcd_exec_dev_cmd - API for sending device management requests
  * @hba: UFS hba
@@ -3365,6 +3382,10 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hb=
a, struct scsi_cmnd *cmd,
 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
+	const struct ufshcd_exec_dev_cmd_args args =3D {
+		.hba =3D hba,
+		.cmd_type =3D cmd_type
+	};
 	const u32 tag =3D hba->reserved_slot;
 	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
@@ -3373,7 +3394,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	/* Protects use of hba->reserved_slot. */
 	lockdep_assert_held(&hba->dev_cmd.lock);
=20
-	err =3D ufshcd_compose_dev_cmd(hba, cmd, cmd_type, tag);
+	err =3D ufshcd_init_dev_cmd(cmd, &args.args);
 	if (unlikely(err))
 		return err;
=20
@@ -7329,6 +7350,88 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba=
, int lun_id, int task_id,
 	return err;
 }
=20
+struct ufshcd_exec_devman_upiu_cmd_args {
+	struct scsi_exec_args args;
+	struct ufs_hba *hba;
+	struct utp_upiu_req *req_upiu;
+	struct utp_upiu_req *rsp_upiu;
+	u8 *desc_buff;
+	int *buff_len;
+	enum dev_cmd_type cmd_type;
+	enum query_opcode desc_op;
+	int *err;
+};
+
+static int ufshcd_init_upiu_cmd(struct scsi_cmnd *cmd,
+				const struct scsi_exec_args *args)
+{
+	const struct ufshcd_exec_devman_upiu_cmd_args *uea =3D
+		container_of(args, typeof(*uea), args);
+	struct utp_upiu_req *req_upiu =3D uea->req_upiu;
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	enum dev_cmd_type cmd_type =3D uea->cmd_type;
+	struct request *rq =3D scsi_cmd_to_rq(cmd);
+	enum query_opcode desc_op =3D uea->desc_op;
+	struct ufs_hba *hba =3D uea->hba;
+	u8 *desc_buff =3D uea->desc_buff;
+	unsigned int tag =3D rq->tag;
+	u8 upiu_flags;
+
+	ufshcd_setup_dev_cmd(hba, cmd, cmd_type, 0, tag);
+
+	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, 0);
+
+	/* Set the task tag in the request UPIU. */
+	req_upiu->header.task_tag =3D tag;
+
+	/* Copy the UPIU request into the LRB. */
+	memcpy(lrbp->ucd_req_ptr, req_upiu, sizeof(*lrbp->ucd_req_ptr));
+	if (desc_buff && desc_op =3D=3D UPIU_QUERY_OPCODE_WRITE_DESC) {
+		/*
+		 * For the WRITE DESCRIPTOR operation, the data segment follows
+		 * right after the UPIU transaction specific fields.
+		 */
+		memcpy(lrbp->ucd_req_ptr + 1, desc_buff, *uea->buff_len);
+		*uea->buff_len =3D 0;
+	}
+
+	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
+
+	return 0;
+}
+
+static void ufshcd_copy_upiu_cmd_result(struct scsi_cmnd *cmd,
+					const struct scsi_exec_args *args)
+{
+	const struct ufshcd_exec_devman_upiu_cmd_args *uea =3D
+		container_of(args, typeof(*uea), args);
+	struct utp_upiu_req *rsp_upiu =3D uea->rsp_upiu;
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	enum query_opcode desc_op =3D uea->desc_op;
+	u8 *desc_buff =3D uea->desc_buff;
+	struct ufs_hba *hba =3D uea->hba;
+
+	/* Copy the UPIU response. */
+	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
+
+	if (desc_buff && desc_op =3D=3D UPIU_QUERY_OPCODE_READ_DESC) {
+		u8 *descp =3D (u8 *)lrbp->ucd_rsp_ptr + sizeof(*rsp_upiu);
+		u16 resp_len =3D be16_to_cpu(
+			lrbp->ucd_rsp_ptr->header.data_segment_length);
+
+		if (resp_len <=3D *uea->buff_len) {
+			memcpy(desc_buff, descp, resp_len);
+			*uea->buff_len =3D resp_len;
+		} else {
+			dev_warn(hba->dev,
+				"%s: rsp size %d is bigger than buffer size %d",
+				__func__, resp_len, *uea->buff_len);
+			*uea->buff_len =3D 0;
+			*uea->err =3D -EINVAL;
+		}
+	}
+}
+
 /**
  * ufshcd_issue_devman_upiu_cmd - API for sending "utrd" type requests
  * @hba:	per-adapter instance
@@ -7355,59 +7458,33 @@ static int ufshcd_issue_devman_upiu_cmd(struct uf=
s_hba *hba,
 					enum dev_cmd_type cmd_type,
 					enum query_opcode desc_op)
 {
+	int err, copy_result_err =3D 0;
+	const struct ufshcd_exec_devman_upiu_cmd_args args =3D {
+		.hba =3D hba,
+		.req_upiu =3D req_upiu,
+		.rsp_upiu =3D rsp_upiu,
+		.desc_buff =3D desc_buff,
+		.buff_len =3D buff_len,
+		.cmd_type =3D cmd_type,
+		.desc_op =3D desc_op,
+		.err =3D &copy_result_err,
+	};
 	const u32 tag =3D hba->reserved_slot;
 	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
-	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
-	int err =3D 0;
-	u8 upiu_flags;
=20
 	/* Protects use of hba->reserved_slot. */
 	lockdep_assert_held(&hba->dev_cmd.lock);
=20
-	ufshcd_setup_dev_cmd(hba, cmd, cmd_type, 0, tag);
-
-	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, 0);
-
-	/* update the task tag in the request upiu */
-	req_upiu->header.task_tag =3D tag;
-
-	/* just copy the upiu request as it is */
-	memcpy(lrbp->ucd_req_ptr, req_upiu, sizeof(*lrbp->ucd_req_ptr));
-	if (desc_buff && desc_op =3D=3D UPIU_QUERY_OPCODE_WRITE_DESC) {
-		/* The Data Segment Area is optional depending upon the query
-		 * function value. for WRITE DESCRIPTOR, the data segment
-		 * follows right after the tsf.
-		 */
-		memcpy(lrbp->ucd_req_ptr + 1, desc_buff, *buff_len);
-		*buff_len =3D 0;
-	}
-
-	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
+	err =3D ufshcd_init_upiu_cmd(cmd, &args.args);
+	WARN_ON_ONCE(err);
=20
 	err =3D ufshcd_issue_dev_cmd(hba, cmd, tag, dev_cmd_timeout);
 	if (err)
 		return err;
=20
-	/* just copy the upiu response as it is */
-	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
-	if (desc_buff && desc_op =3D=3D UPIU_QUERY_OPCODE_READ_DESC) {
-		u8 *descp =3D (u8 *)lrbp->ucd_rsp_ptr + sizeof(*rsp_upiu);
-		u16 resp_len =3D be16_to_cpu(lrbp->ucd_rsp_ptr->header
-					   .data_segment_length);
+	ufshcd_copy_upiu_cmd_result(cmd, &args.args);
=20
-		if (*buff_len >=3D resp_len) {
-			memcpy(desc_buff, descp, resp_len);
-			*buff_len =3D resp_len;
-		} else {
-			dev_warn(hba->dev,
-				 "%s: rsp size %d is bigger than buffer size %d",
-				 __func__, resp_len, *buff_len);
-			*buff_len =3D 0;
-			err =3D -EINVAL;
-		}
-	}
-
-	return err;
+	return copy_result_err;
 }
=20
 /**
@@ -7481,36 +7558,34 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 	return err;
 }
=20
-/**
- * ufshcd_advanced_rpmb_req_handler - handle advanced RPMB request
- * @hba:	per adapter instance
- * @req_upiu:	upiu request
- * @rsp_upiu:	upiu reply
- * @req_ehs:	EHS field which contains Advanced RPMB Request Message
- * @rsp_ehs:	EHS field which returns Advanced RPMB Response Message
- * @sg_cnt:	The number of sg lists actually used
- * @sg_list:	Pointer to SG list when DATA IN/OUT UPIU is required in ARP=
MB operation
- * @dir:	DMA direction
- *
- * Return: zero on success, non-zero on failure.
- */
-int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upi=
u_req *req_upiu,
-			 struct utp_upiu_req *rsp_upiu, struct ufs_ehs *req_ehs,
-			 struct ufs_ehs *rsp_ehs, int sg_cnt, struct scatterlist *sg_list,
-			 enum dma_data_direction dir)
+struct ufshcd_rpmb_args {
+	struct scsi_exec_args args;
+	struct ufs_hba *hba;
+	struct utp_upiu_req *req_upiu;
+	struct utp_upiu_req *rsp_upiu;
+	struct ufs_ehs *req_ehs;
+	struct ufs_ehs *rsp_ehs;
+	int sg_cnt;
+	struct scatterlist *sg_list;
+	enum dma_data_direction dir;
+	int *upiu_result;
+};
+
+static int ufshcd_init_rpmb(struct scsi_cmnd *cmd,
+			    const struct scsi_exec_args *args)
 {
-	const u32 tag =3D hba->reserved_slot;
-	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
+	const struct ufshcd_rpmb_args *ura =3D
+		container_of(args, typeof(*ura), args);
+	struct ufs_hba *hba =3D ura->hba;
+	int ehs =3D (hba->capabilities & MASK_EHSLUTRD_SUPPORTED) ? 2 : 0;
 	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
-	int err =3D 0;
-	int result;
+	struct utp_upiu_req *req_upiu =3D ura->req_upiu;
+	struct scatterlist *sg_list =3D ura->sg_list;
+	struct ufs_ehs *req_ehs =3D ura->req_ehs;
+	enum dma_data_direction dir =3D ura->dir;
+	u32 tag =3D scsi_cmd_to_rq(cmd)->tag;
+	int sg_cnt =3D ura->sg_cnt;
 	u8 upiu_flags;
-	u8 *ehs_data;
-	u16 ehs_len;
-	int ehs =3D (hba->capabilities & MASK_EHSLUTRD_SUPPORTED) ? 2 : 0;
-
-	/* Protects use of hba->reserved_slot. */
-	ufshcd_dev_man_lock(hba);
=20
 	ufshcd_setup_dev_cmd(hba, cmd, DEV_CMD_TYPE_RPMB, UFS_UPIU_RPMB_WLUN,
 			     tag);
@@ -7530,37 +7605,96 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_h=
ba *hba, struct utp_upiu_req *r
=20
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
=20
-	err =3D ufshcd_issue_dev_cmd(hba, cmd, tag, ADVANCED_RPMB_REQ_TIMEOUT);
-	if (err)
-		return err;
+	return 0;
+}
=20
-	err =3D ufshcd_dev_cmd_completion(hba, lrbp);
-	if (!err) {
-		/* Just copy the upiu response as it is */
-		memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
-		/* Get the response UPIU result */
-		result =3D (lrbp->ucd_rsp_ptr->header.response << 8) |
-			lrbp->ucd_rsp_ptr->header.status;
+static void ufshcd_copy_rpmb_result(struct scsi_cmnd *cmd,
+				    const struct scsi_exec_args *args)
+{
+	const struct ufshcd_rpmb_args *ura =3D
+		container_of(args, typeof(*ura), args);
+	struct utp_upiu_req *rsp_upiu =3D ura->rsp_upiu;
+	struct ufshcd_lrb *lrbp =3D scsi_cmd_priv(cmd);
+	struct ufs_ehs *rsp_ehs =3D ura->rsp_ehs;
+	u8 *ehs_data;
+	u16 ehs_len;
=20
-		ehs_len =3D lrbp->ucd_rsp_ptr->header.ehs_length;
+	/* Copy the upiu response. */
+	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
+	/* Copy the UPIU response and status fields. */
+	*ura->upiu_result =3D (lrbp->ucd_rsp_ptr->header.response << 8) |
+		lrbp->ucd_rsp_ptr->header.status;
+
+	ehs_len =3D lrbp->ucd_rsp_ptr->header.ehs_length;
+	/*
+	 * Since the bLength in the EHS indicates the total size of the EHS
+	 * Header and EHS Data in 32 Byte units, the value of the bLength
+	 * Request/Response for Advanced RPMB Message is 02h.
+	 */
+	if (ehs_len =3D=3D 2 && rsp_ehs) {
 		/*
-		 * Since the bLength in EHS indicates the total size of the EHS Header=
 and EHS Data
-		 * in 32 Byte units, the value of the bLength Request/Response for Adv=
anced RPMB
-		 * Message is 02h
+		 * ucd_rsp_ptr points to a buffer with a length of 512 bytes
+		 * (ALIGNED_UPIU_SIZE =3D 512), and the EHS data just starts from
+		 * byte32.
 		 */
-		if (ehs_len =3D=3D 2 && rsp_ehs) {
-			/*
-			 * ucd_rsp_ptr points to a buffer with a length of 512 bytes
-			 * (ALIGNED_UPIU_SIZE =3D 512), and the EHS data just starts from byt=
e32
-			 */
-			ehs_data =3D (u8 *)lrbp->ucd_rsp_ptr + EHS_OFFSET_IN_RESPONSE;
-			memcpy(rsp_ehs, ehs_data, ehs_len * 32);
-		}
+		ehs_data =3D (u8 *)lrbp->ucd_rsp_ptr + EHS_OFFSET_IN_RESPONSE;
+		memcpy(rsp_ehs, ehs_data, ehs_len * 32);
 	}
+}
=20
+/**
+ * ufshcd_advanced_rpmb_req_handler - handle advanced RPMB request
+ * @hba:	per adapter instance
+ * @req_upiu:	upiu request
+ * @rsp_upiu:	upiu reply
+ * @req_ehs:	EHS field which contains Advanced RPMB Request Message
+ * @rsp_ehs:	EHS field which returns Advanced RPMB Response Message
+ * @sg_cnt:	The number of sg lists actually used
+ * @sg_list:	Pointer to SG list when DATA IN/OUT UPIU is required in ARP=
MB operation
+ * @dir:	DMA direction
+ *
+ * Return: zero on success, non-zero on failure. This function can retur=
n a
+ * negative error code, a positive OCS error or a two byte integer with =
the
+ * most significant byte representing the UTP response value and the lea=
st
+ * significant byte representing the RPMB status value. See also section
+ * "12.4.3.7 RPMB Operation Result" in the UFS standard.
+ */
+int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upi=
u_req *req_upiu,
+			 struct utp_upiu_req *rsp_upiu, struct ufs_ehs *req_ehs,
+			 struct ufs_ehs *rsp_ehs, int sg_cnt, struct scatterlist *sg_list,
+			 enum dma_data_direction dir)
+{
+	int err, upiu_result =3D 0;
+	const struct ufshcd_rpmb_args args =3D {
+		.hba =3D hba,
+		.req_upiu =3D req_upiu,
+		.rsp_upiu =3D rsp_upiu,
+		.req_ehs =3D req_ehs,
+		.rsp_ehs =3D rsp_ehs,
+		.sg_cnt =3D sg_cnt,
+		.sg_list =3D sg_list,
+		.dir =3D dir,
+		.upiu_result =3D &upiu_result,
+	};
+	const u32 tag =3D hba->reserved_slot;
+	struct scsi_cmnd *cmd =3D ufshcd_tag_to_cmd(hba, tag);
+
+	/* Protects use of hba->reserved_slot. */
+	ufshcd_dev_man_lock(hba);
+
+	err =3D ufshcd_init_rpmb(cmd, &args.args);
+	WARN_ON_ONCE(err);
+
+	err =3D ufshcd_issue_dev_cmd(hba, cmd, tag, ADVANCED_RPMB_REQ_TIMEOUT);
+	if (err)
+		goto unlock;
+
+	ufshcd_copy_rpmb_result(cmd, &args.args);
+
+unlock:
 	ufshcd_dev_man_unlock(hba);
=20
-	return err ? : result;
+	return err ?: upiu_result;
 }
=20
 static bool ufshcd_clear_lu_cmds(struct request *req, void *priv)
