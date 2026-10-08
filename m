Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC18499F3A
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 12:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462372; cv=none; b=NLvrUk8Pwiw3z5iW0EzknFPeYzaZl9su53Yitld6+HUmkz0X45t3/lXqKZl9YNfxatUOQM6WRfZsXrLwNJW8Th/SfEjIiJb657MpQxq686ZtjzIfBZwZ2h32fskjx+q8Ksl8AueEHFN25xLuFGvdppTquO/L5CUD84byOgGGLS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462372; c=relaxed/simple;
	bh=Bs+iBiD10QCyQcfSdjj7ySU1nu0oryBu79Ovzx25rjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T76/bn5MLk1GMX2eZ+Qka5x1Pidjm8DaISSp9S9EFKXjfvyTM7ELpw4EmE9kgMKu2OAgU+ftgTg/zp9FHQkRZUKowGqRo49RIC1IDx5bkyzM6eh83TcOQ/OZ/ZRCwX9zqEmWdxJ4YvMowtfgQrPqAmIMqkBj53ZdBbnRrCaWjOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XpQgmaFi; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XpQgmaFi"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48c4be28b82so2644702f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 05:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791462369; x=1792067169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0HSiTIvoAk4tlJxEwcQcLh/RkXI90ywllTfjG9Xv8n4=;
        b=XpQgmaFi63c3fhjFycG1CFgotUZ0T8oaUX35YPJvjaRIGGfSwd/3CpmJbi0UVBWz2Z
         TxGLs2LRrNPAe4k13sEX7Fv5TVSsmodxCaDPyUQdUM2U4Yh+AxdnsqML0pmqqCKb+t8f
         b+nfS9jUQeHAIGjpDt4bZfpQdlBwzQttRfSck1h4I0dxpnMYGp2Q0HJqVP/Y6hZTU1Ko
         cuo2IeredTCtJ9T50eGChSuBnUFu+HxiO5b2yPQsRE8e28gb9N7Hq54tw5i/I7fHB8cO
         9Wyqqn+Ur0zMuRkX2129Fyud3NjitmA0/MaJoPNt4y0wKtStjylfB1XkJTfJ7uRa63dB
         Hxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791462369; x=1792067169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0HSiTIvoAk4tlJxEwcQcLh/RkXI90ywllTfjG9Xv8n4=;
        b=sogetqYSBRXAJn/XvD+fcM/4JxT+CTVbQFd+IQlpYFPd5IrhPi1Hct5onX1U5ptz7f
         79mXTHtjNtb9rVi2JlGxhWiS8IgVvDNHfNnkHkrxA2ilA8TzMG6BrgMyssunhdkd+qIz
         t74dsqPlb5aMbhDtTgVXKBfjbmaY52BZKSYSbV4rq5EW4EhYqJfIiNt7D/tgsWiBBo84
         ZxUEL8Z8eIqyc9tsaCDTG1Hj+lwWPH1KiJWh95mIIPfW3wkCZJMkT7vl8SySxSqHM9JP
         G/v4mPqa0yjL0RlXMvylr/Of9YJgsxFn3UKej8swbnGILN1dJGZrcMLAbisFiMZ5mtkO
         coUg==
X-Gm-Message-State: AFq9FYKbUsmqZJ2Nu35iTGZ+3As2nv6l/fBaiHtgiALuHPtuooV1jGkf
	6fjIgHJk0pMATKuQG0zOs00bUKYIjhA5mIrMv3yD/fPmSg2obrHI7Xgs
X-Gm-Gg: AYBFou0qhnneKmBd6CAJGVyt+jaUEsWYeC2GjFdtOk0yap/S4usUErnl2uAebs0/08U
	D1gyy50bs/B6quPVCyDAxAOvCYj2h6ou+Fxcs6unmDeZRL5xOfiRnh7iE63o85TQJ0ZtAA4dbaR
	hN1fxUQEAIEIEYmGVmxYn+D+vJLB/PRouevC7Dz7rM2+KpQfxzRclC/Gsuw/6uDn+mVR+5UTBYx
	qb500dtZTnDHLB3bgHBorGLjqxQV6eO8Ijh/5p0/gAgCMkUSPZabC1JcK8Kz92fuIESepSnq1Wy
	GZkJqmBeB3oRfQcb8SyQTEJyE3JpS1sA2+qiBJ+wU6pAU+2jqmyJHt+eTSwl+LSnHOcDWWqSYBD
	KYe3AF+No0JiqsRhHSQWKYOu6y0kaQjNhzmwXwfoZ43R/THzzsXDrCq5OfSwv84xM5ye0FY9ziT
	7ETqOO7VuNAE797Vqs+DnOhwPjhVFij12Jpiyw5N1mWJCtzFOCMKWchMzz0r1MJ8mOx8XlNgy1D
	1k6nuZ1TBzueywt55Og6TspNSU=
