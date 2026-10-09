Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421634973AD
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 08:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791533557; cv=none; b=pw24UrXezEVdcqbWt96c9MNvOe0gO9TpGYoG7D9uApogYb+0+MGF12qyfHeaaqMgpgCIyN0JVup+Tpp8gq0VHGlEpzRabkHwjffU+ugH8g2b3lcIjb+2fDBoirfXRQ0luJ+6mW85iF58+fYJroHOw485FQMezarUMXvP9r11EvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791533557; c=relaxed/simple;
	bh=4F+TSlbYkXT2ClJWEr5D0vOHM76ADdsVyCS4YgVNFb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVTyN6PJvVYMxkGrla4/1qF7ubxObgEdTU5/Ybcjk1zMSvFnaAQvS7M/dU3XI84JuHScDCCN+Yj6FlhjP8Wq90cs14AaZQlmPUCDiRqkIJMfwBlgj2ePTBvpyMBV6l7qbGZt8RBZFEDUIntv2dnscspo/gMnZhqesYiywDwK4jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0PvZoR6; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0PvZoR6"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso63168405e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 01:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791533549; x=1792138349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=trUwtHSfgnebdrDRGmzA04LycFSBQ2s2lc/J18OXkXY=;
        b=g0PvZoR6o1yy/4AXGpoOwM/K3T/gEoYOmuoPpYiFiTluh2eTrmOHaii9k6WS9R9/lL
         rcwiVfowp9DLzC8MqsgNXgJBfB7n5zLSVzfCkRb0RDjk4jUO2sa7iyeI9BEuvCpv8J+q
         rEczli8uMOUsmw51JU5kvLppOTNdk6zGFxp3aji2E5eaZMwFqcPLiLtOKavMUe9KJxSG
         d7qEYO6oimt45VLQ0I0ruf0MfnZowAqKrwPrHN5JCn8pU4zpGGr0qH3Y25SYqfWT0Kqm
         rsa7AFeZj/t3xq/+YGyDnsdHhdDgrBTY+pvTi2gi0pYM32IgfuXgwxGbpkV4KaJ7XSgL
         4QPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791533549; x=1792138349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=trUwtHSfgnebdrDRGmzA04LycFSBQ2s2lc/J18OXkXY=;
        b=zQdT+m9UxZwaMnbFJ3oax6k7m5NPGpOhTOPgDqXVYLS+wFmcf4dfNLN4rBYcALKGGJ
         yIeLE3HGtUTle/igiZuysK3OqzVECY+NiBOPHP28ukmJRqrr9L52WqvpQvqTbI8maDbM
         FndNJjVFwX8254670v9rPMAE0/Em3AYOlqf+3lZ7ZgK+U2EVFOIASEh1F986ax9paxPA
         LGuGqVz724npoCiTRtE+8fIoiaJo369xb3dnPOLdvGsyG9Be2zGGSVUb693QEvsqVqlK
         F6ok9cgw1n1qbk4Cjr+f+zD2SAKjir/h/Xs/3atiH603+Se6HJHo+M+Do0j51tjmGFi7
         eAyg==
X-Gm-Message-State: AFuF++lllcZ4ymbOiZYXXT+D/ix6KLkTpigABlHS67Pr7OkhU/G70Sd1
	B6A1eKMCr/0G5llm2UquKaS+o98zuWODcMfm8JCWSvVsdtGBOivOyS6F
