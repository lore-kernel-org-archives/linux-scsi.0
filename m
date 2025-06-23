Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1F5220686
	for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2025 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715980; cv=none; b=Pw5Ztlz6bAD0Ww1PAh/iBjcj7FDDAnJxFyqx6CyiguVQh2UtO/3kriamkO3RDvHS0Yo6+flaHabQJWxw1k3EMIpdsoZyyu6dkRR7KMsxrbjukBjnkWjtI165al6ftpqUDbr9TnzQiUA3eW4ZXPG60Rq2Ai5kwCmDOmz7x3wr8Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715980; c=relaxed/simple;
	bh=Nj9+Si1MSliMHy4weJ0O1ybXoIBktFBUFz5sP5lRZt4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tc9OvEBENeQDeQaS/YpDbZ2Bp6krFLLrLeWVgxWTn1yArv6SjJ9a0Pul6C00lmgbtCB67LXcSItdAYilUG2NPLIbXLtcZIQso2lnIw6HHZiL9A/txy1M7EzEP5hdOroVnlIG0PnZ2HLs7dDIk2H8nYzadxQPwGTMn6Rszi3L318=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M/1LgzT/; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M/1LgzT/"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bR26v3nDXzm0yT6;
	Mon, 23 Jun 2025 21:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1750715973; x=1753307974; bh=U3QF2dOgMln1UbuaXbWx4ETan33hdSiahI/
	UNuxKV7o=; b=M/1LgzT/oddqPzrFYwwnqHQNZK529ldb+ogjdW+PjwHsdhLPRKH
	boxvxQgnZEqkmQ+9ZTVLJ+BnEzMt3HEweQx4sIWE6BAYkh2u5DMy6mAgP+YeZCW8
	Kk2gADtJQMgWezWNUONkjFUu//lYeQF0JdFFvMm3CVVOCmbRIFYBfSNs2wdFdm2N
	f9nVD43RcnRUyxh8ElkxqJxuM+rJmQE17LPryhv1lf522tjmJLLcNgYzCXdHBZWr
	WLH865CM+LwFr6Ws/Z/VvRFcPoFuscMwjaWRrDz4KLvVM6/O5QMwKGxl2RNVp7/+
	0CeipX8psPljQbdnLXsUjdEVixDzej5Dnqg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OKDlSGXNnHt4; Mon, 23 Jun 2025 21:59:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bR26m4TW2zm0ySq;
	Mon, 23 Jun 2025 21:59:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH] scsi: ufs: core: Improve return value documentation
Date: Mon, 23 Jun 2025 14:59:01 -0700
Message-ID: <20250623215909.4169007-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Some functions return a negative value to indicate an error while other
functions return a value !=3D 0 to indicate an error. Document the return
value behavior where this documentation is missing and fix the return
value documentation where necessary. Add warnings to detect mismatches
between documentation and implementation. This matters because several
sysfs callback functions only work correctly if a negative value is
returned upon error.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2048aca09fc..b3fe4335d56c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2566,7 +2566,7 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct=
 uic_command *uic_cmd)
  * @hba: per adapter instance
  * @uic_cmd: UIC command
  *
- * Return: 0 only if success.
+ * Return: 0 if successful; < 0 upon failure.
  */
 static int
 __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
@@ -3072,6 +3072,9 @@ static void ufshcd_setup_dev_cmd(struct ufs_hba *hb=
a, struct ufshcd_lrb *lrbp,
 	hba->dev_cmd.type =3D cmd_type;
 }
=20
+/*
+ * Return: 0 upon success; < 0 upon failure.
+ */
 static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int tag)
 {
@@ -3184,9 +3187,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, str=
uct ufshcd_lrb *lrbp)
 		break;
 	}
=20
+	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
+/*
+ * Return: 0 upon success; < 0 upon failure.
+ */
 static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, int max_timeout)
 {
@@ -3261,6 +3268,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
 		}
 	}
=20
+	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3278,6 +3286,9 @@ static void ufshcd_dev_man_unlock(struct ufs_hba *h=
ba)
 	ufshcd_release(hba);
 }
=20
+/*
+ * Return: 0 upon success; < 0 upon failure.
+ */
 static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *=
