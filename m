Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B883921F6
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 06:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776236219; cv=none; b=WsOwR5196a78sA8WnWXr+95PGq7rbB0vql2f5J59IjPxlgSfxBApcvfhsIoVL+TMqxJpOJfQypvHoXcERD3soyfqzF1p3jYXwBFN4UtThWVX7sU8d748gBhuzn3ZGZwYagidzF3uSDYDNLceUoxriDTaV7USoTyC9Y3/nfRKN3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776236219; c=relaxed/simple;
	bh=Et44yq5PHKoFwmSzMbKS0IZ5nZ1YukjypTBHXvTO+js=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DmToOWu1AMvMqqWyXBFJ2jFb8ZwFaAV+SnZoIVoLi7znX8y1ux3JESvQbujldNYtxQErAhStjye3biMTCOnpnf/BAU/8wFoFQa7Ixaes8JE6Wq27AvvLWxKAjgR2DqOakXo0thT1mOqtQcbGQiDnP1bxI1feQEbiAWxvW5nESdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ximv50Fj; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ximv50Fj"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48897fd88ebso65778205e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 23:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776236216; x=1776841016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uTzmmQmbSiBeZkId4dhEkcC44U6vwxKgtYTaYKlS5SU=;
        b=Ximv50FjisN72cV2Ki3am7xNuMgzvurSBnJCbFAtvyjH69ycsQrPzWROgT5nPwD5Y5
         WyIuwZI1NCdBR44b+1vrT5UkDDKa5+vU9HFBWE2DZv2NCQTAoynA+H/3csPCwXrW5T16
         Dd6JdnzZUhmFXbf6cT+yqBxnpCOV/FKDsv2liyoOua6FfpQqjDhmWB9yYP3xaCs0l7QB
         SKJntWAvoh6WVBB7xWH+xz8lI3/IttFYb77FAQIV3zGvN73FnieVZ9Oa5uvX513Cl9xD
         9DKItPX1saiubCUirD7Wb785exCi0+dqHGjgNF+kiJYpQmLoBlzfed15f09N0WnOSlCX
         BM0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776236216; x=1776841016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTzmmQmbSiBeZkId4dhEkcC44U6vwxKgtYTaYKlS5SU=;
        b=iUono1tA6+ohVCN8a0DgPu2+ZLKuyuqKKt9Rrk03pvXNYLvFhXnUZWc2RPQIBpQyws
         vbyqlDFLDRyVbAzaLyXlfdssejJ7D6yuQsUyYeTT9PI2IjbSwMRsZS9Z+yLmSnW0u0AW
         D2loOs7DiyqcNa8xgXVyXof23Yiqs+/AaV5jtZniIdV5oo7yDjTtipEc4yGms0jIi1dx
         66vsEvJfSJ0sU9ztlYZwPfWw5v453FH3dX3azS4hA10aEvQnRpkMSuw6sLozbBgRALli
         JOG0nfPiWAGm1BTWS3OMDdGS18vEHKdYIMnLztrmbFYY2xF2GSBB7Ml8doM4WuhvXP+P
         IXtA==
X-Gm-Message-State: AOJu0YzLfo1Ju+q4e774nBS2suj/0DaQhLZ7ASWNyZdX0Fu3+cwXMYB2
	DDFw/Kr4r+/R4Pd4hiCvy0FUoYvVr0XHHbOe7vvs2hs47/ORMyyh7AexuBMe2ymL
