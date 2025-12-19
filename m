Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2C22EFDBA
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 09:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766136370; cv=none; b=oPXY6WwGJcPHhx3kngAPE2RqV6FhMcKtpxj7XLlFwrdyduAsR+G3vFp/CwFnUevLm3Fbh9DpmRDUE9Onf6rmWFzNjFU/34f2FfMQGCe+Cp1MT+EfpEeylVPoiYxswxovi/s0aGEzeVhObzM7aWyhGXZMevowZp95OOXRs5xkrCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766136370; c=relaxed/simple;
	bh=5OSALBiHZWEMdVoOQf+HBqqfg5Z3bi19g+1/BKO3HAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cwu/kJCDWy3HbdWRGfP7yemRGr3DyxzP2WdRqelmT83CGMQai5RX+tFQC+T2p1sKrMqxdI1HlkGJ5wEOcpcEaKWCJDXErIGWrXOYvWLZVuz+tly1ONfcaNpER6HgleioeBGd6gFML3xXg2fwjYtyFHSutJduSVW9SVckcVFsTFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=ycKcyH/F; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="ycKcyH/F"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477b91680f8so13386705e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 01:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1766136365; x=1766741165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxMyB50+/zeWFScSgn2QI/aE3GE1ZNIeczcvT1jVmnk=;
        b=ycKcyH/FosM80bx3Di1lUM/db8L34frBlBztFSGcBsBtPE8TwJPJHXeGZqnMz6nTea
         kWHjW7sYZpr/YlXgD8VrEUkEdnNK6ViRTTEdPWR7p3PzblLnoQzJHk6Nd45wJrhnw+g+
         5wApbbDBhY/XOx+aLDBT72jPDtwBwktiyr0gxNyrKtP0vCmdrl5LyGoXCY9int5MhPGS
         cou8J0kpIMvEU3lRcVIe2Rbs6gf/5EeC/NI5o+VEZU0bE0JrCS4qAB+QhkT/JY8JhnGv
         ECsQ5+8hatoXlk4YeSGAkTEvGaG6f6fiQrIT1WCxyB1auz7RRah+4uacbrg3Jpcs9glx
         VfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766136365; x=1766741165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gxMyB50+/zeWFScSgn2QI/aE3GE1ZNIeczcvT1jVmnk=;
        b=rkSyC/WnjKjQuWo5BDxdCcj9BUAGano9yEXqb8iCVa2Pxcs87cexJVRmmBEy8ow6an
         ikZq3yu2rdtCP0WSbv0AzX37vbKz1tadVSL9/3qSw7e6gCakSMJvKLjBjxwp0ouAMGFt
         EP/Pyzwgh7UzKBxJB3LjL60jiR9uj42UJ0eUXDF3zhAVRhtrciIm0KZtUxX7acRnwyvX
         m5AQE3ZOaclLARsmOc+4EAQtmNIEAJ/wL6TxDttCYTsAkY0xAeSZ9CmLaFKz04fCCgMZ
         jMCMdF/IaaKcwi02SHM6RJJYbKky8iqvg7vu0xS+nQjiY1D110mtai7jQPU1M40/FqJN
         5V1g==
X-Gm-Message-State: AOJu0Yx0P7PqDDF9nlrM53cREk+ONI+UizwuJm5Ah0puzlrNDGEx6kUo
	U56h9qEUrPxus/aHA3nELhfSlu//vYvsRpFgAXnzx5iRXzxdcQNVwOQ8wCwUuQarxKE=
X-Gm-Gg: AY/fxX4qUUom8Q04uLze22B/P1cE36Bu72zVnocrZZhAw5raEOlw91qzPtNW2aIxyCz
	s0BhJAjVNEjM+Z/wSsd31Nzq7L7wwA3hHHDxKtaJTcs8FmSrXZNDqT2qywR+h7vkQ0ZPi2rreIL
	pCiAEjXK+BIrY02h7bR3Y5K7Tyzcx+3tdsPjbtztYiM/eWDs90+cJslQMX6+/trECdq7rlLh/Uq
	McAc30xblbxH3mqff8knv+/dWxv4CTXzerBEJ5V6ZIoGhLa4HOcqN3g69tawgC333wrtaqg8sW5
	iZRe1u41lFkN6vyJqmTJYd4uV2yjw3rRMq23LceIiLAdj8tGzSrj4bhDY4ArxF81pmokl8a2p/o
	M/U8by2zBrIMhCsvptB05CGr+B32ndbzsFWWvUlYPsyRbAR+LLhYwBEcqlqRkWY1emUzgZ7u6NH
	msRNWpBvF20ovYE187DfRIlC+wvu49Hm0uzJPo21hcMW9w+Dpep80IriLpFGEirnRne6HpQ/eYu
	unJN6ASvep3kQ==
X-Google-Smtp-Source: AGHT+IHJWrVBg4FXbeuWT2QmUyDRopZjU5axSCnkR8yyqalDbQPRSe2W/ABVZde1jGrojy2K4KtKqA==
X-Received: by 2002:a05:600c:190f:b0:475:dd89:acb with SMTP id 5b1f17b1804b1-47d195a72fbmr17844715e9.22.1766136365303;
        Fri, 19 Dec 2025 01:26:05 -0800 (PST)
