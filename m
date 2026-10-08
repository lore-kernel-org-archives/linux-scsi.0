Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9816639769B
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 02:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791426895; cv=none; b=VYCvwIBrIRkomzfWBjzNAtELKjNLV5yhahJVTb+A8HQCW4fj2oBgt7PReLeiOgruDUSUAoTRSdPPy56l3Y2BY+1uN0WzV9bIa2zxd7nnK/4W8tCTfnUtI2wgWTfRbbEmzuBv7g42xUaCaqcR9COooTz8o5WDxlpF8qg1KIST+ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791426895; c=relaxed/simple;
	bh=ipFidcXxbVizbNu+kgmGjmrJAORqhj4oJeJtvJTCpuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFc4Rz6UThv9PNafh19yaw/8yF+cd2MGSxXAioeAuVlNlUOErDa1GsjEjI0dbDs399Fk0uKGFGA603n44ufTjCycw3zrJN5bVU68nJxtnHX6W4KJfu3u5/2Rwpd4IPq1ueBkWivE9agZ8y2wEZswPx+G33QS2Vf0H1Gd86isBYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20251104.gappssmtp.com header.i=@smartx-com.20251104.gappssmtp.com header.b=MhBBCfT0; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20251104.gappssmtp.com header.i=@smartx-com.20251104.gappssmtp.com header.b="MhBBCfT0"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-30b6dad2382so5679551eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 19:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20251104.gappssmtp.com; s=20251104; t=1791426894; x=1792031694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sfh2HSMnCjXwgYeAujbI+vl7unaGjCR05Oxxe16EwFw=;
        b=MhBBCfT0Ve7Mq8Ler+7nOy7KefPP/A/rt7IcbZ2xZhjvDpI4OKCyXIIf1KL2E+0rIP
         H5alxfSbo3tz4lzK/avqnETlQtAfWhST6XBhBUTZ/GltrGyTXN2Q1nQsc8SuZ2LhoUcH
         VJc+Talr+D5zh4b4CKRn0XJsCGRLD1zbmAuj0dEC9OXYN1NEvjqVxGuqKYBJVdF47Oyk
         mCOhuu7Nl4aR5+A3h9OJPtrnxd/G4+ZyhWqWm0loMqliMXUveAxeTm/A4ROppiuIrjVb
         Tfvp1lFAPRAIu5oKsTz0yNnrPls5h5+l7v3vlUHfkKFw0yTAa7vQQp42W33cfbtF4+iZ
         EMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791426894; x=1792031694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sfh2HSMnCjXwgYeAujbI+vl7unaGjCR05Oxxe16EwFw=;
        b=vqN7Uyj1v9YGw0QJBYpkUPjzGa5TFiDeEX0G5SYtnfAjOkIBhk62Oov3E64YzjEP0o
         v4YW+yLOVuZIKDvIKcWTg1BW2XM39BbxCGoCddTOVbEwLFNiP1oYopPS/4Hff+NRKn+6
         +4oBBcJl8E7hkyou22dXGNZ3lD1v6NBvOO3n4nRa7jr5FLRkynEhcV9cmSK01w2xnCSs
         A2W3XO2e93oXwluE13iWYItopC9Y4wEby2lWXbUWI4DdZKizO6/2W/uOiUp5MppzLQji
         JH4qG2tKa3RqsaPZtrsiWiiXlq2KxzAhDoLM4nhHujksYm0zOUSKZg99ErPW50KAuOSJ
         xsBg==
X-Forwarded-Encrypted: i=1; AKwUvBwpzUempiu/tMs1VbCatG33JVSXGHJHTvJV+qiuhIfWDwjamcBGdoTiRHVQAXyIm2eFrmp+8ZsF+GGN@vger.kernel.org
X-Gm-Message-State: AFuF++lhUDeU+d0JwrLx9XzAj8IbC0noG8eS2+jci9WgIEWmw5SqP6TO
	Tgfu+VgMEcJ0NldoXRq5A1Xsk6lxyzWDpMjOLbuZM3ebFj/JkdOlIWdqO49BgtxIFYNw18ZZX5P
	BsDNOUYxR28n5iNyFG2+HFzRFFAp4FW2B0Foob2xheW4dBGjvNecgYuaY
