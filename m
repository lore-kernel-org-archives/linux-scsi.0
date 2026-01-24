Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9501525F995
	for <linux-scsi@vger.kernel.org>; Sat, 24 Jan 2026 20:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769287124; cv=none; b=VDWF1fu4EDRWfJk96bojQwokDXYdbIrzDP9W1zs7BpxaxRFoc6gq1Oz6QoXqT1cX8uD5QI2x9J2Io0XkoP9Tkh7YO6wa+JkINvYbpLcZGKA+VGyKKWkwoDeslL7Yc54g7nWRSJ8ClFikEZ9m2goqUoVd29GCufbp+qNjrh8ckVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769287124; c=relaxed/simple;
	bh=25a/E1ieYaYajebMpinnWoCJHPA4xp41mlwl272x/JM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=d8TEuxR8WjoXvSrVNQHNtAui2X2oQwA8+nbtezAKlDGyyoxBaJWBQ/O9nXP48O3+i2xIP1u/7ZJnJAjOAGkTLl2f/ssTOgXZSlqCk5FYOYLdjD5My3SS/sIuuoDbmwKwaRam1fEq9B9rlY3oVf9VWUDeJmx36WoP9lUrOGQUe+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZD2wZkgI; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZD2wZkgI"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47ee301a06aso37707815e9.0
        for <linux-scsi@vger.kernel.org>; Sat, 24 Jan 2026 12:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769287121; x=1769891921; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KxVCffFqhNRpRYa3HsmFMXBCyunB2idZw39lfLbIlZs=;
        b=ZD2wZkgIqVp0G1U2Im7vWQiV577ZFIgBvXYuP10rIqd1d0nBM0ESjj/hU7zUgtRzEH
         xDq1p69o/zH1aIKYOs9D1BkBpdWhs67FE8Yu78orkq1wi+jSew45+Tw9qSYQMcgu+8Mg
         sZMxEtM7klbm5/chRrdDEC1/pLFKlgbXSOb4eRmVEien3J2Px0Z30vOqaTVb9o27by0U
         dNaE1E0wkuWGKpVyzRYSQxe8sB8YTufXNPBWSwzfOm+0z0SDOxced3saVZNeislfwiCf
         ksYPKb6bdbbbpbfUGjcKCzBR+4E66rHWWY6gbLvojc4UmMCm0r/Yw2XuQBOq/nod1xGw
         yykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769287121; x=1769891921;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KxVCffFqhNRpRYa3HsmFMXBCyunB2idZw39lfLbIlZs=;
        b=T3z42k3oxV/8bKmX2PhvoFyOwmiV533ZviQQmn4uJ5GI49TkFIIE7Koyxt1mIR6IU8
         57JuHJGUe2A5TlJO/bPqQ0bLu1J7KNukRdcv3ixRfDFnd4dSEl8UY6r7CN/w1Trkfz+h
         qE0RP9ofBQr1Sug6qpxlVMiwDpxb0G7UkIPnHcBiYSHm6YulSam/fY0lPcorx8FkQuPT
         FKIK/ExhTMDtpMxSLJkQDzEZPn1c+cA9S+T03b0kOwKmUx48p0pBsgEyPCCCmiGZRik9
         iI9W/cjLTCxAG94wVdABvPN7f6oNnRRpw2BNogVdP01zG7mBFS42yggupPROjYJ3T2Tp
         yP0A==
X-Gm-Message-State: AOJu0YwtuWeCRT9MMeGFwOs+GAC6HRw4JDXn9/oYHLacQ7wZVYZUOYR5
	ElmHWJ3fKMxPGMxfp7jxZNuWi3uUM8KM3ienU+ibP8rRnYiMfF4ikLOaeTt3PtmE
X-Gm-Gg: AZuq6aJfNDm+hLw/g6cdPwwNEtdvn7e7kJoW3tEtK5VNj11PctMOTrXvVeyg+Yaa6vO
	c23urU8m7AY/WPv8rqtmJnsw9o76pj3NEcjReEd701TGYf2XbMwnns5QLqmCs1he3sKsZPKXqJJ
	QVjmtg1x701iUoPy1Y8ZtvCjOUyf/WhYxi8QqzmYq6VNCWvrTMyb6exh8gakmOLPI1UjIf4VOhL
	BLDzaAsJslnlRHY1eaaPDLa1nlzx5DYBCxwmR449zBNuMcGR+/5HQijsfhEB7KWgMOLcDaFHLuJ
	gUtHz6YaENyuLy7Tff/Vh9okzfjYBEhs/zGYJrRk/wcqQtlnICVdSU1vV5vdqrjgsV/K3PKENNU
	IwOdZHZYdqju/1aiBfr9Xjcgrf/7/A/DPBu802FFJ4wVOruYCQr/JhLQGEyf7dgpfhCEi4wCFgi
	QGYJeDD0NIsdn6HhDSMrwBJMuFDqX/fpGgErphrozRvMz+24bdBTkCcseawDtDy7wj80OIrw==