Received: from localhost (p200300f65f0066087cf387e078e1a5dc.dip0.t-ipconnect.de. [2003:f6:5f00:6608:7cf3:87e0:78e1:a5dc])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47d193cbe58sm34643185e9.9.2025.12.19.01.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 01:26:04 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH v2 4/8] scsi: sd: Convert to scsi bus methods
Date: Fri, 19 Dec 2025 10:25:33 +0100
Message-ID:  <8ad5a00c2ad2a64b81350ae3fab02fbe430f306d.1766133330.git.u.kleine-koenig@baylibre.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3835; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=5OSALBiHZWEMdVoOQf+HBqqfg5Z3bi19g+1/BKO3HAo=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpRRoXMwjA6kxZ9I1B/wuX1nUll6c+va/6t6YwV eOaA8qCmMOJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaUUaFwAKCRCPgPtYfRL+ TtyZCACHnHQiAcnv8UHUWMYtAlBPYJXxFBmUbEAyI+tDxmVW438DloO1ohN8yMEYZngKfp3mWma 2bfOYVXT7/dKL7gTLqo4Z4Hz8pHYIDdbikM78QtwT/nUS7b9L/OJ86fYtlYwgLa41LbMLq1Gy3u RYAvlv+C8IB9dfPxwKZw4Tw4Or9ZNCSfzxKRCrIwXuPdNeopSNMoZ0BE0sDQG4QD9e9L/s7sKpo KgAOuHu4nbBLqUIIk2GXpShuqcKPYNBkmr/mLDPsI5LGfE3cCr97Qom+osa8SeDEQsNnTIPx68Z EMFIdH4fS5xU0qxw8f7l4K10WphgpDm5JziEK6NtugsDJNHi
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi subsystem has implemented dedicated callbacks for probe, remove
and shutdown. Make use of them. This fixes a runtime warning about the
driver needing to be converted to the bus probe method.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/sd.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6ea6ee2830a4..dc7eac6211bc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -108,7 +108,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp,
 		struct queue_limits *lim);
 static void  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
-static void sd_shutdown(struct device *);
+static void sd_shutdown(struct scsi_device *);
 static void scsi_disk_release(struct device *cdev);
 
 static DEFINE_IDA(sd_index_ida);
@@ -3935,7 +3935,7 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
  *	for each scsi device (not just disks) present.
- *	@dev: pointer to device object
+ *	@sdp: pointer to device object
  *
  *	Returns 0 if successful (or not interested in this scsi device 
  *	(e.g. scanner)); 1 when there is an error.
@@ -3949,9 +3949,9 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
  *	Assume sd_probe is not re-entrant (for time being)
  *	Also think about sd_probe() and sd_remove() running coincidentally.
  **/
-static int sd_probe(struct device *dev)
+static int sd_probe(struct scsi_device *sdp)
 {
-	struct scsi_device *sdp = to_scsi_device(dev);
+	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
 	int index;
@@ -4091,15 +4091,16 @@ static int sd_probe(struct device *dev)
  *	sd_remove - called whenever a scsi disk (previously recognized by
  *	sd_probe) is detached from the system. It is called (potentially
  *	multiple times) during sd module unload.
- *	@dev: pointer to device object
+ *	@sdp: pointer to device object
  *
  *	Note: this function is invoked from the scsi mid-level.
  *	This function potentially frees up a device name (e.g. /dev/sdc)
  *	that could be re-used by a subsequent sd_probe().
  *	This function is not called when the built-in sd driver is "exit-ed".
  **/
-static int sd_remove(struct device *dev)
+static void sd_remove(struct scsi_device *sdp)
 {
+	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	scsi_autopm_get_device(sdkp->device);
@@ -4107,10 +4108,9 @@ static int sd_remove(struct device *dev)
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
 	if (!sdkp->suspended)
-		sd_shutdown(dev);
+		sd_shutdown(sdp);
 
 	put_disk(sdkp->disk);
-	return 0;
 }
 
 static void scsi_disk_release(struct device *dev)
@@ -4197,8 +4197,9 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
  * the normal SCSI command structure.  Wait for the command to
  * complete.
  */
-static void sd_shutdown(struct device *dev)
+static void sd_shutdown(struct scsi_device *sdp)
 {
+	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	if (!sdkp)
@@ -4368,12 +4369,12 @@ static const struct dev_pm_ops sd_pm_ops = {
 };
 
 static struct scsi_driver sd_template = {
+	.probe = sd_probe,
+	.remove = sd_remove,
+	.shutdown = sd_shutdown,
 	.gendrv = {
 		.name		= "sd",
-		.probe		= sd_probe,
 		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
-		.remove		= sd_remove,
-		.shutdown	= sd_shutdown,
 		.pm		= &sd_pm_ops,
 	},
 	.rescan			= sd_rescan,
-- 
2.47.3

