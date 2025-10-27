Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA9D32F744
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607464; cv=none; b=AvvOLKpWB0hghWdc2Bp0oYnqNjjpvPgW39kCxBA+pVZqT/JofWr0DChw3mI720D2UZokQVcazJrPFCICS9q/XHNJgzUImOuPcy2k6JPZvBGTotVdeMqWjNcDDt5S57XCFjk2VZ+3nXqcux/CJlxRrbd+4/UIwsjfkqjMoNC+4qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607464; c=relaxed/simple;
	bh=r92EaJSgsoTYjNbWcHxty0ZHCy0mOyKPDWV2lgYi2AU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vD8IhGKxqCMecwB6uUonSgQ7TXXG21EwA0KOvf5X7Mhb4dWGwBk73+4xNaMYxrfbxfGEC51nh3Ti1grwRHVhYt1TvTzlKm4Cnmp/4Fk5uq7/0InthiplwLJ8hKWpwhhIMSI/wg6+ci/q8zRm4tArglS93g9gAPUuuKuxBMY2bIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CscJywBI; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CscJywBI"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b6cf1a95273so3864031a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607462; x=1762212262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/S9S8C5NSJXmgIZATJshSjNhuM7rqPIQ+iWRpHzB84=;
        b=CscJywBIj5vWo0hJcbwixrfLIniq7WiWYubUm66h0XLYh/zgj1troLQ3Fitd5dEAUA
         BrMF/zIQgR0ot5LxPD/g9HmdmOpoYHWSKHlz+7isPxcC1DfF9cz6i3KhhTlrB5tG/vy4
         D0Nzs3piGih2wT/JCE3rrrhKBFyUBujdMrJlXLW60wEyW4dY/W5TfqfGdRkLa3eWUvQA
         mf4mX3IRZza67fzx0aUD0hz6QHt8JPrdMgRaBayatUMyyJEOGVKfXKURjcwfQVnHKWkX
         FRa3Ml5My4ndBuy9WEtzXfKvkC5SgS4vofSfkfoFHekHB2rEOZfki5o44F2RsqBpAkUD
         h/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607462; x=1762212262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g/S9S8C5NSJXmgIZATJshSjNhuM7rqPIQ+iWRpHzB84=;
        b=jfP87gYvUcMpvZ7tHXMEyzLUtzDS36XXoVihEuL27gQ11AkO7f0lsLWCqLBYlisZVH
         bJ868eAkveIgq4EZc6m+oj5ENREGKQ6uQ6JQECO5C1JZZzlOM7d/gsf2k+K+eeapVWdB
         ztDX1dbZMlqW4gewIJR1xKrIOHBG7RKo5Gg/8AvnbyCxn2HX8B1SUySYjGN3SPYKtAAx
         xFaZ0WdMaeCsGh8DRpCmdzbTq2XjJ6nol/GzPSwRwRi3NXtWk9jXva3648LZ/PZRazYi
         2Op79eYTtfueRTGHSF0yRzORhtNn8FrL0m8rs09cn0QvUWNYPPJIM/zt0EV9h0mVJtWZ
         RWFw==
X-Gm-Message-State: AOJu0Yz99kQ3dK3kBh8r8k9zaDx3wAxEp6Pbv/FqTtZwE2l0rKUYEbuN
	qGoYmT/roJQhQjpGbFdkhzciOz98515PEQcZpGLDPJCCKIP26ow14OVcUTvfuw==
X-Gm-Gg: ASbGncu9+8YO7jj2Grt4IuLJjo1GbECQUt6V4bD10Ik3H9/cYJNShKSiBCEIn7SlMrW
	DUSnsoOuLuDrK5fVozlB36LWshBkNU9cCKieZ8ZCxRwWCwhDg55GGy5kbDHKKT8ivnsgkLdGSGR
	nPmR/o8883vizGn3cqCmvvJAwkK2doRcC+Rm4g2f719kvIZVNJpAwVuciFKpnFwSu9tXwTuyAIb
	YmNAiyIWtatoZXrLnSvihQEbMAxYLQV2+fSqza9sqFavOL8H7BeZUguR+Q15V0Hop2b3J2Xwh2i
	dF8Wi0X0jQLZ2EtzlR7EKPdk5+EzUSBGQouHDPmFibQo6pFTPMakgjna+Da4BqfnQqEMfJxrnAP
	R2MmP0KbQ2TgXB47ntzP/Hc2EbgI7L4SIXHnMazO+VpUgm+KmuDH5dARaoW1zfIKb8yTxPQpvNu
	5+c71ZoZK+xbVIVV7HG4OJs11T3rJP37bjIEYAodiCrbKOwhvRcffGYFZUNqj7
X-Google-Smtp-Source: AGHT+IF8l7ZMx4ugNS59dhM4mRyOc0PzGusHMQNVVlzN/D7pt6+uOYWPe0sOOdzTW9ZeUVdpSDsZYg==
X-Received: by 2002:a17:903:124e:b0:249:1234:9f7c with SMTP id d9443c01a7336-294cb53c9a5mr14526665ad.60.1761607461617;
        Mon, 27 Oct 2025 16:24:21 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:21 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/11] lpfc: Allow support for BB credit recovery in point-to-point topology
Date: Mon, 27 Oct 2025 16:54:43 -0700
Message-Id: <20251027235446.77200-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251027235446.77200-1-justintee8345@gmail.com>
References: <20251027235446.77200-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, BB credit recovery is excluded to fabric topology mode.  This
patch allows setting of BB_SC_N in PLOGIs and PLOGI_ACCs when in
point-to-point mode so that BB credit recovery can operate in
point-to-point topology as well.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0045c1e29619..b066ba83ce87 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2279,7 +2279,8 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 
 	sp->cmn.valid_vendor_ver_level = 0;
 	memset(sp->un.vendorVersion, 0, sizeof(sp->un.vendorVersion));
-	sp->cmn.bbRcvSizeMsb &= 0xF;
+	if (!test_bit(FC_PT2PT, &vport->fc_flag))
+		sp->cmn.bbRcvSizeMsb &= 0xF;
 
 	/* Check if the destination port supports VMID */
 	ndlp->vmid_support = 0;
@@ -5670,7 +5671,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			sp->cmn.valid_vendor_ver_level = 0;
 			memset(sp->un.vendorVersion, 0,
 			       sizeof(sp->un.vendorVersion));
-			sp->cmn.bbRcvSizeMsb &= 0xF;
+			if (!test_bit(FC_PT2PT, &vport->fc_flag))
+				sp->cmn.bbRcvSizeMsb &= 0xF;
 
 			/* If our firmware supports this feature, convey that
 			 * info to the target using the vendor specific field.
-- 
2.38.0

