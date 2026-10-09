Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A87379C3C
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 08:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791533558; cv=none; b=H5Uc6D6RLen5xSiNGcxxclcssqXGQrQw+rgILzV9dveCT9Fqr8ha9mqD2c787I/sJgC84n0rlke97gMs4aMac51YM4Bb6nj4qZFjR5j9Gd9YWK1EYUGt6sYTbvqqWCnZwNCni/8p4dwDFS+aPIruJ7bcNxHO6dkPsLShiy18CRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791533558; c=relaxed/simple;
	bh=aFPXM7UhFm/SVZQTxJ63xQjfNm/bYys45ib/RN1PAKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgofzLx62QKH1rDx+Mg6RIGnglTnpm/7JHwh043TvJfc+P4tVRpH1Ko4TbnR7FmCowAj9G79DvvmOuVmpbucP/im+TiDX2YRw2GUvfePPskWA2q7PknXXPOblrkyZiWokFvO8U2IGBnUDvZsMwFH+vVgT9arU6LHsRkR8bfyhH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TfSh7grO; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfSh7grO"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48c5358fc28so3858136f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 01:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791533548; x=1792138348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cFpoGNw4wxXbDG3Mm1/vSzmzrhyH7cgrIzeltqcj+/A=;
        b=TfSh7grOJ+/IDYgbtTm5eOkFU0jVEZRgMZxfuGLrFSDb3+WyWvXH/f/TT5D7U4Oq+O
         /62hM/bVqyOv6v0L72401Nb8obuwqRFy/H48gC1NF/DAJT1KAM/q/Zp+cF+fJ0GZaJ6k
         vA3apW4ZonLn4uJNkFoVtlMuyeD/nJvq2CvymR3LSVP59QP839oUhQYoT9THWc3FZgYG
         EqL9mM9er1sB6GAp6qggtFypvquI97TvxrpjJ3o6OAgZjc6/bfDpAgXXe712O9t7Tytp
         mzO21tBW/JoEbIrxnIot2so5nA/WbRq4eUlEF+UjtX4u/K4ySFVhVt/h9dPcZsxxbCmf
         TFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791533548; x=1792138348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cFpoGNw4wxXbDG3Mm1/vSzmzrhyH7cgrIzeltqcj+/A=;
        b=Ldr5lwazxN6iexhBOnRzuiaCzEP7DhCossKaV5M0P4E2RgWyv5/WparIJXc6yWHRjV
         L3u/h9g+1Wk1tcnXAlrJ9U2mIInB/R4Vfo72WPM/Q207lC8Q9dWWVQo2kvB74whhOWuF
         ZSx6E82Xw6sKp9ViJdymu0q4mQcNxI/eSOvR7/djfs2CXqJgngqNwn0QcwzpgFgPvMcD
         wpXFfSbJ6IPuosMNrgS2qnFeTe9xOWoL/Cdu1+tfxpOXrGQo+W77SuLSGAFo5XPCCROn
         Sx2sZ6f5pml2Hs6sxYLwuAOJ+N4qCMiGV8J33TNfCtNeeXmNMj/nE88QofqroI+TNHzI
         1G0w==
X-Gm-Message-State: AFq9FYLlTrwm+DZqERWKzmlldwzWqVdm5Gb/5HY+BwgGQ3X575RnaNnw
	Xvs6Ih439VMhKI8FEWsGhrhAV7aMByp0xj1RwXz1hwbBQI8rSr3GVsZy
