Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7508425E457;
	Mon,  5 May 2025 15:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746458913; cv=none; b=TYZUJeo+d/qdjRpAQOdE22xXIG4FsgbROrcwBGMvtmxuhrZa24eB9DiMG3jLOIkxon0ajI6aProPypIWgib/M30B5Hue52JFNV50E0cjczrMIyDyAAIbGA/wBEkp1D7MsIQPSRNWbYX0yrqx6eV11Zd63nI5qoDW6dJmyr2yB/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746458913; c=relaxed/simple;
	bh=6SDmYZgXdlu/WBCDGEOSGE8fpNGIh6i3qK4i75F40DU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uAGVpE6e6v4DsEaEsAaoZjm8Pgh1V2TKC9bfz2MaXJshlxYaL9UnVJDJ+0KlPM/B+wPk6Kfgj6JS40P7r3ziSIkVVmBU2hQ4hjQA/ZbvK/tZUivOMfqoP5S8H9B1EwequqdfLA3Kr5G/x70Z6Nvv8DFkI3vvuaPZrxTkxme37uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCGQu5SG; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCGQu5SG"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cf3192f3bso43370635e9.1;
        Mon, 05 May 2025 08:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746458910; x=1747063710; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EmE9oKwDnpC0K6rYJTwf1LbRWby759kFOM4+Y97cWvs=;
        b=CCGQu5SGSe5n36FM6Sv+YV7hnMznzSZkqO0htRU8IBvi/OfFiYhx2sUQ7OD+Q07jQ7
         D4+24ZzsxdQdcC3i9rd06SLHh/0mk2Y4RLQBTDub0lXanUYsBPQJAzCOdyRzq5vrsy74
         LERBi0cn/lbklfelmO4+PHhFODY8dmrp31sEfVhEcyUJ/rrDxt+8FGHWwQYQpch+HWS1
         pCVkp1Fz+ft5cChMGqU5BzA4IDcuYaWqPaKqLE7CjWx5N84jNqJFu0zqfm3lGaQ6yPe2
         CS2QrF9wFfI8XVO+Z26BvIDRjACI1nFe7DpCAAFIOycy4L2v1q/pCi7XdloKknsdMsMv
         saIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746458910; x=1747063710;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EmE9oKwDnpC0K6rYJTwf1LbRWby759kFOM4+Y97cWvs=;
        b=cOKBY0iOJX1+A2A7ekUYm/tEfxgzwzN7cPx9hlqO4fRh7gK6osB/VNX7FgWeO12ryP
         VYxXRcB0n57UJqWjDdUCTyRy50icWj55QmPBQ5P0YhmqTcbM7PBVA8L9sYpEUXXQGe8T
         aspNj6i/VdynNIhEUWvtu1csFaOt8TFqKCzlUFzS3wysBRZ+Za3Ah8B4a4pE8IpFDYlH
         WsxefREX0Ngral1JBKvayW62GhSIg+KpK7GWnJuOrdtYgdl5O+eqY29UUdBcydAs5PmB
         82AHBTidsJ+fWChhVxPvBs8S2A5mYK0zk342ZRHWm0mfccrXzoaawArIx74taprs9qlD
         cqsg==
X-Forwarded-Encrypted: i=1; AJvYcCV+zg3dgRpk2vNzTKCXFvDnoYogK22RCBMraNQXaVJ+vMnQjFn0++3Mpn+LgPxvTlSFMMNoZXR2gAcaoeo=@vger.kernel.org, AJvYcCVRvyIlnqZKpwlBVQBkKfEEmoJ7a8ZjC30rXmm149V/LmyPtl2qYJYI4+DRxwF1USHI08A5wuyJcaaNUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyImLAC+mixLfxxKyfHzN1MZKcp5MhCEenINW6GIBgng6GeHR7F
	ha4LPo5cHoyK5JSm/yhspacB6+T6ge5+t2YwUekw6rwsvV0FXWjO