X-Gm-Gg: AYBFou1Z7E5FQfTBxWC59wMKPpXNAE738NtXaiX7GZGz06SFO4892MPmZ+Qa2Tvc9J6
	vNsBIgSZ+uMxBMVAaxvyjzM+NrrME7ETa5F1vtm84YTq3Vgb5TcuTcyQfR79I509Iy4X95sNqsu
	NlZhm+QA/HJJRFqgHqiJR2FZL2RVj0XdTqawnCo633GxtVPl10iqGRLYLSVWNApm2wvbaqGHar8
	EGVGi/nAZKZ/lAYPlslScx7cXdNkdXKhgIaB8ecDoJIVNY6nee1LaSxl2t1UDtVZg8NzbN8Z3WJ
	xk2yH/JpNAvPbiW//MyYPheDhhtF7+gvRsA8DA/Q7aQgVhjXh/5+PKlfc1TXgwqPBR1MQwqDxlf
	hycGbogbughKvyUdQoRnv92AdIHTfPE0U6Ug/kBzdtENUVk9cqY+nfwt42ySqBZGF2slKvx+THG
	8blvzmk1OOJfSi0ZhqeMJ4n2U3G0tSmkyJY79mcyJRG8MLo4tAhVwAIrmM5HxIgxX9/uUgGOprY
	DQjf2vMjysR5svBK8NY
X-Received: by 2002:a05:7301:b06:b0:351:515b:4e85 with SMTP id 5a478bee46e88-3515dd78cacmr4684940eec.16.1791426893578;
        Wed, 07 Oct 2026 19:34:53 -0700 (PDT)
Received: from localhost.localdomain ([23.148.204.240])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-3515aff5dd6sm11859009eec.26.2026.10.07.19.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 19:34:53 -0700 (PDT)
From: Lei Chen <lei.chen@smartx.com>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lei.chen@smartx.com
Subject: [PATCH v2] scsi: mpt3sas: Simplify debugfs setup
Date: Thu,  8 Oct 2026 10:34:40 +0800
Message-ID: <20261008023440.468919-1-lei.chen@smartx.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007141951.417155-1-lei.chen@smartx.com>
References: <20261007141951.417155-1-lei.chen@smartx.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The debugfs creation helpers return error pointers on failure, so the
existing NULL checks do not handle creation failures. There is no need
to add error handling here: debugfs accepts error pointers as parents
and debugfs_remove_recursive() safely handles error pointers and NULL.

Remove the ineffective checks, error messages and file-creation rollback.
Allow host_recovery creation to proceed independently of ioc_dump, and
leave any successfully created entries for the existing teardown path
to remove.

The setup function is called only once per adapter from probe, so create
the per-adapter directory without checking whether it already exists.

Signed-off-by: Lei Chen <lei.chen@smartx.com>
---
Changes in v2:
- Remove debugfs error checks and logging instead of adding
  IS_ERR_OR_NULL() checks.
- Leave debugfs cleanup to the existing teardown path.
- Allow host_recovery creation to proceed independently of ioc_dump.
- Remove the redundant directory existence check, since setup is called
  only once per adapter from probe.
- Reframe the patch as a cleanup and drop the Fixes tag.

Link to v1:
https://lore.kernel.org/all/20261007141951.417155-1-lei.chen@smartx.com/

 drivers/scsi/mpt3sas/mpt3sas_debugfs.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
index 183391f6b8d1..0e37473abbf6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
@@ -99,8 +99,6 @@ static const struct file_operations mpt3sas_debugfs_iocdump_fops = {
 void mpt3sas_init_debugfs(void)
 {
 	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
-	if (!mpt3sas_debugfs_root)
-		pr_info("mpt3sas: Cannot create debugfs root\n");
 }
 
 /*
@@ -121,25 +119,12 @@ mpt3sas_setup_debugfs(struct MPT3SAS_ADAPTER *ioc)
 	char name[64];
 
 	snprintf(name, sizeof(name), "scsi_host%d", ioc->shost->host_no);
-	if (!ioc->debugfs_root) {
-		ioc->debugfs_root =
-		    debugfs_create_dir(name, mpt3sas_debugfs_root);
-		if (!ioc->debugfs_root) {
-			dev_err(&ioc->pdev->dev,
-			    "Cannot create per adapter debugfs directory\n");
-			return;
-		}
-	}
+	ioc->debugfs_root =
+		debugfs_create_dir(name, mpt3sas_debugfs_root);
 
 	snprintf(name, sizeof(name), "ioc_dump");
 	ioc->ioc_dump =	debugfs_create_file(name, 0444,
 	    ioc->debugfs_root, ioc, &mpt3sas_debugfs_iocdump_fops);
-	if (!ioc->ioc_dump) {
-		dev_err(&ioc->pdev->dev,
-		    "Cannot create ioc_dump debugfs file\n");
-		debugfs_remove(ioc->debugfs_root);
-		return;
-	}
 
 	snprintf(name, sizeof(name), "host_recovery");
 	debugfs_create_u8(name, 0444, ioc->debugfs_root, &ioc->shost_recovery);
-- 
2.43.0