X-Received: by 2002:a05:6000:25fd:b0:48c:77aa:2f78 with SMTP id ffacd0b85a97d-48c77aa320dmr7627482f8f.56.1791462369151;
        Thu, 08 Oct 2026 05:26:09 -0700 (PDT)
Received: from darkstar.tail74c586.ts.net ([217.201.94.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d2e2dcsm12348992f8f.42.2026.10.08.05.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 05:26:08 -0700 (PDT)
From: Luca Cecchi <luca.cecchi.info@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	oneukum@suse.com,
	Luca Cecchi <luca.cecchi.info@gmail.com>
Subject: [PATCH v2 2/2] usb: uas: add US_FL_QDEPTH_075 quirk to cap queue depth at probe time
Date: Thu,  8 Oct 2026 14:26:04 +0200
Message-ID: <20261008122604.1862534-2-luca.cecchi.info@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261008122604.1862534-1-luca.cecchi.info@gmail.com>
References: <20261008112645.1820678-1-luca.cecchi.info@gmail.com>
 <20261008122604.1862534-1-luca.cecchi.info@gmail.com>
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
attribute, e.g. through a udev rule matching idVendor/idProduct.

That is not sufficient on its own: relying on udev to act after the
device is already probed and in use leaves a window, right after
probe, during which the device is already live with the unmodified
(and, for some bridges, unsafe) default depth. A lockup can happen in
that window before udev has a chance to write the reduced value.

This adds US_FL_QDEPTH_075, a quirk flag that caps can_queue to 3/4 of
the device's reported maximum directly in uas_probe(), before the
device is ever added to the SCSI layer. This closes the race window
entirely for devices known to need it, while leaving the
.change_queue_depth path available for anyone who wants to tune
further.

Applied to the Lexar ES3 enclosure (21c4:0003) already described in
the previous patch: qdepth=32, so this caps can_queue to 24 - exactly
the value empirically found stable during that investigation (zero
lockups across multiple 360s runs and a 1-hour soak test at that
depth, vs. lockups on every run at the unmodified qdepth-2 default).

Signed-off-by: Luca Cecchi <luca.cecchi.info@gmail.com>
---
 drivers/usb/storage/uas.c         | 10 ++++++++++
 drivers/usb/storage/unusual_uas.h |  7 +++++++
 include/linux/usb_usual.h         |  2 ++
 3 files changed, 19 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 971a47f..95374dc 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1085,6 +1085,16 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 */
 	shost->can_queue = devinfo->qdepth - 2;
 
+	/*
+	 * Some bridge chips lock up under sustained deep command queueing
+	 * even within the margin above. For those, US_FL_QDEPTH_075 caps
+	 * the depth to 3/4 of the device's reported maximum at probe time,
+	 * closing the window a udev-triggered .change_queue_depth write
+	 * would otherwise leave open between probe and udev acting.
+	 */
+	if (devinfo->flags & US_FL_QDEPTH_075)
+		shost->can_queue = (devinfo->qdepth * 3) / 4;
+
 	usb_set_intfdata(intf, shost);
 	result = scsi_add_host(shost, &intf->dev);
 	if (result)
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index d6f86d5..d41f206 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -167,6 +167,13 @@ UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Luca Cecchi <luca.cecchi.info@gmail.com> */
+UNUSUAL_DEV(0x21c4, 0x0003, 0x0000, 0x9999,
+		"Lexar",
+		"ES3",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_QDEPTH_075),
+
 /* Reported-by: Icenowy Zheng <icenowy@aosc.io> */
 UNUSUAL_DEV(0x2537, 0x1068, 0x0000, 0x9999,
 		"Norelsys",
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

