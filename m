Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1734A2417DE
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313141; cv=none; b=quCZ1iWlA4VZVvbuI0XQhkbQOOUvzUh1DRVzvsNopGW4wugs2sgFhznby5AOql9fZhTXedy30TH28ldMBYfvbpAMDQpWLFY7YfsnXT1hSSzzBCYBn7SheHG1qxjeKjowl2FaT6h1aKGW9FDqnSEUxlDIAdd+iCjCPQXLtwAdAEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313141; c=relaxed/simple;
	bh=vxXCd6XEqHsxiBy3+8h4IRX/R6Q8wiV4zrt7I3asWsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UQWq/YwmcSnqotM+lNiNQ76Q6dCX6unTXSzgVsTA+Y+tNEJ9cra7NFF29zXZcWngBFS+170UEiYOzLPYmjfet+ypf7jfrekQDMs6LZkF+z3PYHMhTFL2SFHIZkBzKiWDXnPhWA2zyKoF5v8QhOLp60N+eXIvHpeCG6O5Q63nvt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=ZbuoZ0Om; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="ZbuoZ0Om"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b79af62d36bso357451166b.3
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 12:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765313137; x=1765917937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyMVf8UAKt8ivdpHfCMg44/m+jYF/0j2yoV734Syfkw=;
        b=ZbuoZ0Omb7eufVsHUf1ckFq6DOvnglSMwV8jQlqVSz2jM8sLlXfswXqP/jXI1XnvHY
         zyCPaoSwDNp1MulnRUOm9sqkTehlGO6Yy+KbbK6Yb+lVG0tor4nbHlppCG2Fa+p2qiN1
         MZOg49JqGTdVMfuBe9dA4mXLnmFoCUeG2k77GLK/6AzorUs0+VjF24ubdLxgvYBB+WXO
         IUH3IC/1j8He0BGoHmAcINa5Xrip06VVbK33fjT8jS8VM5g8YF+zl92F2SuAiQLNIjSq
         5dojK221BQTEWUz9NEwvbjctnFNBxPmyaSTn/i+bVmxJnZXE8Wb8xps/ML+SO94mdbXd
         r9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313137; x=1765917937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OyMVf8UAKt8ivdpHfCMg44/m+jYF/0j2yoV734Syfkw=;
        b=sHiS8/kp60nbFfRrDMz1k4+A+F9MozWnohpkGkrYiLtQ5GrQsA8RPRcu4AdkTum3kR
         PY/pMmx8hCwE1y4sAnpnR/8nm82f441yoQQXThKwlbwoWdyHqkkxxAf/ZgKSspiplck2
         nFbz40cKQuVEbGZ7xyuxNwA68PEgI0SMUghn2sAH5GoIb9WT/WNReUk7tagaPHIB/bjL
         LhaTmG3FKxjijumJuFj8zK+z+MN+Ez44ZzhW3ndXQ4feezkffIlZ4ruzq3pJD0g2bzcy
         u2g8AAFzVG1Q6svOW1uJ9JyZsjzmqgiVhHgoZnK06E5nVccGZiwdNraZd/mENGqP5QRv
         OQ9A==
X-Forwarded-Encrypted: i=1; AJvYcCW1x2l1qTBe1isYtH5qQ+zQCXwSacmAY+glZqiMeQwOn2t+IJJ4BO7wQo+mu2Th3QECfPNLg1nCBYrj@vger.kernel.org
X-Gm-Message-State: AOJu0Yz61Luaxi5jql+T20l0Ai5ULuJ1kW3qUWhVfNyQgB3VwpUKqbbL
	di4L5OeuqPLtJjaiTcZXlPFeabbKo6epYV08ReW+S1R2OKnZNlH/tcJdOt9HzLl4zhQ=
