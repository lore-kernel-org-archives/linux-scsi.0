Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64413DBA0
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 09:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136371; cv=none; b=ZfwxUoUIRHaCUYDOuY//LAj0wYxYL809+/WMpVUVL5Q6z2thXOBx/NCjoGy5+pjqgOtB38GiYE8fiRX7NAXtThrZpgliNtO25I6D2nYhQwnT7Ef6sMG7xNHIn69g06zSNDEV0ESIw8zsabES2X/g3E2m9bICrmRRlES5ikhfYG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136371; c=relaxed/simple;
	bh=8o6RvsycgrEG2C58hsgRkCQP649iNhfo19JADTZHXiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oI3ubXKUMvTJDBiNcPJX6tAScC9VGT0AOBPcJZ9FQJp06h2hqsYuOy8hS0B38W+FQYTbsbD3n5a3B6JIQUp7eY+FQ0YIaouRFdg64PUGhQUoqcI3t+5ciJbDde7qjk2Bad8FYiKJGKV56idgBk2kyYdgCLg51rIJD7U9pbTmC+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=raFdZdd8; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="raFdZdd8"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42e2d52c24dso670348f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 01:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1766136366; x=1766741166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3A+bIjXC/cxKbYvyAFD28qNRTnMBYDdZKzUujC2/OfU=;
        b=raFdZdd8Utf++o6bvG83eBKYQ23plZFBGsJ0hdFjRpUNfsLZErF+yb6hSh1SJzMbSe
         xfYWzLGrh8zMhdd/KNtalzdzmpygo0E0KNO0DiDylXllNX+2ctsfMeXjlVQwFLuvs50z
         /0+kenIXAjX38x9Lv0bqqoI0a7b6yJWsAdV0V/iRO3kb/fUnOubOtYq23p/6xU9M0L7F
         mV0kT5+QXCHwcUyVleQpNE+ROwS1nrY+mVlWWFCRy2vpW01WcV732D4tMCJGdrQNwXQ9
         mTR9LtbQxeOvNqDkmT2vkVm2G01bThx/9oKSWJPUPUIwTR8HlNkxcj4xLiUaqaepAgYw
         y7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136366; x=1766741166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3A+bIjXC/cxKbYvyAFD28qNRTnMBYDdZKzUujC2/OfU=;
        b=lt/5nKI2haWu9g1HglPzr//btLJl17S8cMX1F3JyHD/8ws0/VXKl8WxC8JtJd+QpIi
         wEDmrsZEsXqBK1wfNH9qv4o3Myy3XOz5oSeCsSKtInMKWggtNx+5jXn/mb9kn/rLyhvx
         LULCEg8vm4QCeNCDQLnqHdTDa9hRcVllft4j/AqN9j80x8v00BHODQuTBzVm6cgyKK8m
         BltgKWq/pbFZKtpuuzEPpjgF+OKh1SlO0V2w3UzLMvkN/e+1vOF1kSx8FKBHvrokmhEm
         g5vVPI0SmuKLzhr0HcLVGf5THnMhpv5saHXjo6tNP9LuNrOIdRkm9047HXWLV2XH/6OI
         cayQ==
X-Gm-Message-State: AOJu0YxBDuQ56F/bLCOALacneQE2WwYGuBT0vR0reTx4TZ+vjqDCKgo+
	7juKTGW/vaBTxsX9JqY/wQaEXdSZmbZWLhP3gux7j3ghgF+w6+m2e2t4zeME771QFL4=