X-Gm-Gg: ASbGncsn8iydMh5d0VgM5Zb/DGjsUQjlzjJrJpEwIw5daanuWaS+SZdHAIlOMI+yS7K
	BslSXaSHVZxadxgeT2XOmhpT4jycWonv9Nrzy9qcpn89JRQX6EbOPIILpLDrIFi3MnU5poF0EJ3
	yiyaCEcbgRXjcDJU8mrKQLVFgu/HbLRrP+RAdAhEChijbh0rCQN2M5GmKoKDx5mDFyqN3jq8B3b
	eK7Fs3yae27UVswDMYgw5kp/PJMRI6IYS2YtD5Oo0GqYmhfY9Uu5CZifI1VjKKF2/TQnpDaMOGV
	Ltq4K5JlbmTKGQCsmCI+WqOyEjUnDg==
X-Google-Smtp-Source: AGHT+IEh1VfP9ve99wVJfFzmDgXH8h5S9kprFwG2ylwwuMm5phd2w6lKVEgxb9V5FDewnFg1U6yXLA==
X-Received: by 2002:a05:600c:45d1:b0:43a:b0ac:b10c with SMTP id 5b1f17b1804b1-441c49236b0mr66063125e9.26.1746458909446;
        Mon, 05 May 2025 08:28:29 -0700 (PDT)
Received: from pc ([196.235.4.121])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2ad781csm182309655e9.8.2025.05.05.08.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 08:28:28 -0700 (PDT)
Date: Mon, 5 May 2025 16:28:26 +0100
From: Salah Triki <salah.triki@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: salah.triki@gmail.com
Subject: [PATCH] drivers: scsi: replace DEVICE_ATTR with DEVICE_ATTR_{RO,WO}
Message-ID: <aBjZGppbYDLSQRlH@pc>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Replace DEVICE_ATTR with DEVICE_ATTR_{RO,WO} to make the code cleaner. And
replace the names of the functions {store_, show_}* with *{_store, _show}
to make the functions usable with DEVICE_ATTR_{RO,WO}.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 drivers/scsi/scsi_sysfs.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d772258e29ad..04c9f0cc18cd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -182,7 +182,7 @@ shost_rd_attr2(field, field, format_string)
  */
 
 static ssize_t
-store_scan(struct device *dev, struct device_attribute *attr,
+scan_store(struct device *dev, struct device_attribute *attr,
 	   const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
@@ -193,7 +193,7 @@ store_scan(struct device *dev, struct device_attribute *attr,
 		res = count;
 	return res;
 };
-static DEVICE_ATTR(scan, S_IWUSR, NULL, store_scan);
+static DEVICE_ATTR_WO(scan);
 
 static ssize_t
 store_shost_state(struct device *dev, struct device_attribute *attr,
@@ -292,7 +292,7 @@ static int check_reset_type(const char *str)
 }
 
 static ssize_t
-store_host_reset(struct device *dev, struct device_attribute *attr,
+host_reset_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
@@ -315,7 +315,7 @@ store_host_reset(struct device *dev, struct device_attribute *attr,
 	return ret;
 }
 
-static DEVICE_ATTR(host_reset, S_IWUSR, NULL, store_host_reset);
+static DEVICE_ATTR_WO(host_reset);
 
 static ssize_t
 show_shost_eh_deadline(struct device *dev,
@@ -379,29 +379,29 @@ shost_rd_attr(prot_guard_type, "%hd\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
 
 static ssize_t
-show_host_busy(struct device *dev, struct device_attribute *attr, char *buf)
+host_busy_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	return snprintf(buf, 20, "%d\n", scsi_host_busy(shost));
 }
-static DEVICE_ATTR(host_busy, S_IRUGO, show_host_busy, NULL);
+static DEVICE_ATTR_RO(host_busy);
 
 static ssize_t
-show_use_blk_mq(struct device *dev, struct device_attribute *attr, char *buf)
+use_blk_mq_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "1\n");
 }
-static DEVICE_ATTR(use_blk_mq, S_IRUGO, show_use_blk_mq, NULL);
+static DEVICE_ATTR_RO(use_blk_mq);
 
 static ssize_t
-show_nr_hw_queues(struct device *dev, struct device_attribute *attr, char *buf)
+nr_hw_queues_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct blk_mq_tag_set *tag_set = &shost->tag_set;
 
 	return snprintf(buf, 20, "%d\n", tag_set->nr_hw_queues);
 }
-static DEVICE_ATTR(nr_hw_queues, S_IRUGO, show_nr_hw_queues, NULL);
+static DEVICE_ATTR_RO(nr_hw_queues);
 
 static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_use_blk_mq.attr,
-- 
2.43.0

