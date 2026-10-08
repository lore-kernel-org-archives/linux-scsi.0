Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58343BE172
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 11:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458811; cv=none; b=GjKgF3vtIt+WWVdCOKF+7i5V+B0/UhP3IxN2z5W1rLRXaxNYKu618cName+g9eRGjYI8Hh0C0MwtVzHWmJZPfE0vRQsyZGMIQtIPNrht27yOUVk/MLRmXrJ79CKyrEDzV7dFFIi6PmS+7lJx4QGIdh/NR+GitfdzVKtWXZMnkiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458811; c=relaxed/simple;
	bh=AZeZBIDeh5u7dy3d92kG69drFR2UguJCjl/XA2N1EIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTXjsbR/epGu26fbh496DkuzQL/Ov8e86MGXlPclNuy3S6BHPQrF9nHQxFShRY5fc4OIjwaxtuGlAbFUoSmXy+DXYJqGu5J4n2R4T+dq41W6x1AGESkAb6TSMlGJOYQYs/VTP8H9+IySe0n8FiyqZySRQbQVE0ETYG2yx9Y9/dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L0nVJwwT; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0nVJwwT"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b02b1b4cfso433266f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 04:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791458808; x=1792063608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DHbdqV3WrEigCNy1tObIuBbS8ZiZjytasJHGB0ISHRk=;
        b=L0nVJwwTp7+DXGgnI781BgJ22G4gbklWbtj5kW20Oq72Waez5YLNhiQAqVYlbjKFGG
         nEKHkA9G/dkfN3oHBjFhC8utZnfzxb9vlUJQhCwotv22Jy+qn22bapUFn/vY3sMguERa
         1LwQCJciEwbxO7TG/AnKfL458QN2Uqzsz1jbk7iyh4e9TPW24nMOY8Nj0V6qaYQ9VC1z
         qoj8qaPpOGKeiH+vEl7B4bPehWTOtOyrfS/3yzbvv/13mqeyhvfAxuZXU78hyiUVPJRf
         mV5B6gE/Qsk3Zax+5pkGj8YG3CrG7cEVBAKDK77cI1E7AN2maiCfIxNQp/2NcXQuQ7OK
         xtCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791458808; x=1792063608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DHbdqV3WrEigCNy1tObIuBbS8ZiZjytasJHGB0ISHRk=;
        b=20YQjRGAK+YR4gaoXcqnF9kzr/0E7Hkru7DZOVkFuJ7WFdfU7vZ+VsqHLHiZPGt2do
         OF2UIsuWKgZzUeroIVJ5eRvcFKjhPSjL6CYmJQri+IUnCS4FrTxgIbU2s69RzlAy/jgM
         ahyQ9nWbqed5zjOanWM12XKKyimZnUAmj5i5BSYClfgc+qWou5dqiKJoh45U0Vwp7Wg6
         nnFLZXoDhFFiZrssVOe7PeL4mxl1p/okPRavN4cb37GJ+2alV6fuhACDdV0+9bGgg6x+
         Xlsml7DYspxNLDX2Z4oYcS4u1wAlhN4fMbNLMIOtwGufcUOrMe7CYUr0RhGHU5GauF4E
         FKRg==
X-Gm-Message-State: AFuF++kHh5KFECJlzIpb5c+s0LxZYr9KqdYMGo/nmuP4vKUEinTNcto1
	xIds3/DmLdvJ7QsTF7fuXWMFtVIwsW5+odeKVgbfKXzwVfR7J8vL1NyAlkIbAg==
X-Gm-Gg: AYBFou0KBqcQliUhdmuKrWeeqrBvTWk2FDdKlFzKSF372L+Rzp0lfN6ggWDE0k6prQ0
	cmP34uUsEFLEXtc41AETvl8TwAIMLSLhOdxDaC81qQM//nDtaDQOLtu7O2n8wGzKWtvs7MbBg02
	qtGyuLqo7pyw0ORMatSLi9tq0eiEJQKtOoEgwXGRC9J8jsGYEqvm6GJlhfJ7h8CwuvbRL7rfxfl
	FMuRa0BZ8pRxmc5kywWxMeJY0fldq4RdjhcQykwg/CTYYWtN5tCO+MsTXYh0hmtnTg2caJumISC
	Zvh/sfEATebJGMp+g/aUsvYn2YUVzsrgmfAKqHebsL1am2DcTxJHdUVF0Cm/et7ziwhD580fiI+
	YYNuCSOosplrmePCBgRCdM7RuWg+uNniQIK9n18AFzLawW114fpLVtjEX3CJPemv2V4ZwZgqukN
	dTnGsJR3KB2S90fG3jTRfE4dOHIHEBjIKvFJhW6yGynQEBgoVnsxo/0ft1M4BR5gTBGGqPtSTwm
	P/ObVuDA9lDZ0zP2x9ukL4ozTSVpOwQMRYlQt1pZLD498z7//iSWoB5ChXM0A==
