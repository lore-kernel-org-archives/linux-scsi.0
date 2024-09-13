Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E7F57CBB;
	Fri, 13 Sep 2024 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726246894; cv=none; b=DWNLbQvbaxUoI0GsP3aTERpIwQX0Qt8gOtGG1heOIEh0eakyzEeMrvaJFXaMLkCfwLXOB0xjiuVLrxyUHbCL9w5L0mUz7FlU5md2Ah2BMYv0D/cDY6nYKfkGgXQ7yX9lAVq3w7s50r4lqZ1/Ligix7a5XAbxibeycYpWSbygTDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726246894; c=relaxed/simple;
	bh=qDtC1y7ZBxJ9wlYLMS6bSqD52Tijs/FV2RCHH1h3K8w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iK+yVJpvVNtvNd5mI8NEJSCeoHkShBQKzPHZrQSQ/kK6JymJ6CMqWmrikKztF29Sbb4evlK+0Y4piXEGaMpHGS8MYLR3vVopgOVIs6h286wKlvIymEpyyVdNqqqw+sLsuUKumMDR+CyOTFRbEfuKhJAuV1NG8ilYHyuVa9cyKhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=JXo5eKd8; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="JXo5eKd8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=xh6orQbvPl5FfKLfh/aG37BBQRsqWm3ZnNvZp2gsyIA=; b=JXo5eKd8wHDMS7Sx
	D/ftgTYfCjAoD890WSd4hPrb2oSL1ZBQrQMKz4q1aNihjrzSrlKLOCim3j1fASnhfMjra5TCD+aEl
	vSx/R/wbb4/7p3V9AT/EzhRXReHzLMmEE8BSE17ebFVIs8QvNxDN6sj+/rkFpiJ+pPZCHbNwvdfQs
	778TIuRBSZlGFb/z6QCYas8/TLms6GiIqi78qok8JOnFTZ1syALvbsnF/wJprXpQmtgv+c9zJIKUn
	xogDSIHYtREv7U5DXqzSJX+anC77j+RyyOYHUYVFyA/2+1gmYsCK641owlVNtod8kuhCnAwRzx2q/
	zSp80kqEs1bZ1H7ICA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sp9fe-005dOb-2I;
	Fri, 13 Sep 2024 17:01:22 +0000
From: linux@treblig.org
To: hare@suse.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: aic7xxx: Remove unused aic7770_find_device
Date: Fri, 13 Sep 2024 18:01:16 +0100
Message-ID: <20240913170116.250996-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

'aic7770_find_device' has been unused since 2005's
  commit dedd83108105 ("[SCSI] aic7xxx: remove Linux 2.4 ifdefs")

Remove it and the associated constant.
(Whether anyone still has one of these cards in use is another question,
I've just build tested this).

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/aic7xxx/aic7770.c | 15 ---------------
 drivers/scsi/aic7xxx/aic7xxx.h |  2 --
 2 files changed, 17 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7770.c b/drivers/scsi/aic7xxx/aic7770.c
index 176704b24e6a..f1ce02cd569e 100644
--- a/drivers/scsi/aic7xxx/aic7770.c
+++ b/drivers/scsi/aic7xxx/aic7770.c
@@ -99,21 +99,6 @@ struct aic7770_identity aic7770_ident_table[] =
 		ahc_aic7770_EISA_setup
 	}
 };
-const int ahc_num_aic7770_devs = ARRAY_SIZE(aic7770_ident_table);
-
-struct aic7770_identity *
-aic7770_find_device(uint32_t id)
-{
-	struct	aic7770_identity *entry;
-	int	i;
-
-	for (i = 0; i < ahc_num_aic7770_devs; i++) {
-		entry = &aic7770_ident_table[i];
-		if (entry->full_id == (id & entry->id_mask))
-			return (entry);
-	}
-	return (NULL);
-}
 
 int
 aic7770_config(struct ahc_softc *ahc, struct aic7770_identity *entry, u_int io)
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 9bc755a0a2d3..20857c213c72 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -1119,7 +1119,6 @@ struct aic7770_identity {
 	ahc_device_setup_t	*setup;
 };
 extern struct aic7770_identity aic7770_ident_table[];
-extern const int ahc_num_aic7770_devs;
 
 #define AHC_EISA_SLOT_OFFSET	0xc00
 #define AHC_EISA_IOSIZE		0x100
@@ -1135,7 +1134,6 @@ int			 ahc_pci_test_register_access(struct ahc_softc *);
 void __maybe_unused	 ahc_pci_resume(struct ahc_softc *ahc);
 
 /*************************** EISA/VL Front End ********************************/
-struct aic7770_identity *aic7770_find_device(uint32_t);
 int			 aic7770_config(struct ahc_softc *ahc,
 					struct aic7770_identity *,
 					u_int port);
-- 
2.46.0