lrbp,
 			  const u32 tag, int timeout)
 {
@@ -3365,6 +3376,7 @@ static int ufshcd_query_flag_retry(struct ufs_hba *=
hba,
 		dev_err(hba->dev,
 			"%s: query flag, opcode %d, idn %d, failed with error %d after %d ret=
ries\n",
 			__func__, opcode, idn, ret, retries);
+	WARN_ONCE(ret > 0, "Incorrect return value %d > 0\n", ret);
 	return ret;
 }
=20
@@ -3376,7 +3388,7 @@ static int ufshcd_query_flag_retry(struct ufs_hba *=
hba,
  * @index: flag index to access
  * @flag_res: the flag value after the query request completes
  *
- * Return: 0 for success, non-zero in case of failure.
+ * Return: 0 for success; < 0 upon failure.
  */
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 			enum flag_idn idn, u8 index, bool *flag_res)
@@ -3432,6 +3444,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum que=
ry_opcode opcode,
=20
 out_unlock:
 	ufshcd_dev_man_unlock(hba);
+	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3444,7 +3457,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum que=
ry_opcode opcode,
  * @selector: selector field
  * @attr_val: the attribute value after the query request completes
  *
- * Return: 0 for success, non-zero in case of failure.
+ * Return: 0 upon success; < 0 upon failure.
 */
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val)
@@ -3493,6 +3506,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum que=
ry_opcode opcode,
=20
 out_unlock:
 	ufshcd_dev_man_unlock(hba);
+	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3507,7 +3521,7 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum que=
ry_opcode opcode,
  * @attr_val: the attribute value after the query request
  * completes
  *
- * Return: 0 for success, non-zero in case of failure.
+ * Return: 0 for success; < 0 upon failure.
 */
 int ufshcd_query_attr_retry(struct ufs_hba *hba,
 	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
@@ -3530,9 +3544,13 @@ int ufshcd_query_attr_retry(struct ufs_hba *hba,
 		dev_err(hba->dev,
 			"%s: query attribute, idn %d, failed with error %d after %d retries\n=
",
 			__func__, idn, ret, QUERY_REQ_RETRIES);
+	WARN_ONCE(ret > 0, "Incorrect return value %d > 0\n", ret);
 	return ret;
 }
=20
+/*
+ * Return: 0 if successful; < 0 upon failure.
+ */
 static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 			enum query_opcode opcode, enum desc_idn idn, u8 index,
 			u8 selector, u8 *desc_buf, int *buf_len)
@@ -3590,6 +3608,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba=
 *hba,
 out_unlock:
 	hba->dev_cmd.query.descriptor =3D NULL;
 	ufshcd_dev_man_unlock(hba);
+	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3606,7 +3625,7 @@ static int __ufshcd_query_descriptor(struct ufs_hba=
 *hba,
  * The buf_len parameter will contain, on return, the length parameter
  * received on the response.
  *
- * Return: 0 for success, non-zero in case of failure.
+ * Return: 0 for success; < 0 upon failure.
  */
 int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 				  enum query_opcode opcode,
@@ -3624,6 +3643,7 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *h=
ba,
 			break;
 	}
=20
+	WARN_ONCE(err > 0, "Incorrect return value %d > 0\n", err);
 	return err;
 }
=20
@@ -3636,7 +3656,7 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *h=
ba,
  * @param_read_buf: pointer to buffer where parameter would be read
  * @param_size: sizeof(param_read_buf)
  *
- * Return: 0 in case of success, non-zero otherwise.
+ * Return: 0 in case of success; < 0 upon failure.
  */
 int ufshcd_read_desc_param(struct ufs_hba *hba,
 			   enum desc_idn desc_id,
@@ -3703,6 +3723,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 out:
 	if (is_kmalloc)
 		kfree(desc_buf);
+	WARN_ONCE(ret > 0, "Incorrect return value %d > 0\n", ret);
 	return ret;
 }
=20
@@ -3816,7 +3837,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8=
 desc_index,
  * @param_read_buf: pointer to buffer where parameter would be read
  * @param_size: sizeof(param_read_buf)
  *
- * Return: 0 in case of success, non-zero otherwise.
+ * Return: 0 in case of success; < 0 upon failure.
  */
 static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 					      int lun,
@@ -4794,7 +4815,7 @@ static int ufshcd_complete_dev_init(struct ufs_hba =
*hba)
  * 3. Program UTRL and UTMRL base address
  * 4. Configure run-stop-registers
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 if successful; < 0 upon failure.
  */
 int ufshcd_make_hba_operational(struct ufs_hba *hba)
 {