X-Received: by 2002:a05:600c:4691:b0:4a1:6282:1cf3 with SMTP id 5b1f17b1804b1-4a1851b3756mr46001435e9.9.1791458807613;
        Thu, 08 Oct 2026 04:26:47 -0700 (PDT)
Received: from darkstar.tail74c586.ts.net (mob-31-158-15-193.net.vodafone.it. [31.158.15.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18445b6b9sm67716975e9.8.2026.10.08.04.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 04:26:47 -0700 (PDT)
From: Luca Cecchi <luca.cecchi.info@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	oneukum@suse.com,
	Luca Cecchi <luca.cecchi.info@gmail.com>
Subject: [PATCH] usb: uas: implement .change_queue_depth to allow per-device queue depth override
Date: Thu,  8 Oct 2026 13:26:45 +0200
Message-ID: <20261008112645.1820678-1-luca.cecchi.info@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <f82a72b7-6122-4bbc-adf4-2d08706344a2@suse.com>
References: <f82a72b7-6122-4bbc-adf4-2d08706344a2@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uas_host_template does not implement .change_queue_depth. Because of
that, the standard sysfs queue_depth attribute stays read-only for
every UAS device, not just mine: scsi_sysfs.c:sdev_store_queue_depth()
requires sht->change_queue_depth to be non-NULL before it allows a
write.

uas_probe() already defaults can_queue to qdepth - 2, with a comment
acknowledging that "some bridge firmwares" need extra margin. That
margin isn't enough for every bridge. Right now the only way to work
around a bridge that needs more headroom is the IGNORE_UAS quirk,
which disables UAS entirely and falls back to BOT/usb-storage - a
large performance cost for a queue-depth problem.

This patch wires up .change_queue_depth so affected users can lower
the depth for just their device (e.g. via a udev rule matching
idVendor/idProduct), without disabling UAS altogether. Default
behaviour (qdepth - 2) is unchanged unless userspace asks for less.

Tested against a Lexar ES3 external SSD enclosure (VID:PID 21c4:0003)
that locks up under sustained heavy concurrent random writes at the
default queue depth. Capping the depth to 24 via this interface
eliminated the lockup across 6 consecutive test runs, including a
continuous 1-hour soak test (1.36TB written, ~822MB/s, no
uas_eh_abort_handler events).

Signed-off-by: Luca Cecchi <luca.cecchi.info@gmail.com>
---
 drivers/usb/storage/uas.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2651629..74fc438 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -910,6 +910,27 @@ static int uas_sdev_configure(struct scsi_device *sdev,
 	return 0;
 }
 
+/*
+ * uas does not implement .change_queue_depth, so the standard sysfs
+ * queue_depth attribute stays read-only for every UAS device (see
+ * scsi_sysfs.c:sdev_store_queue_depth(), which requires
+ * sht->change_queue_depth != NULL). Some bridge chips become
+ * unstable under deep command queueing; wiring this up lets affected
+ * users lower the depth for just their device (e.g. via a udev rule
+ * matching idVendor/idProduct), without disabling UAS altogether.
+ * Default behaviour (qdepth - 2) is unchanged unless userspace asks
+ * for less.
+ */
+static int uas_change_queue_depth(struct scsi_device *sdev, int depth)
+{
+	struct uas_dev_info *devinfo = (struct uas_dev_info *)sdev->host->hostdata;
+	int max_depth = devinfo->qdepth - 2;
+
+	if (depth > max_depth)
+		depth = max_depth;
+	return scsi_change_queue_depth(sdev, depth);
+}
+
 static const struct scsi_host_template uas_host_template = {
 	.module = THIS_MODULE,
 	.name = "uas",
@@ -917,6 +938,7 @@ static const struct scsi_host_template uas_host_template = {
 	.target_alloc = uas_target_alloc,
 	.sdev_init = uas_sdev_init,
 	.sdev_configure = uas_sdev_configure,
+	.change_queue_depth = uas_change_queue_depth,
 	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_host_reset_handler = uas_eh_host_reset_handler,
 	.this_id = -1,
-- 
2.55.0

