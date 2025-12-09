Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4FF1E376C
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313143; cv=none; b=fPl1cO4ejvOjwLS6XyTgqoSN8m69h8c8Stz7VvpbOhD/BG1LQM5oTBk052D3BmnQfebfAWpWOatLgjeWpCUCN3dpEo485x3Mb/C8nhj3xeBYVrCwtMRakYqykBluCsx5+zYjNjBuw83LaeC72yA64MxEBIZ8lw9+pCOS+m8fmVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313143; c=relaxed/simple;
	bh=P60P1jCZ9rJ5qFV4YrZSMhbhHE9SDvYDP+HyYltMKf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cku8Bdk73uUpmK6vNr/i0xA4YPbCeSzC2qGocdOsxU3dT/+a19Byw/HCoS9WIyMMvUnOz1y9MGmwe0kU2yVnCGpNxyKmGpnXR+9Xl07S0aRpt5TgYL7P+6h80QDdytUViQS/3m7nK8hW893oKR1hKfrU0UAakcmWbBSkACq5lBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=vX6E6zgT; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="vX6E6zgT"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b770f4accc0so845457866b.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 12:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765313139; x=1765917939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S8l2b4nl5sqlOEV4tFu05ObuWW/7+JFQFODSs3eF1sQ=;
        b=vX6E6zgTvEr+Wii1WbgDhzlSfh6dDz/gVU1TsNUQkFSM/oS3H5jWanv3lKtrGqZOM8
         xwQ8KbbmflojgaXtNvhdeo9WyNvjnB94EN1q7EesPwY0pL43VPNwvz3yw53UY+nJp4gW
         m+Aoi/CHW42eYtkskuySjxLH9L5lnC2Wyj4euPGqU3qlfPk7gZs3gOUfRsgKec92hxSo
         fGOkZx/3RVhwVDqAHZ/QIy/SSbTXyrfPoXdpvRCHR9X73oSSzpWEAr9jxNB5aItR2x4a
         XN8i6RWeq8Ror767xDT5DdkZx54vb/yGIcvMNW/AeiMh4PftTX5E85XkMC2AMHnmzpcs
         flBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313139; x=1765917939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S8l2b4nl5sqlOEV4tFu05ObuWW/7+JFQFODSs3eF1sQ=;
        b=TULwfmD4daTcs3n5xgYmbrwh0zWHI62eRJyYLLRRyTI38fdzq8Jlpwh5OVPm5367KW
         UEcyeUoj2j/qIzjG/sK0QOfj5Q8hiNAzU5MOZM1KsYFFHnvXV/NlLHnfj1tUVJNcea50
         KdLy2Z7EHCK7KndxkBLqq6nlcv8832a+J9In7s5IgfIBqV7YMpTmVox4sZoypnqZPaZA
         PG5rxdzjZxQMuaPm1A5tX6Ai830igq+s+jLAxZzMpaiplsWVwjgftGOqZtC6xgCgDyq0
         N0L0znwomVwIxT88H40QiMDkdSVFaEdTemNCNe9ke11TjUvb86ZfzW6C8iPvGxQNY/iE
         441w==
X-Forwarded-Encrypted: i=1; AJvYcCUqs+g2W+9+b87I4IOKTgGipVhsTlwJZO0AIGIKfFjtb6eBABAbiSpKAzfBnpQQtsqKCgz/Bf1Dx9YE@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9iokngkP2MKRBICeGuZpzTZaCr7HRHLXPvdPhuQV9EYteYgQ9
	oiBXJirNnrtT/vk19N1El2r7b1w+CmjiHOcdkeaVYNR8kmAEz06rjQ2GoqpHc6fjj1y05JkUvhG
	lUzb/
