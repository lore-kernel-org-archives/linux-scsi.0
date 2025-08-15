Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE2C227B9F
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755273580; cv=none; b=Tg6A1fgrIIdglHNJJ5HbwjniKPHvh4IocSiX5ntfe3x3yIah+U5lGIwbAOyX4kGyBRgmZP2FQE7EmuIC9uwv2E0WJuenlPEH0/blwVR/snoGWrgG6J5ufIhxKogAtgq9k9z2U30vikTA3mO4atLDK8MaMQRdx9ba+wctTfQ72Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755273580; c=relaxed/simple;
	bh=+l0e+f6rGSk/wbIfs3mAeZumhqnQOci6aFfNZcWSh8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYFSt+0V882q0ATsJKlS9GDxB95fvzVNaVWUJVP/Rfo6Vtb+4CdNWL9v+ho/zuMdGlTLIa6EKFXtlC19YE2sS0YGaq2qXLRemhNoitC8u0VigfENwTApoOk3wce3K0P8HoxkkZnJEjEnA+eNhFniBJi4E8QFzRyam/bfikjToYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=06o0habS; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="06o0habS"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c3Rd35XkWzlgqVS;
	Fri, 15 Aug 2025 15:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1755273573; x=1757865574; bh=Vg25A
	NGhMTY9EGJROgI1PiVAbwEVvlBtC+ptCRrtkpg=; b=06o0habSV1ZWPtL+qrEWm
	+rpqMOP2kp1zOw4Qe9NhDbEfA4p3oawQCsAYpwvAraZgBVLfaInkW/7AKd8b/e27
	DGVSkakVjlClqw7yy4e6vtwT+8GCL0PKLSv8hoRqiA/qkpDRDkhtPYCrTRunuDtw
	3ZarH10ASZY5b62q/Nle3SEtv+nL62Zeu7OiDhJPSVc9yVUCNKGGJMHlzydtNZ5e
	anFCTCjCewQjf5td/5iBfu4t6kOe/HRH/utk+s3P8gMOGPH374piAX3COMezWuUq
	JEIxAFAvFTHvc3jUXfoBPJz/lExDLgMXxzHeFV2gO0PG9hHyw7J3v9ddW/kAbAf4
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PFIOhwY21zHN; Fri, 15 Aug 2025 15:59:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c3Rcs6clHzlngST;
	Fri, 15 Aug 2025 15:59:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v3 3/4] ufs: core: Fix the return value documentation
Date: Fri, 15 Aug 2025 08:58:25 -0700
Message-ID: <20250815155842.472867-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
In-Reply-To: <20250815155842.472867-1-bvanassche@acm.org>
References: <20250815155842.472867-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

ufshcd_wait_for_dev_cmd() and all its callers can return an OCS error.
OCS errors are represented by positive integers. Remove the WARN_ONCE()
statements that complain about positive error codes and update the
documentation.

Keep the behavior of ufshcd_wait_for_dev_cmd() because this return value
may end be passed as the second argument of bsg_job_done() and
bsg_job_done() handles positive and negative error codes differently.

Cc: Peter Wang <peter.wang@mediatek.com>
Fixes: cc59f3b68542 ("scsi: ufs: core: Improve return value documentation=
")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 62 ++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ebacf5dd959..e6c2daba2772 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3199,7 +3199,8 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, stru=
ct ufshcd_lrb *lrbp)
 }
