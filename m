Received: from mail-qv2-f42.google.com (mail-qv2-f42.google.com [74.125.230.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7CD2F7445
	for <linux-scsi@vger.kernel.org>; Sun,  4 Oct 2026 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791114125; cv=pass; b=SvJjZitPakPT2XLEJB8xgEY0/tGViwl8mCL3IUmPZba10rjPFSG4G1/8Ao/kuZsbOXvLmIJ3yVTaGmGy/x4vrI01CLt6nBbKRmlG9GXkKzSzQDhVESM7yVfy1alQFmiQWIvug5nwOKG7dVobUO2u1lFa2QcYiR/ce9Zs+tOxh0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791114125; c=relaxed/simple;
	bh=0DlZtEOWuWcbn2hX5FV5823ncSzwSSZ+kJrvNA9lmus=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=N7yP/SDzQWwtvryT8DWMwQQjNJwFLOpvAoRqwFervyVfJow40pP8iJ/YMxwAu/xYnf416/cc+YtgwW7oWUDUk/DVW64Y/bge7izfzocrF4fQlDd340If4yeGDOiq9m/UQUzKpqgTbJ2zV3um3eyQklQKQLoKMyYx9izj1ApaEUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b+svOQgc; arc=pass smtp.client-ip=74.125.230.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+svOQgc"
Received: by mail-qv2-f42.google.com with SMTP id 6a1803df08f44-918a81965d7so11604546d6.0
        for <linux-scsi@vger.kernel.org>; Sun, 04 Oct 2026 04:42:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791114122; cv=none;
        d=google.com; s=arc-20260327;
        b=TqmNpYH+T7C1HDazjBa2LImdM08LfZmeHBXavPstwWvo5hLPE03PPFRhRGR1NtaAXm
         Nx5aKJKn2GKliJCINMlO9UF3Yw65sFIV7uKU8F3bk3CqzEjfXPueIYZ+RChiLPSW9bdC
         PyYAqMPaml1DrCLGHI9HT5RmWgvFqss1Hbu9O+cjNEXGUslIG9XIdK4W7BQlfGCXXFYC
         LJPwVj6hEM//SU1f+eFLl6F8dSuVJv1WlP/Ei3Hw6GC3yWXouBfsiyq80RZeWhOEJF1/
         UIz2AFZ07bvIJh1Ow3GrcnEVkn7oNJmBtebOjn0dn/TJ99OIjZ/DdFl7lv+ytfF4T42Q
         hdqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=NNwc7R9EEISunYPcpb2H5lqLQeV15gnBcr6epdIhiiQ=;
        fh=8qo8kM/r2wHBmQKfWxInM+719FPOMXWd5qerJ8UrFYY=;
        b=eyWJ1n4mYQe6cc35jPaJozLKVr6+6jODphm1HV9KHvDk+hDJwVYs7pYwKFJwfcf1KF
         1J3bp1cJfiIIxt81hPkJ68WQ8/FIarjIrUDPKdddn73EDGka7Wgb9sgr4ZD90FhvjrxR
         bQ5VHruw4DbJdbRyqb7dUA2yzOJ/TFzQpmMSobg52fRXvDGGW2qIavjpMRsZUNcnKmoF
         58jeBQmbCrz3c1XUUS/ZEWGstUfLMHuGkUzTOmiZgrCwcPFHeqIeuHOCWgjp2Z4ui01Q
         in2S1cq+7kFu8CDfMtdsDCZqXEa4c1aReum+8q41dF8c143gtBq0neaIicBlvOldNQob
         OkEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791114122; x=1791718922; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NNwc7R9EEISunYPcpb2H5lqLQeV15gnBcr6epdIhiiQ=;
        b=b+svOQgcTUhBT+66+nQamSlIh5BFv6QHWc0j/TY89jjAcUH1G3EbmP4NlZ1yt6aDa3
         Y01dHJHlzqBHDd+qDmpd5G+8/XF2I4L+U+OQIkFP3thG1u30P1DO/F9jjX7JBwNDWidg
         cM2tZMwmdD9OzhTKnWRTKM1ki3mY8n+rOg/HEHdk7uC23CF8SdkYoebaJF3xvD5Tgkc9
         02h4xfo/sB36fbvUiHLlfQUgGG1M7voVTccOWHwFVl14ZXwc16PUFU3bgMAmm25/8W2a
         7AZDjFYdUe6Ddix2H1NOUfU86pjS+TdrRUAXFh0Tx71c7uu1z2WUwOw6RVLKE5e3RH+3
         oeig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791114122; x=1791718922;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NNwc7R9EEISunYPcpb2H5lqLQeV15gnBcr6epdIhiiQ=;
        b=yKEkJSlHM/w3u2gmr8hL3GXCy+695YNG89xrsou9riTruGFiKYtKrHZ6sli0yRpJ2v
         /EgRkMDfRe8kah7Aws8s7L56Go/qek5ABJGY8HGVyhnzXW+PWqLxPmZzNeVKmKFSHxk2
         m4U4a64Y2l40mVSgKSz0iLcvNgAgg/x2OfQKyyJa93Sj442BD8kONmiEgmbnlDzDLZ7/
         TDZHMzySAf2LSztD4+XBTbLrv6NPaAofLe5fHp6Mz/mhlJfSOccQ4gceQHkWmOcYLF92
         J4TjfmySj0dqxl7PZKQuhpIjkBjWPom5KWdnpjLGhsowrCV2Qqt/ZJj0O4PEOyVKQfkp
         Hfhg==
X-Gm-Message-State: AFuF++m8AHwHOn0/2mv1Ybegj4+kXo8ff8PoDiGAJzJ6VH79joq9a9vo
	Fp1e3uCeB01kgbd5GI7CLD5DqSSTk2v9Pl4RXdNuhviHGhufONXPOafpLUHsmTcy95B4QBxc6vI
	4PUNkPsv2t1Lxhg8enH9ehK9iIsBjg9w=
X-Gm-Gg: AYBFou2FCJy5nCGq3apOwOjpyG+/qiR+gEnsq03MEWDg2PqNpmpCP1tC9Ox7q+nu3hV
	wx9XSzNgc4fO97RL6/TpsEsB3ajiFwMyuxTKhxUYFKiGZ/iz3GSd+OwSinH6AYdZjniXH5sBk6h
	FtasgVHk0zc+2KUm0AhnbgC/0Fy+KwwBpj3kUEP/SEJa1ybEQ05Ciy8uTiWPMqTkmr+aoSKvzYx
	XjHS4rseHoYrODPPsXRS7SJ3kzfA/dfS7tBrut35vBK7FLkBetVXyeftn68BnXKsPVIkHPGqtRb
	hWA16JxTqokHXALi2x3Id0Hw1IRhh75V/nDgiBy7/tgpclCmJKJiwjlS
X-Received: by 2002:ad4:5f09:0:b0:917:9ec0:f0f8 with SMTP id
 6a1803df08f44-917bff2b3bbmr163409776d6.2.1791114122307; Sun, 04 Oct 2026
 04:42:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Luca Cecchi <luca.cecchi.info@gmail.com>
Date: Sun, 4 Oct 2026 13:41:50 +0200
X-Gm-Features: AclHuK8eS10rujqX1x7jV30AUPiCFGMA1PI5RotGAddA6hPu6DPQ1koBorDEyCQ
Message-ID: <CAKVTVpi5WaOcmg0Tx8+wG01ReD0kmZJv-ZEQF_XusqF-PH3F9Q@mail.gmail.com>
Subject: [RFC] usb: uas: implement .change_queue_depth to allow per-device
 queue depth override
To: linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, oneukum@suse.com
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

First time writing to this list, so apologies in advance if anything about
the format is off. I ran into a UAS bridge that locks up under deep
concurrent command queueing, worked around it, and ended up with a small
generic patch that I think could be useful beyond my specific device. I'd
like to hear whether this approach makes sense before trying to turn it
into a proper patch submission.

THE GAP

uas_host_template does not implement .change_queue_depth. Because of that,
the standard sysfs queue_depth attribute stays read-only for every UAS
device, not just mine: scsi_sysfs.c:sdev_store_queue_depth() requires
sht->change_queue_depth to be non-NULL before it allows a write.

uas_probe() already defaults can_queue to qdepth - 2, with a comment
acknowledging that "some bridge firmwares" need extra margin:

      /*
       * 1 tag is reserved for untagged commands +
       * 1 tag to avoid off by one errors in some bridge firmwares
       */
      shost->can_queue = devinfo->qdepth - 2;

That margin isn't enough for every bridge. Right now the only way to work
around a bridge that needs more headroom is the IGNORE_UAS quirk, which
disables UAS entirely and falls back to BOT/usb-storage - a large
performance cost for a queue-depth problem.

THE PATCH

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -910,6 +910,23 @@ static int uas_sdev_configure(struct scsi_device *sdev,
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
+     struct uas_dev_info *devinfo = (struct uas_dev_info
*)sdev->host->hostdata;
+     int max_depth = devinfo->qdepth - 2;
+
+     if (depth > max_depth)
+             depth = max_depth;
+     return scsi_change_queue_depth(sdev, depth);
+}
+
 static const struct scsi_host_template uas_host_template = {
      .module = THIS_MODULE,
      .name = "uas",
@@ -917,6 +934,7 @@ static const struct scsi_host_template uas_host_template = {
      .target_alloc = uas_target_alloc,
      .sdev_init = uas_sdev_init,
      .sdev_configure = uas_sdev_configure,
+     .change_queue_depth = uas_change_queue_depth,
      .eh_abort_handler = uas_eh_abort_handler,
      .eh_host_reset_handler = uas_eh_host_reset_handler,
      .this_id = -1,

Nothing changes by default for any device. It only becomes possible to
ask for a lower depth, per device, through the existing sysfs interface -
e.g. a udev rule matching a specific idVendor/idProduct:

ACTION=="add", SUBSYSTEM=="scsi", ATTR{type}=="0", \
  ATTRS{idVendor}=="21c4", ATTRS{idProduct}=="0003", \
  RUN+="/bin/sh -c 'echo 24 > /sys%p/queue_depth'"

THE CASE THAT LED HERE

Device: Lexar ES3 external SSD enclosure, VID:PID 21c4:0003, USB 3.x
SuperSpeed (qdepth=32, can_queue=30 by default). Host: Lenovo 82KU, AMD
Ryzen 5 5500U, onboard AMD Renoir/Cezanne USB 3.1 controller [1022:1639].
Kernel: 7.2.7 (CachyOS-BORE; BORE only touches the CPU scheduler, verified
it doesn't touch USB/storage).

Under sustained heavy concurrent random writes (32 processes, one
outstanding command each, 64KiB blocks, O_DIRECT), the bridge stops
responding entirely after a period of healthy operation (anywhere from a
few seconds to several minutes). No STALL, NAK, or malformed reply visible
on the bus - the device simply goes silent. After the 30s default SCSI
timeout, the kernel aborts every in-flight command (uas_eh_abort_handler)
and resets the device (uas_eh_host_reset_handler), successfully.

A usbmon + Wireshark capture of one such event shows a clean 3-pipe UAS
cycle (32B command on EP 0x01, 64KiB data on EP 0x04, status on EP 0x82,
~160us per cycle) right up to the last normal packet at 10:27:45.752012,
followed by complete silence - zero packets in either direction - for
exactly 30.610467 seconds, until the first abort-triggered URB
cancellation at 10:28:16.362479.

I compared against the same device on the same host under Windows 11
(UASPStor driver): no lockup, 733MB/s sustained, max latency 194ms. A
USBPcap capture there showed Windows also keeping up to 30 commands truly
in flight (not serialized), using stream IDs 2-31; Linux stock
(can_queue=30) uses 1-30. Same count, one-off range, both inside the valid
1-31 window for MaxPStreams=5 - so "Linux reuses tags out of range" isn't
the explanation, and tag reuse cadence on Windows was comparable or
faster than what I measured on Linux. I could not fully isolate why the
same chip behaves differently between the two stacks (different
filesystem, and USB scheduling under the hood may differ in ways not
visible at this level), but empirically:

- can_queue=30 (the current default -2): locked up in every single test
  run (4/4), including one using parameters matching the Windows
  comparison exactly.
- Depth capped at 24 (via fio numjobs, before this patch existed): zero
  lockups across multiple 360s runs and a continuous 1-hour soak test
  (1.36TB written), at 819-823MB/s - faster than the Windows run.
- After implementing this patch plus the udev rule above: 6 consecutive
  clean runs, including with the application still requesting 32
  concurrent commands, confirming the kernel-enforced cap protects the
  device even when userspace asks for more than it's given.

QUESTION

Does this seem like a reasonable way to expose this, or would you rather
see it handled differently (e.g. through the quirks table with a numeric
value instead of a boolean, if that fits the existing infrastructure
better)? Happy to adjust the implementation, rerun tests, or send more
logs/captures if useful. I can also follow up with a proper patch
(Signed-off-by, etc.) once the approach itself looks right to you.

Disclosure: the investigation (usbmon/Wireshark analysis, the Windows
comparison, the fio testing methodology) and this patch were carried out
with the assistance of an AI coding assistant (Claude, Anthropic), under
my direction and with every result independently verified against kernel
source and live system behaviour before being included here.

Note: my first attempt at this email bounced from both lists for
containing an HTML part (a mail client default I didn't catch in time) -
apologies for the noise if a duplicate reaches you, Oliver.

Thanks for maintaining this driver.

Cecchi Luca
luca.cecchi.info@gmail.com