X-Received: by 2002:a05:600c:609b:b0:47d:403e:4eaf with SMTP id 5b1f17b1804b1-4804c9596bcmr129506805e9.10.1769287120843;
        Sat, 24 Jan 2026 12:38:40 -0800 (PST)
Received: from [192.168.10.194] (net-188-216-175-96.cust.vodafonedsl.it. [188.216.175.96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804703b90bsm259845925e9.6.2026.01.24.12.38.40
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jan 2026 12:38:40 -0800 (PST)
Message-ID: <94ce4f7b-25dc-45d1-8467-f63eb15a3654@gmail.com>
Date: Sat, 24 Jan 2026 21:38:39 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Sd card race on resume with filesystem errors (possible data
 loss?)
From: Sergio Callegari <sergio.callegari@gmail.com>
To: linux-scsi@vger.kernel.org
References: <3bb03946-eb11-4e28-a72b-e958833bb5cc@gmail.com>
 <fe070d43-f9b2-45b2-95d8-477154b28dea@acm.org>
 <04811e0b-efc5-47ff-ac16-a97f49280bb7@gmail.com>
Content-Language: en-US, it-IT
In-Reply-To: <04811e0b-efc5-47ff-ac16-a97f49280bb7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Made some tests with the purism patch:

Made some tests with the patch from the purism developers, that is the 
following one:

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
---
  drivers/scsi/sd.c | 39 +++++++++++++++++----------------------
  1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c627deedc1f..c2353a260123 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3968,11 +3968,28 @@ static int sd_resume(struct device *dev)
  static int sd_resume_common(struct device *dev, bool runtime)
  {
      struct scsi_disk *sdkp = dev_get_drvdata(dev);
+    struct scsi_device *sdp;
      int ret;

      if (!sdkp)    /* E.g.: runtime resume at the start of sd_probe() */
          return 0;

+    sdp = sdkp->device;
+
+    if (sdp->ignore_media_change) {
+        /* clear the device's sense data */
+        static const u8 cmd[10] = { REQUEST_SENSE };
+        const struct scsi_exec_args exec_args = {
+            .req_flags = BLK_MQ_REQ_PM,
+        };
+
+        if (scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+                     sdp->request_queue->rq_timeout, 1,
+                     &exec_args))
+            sd_printk(KERN_NOTICE, sdkp,
+                  "Failed to clear sense data\n");
+    }
+
      if (!sd_do_start_stop(sdkp->device, runtime)) {
          sdkp->suspended = false;
          return 0;
@@ -4005,28 +4022,6 @@ static int sd_resume_system(struct device *dev)

  static int sd_resume_runtime(struct device *dev)
  {
-    struct scsi_disk *sdkp = dev_get_drvdata(dev);
-    struct scsi_device *sdp;
-
-    if (!sdkp)    /* E.g.: runtime resume at the start of sd_probe() */
-        return 0;
-
-    sdp = sdkp->device;
-
-    if (sdp->ignore_media_change) {
-        /* clear the device's sense data */
-        static const u8 cmd[10] = { REQUEST_SENSE };
-        const struct scsi_exec_args exec_args = {
-            .req_flags = BLK_MQ_REQ_PM,
-        };
-
-        if (scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
-                     sdp->request_queue->rq_timeout, 1,
-                     &exec_args))
-            sd_printk(KERN_NOTICE, sdkp,
-                  "Failed to clear sense data\n");
-    }
-
      return sd_resume_common(dev, true);
  }

--

Unfortunately, this patch does not seem to fix my issue.

There seems to be something wrong with the usb-persist mechanism, since 
there seems to be no way to delay the first access to the usb disk until 
it can be assumed to be ready.

Incidentally, my sd reader is by Genesys Logic 05e3:0751, in case this 
information is useful.

Best,

Sergio