X-Gm-Gg: AYBFou1c6sG2NdCHlsg0CpH+SppA6ZsMr0/aVj8uelJtD/0XJ1ljfpH5gaPKlDi1Nuk
	flGk6sc7oG4xZJ/qzvz996l1BYT0Tg9cne7YjwwY/PWyfrb+dxr10gusALa0OkqnreTF0X9ZDd2
	kmzZHY7A46cKRt8NxZNSX9hnkJYyMdbvlPnLGnX8wPMb6/QjfVn+BFbWdXNfedPAmSXAfy6qtJ0
	MWU7/sPFKr+tMN1FsjTHP/PLdHBpp5bGhxrz0taIkcvwlM3uSEixBht8wedHdabDkMDrJpT/sRv
	SQD5eD79CgeWavSW/RmApnGdULGdCt/E5roGCNuQe71ebLzUaQsmC53urErEfXcw8mG6ohqsrwA
	F+IYhN7BzKT0nn1v82Kpd80iSIfnEjdjuixS4CCzF4/6XkrTpGCmdyrxO9jeOqgBZJ5CalgLcxH
	spw9PiBzjNrFE1Jiy+ezS1ju7v0Bc9yrRmD/OMZbhYbi2BFdVuQyNoayCzmno5+52oQDGfSfPV1
	UBWCt2/odP+XYj6CHIFLDvL8sIFTFhaXUJ0Vc8FOH0rFn5wyfpllfZB5n48s+TkoXDHjw==
X-Received: by 2002:a05:600c:8b65:b0:4a1:742e:3 with SMTP id 5b1f17b1804b1-4a18e4ca244mr18440125e9.27.1791533548960;
        Fri, 09 Oct 2026 01:12:28 -0700 (PDT)
Received: from darkstar.tail74c586.ts.net (mob-31-158-7-150.net.vodafone.it. [31.158.7.150])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db93d6069sm2405577f8f.0.2026.10.09.01.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:12:28 -0700 (PDT)
From: Luca Cecchi <luca.cecchi.info@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	oneukum@suse.com,
	stern@rowland.harvard.edu,
	Luca Cecchi <luca.cecchi.info@gmail.com>
Subject: [PATCH v3 2/2] usb: uas: add US_FL_QDEPTH_075 quirk to cap queue depth at probe time
Date: Fri,  9 Oct 2026 10:12:25 +0200
Message-ID: <20261009081225.304319-2-luca.cecchi.info@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009081225.304319-1-luca.cecchi.info@gmail.com>
References: <20261009080341.295646-1-luca.cecchi.info@gmail.com>
 <20261009081225.304319-1-luca.cecchi.info@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous patch in this series ("usb: uas: implement
.change_queue_depth to allow per-device queue depth override") lets
userspace lower a device's queue depth via the standard sysfs
attribute, but only after udev has had a chance to act. That still
leaves a window between probe and udev's write where the device runs
at the full default depth.

This adds US_FL_QDEPTH_075: it caps can_queue to 3/4 of the device's
reported maximum directly in uas_probe(), closing that window for
devices that need it. Applied here to the Lexar ES3 enclosure
(21c4:0003) from the previous patch.

v3: Sashiko AI review found two real issues in v2 (first version of
    this patch, sent alongside v2 of patch 1), both fixed:

    - [High] US_FL_QDEPTH_075 is bit 32 (0x100000000ULL - all 32 bits
      below it are already allocated upstream). UNUSUAL_DEV()'s
      driver_info field is kernel_ulong_t, i.e. a 32-bit unsigned
      long on 32-bit arches - storing this flag there would silently
      truncate to 0 at compile time, disabling the quirk on 32-bit
      kernels with no warning. Confirmed by checking
      include/linux/mod_devicetable.h's usb_device_id definition.

      Fix: dropped the UNUSUAL_DEV() table entry for the Lexar device
      entirely. uas-detect.h's uas_use_uas_driver() already has
      precedent for exactly this situation - the ASMedia/Seagate/
      HIKSEMI checks there match idVendor/idProduct directly and OR
      the flag into a local u64 variable, never touching driver_info.
      Added the Lexar check the same way. devinfo->flags itself is a
      plain u64 with no 32-bit-platform narrowing anywhere in that
      path, so this sidesteps the truncation entirely.

    - [Medium] the 3/4 cap in uas_probe() unconditionally overwrote
      can_queue, which could raise it instead of capping it for
      devices with a small qdepth (e.g. qdepth=4: the existing
      default is qdepth-2=2, but (4*3)/4=3 is larger, defeating the
      point of a cap). Fixed with min_t() against the existing
      qdepth-2 value - this quirk may now only lower can_queue, never
      raise it.

    Re-validated on bare metal with the same Lexar ES3 unit after the
    drive turned out to have been thermally stressed from several
    hours of back-to-back testing (confirmed by reproducing the same
    command-timeout/reset behaviour on Windows with a completely
    different driver stack, UASPStor - ruling out the driver/patch as
    the cause). After letting the drive rest:

    - Confirmed the quirk applies on its own at probe time
      (queue_depth=24) even with the udev rule from the previous
      patch disabled, so it isn't just masking a udev race.
    - Two 6-minute runs of the original load test (24 sync writers,
      randwrite, 64KiB, direct=1): 840-843MB/s, zero
      uas_eh_abort_handler/uas_eh_host_reset_handler events.
    - Same test run concurrently with a second USB flash drive under
      load on the same controller: no effect on throughput or
      stability.
    - Unplugged/replugged the drive mid-load: in-flight commands were
      cleaned up correctly (uas_zap_pending, no hang), the device
      re-enumerated as SuperSpeed, uas re-bound, and the quirk
      re-applied queue_depth=24 on the new probe without any help
      from udev.
    - Mixed 70/30 read/write load: 614MB/s read + 263MB/s write, zero
      events.

Signed-off-by: Luca Cecchi <luca.cecchi.info@gmail.com>
---
 drivers/usb/storage/uas-detect.h | 13 +++++++++++++
 drivers/usb/storage/uas.c        | 13 +++++++++++++
 include/linux/usb_usual.h        |  2 ++
 3 files changed, 28 insertions(+)

diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 4d3b49e..5dd52d6 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -129,6 +129,19 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 			(udev->product && !strcmp(udev->product, "MD202")))
 		flags |= US_FL_IGNORE_UAS;
 