X-Gm-Gg: ASbGncs4ZLScTAPPeeS3rMIsYc5gH7qhsnxx5g8tNIY+VJpyLm+bMGEibG51q5R8SY5
	6kVKWy+gOBm/i+Lmi1m6GSNyQ7vbdHJoQtzF1BwWR1kEjtcLcj0n1yhpCaPxBox7zDOt8PdiSEZ
	hu/UFpvD0369J7Hyjx2lxHQ8NmyQtW0u1bAx/Qxu+kwL0tqbjA5ZeiG54U8z+yZTUeCwBO2Oxiw
	OZen97yrtDEmkVZ5cuMIb4RRhjzbbX44Q1kcMGj3yaTbl6N6i5KOu0xOwwaUdZthsEKMyFcvUMJ
	/ambIC5/oW6Dhu7HvV2U9Y5+TcL4qxuE1NqnTWtUa3dTn5WbWvlLGDsDiRmr9ekrG7mIojIXo90
	fx5ciJRUexv009BBKbXfVf9J+fSl8RijbM/t6ivyqYzXSAqpvkePA114KXFwBuVJDCB/2X7wbsO
	7KdPdQHq37Dr8SDGGq
X-Google-Smtp-Source: AGHT+IEtEfoB1rWKj/l+CZHHiONRCsz4m3OxiQOG1IlxHWCyxOo/Vy72zTuE5QOuhyJ6jAt93sOoSw==
X-Received: by 2002:a17:906:d54c:b0:b74:9862:3e36 with SMTP id a640c23a62f3a-b7a24805105mr1261501566b.51.1765313137460;
        Tue, 09 Dec 2025 12:45:37 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b79f4a2f19dsm1514544466b.64.2025.12.09.12.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:45:37 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 3/8] scsi: ch: Convert to scsi bus methods
Date: Tue,  9 Dec 2025 21:45:04 +0100
Message-ID:  <bab94af5f87f67fac8837ee17e06fdc541ca9cbb.1765312062.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1656; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=vxXCd6XEqHsxiBy3+8h4IRX/R6Q8wiV4zrt7I3asWsU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpOIpVXQRXuikXPa58vPVWo34HVrOEFkzPwNTGG 0mflJiI+0KJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaTiKVQAKCRCPgPtYfRL+ TnW0CACghFOZPooxi1cX+MGVw1dOczYqSxs7B/ak33+XnBsvbGSuC7SOpvynkFd7ukx7QnkMc+l vEEqqW0f3Uv14359qLxVK86kQT7+hgFPcMvcu95K8XA+q8mOBGMIXw8y+Mx/QknsZIiJov/F6OW ybf8EDXS7wz8EUyhVjpwBMs0m8Z9bDh66Ir2zhohWDEYlD/eubctHkPS8N81+o92N1Z7PAYGDZW 7cByYZpbiNT/dgxRN+5GBeg3vURMZBpUYInYDf4W7ooxrWce1US4mwVwIKL77SyOFgyZeZ3f5CK +aq7V4qnFKmqSf4mY6ehE8avY+zG1/5YZf8oHhsTuDHVWSso
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi bus got dedicated callbacks for probe, remove and shutdown.
Make use of that. This fixes a runtime warning about the driver needing
to be converted to the bus probe method.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/ch.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index f2b63e4b9b99..91318e110901 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -894,9 +894,9 @@ static long ch_ioctl(struct file *file,
 
 /* ------------------------------------------------------------------------ */
 
-static int ch_probe(struct device *dev)
+static int ch_probe(struct scsi_device *sd)
 {
-	struct scsi_device *sd = to_scsi_device(dev);
+	struct device *dev = &sd->sdev_gendev;
 	struct device *class_dev;
 	int ret;
 	scsi_changer *ch;
@@ -967,8 +967,9 @@ static int ch_probe(struct device *dev)
 	return ret;
 }
 
-static int ch_remove(struct device *dev)
+static void ch_remove(struct scsi_device *sdev)
 {
+	struct device *dev = &sdev->sdev_gendev;
 	scsi_changer *ch = dev_get_drvdata(dev);
 
 	spin_lock(&ch_index_lock);
@@ -979,15 +980,14 @@ static int ch_remove(struct device *dev)
 	device_destroy(&ch_sysfs_class, MKDEV(SCSI_CHANGER_MAJOR, ch->minor));
 	scsi_device_put(ch->device);
 	kref_put(&ch->ref, ch_destroy);
-	return 0;
 }
 
 static struct scsi_driver ch_template = {
-	.gendrv     	= {
+	.probe = ch_probe,
+	.remove = ch_remove,
+	.gendrv = {
 		.name	= "ch",
 		.owner	= THIS_MODULE,
-		.probe  = ch_probe,
-		.remove = ch_remove,
 	},
 };
 
-- 
2.47.3

