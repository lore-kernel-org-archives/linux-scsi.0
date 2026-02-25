Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F38366054
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 23:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772061376; cv=none; b=ckFJUvdwAB51zr/S+/aocnSUlQfpV8NWwvdEZyLfcS1bkVPg5pzctAvak+a3dGwOCVVRYYITTh7ZwxYv0wRh2IFKwsSIdI+YXd9z8PhkVdY7tbTLlBvS+evAXVvjdp84xXiaeqcMbB7Rm+1jPmfqogHQD81Hef9kpg9t3BWDUX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772061376; c=relaxed/simple;
	bh=vGLV6MMskITK2z/wINdyUTs6uwN3zcL4fdNAbCEPOI8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=XpyVFer8acGh6ZCOeqOYD91uzaA7ZVDbR3Xnf4FsFIPpoX4Kk346AO8qZhnHgI7fl4uOPRvGO3M6HlGgb7CEZjK/Mr8Z0P3qCxvZjc3Gtt637oS1SspKYuCOFGKbixYaWUzvwXlz3p/fU2EmLVfY84DYItUn+AA7YYtvEpxSGdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYP+WNBi; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYP+WNBi"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-899a5db525cso2383036d6.3
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 15:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772061374; x=1772666174; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1PApqkreHhTno1KBvHo9H0FXDAItxdLWhHiztfTVJd4=;
        b=OYP+WNBiQmx2DZLRhhVMtszBVSnZuUlV/tTxqCBi1DwDal12AW9rUD24De3G7rZ8vV
         YBy9Be0b2Mfip6o1K5XRQQFcwjLXgem6IY4jwzRCZX6a8UMRR0J4S4D32VPlN8COKFX8
         yp5uuIuZfPe9ELyZTr/geU9tTfCitATDclvI9yuzx9wWlo4n7XNaLV157BiW164Tjlxq
         046/D0szqIHyPl5RF7oiA1coB3v22Z5zTvvsYNRds2ncNnbP4Pszu/IdLgP8z7HqnHKV
         egv016OZvI3TNN11GSnBLEhaz+oUuUE40aZt93AqySEojo0A83i5EIkaiiAlNdWCys9T
         BShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772061374; x=1772666174;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1PApqkreHhTno1KBvHo9H0FXDAItxdLWhHiztfTVJd4=;
        b=aXwTt+3fUgVWBzxRHhqUTPecUf6ifElw/tf1kEoEYUJpp/7O36AOcsp5hqL9JwX3Bp
         C/vmJtM9ONuISEEbS3ViVH49ledbxs4l92QZbPmzmlwDRUQzF2zm7FN5Q6a5Vd0P16XI
         FyhNF6TBplDgO3kXVB6yhhhd2nsftsTqkWjSqdJo6SUFmyyZ0etONguVgkekv1/Er7H9
         F3J++I3qEtQhQy5DQbIXxE5UV0jZxzi4UG+uKlMoET3Dop2pYEfOeKsvN659wgbajxkB
         k8aPXECa4W4YDrKWb9JzP6YltYODx9cwE6JTWtDBtGxFkiyjZ9BdlFFY4AQQm+xjK1Jv
         7V9w==
X-Gm-Message-State: AOJu0YwYC1b2WJkDmGFu9hEUuDhEn6gV/7MeIVvQeyb6/zN3cVqQrpR6
	wMFPkAzoFO/ZRbj7ZPHVh1O1MQvhjFQUMZYurje+Rvr2fmDKGlSfeuOTT7MY9Q==
X-Gm-Gg: ATEYQzwwgHn3zKd9WOVaYbbp4BsVdH2HGj+3ouEH4a9+mnkGj9oDzgh8Mwcy7I/zZNF
	VWssABBr5EGzy9A/78B3kUAnQGu+YanJ6VG2rXsC5Y+9PYeYCO0BShDo0C1guckLwlkT/g14Jvf
	NuqlYTe4yjtaYlssqkrEfvymaODDT2PpLzDCu+AeXURbek2yx4zhGPExVR1sT/ikfPU7OXDlAD+
	tYICvXgH7Cr9O4klSO4YPsuS1SAQGS4vIRTU2xd0Nle9BWIb6yFYU+8nJ4gplNEbgTrig/my/LQ
	jDXe4MG4sqrBCfvHL6N5Ru+BT6KtFwCmdcAN2jGIjKi/d8U71El5Avru4rtuAX1ltOm5lq4TY/Z
	bmKE8Wqz4ar0Fu6WU2W1W95TvBX402zjvfZadhkDWMO/bN0A5UcPKW0EcLXfIh4Kz6NWMAEYj92
	ZZd79A8aRYz7dyvD+na93OZeU1PyYOQNRxm80O7FB6yNL/IFHCzkPoPIO+1ry0Ta5zO4Q=
