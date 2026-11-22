Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795363520;
	b=KwXZ1qptwnb8tkI0yqJpEgiCL0mqOpVRhDBCotjwTEtytxFOCx/ga9YUzbHbWng/E3gy
	 8LQbJXXPDkEPMci3XDeZ9GJyWPWYodBDZ3hrfpL6Ot15XOPtF7SICPYDv1nQtHUPfw6fw
	 DvyIO/3SjDTJBRQCbOv3a+c3LYsUpIGU1jHH/XHcFmgi3rWHdGWu8oWcbDeL56OIybTom
	 6qgYHXfbqZJFXhe8wPv294xkKdUaEdH9C8qozB+UPdA7ZsIfEIlSRCidzZu21gW8mhNk7
	 nTNN7EAJFMwJVI19xirQP58uxDazfDP8gDP3SfaMWUL7jWSU5bgEArOJniJVQ21YEWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795363520;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=Fjpy/v9DDwCofr6eeX3DIOZaJKkQojAfzwVNo0pgkt4=;
	b=LlJw8XvpPXJNPrKPaVsauf3ZaZZLjwhIxZJJW6vX4bxNFkLxYMrJ86RcO6Dpj3m5jqBK
	 xe7SdmEUnkA1rUMTDjvmCHpy7pXg9UtTVZ+kTvbvc3KOVjoiULkBmWldDBe3kV2FlQPqU
	 wRHZA/HFXkutbBCCD3SKcikixtCkAx4YfsZwKPB85nlzRK7Ym2Rpop4zptUgXHUa3S4ja
	 tMuFrIwyd/5l4sXDOnWvz6k/NAA7Ju0QXOZz1LoVmqyBen9TTaO3ZdWZgSKm7+RdYeQrs
	 tX3bdGDAxxpNPSDQUhoky+LbwdX1NoQU/RGn8lopihZbYKY5GGzYd+8qyU+HcP76wqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dOCFbLhR;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C3A606A33C;
	Sun, 22 Nov 2026 16:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5C3A606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dOCFbLhR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Fj
	py/v9DDwCofr6eeX3DIOZaJKkQojAfzwVNo0pgkt4=; b=dOCFbLhRWEmA3KAW9O
	/XYPsPoPoN1RWf6pNbmc4+Cko5iyvg4zhUPVTSwnQX7pDW0XFBEzDMM2CI+HiFok
	1EQ9OSX3ESn9rv23hsqdntMgB0IcG3VaJw7m1LyT23DWtku/lABacZogOXqhyUBR
	OPUmOXyv8qs7EZJ+HXP9R5/eY=
Received: from user-VMware-Virtual-Platform.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCnPyafEgNrVQpUHg--.41122S2;
	Mon, 23 Nov 2026 00:04:48 +0800 (CST)
From: Ziheng Wei <zihengw03@163.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: 53c700: fix invalid frees in m68k driver remove paths
Date: Mon, 23 Nov 2026 00:04:47 +0800
Message-ID: <20261122160447.519889-1-zihengw03@163.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgCnPyafEgNrVQpUHg--.41122S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCFWkurWfXry5XFyxJr13Jwb_yoW5tw15pF
	Wv93y5Cr4DKF1jgw1xGrWUAFySk3Wxt34jgay8u34S9FWUtryUXF9FgFW5CF95tFWkGanI
	qF4Dtry29FsrXFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jEpBfUUUUU=
X-CM-SenderInfo: p2lkv0ljzqjqqrwthudrp/xtbC7QBImGsDEqCedwAA3O

NCR_700_detect() stores the allocated host parameters in
host->hostdata[0]. The m68k remove paths instead use shost_priv(host),
which returns the address of the pointer slot and causes an interior free.

Free the pointer stored in host->hostdata[0], as the other 53c700 drivers
do.

Found by LLM-assisted static analysis. Cross-compiled for m68k; no
runtime test on the affected hardware.

Fixes: a16efc1cbf0a ("[SCSI] 53c700: Amiga 4000T NCR53c710 SCSI")
Fixes: 8276b58af4dd ("[SCSI] 53c700: m68k BVME6000 NCR53C710 SCSI")
Fixes: 506c7bbcd9bc ("[SCSI] 53c700: m68k MVME16x NCR53C710 SCSI")
Fixes: 45804fbb00ee ("[SCSI] 53c700: Amiga Zorro NCR53c710 SCSI")
Cc: stable@vger.kernel.org
Signed-off-by: Ziheng Wei <zihengw03@163.com>
---
 drivers/scsi/a4000t.c        | 3 ++-
 drivers/scsi/bvme6000_scsi.c | 3 ++-
 drivers/scsi/mvme16x_scsi.c  | 3 ++-
 drivers/scsi/zorro7xx.c      | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index a02638b47..e35df140a 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -97,7 +97,8 @@ static int __init amiga_a4000t_scsi_probe(struct platform_device *pdev)
 static void __exit amiga_a4000t_scsi_remove(struct platform_device *pdev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(pdev);
-	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	scsi_remove_host(host);
diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
index 23301edf1..4054f788d 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -93,7 +93,8 @@ static void
 bvme6000_device_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(dev);
-	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
 	scsi_remove_host(host);
 	NCR_700_release(host);
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index f4db93c13..ba458c1a5 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -106,7 +106,8 @@ static int mvme16x_probe(struct platform_device *dev)
 static void mvme16x_device_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(dev);
-	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
 	/* Disable scsi chip ints */
 	{
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 894756326..6ec60deb7 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -161,7 +161,8 @@ static int zorro7xx_init_one(struct zorro_dev *z,
 static void zorro7xx_remove_one(struct zorro_dev *z)
 {
 	struct Scsi_Host *host = zorro_get_drvdata(z);
-	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
 	scsi_remove_host(host);
 

base-commit: 97d73c8251226cf27cc6656b4c542869bb8c69fa
-- 
2.43.0

