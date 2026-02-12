Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FA02D4805
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929739; cv=none; b=LKfrYYt+Dj1h6zb6TfFCQJzd6kdTvfnV0s9y91OmzBUZnqu2lVIH/mNSG6R7M8bk7s1g9Qfi4Asf2kDzPFvbTP26qK5yeZB8d6lO8ykn3Szl3xJ5Gij8upsuRc88KBkq1dbHZ1OH23M4voJla7xGlW+F19v6X74Nfuingx0UAYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929739; c=relaxed/simple;
	bh=iUDSNtlK0Gs7+fXP4Z9sVT6dhPcix9T8qU4QPx26FtA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oJ/e1nLNOcIwlvdH/NAiBWgi74RGTl4XKAzFNhQgWlJBKuz1MwK6zLPA7X4eKE4lfzT56H7PCQn0szdtSL0tD0hOADyFwI064LKQSdn9IY0XVsoLY8d1j7OpOhD/v5T8pP3C0/oNW+eOoOoclko0tidW5TOyysz5IYH67NEaSnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UEWcqo/6; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UEWcqo/6"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50697d6a69cso1676141cf.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929737; x=1771534537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=brLOvCDrZQ7jb5nfFcJVD0wv+nVS4N9OWw0mF9SPY7k=;
        b=UEWcqo/6//XePpQNObFkf+0mbcrfn9ZjPQymWsxpdxtWgaZt/RWj2/QruTk5rM8Xms
         IXFnpn4MpR1DQ/j4jeTOF383sAwI2/sd3YnMlECjERP/UZiTYgZRs32KMyvGpY3CH+2K
         dJGP0HGjUm539S857K6UNQE/cnfHqW5jj8yQTf1bv+fTrCjR8idHz6sWRuS8CDCq5RYV
         uhFXdHjry+yWg70bhOryQAXbxLHaA0nvfb8jCGTu9JbT+LEE3rJXF+Omw2km7e273T0R
         g/Vl1LBPdVpHgGLUrV8FCHfiSJDc5UeDSMv7gNkXcGsgUrRb6wlidnH0SesrbjTqXPBn
         yfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929737; x=1771534537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=brLOvCDrZQ7jb5nfFcJVD0wv+nVS4N9OWw0mF9SPY7k=;
        b=rGNmjwRRLbcPv1fR5+0312w1TJnIDhWJCHGEq5tgCbtARDJZhBdZ4b0NZ+jrm1o7cj
         9PURaZUr0wzHK5MW7+71RKJmq0qyTz3bjV2G/hx1LD88CfaK6CAadtCTQaFyoEX06peU
         MuRmmIB4tokGJ+sUz0J/Bb8IOOtWqUfJFuv3AJOylk+xOvU8yg4bLFGyYAgTVnblSBYi
         jiV7JXBylrKLD0Dusryf+p4aYlGeNzO9JPUhmO9sgHWI8wMeq8aWFvxAWL+qDpRtsF/F
         sw8oPhmQEfZnFbFkVCDsNVo0Xl+q1u3JMx6DF9JfMz9tQ/Kbesp5HawBUqbx/DPo7lnA
         Kdnw==
X-Gm-Message-State: AOJu0Yzxy3fEPw/ev6f9D547D8EeP/GbM0nYjdFjm00zNWj57VGbZSG3
	KSPPowAFtOxP627YkNwqWS/XaaXgCQaVxGlDEEvynztiasURp9crSg9RX8891W58
X-Gm-Gg: AZuq6aIFAtr6C1ZvBDp8dgleBrgX58IV5blEd2qp/7rRn8zO7ZfxwLh9kPyjUvP1oq1
	hJkt+5pF8k8D+vwoPQ1gJiSNZWvHoe+6OL+ShV5t6wcLSx2GH93v6kp/IeIFcehXWokeWpLFtr1
	4Hl8vLbXvHjs18gPSwfiT9G4GOlNCo62VNnT9Pbs/wbxDSw/adt4grwJdGHHgTU9/PDUnYlTdj9
	tTB+8j0L19FMHHDsZZZZUGN1qPq0HysSnMG18iYIA17Bh3e+JdAX7OYXS7Cku0kK1+GtnDGfTfm
	JfyryZIWzyDoO4eV/lSlKgz8e8ZW5CR4IVD6k3vwad4H0Ub5JZ4fiayG0dIB5lkrdhvzlXCb8FM
	LNpSb9+NDT4LPNo/03h4xU+r8YJfhyBtTJGvDE0eIIGE/kjsDB13jheQz81gwSJtUfXD8yjdofx
	/1P9e8Hcpj45fwAwdY3YXxTy6CUXwCrN86Kj9DTfIobCPQZRO8zd8F6T0/4YUTtImkNouoc0VkS
	ASJm+5omog=
X-Received: by 2002:ac8:7d04:0:b0:4ed:6dde:4573 with SMTP id d75a77b69052e-506a6af3d2amr570251cf.52.1770929737108;
        Thu, 12 Feb 2026 12:55:37 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:36 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 06/13] lpfc: Remove unnecessary ndlp kref get in lpfc_check_nlp_post_devloss
Date: Thu, 12 Feb 2026 13:30:01 -0800
Message-Id: <20260212213008.149873-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When NLP_IN_RECOV_POST_DEV_LOSS is set, the initial node reference remains
held while recovery is in progress.  Taking a reference when
NLP_IN_RECOV_POST_DEV_LOSS is cleared results in an additional reference
being held.  This causes an extra reference when cleaning up lpfc_vport
instances.  Thus, remove the extraneous ndlp kref get in
lpfc_check_nlp_post_devloss.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 210aa88f9df9..2fa121e50c1c 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -425,7 +425,6 @@ lpfc_check_nlp_post_devloss(struct lpfc_vport *vport,
 {
 	if (test_and_clear_bit(NLP_IN_RECOV_POST_DEV_LOSS, &ndlp->save_flags)) {
 		clear_bit(NLP_DROPPED, &ndlp->nlp_flag);
-		lpfc_nlp_get(ndlp);
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_NODE,
 				 "8438 Devloss timeout reversed on DID x%x "
 				 "refcnt %d ndlp %p flag x%lx "
-- 
2.38.0