X-Received: by 2002:a05:6214:21e1:b0:895:4b4f:133a with SMTP id 6a1803df08f44-899c7ea4d33mr2757096d6.5.1772061373791;
        Wed, 25 Feb 2026 15:16:13 -0800 (PST)
Received: from ?IPV6:2601:244:417c:14a0:214:15e2:6a74:6134? ([2601:244:417c:14a0:214:15e2:6a74:6134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf71ae8esm47392385a.41.2026.02.25.15.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 15:16:13 -0800 (PST)
Message-ID: <293e4493-023b-415f-b2b0-0fe3cdfe7149@gmail.com>
Date: Wed, 25 Feb 2026 17:16:12 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, kylek389@gmail.com
From: Kamil Kaminski <kylek389@gmail.com>
Subject: Subject: [PATCH 2/2] scsi: sd: Treat locked encrypted drives as "no
 media"
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

 From 4cf844d0840836e406e6eb1b65bd512b89fcdc20 Mon Sep 17 00:00:00 2001
From: Kamil Kaminski <kylek389@gmail.com>
Date: Wed, 25 Feb 2026 13:43:29 -0600
Subject: [PATCH 2/2] scsi: sd: Treat locked encrypted drives as "no media"

SanDisk Extreme Portable SSD and similar hardware-encrypted drives
return "Logical unit access not authorized" (ASC 0x74, ASCQ 0x71) when
password-locked. Currently, the driver attempts to read capacity and
partition tables, causing excessive I/O errors that crash USB controllers.

Detect the locked condition early in sd_revalidate_disk() using
scsi_test_unit_ready(). If locked, mark the drive as having no media
and set capacity to 0. This prevents partition scanning and allows
graceful handling (similar to an empty optical drive).

The virtual CD-ROM interface remains available for vendor unlock
software.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=216696
Signed-off-by: Kamil Kaminski <kylek389@gmail.com>
---
  drivers/scsi/sd.c | 34 ++++++++++++++++++++++++++++++++++
  1 file changed, 34 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 628a1d0a74ba..c83004100bc4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3721,6 +3721,8 @@ static void sd_revalidate_disk(struct gendisk *disk)
  	struct scsi_device *sdp = sdkp->device;
  	sector_t old_capacity = sdkp->capacity;
  	struct queue_limits *lim = NULL;
+	struct scsi_sense_hdr sshdr;
+	int retval;
  	unsigned char *buffer = NULL;
  	unsigned int dev_max;
  	int err;
@@ -3743,6 +3744,37 @@ static void sd_revalidate_disk(struct gendisk *disk)
  	if (!buffer)
  		goto out;
  
+	/*
+	 * Check for hardware-encrypted locked devices early.
+	 * SanDisk Extreme and similar drives return ASC 0x74/ASCQ 0x71
+	 * "Logical unit access not authorized" when password locked.
+	 * Detect this before attempting capacity reads to prevent
+	 * excessive I/O errors during partition scanning.
+	 */
+	memset(&sshdr, 0, sizeof(sshdr));
+	retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, sdkp->max_retries, &sshdr);
+	if (retval && sshdr.sense_key == DATA_PROTECT &&
+	    sshdr.asc == 0x74 && sshdr.ascq == 0x71) {
+		sd_printk(KERN_WARNING, sdkp,
+			"Device is locked (hardware encryption) - treating as no media to prevent I/O errors\n");
+		set_media_not_present(sdkp);
+		sdkp->capacity = 0;
+		/* Set minimal valid block sizes */
+		sdkp->physical_block_size = 512;
+		sdp->sector_size = 512;
+
+		*lim = queue_limits_start_update(sdkp->disk->queue);
+		lim->logical_block_size = 512;
+		lim->physical_block_size = 512;
+		err = queue_limits_commit_update_frozen(sdkp->disk->queue, lim);
+		if (err)
+			goto out;
+
+		set_capacity_and_notify(disk, 0);
+		sdkp->first_scan = 0;
+		goto out;
+	}
+
  	sd_spinup_disk(sdkp);
  
  	*lim = queue_limits_start_update(sdkp->disk->queue);
-- 
2.53.0