X-Gm-Gg: AYBFou2amFqN0w3V6JLke7TG3/3+/vpMkBoKcBaGPoxAu0rjSyL+6w0eURUM1RB1cng
	DMWPcS2azVWvQmfkvP/i+Je48UTZrXfYeE7llMPm51Yjoev24GKBg0j5+Ces9G4XK9E+H0LSK+U
	9mjcLgd51Qzh5rUiADluSoN00wz47k7xSYOMB6T6TksV2LPEOVV97Ji1g8zQgAvVhmVKC2wqNTg
	5yEsIFbP5GkPAd6o9ZlkX7qRnzUPL+u8KNKzpwNaa5jus1NNopZy8+maAXhWLftpK3bqUOM59rQ
	9fhIMd7MP4EgeFnZZsxvXYkEr+Te/XDcnRv3Y6Tk1vQCviicazjF8N6oQClwBQvZ+hFKFffdyhN
	fyv2kbqGNg2yRrcbjhz/2hxTA9oJqQdcLLGN4dyQl9jZqeKgHV86AWcPcl+VCjvTCNE7T02LnrQ
	WY9Swa7xr8oEWChrDaY+VXn53VXAyl+o/kFEy/5VnK5C/ZyD2lxTScIpg1ViBF8nGzWqZQ4APnv
	/50Zsa5sw6Y3Q2K9sQ5DcN7NScsYdjbQStbGrlzmGn9a485U4sDDDnxvpc=
X-Received: by 2002:a05:6000:288a:b0:48a:f11e:6d57 with SMTP id ffacd0b85a97d-48dbaadb3a5mr1880526f8f.19.1791533547850;
        Fri, 09 Oct 2026 01:12:27 -0700 (PDT)
Received: from darkstar.tail74c586.ts.net (mob-31-158-7-150.net.vodafone.it. [31.158.7.150])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db93d6069sm2405577f8f.0.2026.10.09.01.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:12:27 -0700 (PDT)
From: Luca Cecchi <luca.cecchi.info@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	oneukum@suse.com,
	stern@rowland.harvard.edu,
	Luca Cecchi <luca.cecchi.info@gmail.com>
Subject: [PATCH v3 1/2] usb: uas: implement .change_queue_depth to allow per-device queue depth override
Date: Fri,  9 Oct 2026 10:12:24 +0200
Message-ID: <20261009081225.304319-1-luca.cecchi.info@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009080341.295646-1-luca.cecchi.info@gmail.com>
References: <20261009080341.295646-1-luca.cecchi.info@gmail.com>
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

v2: guarded against devinfo->qdepth holding a negative error code
    left over from a failed uas_configure_endpoints() call in
    uas_post_reset()/uas_reset_resume() (found by Sashiko AI review)

v3: dropped that guard per Oliver's direct reply - qdepth going
    negative is a general bug independent of this patch, which he is
    fixing separately at the source. This patch just happened to hit
    the symptom; it carries no workaround for it anymore.

    Trimmed the comment above uas_change_queue_depth() per Alan
    Stern's feedback - it described the pre-patch state rather than
    the code itself, which won't be true after this is merged.

    Also switched devinfo's lookup to sdev->hostdata (same pattern
    already used by uas_sdev_configure() and the other scsi_device-
    level callbacks in this file) instead of casting
    sdev->host->hostdata, which was pushing the line past 80 columns.

    Re-validated on bare metal with the same Lexar ES3 unit: two
    6-minute runs of the original load test (24 sync writers,
    randwrite, 64KiB, direct=1) at 840-843MB/s with zero
    uas_eh_abort_handler/uas_eh_host_reset_handler events, plus a
    mixed 70/30 read/write run (614MB/s read + 263MB/s write, zero
    events) and a run concurrent with a second USB flash drive on the
    same controller (no effect on throughput or stability).

Signed-off-by: Luca Cecchi <luca.cecchi.info@gmail.com>
---
 drivers/usb/storage/uas.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2651629..1b65e03 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -910,6 +910,20 @@ static int uas_sdev_configure(struct scsi_device *sdev,
 	return 0;
 }
 
+/*
+ * Implementing .change_queue_depth allows users to lower the per-device
+ * queue depth via sysfs.
+ */
+static int uas_change_queue_depth(struct scsi_device *sdev, int depth)
+{
+	struct uas_dev_info *devinfo = sdev->hostdata;
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
@@ -917,6 +931,7 @@ static const struct scsi_host_template uas_host_template = {
 	.target_alloc = uas_target_alloc,
 	.sdev_init = uas_sdev_init,
 	.sdev_configure = uas_sdev_configure,
+	.change_queue_depth = uas_change_queue_depth,
 	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_host_reset_handler = uas_eh_host_reset_handler,
 	.this_id = -1,
-- 
2.55.0

