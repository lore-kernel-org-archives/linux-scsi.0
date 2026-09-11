Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EFB3E3156
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094605; cv=none; b=aVwlSdJPkMDgCaTyN98p8ojzhXHpCfPwdYJ4BEtVbMxvtfjzkQRI3wDNIy5AWMSrI5s5dj6J1M1yoyjCgbaFVwNXguyPF17a069+uxoEl7XvdB/q7i+P1KMsllKT9DUpRwLTZsng6N7PGFdkXcunFEMlwP5msdp/3GgWRhBkcXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094605; c=relaxed/simple;
	bh=/cObwhUGxRYT81pWRaz2+xTY8TN+IfT3Lgkepn5EkFM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eNLe+tBs0WvKTGJUMxTdCebT1PZELSHhZ8sptW6D6AUsG1Ev+IjvWbK90i5/25x5zTEUZuooY9cuVNJjWBLw3Ks7Gb97zbj6HRcls/oY26yPppmOSbkPk9zgCbJMtWOJzHWWrcAc5uNT3W64kyGmBuW/iBr/hjpmm0k3+HrD8gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kJGIlNaL; arc=none smtp.client-ip=209.85.216.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kJGIlNaL"
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dbf293831so905327a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 19:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789094604; x=1789699404; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n65nahpXmxrqssgUn61577EijG7naLtO5boPcffg92w=;
        b=kJGIlNaLYJrtxnNI6l9GtpLzYonuEueleiK/48zjQcPEvq6DgxyoNb7g3kaLH0crna
         avPb1OQjfmagqjlLnPJ4OLbqBOlf6lXCA888hunBb2YvcqQLMQ7ZclM3GeAZO76S950x
         KEFWpSHCm5P3k5W6FXsTP4BrHkWbtsKijB29fQ3xMg+Hwny0xaoIqv4QRYd1O/D7eMF1
         W8QF80U+WU5s1ahXRPNohdPnhxCN6MbIK0VkyhUpIYHDpZCR0OBHOWazliWD0eCC8y1l
         cwMlEmGAI9QxL6ZHRRsNVB5x4mN6d1OqhAdGJmUapz0hwIqYlWG1MUBoKhaOwsTF/KP5
         Xjqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789094604; x=1789699404;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n65nahpXmxrqssgUn61577EijG7naLtO5boPcffg92w=;
        b=VB7hKUvsDBsoo/Ag/hL2EqULa5hbj01WrN2yCbKFaTWZaKN6CQ06YsR09bUGkXvhAf
         sbGzre2SgzL2xqCoFsc8x7wcJYi8Y9XZZgyYzkuE2cXhh5FAAUu4wgROu1C7mEHWdpKx
         lOrHbLOiz+ob9xA+eUiW0KvbQNfM/5OZRYgOgzJlw1WMo+FY5V73eo4TVEyooDyB68NR
         TpeIDgwA09gAmOg47SVpu3gWjRcQKVM/LGbk9z2JxNgKgNaX/7b2uIdQ5AuD43ZPDw+I
         Nxvfe7nwt8lcNd1eDpj3KAd7056Jz56cMlAC3srrBSN4w8EAMj2jVfsAlAMvIQxNoPbr
         wMlA==
X-Gm-Message-State: AFuF++l1o4Rw2iMqxpaTkW0Yn6g7jFG2TanGSTOBYYvC2yqXeVHpQkm6
	Ll/lC6n45ebYsZGZXLVYAUFA7WcgbrTbJxIET/fgcXl62upMfkeQ8ysyZLD9upzyCfFJ9lUV5eE
	Kzr9Hscar4hgvwHREfXxZhQ==
X-Received: from pjzb21.prod.google.com ([2002:a17:90a:e395:b0:39d:8c1c:1e2f])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:35d2:b0:39d:8d38:8b04 with SMTP id 98e67ed59e1d1-39d9bbea1d3mr3240325a91.1.1789094603515;
 Thu, 10 Sep 2026 19:43:23 -0700 (PDT)
Date: Fri, 11 Sep 2026 10:43:18 +0800
In-Reply-To: <20260911024319.1346706-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260911024319.1346706-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911024319.1346706-2-stanleyjhu@google.com>
Subject: [PATCH 1/2] scsi: ufs: core: Fast-abort unsupported Query IDNs
From: Stanley Jhu <stanleyjhu@google.com>
To: mkp@kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bvanassche@acm.org, avri.altman@sandisk.com, alim.akhtar@samsung.com, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

JEDEC JESD220F specifies that devices not supporting an optional
Query IDN return QUERY_RESULT_INVALID_IDN (0xFD) in the Query Response
UPIU.

