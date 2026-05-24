Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B684D2F872
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 09:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779613660; cv=none; b=h7QK5ytuUgDxE/QSfv5sa8mMyMvC4qoJPxUvMa77zEsJrWBMus4rb8uha78BDUvfe0YGcaV2pWF2B1WeJLm3ZIcOSqecTUtfUDM/AcVdH27jRV4HDItdnTRcgG5Kt9PTNS74KjxYGtthg956FXf4Br73KxUep96xbHmUfPhOXM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779613660; c=relaxed/simple;
	bh=x70/6ktCIw9+n7HuZfNXmrYhvu/GUGiM+jVCJzW9XM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YECJsq4JrR381bgbLSolzco0K5wm7d8NVKqQdfN5L6MoUOX0YhIgONL2M6uewosOe2hMtX/ZNzTiDtoLXhU1TGs4aNDDvg5hku4A8QvB9MPI8Rh5KAAW5kwhqKZf62bU2lh4inc9ZH+phvGL6/2mavSFe1l6cid0mWSiTroUOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GJbWBH6p; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJbWBH6p"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4891c569cb1so8103895e9.2
        for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 02:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779613657; x=1780218457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZL3u+lDWbKPo94X92eLqSMUwqKf0ZdtkDoG9Wc5Jiik=;
        b=GJbWBH6pxhACESsVyaxgORgL8OpNzucbQj6+sOqTLA+QTmp05FKFDlAWSBb6UwzVv0
         uhYVJoCX0CAWY+DNh31yFzUC9lwpIQVcUzlJZgpN8Azj1FtDrqypvzEYi6/RI5zjSMl1
         8Yntzy7xAJRnGiKm0ex1GtK8U4WD/praSG/0NMccwnStWXHRjpcS3Sjx2X6L1RsrTsaA
         yVQYF9fOy5VdDpfm6dCYx1EkYtE2Kok+/Mcl+GSeGHx3z0x3tX9TfD3eaLdsmZw+eyuZ
         nyR1xFLbrlLSeYQEXUCo9SOX7GQ4IonM5oNqpluohcVrS+UuV+kxQxGiwvBj/xpXl3SV
         y/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779613657; x=1780218457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZL3u+lDWbKPo94X92eLqSMUwqKf0ZdtkDoG9Wc5Jiik=;
        b=foYB+Q1sIQwmuFpsMlGc07DeMteOV91mjzxbZOpKe0KRZh+ZhUJq8p7wIadPmj9ux9
         9aN5/JuylZlKG9ZdQFXL+tnJqBt5f/Z4MncCwBAAbmpK20TXYJj6agxTST6gxHwr6f+Y
         2fqlGxPjGUgBHOs76zUnrop7il7k6T0RhS1hp9uAiWDV7rClDvxaQLx3lGbc8p0gwh3p
         HNqSgriqNBRYN5gCufsg8y+T0ijq5IbyrZbfJdzYOFpZLFS70EUlc8xEcW/hY1k3hkqu
         1Y+Sr68KlopPsuus3SpiJWtk4Ei7CcqhSX+/Bbo7w+zLG40UN+HVdyS/4WYIU3ZDFjwg
         v9SQ==
X-Forwarded-Encrypted: i=1; AFNElJ9XfkB1i2maCWMAwEHgpx7EHsANHvt+dgq2jGKrJqK8gs8OAlwc2Mlm54pPyJgvFBLqDY9SR+EmoonU@vger.kernel.org
X-Gm-Message-State: AOJu0YyflhvtLPhxlWvgpg4pwbs6tf48IMsyhNzT9NHQp0dyNWWqTLCN
	+htExtK2CwkHyYcKOyemoANCiAIBllzEB2eTrOTQnGbZa3uwZEagvL4=
X-Gm-Gg: Acq92OGb1RD/BI2sO8cvLaysSkAVN95VGUMX/mOGlzR+2Znbua5v7uNhvO4LuOcQzat
	ASoByh0xiGtsLo6aQ+2280TWEXtU56BJ6XhrPt313u1mLlzZTn3iM6NijrFaRNqm2AdMv7yVUDr
	vBk/QfNdBxg/LILqnDlQkszTWlXIVa/e2yC7TxPtw/iZz+opS3CC7ckh1OQRul4Gjw6oAoHwNZN
	cEjp7iCEfL0GuP3svpDxwxv6ALhwtkwRAo3/gNDMFAXOJhgqduMoI81ScVtaKxZGyFA5srcgY8E
	6edJwTV46JXirJozDGsQ6kjkbrNs+SWZ75z8cF3Oscu47buWO9xynip89VBLff+LN+md4+oDCgc
	IQvooeZYus2o3VOk9R3Y2gg737WhrVe05qLtCPzJ5LQfz+tj0NTVEFxaVuHdFm38cmCknnlJ6Ht
	qLII8epWc5iN3kY9woMsVP6tm8XpDsCHO18coKEK0vyfiErakKwiAYgVi5fLuf
X-Received: by 2002:a05:600c:4513:b0:490:6238:c5d0 with SMTP id 5b1f17b1804b1-4906238c6a3mr3122215e9.1.1779613656852;
        Sun, 24 May 2026 02:07:36 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904179826dsm76991305e9.2.2026.05.24.02.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 02:07:36 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Anthony Cheung <anthony.cheung@hpe.com>,
	Takahiro Yasui <takahiro.yasui@hitachivantara.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH RESEND] scsi: scsi_devinfo: blacklist HPE/DISK-SUBSYSTEM
Date: Sun, 24 May 2026 11:07:34 +0200
Message-ID: <20260524090735.152449-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

DISK-SUBSYSTEM is a special model name returned by "OPEN-" arrays when LUs
are not installed. This requires BLIST_REPORTLUN2 to prevent issues during
device scanning.
Full info: https://lore.kernel.org/linux-scsi/4AF9D98B.9030605@redhat.com

While this entry was originally covered by:
{"HP", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},

After commit b8018b973c7c (scsi: scsi_devinfo: fixup string compare), vendor
string matching must be exact. Devices reporting the vendor as "HPE" are no
longer matched by the "HP" entry.

Add an explicit entry for "HPE" to restore the intended scanning behavior
for these devices.

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Anthony Cheung <anthony.cheung@hpe.com>
Cc: Takahiro Yasui <takahiro.yasui@hitachivantara.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 7a99983854f9..4de9b9dd1833 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -183,6 +183,7 @@ static struct {
 	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
 	{"HP", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
 	{"HPE", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
+	{"HPE", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2076", NULL, BLIST_NO_VPD_SIZE},
-- 
2.54.0