X-Gm-Gg: ASbGncu5Cj4TLACB8uBzQE+AaQBOm/AhheDf4DW0A0qxtQ7X/8pkT7hNk2rpsyfvBW/
	WJVwEzNY8iJdkbI89lWNHX+g7C4Gof+hSSvJbkrYfIIqgZ2QYjmId09G6gfj0AP0/Z82WwtVhCy
	BEs3Axoizgz4Kil1KNejZuUcZW0pjeBuxryKqnE6YM4NWhg8b8R2Gnrr6Cy1wYPMXMyPWszE0Cb
	SHQpyDWcOKlb+4MwiJpZknQAE5vf0D+ZUnjSFyVhcW4fUF4TE7jo8uR8wPLfepth8J4JnUCxF2/
	pZFJZITaUKG6y31/lp6olJBrZwplGqJmrfM6Q1iBKt/aHYATpkJdX8VWTqM6auxNH8KiqZL0cX5
	bmq9cbRudOutRUaICHgAtdkmVDiz+IhPiraEZ8iVBtQOcbkTcIBFx79y1F3AE9e47kyP6uTNt5g
	0gAVdcl8JE+f/6qKAi
X-Google-Smtp-Source: AGHT+IGeel1Ek22ij8e+JU8pYVuEvAYwPoP59zz2TsUO0WOZCwFAYqdvReghJ9dxksTb03mOmZMAJg==
X-Received: by 2002:a17:907:9494:b0:b76:d734:d459 with SMTP id a640c23a62f3a-b7a248183d7mr1461859766b.57.1765313139003;
        Tue, 09 Dec 2025 12:45:39 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b79f4498d2fsm1508618566b.21.2025.12.09.12.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:45:38 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 4/8] scsi: sd: Convert to scsi bus methods
Date: Tue,  9 Dec 2025 21:45:05 +0100
Message-ID:  <1931ec5bbe8d0ad82b6fbc77939d43bf5a4f177f.1765312062.git.u.kleine-koenig@baylibre.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2930; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=P60P1jCZ9rJ5qFV4YrZSMhbhHE9SDvYDP+HyYltMKf4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpOIpX8R3j5Eww+bmAPSIUt8CCgx3zt2LlnC6rg b4sq9Hn2vyJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaTiKVwAKCRCPgPtYfRL+ TmnuB/9qRuzZg3FfPW/DVheagMu4SU4re0s6Ws5it3FfBJhcqzlGZsWt7vIAohc+Zl6j0rPy7pG YAqh2pQi2J+9YEbIN3Kls83fmCyt4+Akq1G7x1A4tVPAaukvT32tYGNrFucbqGbGRYcs+gJisko L1kcKJ6hTjzch6iNooWOrxbB5RYfy6vRnTFInMOKLG/w9ZoaNOV0JYfxsBequJbwnB8V9L+mhU9 YV3MEET4REK+C/1c3Hbi4lBlH/4sbAKijak3QsG9LUaAFfdeI5/NrKrZmqVSZEfh4FC/VkBZWBK 8VpJgLxEoV1pzml3NCt4D75cyUKZkzvSNtedjp7fAo3xFmeW
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The scsi bus got dedicated callbacks for probe, remove and shutdown.
Make use of that. This fixes a runtime warning about the driver needing
to be converted to the bus probe method.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/sd.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index da927c030ecc..afed915eb158 100644
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
@@ -3909,9 +3909,9 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
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
@@ -4058,8 +4058,9 @@ static int sd_probe(struct device *dev)
  *	that could be re-used by a subsequent sd_probe().
  *	This function is not called when the built-in sd driver is "exit-ed".
  **/
-static int sd_remove(struct device *dev)
+static void sd_remove(struct scsi_device *sd)
 {
+	struct device *dev = &sd->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	scsi_autopm_get_device(sdkp->device);
@@ -4067,10 +4068,9 @@ static int sd_remove(struct device *dev)
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
 	if (!sdkp->suspended)
-		sd_shutdown(dev);
+		sd_shutdown(sd);
 
 	put_disk(sdkp->disk);
-	return 0;
 }
 
 static void scsi_disk_release(struct device *dev)
@@ -4157,8 +4157,9 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
  * the normal SCSI command structure.  Wait for the command to
  * complete.
  */
-static void sd_shutdown(struct device *dev)
+static void sd_shutdown(struct scsi_device *sd)
 {
+	struct device *dev = &sd->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	if (!sdkp)
@@ -4326,12 +4327,12 @@ static const struct dev_pm_ops sd_pm_ops = {
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