ufshcd_dev_cmd_completion() maps all non-zero Query responses to
-EINVAL and logs dev_err(). A device declining an optional IDN is
spec-compliant, so this reports an error that did not occur and leaves
the retry loops resending a request the device will never accept.

Decode 0xFD as -EOPNOTSUPP, terminate the query retry loops on it, and
drop the dev_err() in the query wrappers and descriptor readers for
that case. Other errors are logged and retried as before.

The suppressed dev_err() calls carried the opcode and IDN; log them
with dev_dbg() where the response is decoded.

Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1ca731675ad1..f01703c3825f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3284,6 +3284,11 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 		if (response == 0) {
 			err = ufshcd_copy_query_response(hba, lrbp);
+		} else if (response == QUERY_RESULT_INVALID_IDN) {
+			err = -EOPNOTSUPP;
+			dev_dbg(hba->dev, "%s: unsupported opcode 0x%x idn 0x%x\n",
+				__func__, lrbp->ucd_req_ptr->qr.opcode,
+				lrbp->ucd_req_ptr->qr.idn);
 		} else {
 			err = -EINVAL;
 			dev_err(hba->dev, "%s: unexpected response in Query RSP: %x\n",
@@ -3446,6 +3451,8 @@ static int ufshcd_query_flag_retry(struct ufs_hba *hba,
 
 	for (retries = 0; retries < QUERY_REQ_RETRIES; retries++) {
 		ret = ufshcd_query_flag(hba, opcode, idn, index, flag_res);
+		if (ret == -EOPNOTSUPP)
+			return ret;
 		if (ret)
 			dev_dbg(hba->dev,
 				"%s: failed with error %d, retries %d\n",
@@ -3512,7 +3519,8 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	}
 
 	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, timeout);
-
+	if (err == -EOPNOTSUPP)
+		goto out_unlock;
 	if (err) {
 		dev_err(hba->dev,
 			"%s: Sending flag query for idn %d failed, err = %d\n",
@@ -3577,7 +3585,8 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 	}
 
 	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
-
+	if (err == -EOPNOTSUPP)
+		goto out_unlock;
 	if (err) {
 		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, err = %d\n",
 				__func__, opcode, idn, index, err);
@@ -3615,6 +3624,8 @@ int ufshcd_query_attr_retry(struct ufs_hba *hba,
 	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
 		ret = ufshcd_query_attr(hba, opcode, idn, index,
 						selector, attr_val);
+		if (ret == -EOPNOTSUPP)
+			return ret;
 		if (ret)
 			dev_dbg(hba->dev, "%s: failed with error %d, retries %d\n",
 				__func__, ret, retries);
@@ -3676,6 +3687,8 @@ int ufshcd_query_attr_qword(struct ufs_hba *hba, enum query_opcode opcode,
 	}
 
 	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
+	if (err == -EOPNOTSUPP)
+		goto out_unlock;
 	if (err) {
 		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, selector %d, err = %d\n",
 			__func__, opcode, idn, index, sel, err);
@@ -3739,7 +3752,8 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 	}
 
 	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, dev_cmd_timeout);
-
+	if (err == -EOPNOTSUPP)
+		goto out_unlock;
 	if (err) {
 		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, err = %d\n",
 				__func__, opcode, idn, index, err);
@@ -3782,7 +3796,7 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
 		err = __ufshcd_query_descriptor(hba, opcode, idn, index,
 						selector, desc_buf, buf_len);
-		if (!err || err == -EINVAL)
+		if (!err || err == -EINVAL || err == -EOPNOTSUPP)
 			break;
 	}
 
@@ -3831,6 +3845,8 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
 					    desc_id, desc_index, 0,
 					    desc_buf, &buff_len);
+	if (ret == -EOPNOTSUPP)
+		goto out;
 	if (ret) {
 		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d\n",
 			__func__, desc_id, desc_index, param_offset, ret);
@@ -3917,8 +3933,9 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 	ret = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_STRING, desc_index, 0,
 				     (u8 *)uc_str, QUERY_DESC_MAX_SIZE);
 	if (ret < 0) {
-		dev_err(hba->dev, "Reading String Desc failed after %d retries. err = %d\n",
-			QUERY_REQ_RETRIES, ret);
+		if (ret != -EOPNOTSUPP)
+			dev_err(hba->dev, "Reading String Desc failed after %d retries. err = %d\n",
+				QUERY_REQ_RETRIES, ret);
 		str = NULL;
 		goto out;
 	}
-- 
2.55.0.1007.g17ff1f9808-goog

