Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0913436D
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660507; cv=none; b=YNj/CV7cHqSrtxHTKBhg10dE7HIDkP080FDZURohQ+2slpywciMrEaRspKYCUV3YXCcnxHJ4hWbIiNzjFPWpj2anAgLnte3BBMOAV7fyO8a8PVWyxGnA66HKZ5f/SnRROYpBEcGL2dIlNrewW/WGs1x6FJqjAt7B3vWgya8ndqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660507; c=relaxed/simple;
	bh=QZC3p6OxMgCqOSF4VYGbC6vOX6EakA87eYj4cdy5CVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TQv8hfWsU+oyH0m+pKsqTBEbWVoWuV+D40CFGxpAzuK201fKjnxHZelgCVUru7ZXs7ZK3EHphnrjI3o2LnaQimKm9+jy9ORUyaO6sfYNaTR16+bUfJYuKwgDIbwtMmYZ49DMpqPgMEp7YOHA57Uh4Y5L5NTH3tnjPV6wZsqLXXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GgA2mEj5; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GgA2mEj5"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-68c3fbc48e0so4392446d6.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660505; x=1707265305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSnj8+K8t2zMtsT9CuwsNJZ/DNaHwaVFLBOycPKEqAI=;
        b=GgA2mEj5VsTJMcx4C6mE3mB4ZD/3yRZdNB1vPA/6TBCUoGTJlAcEQPbcmjjoMLR3A+
         OVyU8Y1BcU/2uxt6jUISfXgCRunsvP7Z6aTtD8B34OKY1rFO67fYLErFpREbRK4eLgBQ
         +a+bhRvRKQWEU3o6lmL+lsKyQg6o1+lrxOgUWpCnykjE1gkQ7kKFj/WXCPydIOHNmVE4
         KT2qVc9LdC4uK37a2xrXJ63YRtbfIN1ElJRY0mHziq4lBYXQupDVYuvGdsE9ZLHBx2xl
         OB1dKOpv+yvmeR1YTqf2RhqXKpJQX5gBqoGnuD1KZvzhNBN6E9YGoaxRMMDXZsHCcxgt
         HnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660505; x=1707265305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSnj8+K8t2zMtsT9CuwsNJZ/DNaHwaVFLBOycPKEqAI=;
        b=lnWhABj81TXc92nj3dAS5GoawMk+cC5iv2+X2vON8wqEZAYHvg+oxnmKM1EN0la93M
         JsHXQ3uNK50g9ErZLzFzVZFLhnh7tbqg+w6T/rdWYpyRNckKKcMeibywBIGwWOeVAM06
         xPlcaQxTTyLYGo6+zvTXNcSDDdQDTMEXqefoLAA6NyumJJYLBTG25afWrN699G8pIcYy
         QKlQb/+d5MQ3qWUGt7ScNtB+1pl94I+rgMCdBY34vuH4ZiN9pWq0ra9LADZnRakDuo4g
         5jGzriJHiTP9WZE71b5ugxpkdkB/BGup8Jf9C9duFPRkGUgx2gi4wBUZ8OIP0x5oxhxs
         S3ZA==
X-Gm-Message-State: AOJu0YyTAO93w9sDTGE74VPS9ApZSCkk1PjKMA9fr66IidokRPtIguZ0
	qd6CjelYhZTLtEQ9qQMA6sOIicv6k7D6hyPeH26lxfrzK1JFJhhJRHHYTKd8
X-Google-Smtp-Source: AGHT+IFkqWBGQuGyOcl9guWpR+uY844AloaDOy9ilNf08Wz5yvkd0Fjz/oFXmLxrSxdzDifQTZbvDA==
X-Received: by 2002:a05:6214:c62:b0:68c:5c71:e5fc with SMTP id t2-20020a0562140c6200b0068c5c71e5fcmr150620qvj.5.1706660504742;
        Tue, 30 Jan 2024 16:21:44 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:44 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/17] lpfc: Use sg_dma_len API to get struct scatterlist's length
Date: Tue, 30 Jan 2024 16:35:35 -0800
Message-Id: <20240131003549.147784-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sg_dma_len API should be used to retrieve a scatterlist's length
instead of directly accessing scatterlist->length.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d26941b131fd..07e941da8a16 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2728,14 +2728,14 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		sgde = scsi_sglist(cmd);
 		blksize = scsi_prot_interval(cmd);
 		data_src = (uint8_t *)sg_virt(sgde);
-		data_len = sgde->length;
+		data_len = sg_dma_len(sgde);
 		if ((data_len & (blksize - 1)) == 0)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
 		start_ref_tag = scsi_prot_ref_tag(cmd);
 		start_app_tag = src->app_tag;
-		len = sgpe->length;
+		len = sg_dma_len(sgpe);
 		while (src && protsegcnt) {
 			while (len) {
 
@@ -2800,7 +2800,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 						goto out;
 
 					data_src = (uint8_t *)sg_virt(sgde);
-					data_len = sgde->length;
+					data_len = sg_dma_len(sgde);
 					if ((data_len & (blksize - 1)) == 0)
 						chk_guard = 1;
 				}
@@ -2810,7 +2810,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			sgpe = sg_next(sgpe);
 			if (sgpe) {
 				src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-				len = sgpe->length;
+				len = sg_dma_len(sgpe);
 			} else {
 				src = NULL;
 			}
-- 
2.38.0