=20
 /*
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, int max_timeout)
@@ -3275,7 +3276,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
 		}
 	}
=20
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3294,7 +3294,8 @@ static void ufshcd_dev_man_unlock(struct ufs_hba *h=
ba)
 }
=20
 /*
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *=
lrbp,
 			  const u32 tag, int timeout)
@@ -3317,7 +3318,8 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba=
, struct ufshcd_lrb *lrbp,
  * @cmd_type: specifies the type (NOP, Query...)
  * @timeout: timeout in milliseconds
  *
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  *
  * NOTE: Since there is only one available tag for device management com=
mands,
  * it is expected you hold the hba->dev_cmd.lock mutex.
@@ -3363,6 +3365,10 @@ static inline void ufshcd_init_query(struct ufs_hb=
a *hba,
 	(*request)->upiu_req.selector =3D selector;
 }
=20
+/*
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
+ */
 static int ufshcd_query_flag_retry(struct ufs_hba *hba,
 	enum query_opcode opcode, enum flag_idn idn, u8 index, bool *flag_res)
 {
@@ -3383,7 +3389,6 @@ static int ufshcd_query_flag_retry(struct ufs_hba *=
hba,
 		dev_err(hba->dev,
 			"%s: query flag, opcode %d, idn %d, failed with error %d after %d ret=
ries\n",
 			__func__, opcode, idn, ret, retries);
-	WARN_ONCE(ret > 0, "Incorrect return value %d > 0\n", ret);
 	return ret;
 }
=20
@@ -3395,7 +3400,8 @@ static int ufshcd_query_flag_retry(struct ufs_hba *=
hba,
  * @index: flag index to access
  * @flag_res: the flag value after the query request completes
  *
- * Return: 0 for success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 			enum flag_idn idn, u8 index, bool *flag_res)
@@ -3451,7 +3457,6 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum que=
ry_opcode opcode,
=20
 out_unlock:
 	ufshcd_dev_man_unlock(hba);
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3464,8 +3469,9 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum que=
ry_opcode opcode,
  * @selector: selector field
  * @attr_val: the attribute value after the query request completes
  *
- * Return: 0 upon success; < 0 upon failure.
-*/
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
+ */
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val)
 {
@@ -3513,7 +3519,6 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum que=
ry_opcode opcode,
=20
 out_unlock:
 	ufshcd_dev_man_unlock(hba);
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3528,8 +3533,9 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum que=
ry_opcode opcode,
  * @attr_val: the attribute value after the query request
  * completes
  *
- * Return: 0 for success; < 0 upon failure.
-*/
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
+ */
 int ufshcd_query_attr_retry(struct ufs_hba *hba,
 	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
 	u32 *attr_val)
@@ -3551,12 +3557,12 @@ int ufshcd_query_attr_retry(struct ufs_hba *hba,
 		dev_err(hba->dev,
 			"%s: query attribute, idn %d, failed with error %d after %d retries\n=
",
 			__func__, idn, ret, QUERY_REQ_RETRIES);
-	WARN_ONCE(ret > 0, "Incorrect return value %d > 0\n", ret);
 	return ret;
 }
=20
 /*
- * Return: 0 if successful; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 			enum query_opcode opcode, enum desc_idn idn, u8 index,
@@ -3615,7 +3621,6 @@ static int __ufshcd_query_descriptor(struct ufs_hba=
 *hba,
 out_unlock:
 	hba->dev_cmd.query.descriptor =3D NULL;
 	ufshcd_dev_man_unlock(hba);
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3632,7 +3637,8 @@ static int __ufshcd_query_descriptor(struct ufs_hba=
 *hba,
  * The buf_len parameter will contain, on return, the length parameter
  * received on the response.
  *
- * Return: 0 for success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 				  enum query_opcode opcode,
@@ -3650,7 +3656,6 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *h=
ba,
 			break;
 	}
=20
-	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3663,7 +3668,8 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *h=
ba,
  * @param_read_buf: pointer to buffer where parameter would be read
  * @param_size: sizeof(param_read_buf)
  *
- * Return: 0 in case of success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 int ufshcd_read_desc_param(struct ufs_hba *hba,
 			   enum desc_idn desc_id,
@@ -3730,7 +3736,6 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 out:
 	if (is_kmalloc)
 		kfree(desc_buf);
-	WARN_ONCE(ret > 0, "Incorrect return value %d > 0\n", ret);
 	return ret;
 }
=20
@@ -4781,7 +4786,8 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
  *
  * Set fDeviceInit flag and poll until device toggles it.
  *
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
@@ -5135,7 +5141,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
  * not respond with NOP IN UPIU within timeout of %NOP_OUT_TIMEOUT
  * and we retry sending NOP OUT for %NOP_OUT_RETRIES iterations.
  *
- * Return: 0 upon success; < 0 upon failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 {
@@ -5867,7 +5874,8 @@ static inline int ufshcd_enable_ee(struct ufs_hba *=
hba, u16 mask)
  * as the device is allowed to manage its own way of handling background
  * operations.
  *
- * Return: zero on success, non-zero on failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
 {
@@ -5906,7 +5914,8 @@ static int ufshcd_enable_auto_bkops(struct ufs_hba =
*hba)
  * host is idle so that BKOPS are managed effectively without any negati=
ve
  * impacts.
  *
- * Return: zero on success, non-zero on failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 {
@@ -6056,6 +6065,10 @@ static void ufshcd_bkops_exception_event_handler(s=
truct ufs_hba *hba)
 				__func__, err);
 }
=20
+/*
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
+ */
 int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *except=
ion_id)
 {
 	struct utp_upiu_query_v4_0 *upiu_resp;
@@ -7447,7 +7460,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
  * @sg_list:	Pointer to SG list when DATA IN/OUT UPIU is required in ARP=
MB operation
  * @dir:	DMA direction
  *
- * Return: zero on success, non-zero on failure.
+ * Return: 0 upon success; > 0 in case the UFS device reported an OCS er=
ror;
+ * < 0 if another error occurred.
  */
 int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upi=
u_req *req_upiu,
 			 struct utp_upiu_req *rsp_upiu, struct ufs_ehs *req_ehs,