X-Gm-Gg: AY/fxX49DQ8Y8sMR/VnFzt+4PFULlYmMDXSz85K3mBUtLpQkKr8ksuRuD77p2066mRl
	QUfJbqrqB/ZXUY2v2T0OIwqVaUg54ZyIJb3Id6Yd9LTw1HyPYy3d5KopgeGzN556o+zzXcQVpUg
	hT1n3fIklyyhPL73H//YlWiMJUgrWX+Me6JuoFQiEMjD3klgnuzSo085dfzWz9MpNCnuvVhIR/B
	jCKu7wy9orrifle22JeFRvSDIogaBQM1MPb3Qu+LoF+yJ19Wgmb8MaQv8Cg3mZRgNxVoez1xreG
	aO7mpPP9zPXDF796Ud0v0gYOReN6EuV9xfPBp2IkYsxWKDs0c3sAJHFlqONDcQtpcXLVki9nERL
	pYHhHQE+1NSqrQX7BJuLRVJsA+WVwhxVmOjIllEG5rhhD20EgOkQevpPT9qYO9A13DoRYmlQAKs
	E4b4DWKG/TxWkWTEBDV//B+H6BMXjgvrNHCbVSkKsitoXxVPAAJ4L6SoutUersBZIVIQTCXDYle
	fM=
X-Google-Smtp-Source: AGHT+IG31JUsVHZzpF05JlVNd5Jv0UZfUD1oqFVEBJv4vd/d75LNOr/rrFjmztB0zyY9Avzl5ndzfw==
X-Received: by 2002:a05:6000:4308:b0:431:35a:4aa3 with SMTP id ffacd0b85a97d-4324e4c8ef3mr2474471f8f.18.1766136366365;
        Fri, 19 Dec 2025 01:26:06 -0800 (PST)
Received: from localhost (p200300f65f0066087cf387e078e1a5dc.dip0.t-ipconnect.de. [2003:f6:5f00:6608:7cf3:87e0:78e1:a5dc])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4324ea225fcsm4056293f8f.16.2025.12.19.01.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 01:26:06 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH v2 5/8] scsi: ses: Convert to scsi bus methods
Date: Fri, 19 Dec 2025 10:25:34 +0100
Message-ID:  <7124bf21c02a116bca13940e40e97373fd776590.1766133330.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
References: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1531; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=8o6RvsycgrEG2C58hsgRkCQP649iNhfo19JADTZHXiA=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpRRoatQqP4O+3bFCPRiH0MiZTASyzXC+BVxWjL ucEGFk54TiJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUUaGgAKCRCPgPtYfRL+ TrJaB/9AJS9XNOdZ2x+/zF+hytVbj756/QTLf33U+/31j7Iw0PgPr83bMNvSvlP/fkRIIWcy6JO 5dzwdlbKIailsc8k9YZHcobwntj4rSmrG1h34+pPoFcH31zljBpDj1iBczYIfRO2/PgLOJNLC4u jU144v4hHWVBzq3zaoceNNms04E2j8/jkKlTVypBcp9r14SBlaX59/vHBf5XzP4Acqq1CZ0AqFy jMv4AJ4SUP+8x8HavQCfBs0C+Ij6j2FTWxIiiIV7E3zvBbi5NuyfYI06/JMR9W/B/8IlfqPeH4Y +b3Ow2NE28pttRnmm+wx/YIj+kAHHGU71bFAtJZtFOGgscKk
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi subsystem has implemented dedicated callbacks for probe, remove
and shutdown. Make use of them. This fixes a runtime warning about the
driver needing to be converted to the bus probe method.

There is no need for an empty remove callback, no remove callback has
the same semantics. So instead of converting the remove callback, drop
it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/ses.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index f8f5164f3de2..789b170da652 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -42,9 +42,8 @@ static bool ses_page2_supported(struct enclosure_device *edev)
 	return (ses_dev->page2 != NULL);
 }
 
-static int ses_probe(struct device *dev)
+static int ses_probe(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
 	int err = -ENODEV;
 
 	if (sdev->type != TYPE_ENCLOSURE)
@@ -847,11 +846,6 @@ static int ses_intf_add(struct device *cdev)
 	return err;
 }
 
-static int ses_remove(struct device *dev)
-{
-	return 0;
-}
-
 static void ses_intf_remove_component(struct scsi_device *sdev)
 {
 	struct enclosure_device *edev, *prev = NULL;
@@ -906,10 +900,9 @@ static struct class_interface ses_interface = {
 };
 
 static struct scsi_driver ses_template = {
+	.probe = ses_probe,
 	.gendrv = {
 		.name		= "ses",
-		.probe		= ses_probe,
-		.remove		= ses_remove,
 	},
 };
 
-- 
2.47.3