X-Gm-Gg: AeBDieuY3EnaniXdD7XhDP3LhwaUfhVt7mGlgNFhQXSwPnFOKIfAmLQlrkh2SRGYnfG
	jvzmYXj0+gW0sYBCjbl08TaejKB9wh0HZvT8YvqP1vW8RRJJS1byjNUQCrzHopScVO7nruxYXi+
	qHkAV3Uh8a29mMREr3QcaZbynsqwZhiCDWh4vzlEXEZay+Q69zoRvKxN1/glr6Sa4UG9/wlbUlR
	TPlW9ka3S6c6hhSdMd9MU1c8jDwfICkDsI4NDCjSffN+C9Pn9gucHL01SAebX2jszWdkWszrMFk
	DUaRKnI9Y+oh+mSDmqeuB0Pb70BOZLGE3djFdD+DbsQCWcWyItmwPl3NlhuN+8LIOHWptx77OPs
	P1XY6e+i+0D4fHOKYenC1JFEellr7zESeVxciP3mpH7ZxzzdF3S33vRILkpd8DqghkyTMtCHJnj
	Sja+xix2P0LvsYca/BoyV3RLsyZWOz8p6DymMIcECL1x+kg2twBedFKWJWFguC5AFrVNQd8Nw9C
	6iV3BTK62cOk6wQvq1yzX4uz9DQgpNDcuSGXy5HvQ0cRsEZWW1RGMDUvLaEN4r+cK5FG143ccYe
	dOP36R7Lxg1+tIDybsPRPmaCgU4wXfjOOR0Oajog/RHX4+JHmhexIzqwbSYj6NTp+yFME9xtrg=
	=
X-Received: by 2002:a05:600c:450a:b0:488:a882:b7 with SMTP id 5b1f17b1804b1-488d6ad17e6mr266563085e9.29.1776236216111;
        Tue, 14 Apr 2026 23:56:56 -0700 (PDT)
Received: from particle-0df3-d360 (2a02-1810-950a-eb00-f9cf-2393-cb7f-6fd9.ip6.access.telenet.be. [2a02:1810:950a:eb00:f9cf:2393:cb7f:6fd9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f0ed71dbsm11979595e9.34.2026.04.14.23.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 23:56:55 -0700 (PDT)
From: Daan De Meyer <daan.j.demeyer@gmail.com>
X-Google-Original-From: Daan De Meyer <daan@amutable.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	Daan De Meyer <daan@amutable.com>
Subject: [PATCH RESEND] scsi: sr: propagate read-only status to block layer via set_disk_ro()
Date: Wed, 15 Apr 2026 06:56:33 +0000
Message-ID: <20260415065632.3497343-2-daan@amutable.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sr driver tracks whether a CD-ROM drive supports writing via the
cd->writeable flag, which is determined from the drive's MODE SENSE
capabilities page (page 0x2A). When the drive does not report any write
capabilities (CD-RW, DVD-RAM, etc.), writeable is supposed to remain 0
and write requests are rejected in sr_init_command().

However, this information is never propagated to the block layer via
set_disk_ro(). As a result, BLKROGET on a CD-ROM device always returns
0 (writable), even when the drive has no write capabilities and writes
will inevitably fail. This causes problems for userspace that relies on
BLKROGET to determine whether a block device is read-only. For example,
systemd's loop device setup uses BLKROGET to decide whether to create a
loop device with LO_FLAGS_READ_ONLY. Without the read-only flag, writes
pass through the loop device to the CD-ROM and fail with I/O errors.
systemd-fsck similarly checks BLKROGET to decide whether to run fsck in
no-repair mode (-n).

The sd driver (SCSI disks) does not have this problem because it checks
the MODE SENSE Write Protect bit and calls set_disk_ro() accordingly.
The sr driver cannot use the same approach because the MMC specification
does not define the WP bit in the MODE SENSE device-specific parameter
byte for CD-ROM devices.

Fix this by calling set_disk_ro(disk, !cd->writeable) in sr_probe()
after get_capabilities() has determined the drive's write support.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daan De Meyer <daan@amutable.com>
---
 drivers/scsi/sr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7adb2573f50d..8ed002f82e36 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -684,6 +684,7 @@ static int sr_probe(struct scsi_device *sdev)
 	sr_vendor_init(cd);
 
 	set_capacity(disk, cd->capacity);
+	set_disk_ro(disk, !cd->writeable);
 	disk->private_data = cd;
 
 	if (register_cdrom(disk, &cd->cdi))
-- 
2.53.0

