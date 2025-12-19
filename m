Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DD62F1FCF
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 09:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136370; cv=none; b=MVajH/gZ6NgeSe8p+WPEzgzpl8MFq1IARxb4tumotzltYHdAQXRZdQ4L9eiZL6QRlhl1SQq280fcX+PNOyc25V1JdYrN1s0pcIbIbrskZbwJ/jWoHT0BCfWwcDVtzGgtDihgi/LCkPB0NNNqCqRkPVHD94+fFRpVi1n6FT7yWPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136370; c=relaxed/simple;
	bh=RuDjD4KpVvIArjTUj0QqTZHVfaEbF5AUSwPJQT89FOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jUHFHVcapKkdTuudyTDqpcvyDGf9It2O8cQHD3YIjsSrPVNQg5o8c70ENmv56t8mqXR7Q0O9aP+2kvCq2cvzfesWMXtI9l+IZwljyNSc3dOw0KFwgtVloEcYuLaD6IrU2FB4RXbkgl50lb6iYXmhOvIU1I9foBZjU8eAG8v0TgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=FBNMm7p8; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="FBNMm7p8"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47bdbc90dcaso10683055e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 01:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1766136364; x=1766741164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLBceqpbrlZX28+y8Kl1K1Ba/Dto5FDGBYW8s5thXwo=;
        b=FBNMm7p8C4yD5tvIqsTn+KDQDcjgBSA6gadb1uyvLw4BbKp6JScQTH4AWMPit6cupX
         GPCB4OAxtj27X3cNQaNE7vAQ+6ZkE7TMPOf0j8jiKodJCWly70GV1Z2KA6n1TjZu5hK+
         oFYshFW3jREj/qA6VPpbgEu657VcGOuXauNvAjWxXVNAf32i6XLXmn11G88hDt1mOzQy
         3AW3ztsTe9XiQfaVvRYMnvX7bzKbPk/VAVmLJH4HEnLLlOSrlNOjeClyC5kD8p4DKM1D
         UhenIUcbdLRUn8r8Y6ZulB2M/aWsCh2pdtKllY+Jp9nSdIxP16HZ3HHWMBQP3QAENK9N
         8LCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136364; x=1766741164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sLBceqpbrlZX28+y8Kl1K1Ba/Dto5FDGBYW8s5thXwo=;
        b=Y2ZMCBjI+c9BNtWs7nh+NRNza0nRidXHHCWBgMWJgQJ1f6/lvkn9ThtuloIdI+NIky
         suoDTGkFi13rBwrWb3Lgtd22sv2PqMfsBTHghbPXXirtCnWXVbPses82SEgnk1cu1b13
         KbO7CpJnPIiCxZlEnlziDI+8PKfVORYm0etnjEzMBBBNhAZjzoZqbGo7pk69pzY3bDxy
         uyTg1uUab4kdVtP89TOcYGqxh2FbhMS8Fs3OSwcGkMajhMGIXNARNS5OgauIoIHEmomk
         tTGvRx7O1ifd/kT+murDCRIiP/gcPRja1Ac39uu7Djwi1y6mpcLKD/lCeeQeaSSCkvUv
         S9XA==
X-Gm-Message-State: AOJu0YyrYm58EQJoKfIrbTetZxFZCW6zH/QX2YHwzJtHn6ziUbExmXQk
	xFF+ZQBqmqxU+8CNmq3vIDKQkz1tdW6gb6BdpXhtJQMFjX78y6Pis8BU/7CNdUpbY7w=
X-Gm-Gg: AY/fxX4HUNsh8ZxitIFCmtXSvBtxA/03P9YKRBmYX+brAQ2OUrHOs8d7e76q9mqZnTq
	FrsGfaVS5mzEA+s+gDWmbNwMBcXpD++Dd7SJE8HRQjwOfyVNJgLp6yWbRR1++255CD0jLgIXMnx
	CHFT7QNdQZK14V5cmqUpaQ56TczzM14oZwRvGTPFB0goYjQWKkvGHCf0xOHpM6eluhzz3iDMv6q
	B4V6hCpxdPWm2l4xp1SMOnUxSTj4suYLg+hxZDW+S5jNIM+Uu5TV0l16GpExNlAS36jZpVlso2m
	cc+2jDrh3NvRvo4/zzqLfLa5fMjhHC7+oEgt+4a9ykwyNgapCOW2bSPbe5H1p86JDY2xPVxykqe
	PJC8w3sAP9oWznJUTZEJCpvf6MB4Bvue2/tntLAn+oYXIpdbd3r9jHyxDtcSe3VCciS0GMDOrRS
	4MePhuBdu3LN0ovaBvgbv9xQyyN+ohvWAaDsZ2abovOy2frML/RGuL1CwRuJI24xfzhjlAo6JJy
	rw=
X-Google-Smtp-Source: AGHT+IHr+XS3ARM+LPVfaNzWjcFOSDW3aCPFhzb3HGlcf24vWyHu1bQC4lk9OPRXW5U+o8F4zzv+0w==
X-Received: by 2002:a05:600c:6388:b0:477:7b16:5f88 with SMTP id 5b1f17b1804b1-47d1953345cmr15568185e9.6.1766136364261;
        Fri, 19 Dec 2025 01:26:04 -0800 (PST)
Received: from localhost (p200300f65f0066087cf387e078e1a5dc.dip0.t-ipconnect.de. [2003:f6:5f00:6608:7cf3:87e0:78e1:a5dc])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47d19362345sm34156485e9.6.2025.12.19.01.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 01:26:03 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH v2 3/8] scsi: ch: Convert to scsi bus methods
Date: Fri, 19 Dec 2025 10:25:32 +0100
Message-ID:  <b36de11cbc32265a52264da5c813dd6e1abd21fd.1766133330.git.u.kleine-koenig@baylibre.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1670; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=RuDjD4KpVvIArjTUj0QqTZHVfaEbF5AUSwPJQT89FOs=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpRRoVeqhYizlT4H8DrZP/jK2De+BbEmwXfJqEg 5dxoqtdF2uJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUUaFQAKCRCPgPtYfRL+ TssdB/91fuFo+vAWUBkytGZOO1ucuReqXfcQBEtY1ZMVDNtK4TLObwmez3OdMOXAnF9DcTB4Mkg nDUyg7cxh5JbNB0CKFm3IHarVLlhrSwyHbj/pV+CcooVG7lo6VlEsunTsxJRCRxYqIr241IWguh SkM2Vvsk4O7bmp6/65X6tJObW2Y9LJuOgnaJSXEyWBpRyTbBQbbdqviyY4IEMI44OgoHeU+cpO+ PiOA4BLMt68tVtI4Rq/W5SRpHzKYv2iSg8xptaLXGh9zqpBH2d1UEN0vGjMbU14eISlI9hyBk6y OibYPzMxUW6Nxlf06Wv1F9C3NJBUGbTlzWW6e1OQfclBWTbg
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi subsystem has implemented dedicated callbacks for probe, remove
and shutdown. Make use of them. This fixes a runtime warning about the
driver needing to be converted to the bus probe method.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/ch.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index f2b63e4b9b99..b6ca23a29ef5 100644
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
+static void ch_remove(struct scsi_device *sd)
 {
+	struct device *dev = &sd->sdev_gendev;
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

