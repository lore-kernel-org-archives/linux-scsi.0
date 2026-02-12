Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CEE25B2F4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929730; cv=none; b=t7E3yEvY9xpgkOcgbKHbYnfh5ri1TS+VlG/y4CC2BQkCSTNr9d5cKbsmMVpS+/0r9pnKImWycHYBqreZfFit0RAx+DAbiL0vkq7qPVQVUQu7zScSm7btBG5McHFRQEuLuFiPQjT552yhKU4PZOj+LV5a0DHr5Hw6mb25ZROprUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929730; c=relaxed/simple;
	bh=7Kgc/w4wDY/Ttdo3DCJpEoDCP3k/dPoTXbuQkJlBZQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=os0wRqEtUJeEB1UvlbHzykr9Z3DIIotrXWIJXcqDYRg4UwVg/wFNMuduIZNxZO00TcCAEeaDpdK4hUBUt9q1PVGwWzFXxGf/BtzeplNLSNGkmMd2MjpwedxPhzi+QjGYuv7NQKD1uJ1rnkkNKXxuDdsVrAGZrnDClN58jy5O3kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BLVgiVVR; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BLVgiVVR"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-506a6cf8242so47731cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929728; x=1771534528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nyy/9C6ynTkn4i3YvEpkYkstf/JmIRfmi0eB9BVQU4=;
        b=BLVgiVVRSmeP+s4ScdQ5GtYr971bf3Ue13FIA9jjr/uBgVNNYanaMPZdidwLKu10wl
         0pDZiDFI2QeZ6CDcIypVdlV2Lg+5JPwm8ouKYWjiqgHMOeNUwxIZ4DxXAf2DywBfb4jO
         b+xcZnFffWmNs1oahjohtvgkvswYrEGlJ1IFxfnv+oS0Y+FW6AEIPWLdwtTUKU6XKHQ8
         048SmwLf/rqsJz3fayONv+xJZ9n/8M3bCKVlh9hjr3YYtma61SQYUkJJ1fPz5pz9QU4w
         bdQjvkaQ73IOVsLRUgS5cGH4RkNK2wPCprRRRIbaUPpZW1n7zfRahIBok8akL5iNNtie
         P2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929728; x=1771534528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5nyy/9C6ynTkn4i3YvEpkYkstf/JmIRfmi0eB9BVQU4=;
        b=pavuo4TlqqnqZqIgUyHsVl2mRwFNwY5AWUnJ51NTcESXBGDu0qWFxo+TYhZVAiEnxC
         rdGDuIOQx005cGCcHAg4pDtHsKM9BOElTu6OWW5HjUXw4nBIucJkePf/KAtyx3yFRRDc
         aA8xkk0769ZUtgYb1ptZp5ktnVC+JTzL3U06JbL46BlRvCadiciXteexUlyUXTCE3KNT
         Uci4NE2+27iMGAT6iPqYTtIpEPu5OSoigxPnNU1+e2bMzG4xpHdDzMo9DlRX08cTL9fd
         YodgrX42XJTtxwYAKa0vZ8c9lvzP/U6kcKYQqLyrk9V5qiq0PNXvIRs2apqhRptZBk0E
         UxUQ==
X-Gm-Message-State: AOJu0YwPn2JodpcDOrbdEV6yPH+STPIEqQfrW9ITscjKgDQ6IC0ZwT3v
	9CO40YrOhcYmBBcikxtxRoJmF+9VLeSHgbagKwmMvpNylnWBMCyUm9LDZdJIGPfG
X-Gm-Gg: AZuq6aJrqMcLhZipzheXr52CBK2V9zqP7LxELwIcOSdHOVHSOYy4i6oMAC3OvA9fuFl
	2DFtQUyrstj7OzMnBItOSgO05C+wMKW14q3pzacRwpA8dBtQRnUTuxoQiclxALVC6IlZNL+1VqC
	c2ANs338wOdasfMKIr5WPBOjuulX5xPDylrDwG5EkfVJRAeHu2pZvIV18eKtDSxTV7VK5G3+LdX
	JfY3c3PyjOPlCacYKKOYHTpd0pJVNMFTEJ3130dKe1T7lzdhyh8y9zITwFfJ3QTfFRfZ0hkNxrN
	qAFX0VQphFAPxlNEgv2HFjAEwG7+AQC4zEFQEV0frDcu2OQDzkTqgq9KDyiOtSe06AdYQRFjLst
	PsjpNEirmnoUtfU4n9KJOmvd/xVlIz0VxkE+Sk6xY0kTWHZK//RSyNfDCKbfWbmvVvoZMArJN+u
	uM0jhYBwymDkb44Bra/VyJ0Ervx+AIX3v6VzjH72ro3tNj4Nf2kAkYngn4umAjvt4QKMHBj0zFh
	Vytlz5O/8M=
X-Received: by 2002:ac8:5f0d:0:b0:506:a51d:93ef with SMTP id d75a77b69052e-506a680f07cmr843471cf.39.1770929728378;
        Thu, 12 Feb 2026 12:55:28 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:28 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/13] lpfc: Update log message when ndlp kref get is unsuccessful
Date: Thu, 12 Feb 2026 13:29:56 -0800
Message-Id: <20260212213008.149873-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If kref_get_unless_zero on ndlp->kref is unsuccessful, then there's no
point to log kref_read(&ndlp->kref) because it will of course be zero.  In
such cases, ndlp->vport would also be an invalid pointer.  Thus, use
pr_info instead of lpfc_printf_vlog to log when a kref get is attempted on
an ndlp with a zero kref.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 1aeebdc08073..eb1ad45dad4b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -6601,11 +6601,6 @@ lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 	unsigned long flags;
 
 	if (ndlp) {
-		lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_NODE,
-			"node get:        did:x%x flg:x%lx refcnt:x%x",
-			ndlp->nlp_DID, ndlp->nlp_flag,
-			kref_read(&ndlp->kref));
-
 		/* The check of ndlp usage to prevent incrementing the
 		 * ndlp reference count that is in the process of being
 		 * released.
@@ -6613,9 +6608,8 @@ lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 		spin_lock_irqsave(&ndlp->lock, flags);
 		if (!kref_get_unless_zero(&ndlp->kref)) {
 			spin_unlock_irqrestore(&ndlp->lock, flags);
-			lpfc_printf_vlog(ndlp->vport, KERN_WARNING, LOG_NODE,
-				"0276 %s: ndlp:x%px refcnt:%d\n",
-				__func__, (void *)ndlp, kref_read(&ndlp->kref));
+			pr_info("0276 %s: NDLP x%px has zero reference count. "
+				"Exiting\n", __func__, ndlp);
 			return NULL;
 		}
 		spin_unlock_irqrestore(&ndlp->lock, flags);
-- 
2.38.0