+	/*
+	 * This Lexar ES3 enclosure locks up under sustained deep command
+	 * queueing. US_FL_QDEPTH_075 doesn't fit in the UNUSUAL_DEV()
+	 * table's driver_info (kernel_ulong_t, only 32 bits on 32-bit
+	 * arches - this flag is bit 32), so it's set here instead,
+	 * same as the ASMedia/Seagate/HIKSEMI cases above.
+	 *
+	 * Reported-by: Luca Cecchi <luca.cecchi.info@gmail.com>
+	 */
+	if (le16_to_cpu(udev->descriptor.idVendor) == 0x21c4 &&
+			le16_to_cpu(udev->descriptor.idProduct) == 0x0003)
+		flags |= US_FL_QDEPTH_075;
+
 	usb_stor_adjust_quirks(udev, &flags);
 
 	if (flags & US_FL_IGNORE_UAS) {
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 1b65e03..4cdf7f8 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1067,6 +1067,19 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 */
 	shost->can_queue = devinfo->qdepth - 2;
 
+	/*
+	 * Some bridge chips lock up under sustained deep command queueing
+	 * even within the margin above. For those, US_FL_QDEPTH_075 caps
+	 * the depth to 3/4 of the device's reported maximum at probe time,
+	 * closing the window a udev-triggered .change_queue_depth write
+	 * would otherwise leave open between probe and udev acting. Take
+	 * the min with the existing margin above - this must only ever
+	 * lower can_queue, never raise it back up for low-qdepth devices.
+	 */
+	if (devinfo->flags & US_FL_QDEPTH_075)
+		shost->can_queue = min_t(int, shost->can_queue,
+					 (devinfo->qdepth * 3) / 4);
+
 	usb_set_intfdata(intf, shost);
 	result = scsi_add_host(shost, &intf->dev);
 	if (result)
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 712363c..b436c34 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -88,6 +88,8 @@
 		/* Cannot handle WRITE_SAME */			\
 	US_FLAG(SENSE_AFTER_SYNC, 0x80000000)			\
 		/* Do REQUEST_SENSE after SYNCHRONIZE_CACHE */	\
+	US_FLAG(QDEPTH_075,	0x100000000ULL)			\
+		/* Cap UAS queue depth to 3/4 of device max at probe time */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
2.55.0

