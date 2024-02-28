Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D9F7292E
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 22:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161152; cv=none; b=FnIs6czWE/Cemjp6QhHEcC42FQ/RhQiaznUWcAW1Pg74cLV07I6bwun7T0JChNZAgYGL1s5IahPJKqjt8UdG4M7xnvizAM9gVdQ+r7qq8mZ4BEkKyjxFUIeybOID+b1njcuE3a0ThsbXYvMrv5yqWXLY0JTQNfgpRRo83A+oAaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161152; c=relaxed/simple;
	bh=Fzxw3B7E/9cimGnCcB1YYMSbhwnEqsP1/yKx00gcrAU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kkxsAhoOhJyoJdsH0vynHw3jejv2177lP4Ev2ax4vOsW/V2kt29sxXfOZOMEH5TEqgXl1bEP78s3PSOKJGcCT2DMO7AHyWBVyFr9sK2cgV8H/IgBZ3Q64/32AapHTGxAb/vlaN7HWPOIG6paSNilNI7QhdH0StLlMJfd916hQAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iraPFeRH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iraPFeRH"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5efe82b835fso6795627b3.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 14:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709161150; x=1709765950; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bwcBf6VTN7kSbKJ8Vs5Gx4XAVHKYHpXJ1cRKxEXuKj0=;
        b=iraPFeRHZCaDwmnufgGQMKC41vAlkljMD5aEZMbtocoBv0Oqc0xIVZjm4gowenrOfq
         UzXVcdXnqwL/MncaNbLZTbeklu5dDLf80smf8YI6udNkK/LG7Uxdoh7ynA7lJBlidBnu
         IhVn8pBl4pl4yhu363XqrKONLUcoJi1/NeH76ss8vUTbg4W/BZow+iWHVb0BbpNsEqix
         Ulk2PixO5GLdSdPSRWM++ew1HeQijNxc9sATkfKxMPhQRuUNIHFu26+6kYOIhE+Etswk
         vk4NdG0Fb9eNmywN2J9sDHQAqvnu7oMJ6ws/18WI1+A1mj5VwVK0pxIh+aR8M6jgaLVT
         aXew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709161150; x=1709765950;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bwcBf6VTN7kSbKJ8Vs5Gx4XAVHKYHpXJ1cRKxEXuKj0=;
        b=aOw8BKE8cV4mzidVn1SrQdOOv5JCizUSjKY+Nj9Uxe/LwhEhzDX+8QFKToTx0Yqedv
         /3yvFBrKgd6v2oxk9LBkKb/Ag8FLwPB52rlRFp0WGOs/sQX+wFCBszwMesQn/shAtrmm
         9smxXrs5pvjYcaT5MnilgPVSCLkTwfNbUroeigJRNEddgrdMikq7jk/6bxAVJ0ecV9Zd
         j1zNKTqHBEVna4QkTJYSTRSPquQLBmMNNyXcw2n/eoJH9+Hm2PdFFWpffMphCO3D37g0
         YFBY+GpciF+Pk7lVsw3jlb1WOWjtQjUA5DtnJe4XcrzWuh2Eod33veI4QHavbv31X4WB
         Ipbw==
X-Forwarded-Encrypted: i=1; AJvYcCX389W1yYjT3HBOvQQyeMadCCml7UlaEdGwtC4CMuvbBWEu2pagBAaoPonyG4w+5pU+MpZIl6FEqboTllnsi+r7zLqIE+RJX70LeQ==
X-Gm-Message-State: AOJu0YyzvDih4Rl6mCLoEkpgvZ7A6y2wYUaYntvG3JXzaiXPbNGUhEn0
	Ou8tQcHD7A//tPTh9P29bD4nWcUkTW1iI9MCx5wgkwA28oUCjijK4JvWjDbIgpJy7A3UTFdqwPC
	vV+TWSRBAyXr07k9COn+Wmw==
X-Google-Smtp-Source: AGHT+IGJSn1iIdhaFuCaAXBuR+oBBkpFnJulYbWTNsBkTp28hN6EtDT8YP5YgukKH/p/y7d8tFeKIDow5NNW+rcMBw==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:690c:3744:b0:608:ce23:638c with
 SMTP id fw4-20020a05690c374400b00608ce23638cmr117431ywb.4.1709161150059; Wed,
 28 Feb 2024 14:59:10 -0800 (PST)
Date: Wed, 28 Feb 2024 22:59:00 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIALS632UC/43NTQrCQAyG4avIrI3Mj2J15T2kiM1M24DtlKSMl
 tK7OxbduwpvFt8zKwlMQdR5MysOiYRin8NuNwrbe98EIJ9bWW332loLMnKPwwSeKQUWEBSCbiD
 X8ffc6icgmMo47Q+m8ogqrw0canqt0rXM3ZKMkacVTubz/RnubyMZ0HBC74rC1vqo9aWJsXmEH cZOlcuyvAHoIOgv3wAAAA==
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1709161149; l=1822;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=Fzxw3B7E/9cimGnCcB1YYMSbhwnEqsP1/yKx00gcrAU=; b=+xX1p9F5acPGhLQnOC0ZvGYgBGCYCRPUuIWu0ALKmc/Irx/7euLxtpBb0vFctrt3pFBFzOk26
 qMxJqYSZlYPB+nRKJdxH1TPJ7iPps8Q9EjX7l5U6axtxrVXXb6PK2aN
X-Mailer: b4 0.12.3
Message-ID: <20240228-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v2-0-dacebd3fcfa0@google.com>
Subject: [PATCH v2 0/7] scsi: replace deprecated strncpy
From: Justin Stitt <justinstitt@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Ariel Elior <aelior@marvell.com>, 
	Manish Chopra <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Don Brace <don.brace@microchip.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kees Cook <keescook@chromium.org>, MPT-FusionLinux.pdl@broadcom.com, 
	netdev@vger.kernel.org, storagedev@microchip.com, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

This series contains multiple replacements of strncpy throughout the
scsi subsystem.

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces. The details of each replacement will be in their respective
patch.

---
Changes in v2:
- for (1/7): change strscpy to simple const char* assignments
- Link to v1: https://lore.kernel.org/r/20240223-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v1-0-9cd3882f0700@google.com

---
Justin Stitt (7):
      scsi: mpi3mr: replace deprecated strncpy with assignments
      scsi: mpt3sas: replace deprecated strncpy with strscpy
      scsi: qedf: replace deprecated strncpy with strscpy
      scsi: qla4xxx: replace deprecated strncpy with strscpy
      scsi: devinfo: replace strncpy and manual pad
      scsi: smartpqi: replace deprecated strncpy with strscpy
      scsi: wd33c93: replace deprecated strncpy with strscpy

 drivers/net/ethernet/qlogic/qed/qed_main.c |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c            | 10 +++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.c        |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c   | 18 +++++++++---------
 drivers/scsi/qedf/qedf_main.c              |  2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c             | 17 ++++++++++++-----
 drivers/scsi/qla4xxx/ql4_os.c              | 14 +++++++-------
 drivers/scsi/scsi_devinfo.c                | 18 ++++++++++--------
 drivers/scsi/smartpqi/smartpqi_init.c      |  5 ++---
 drivers/scsi/wd33c93.c                     |  4 +---
 10 files changed, 49 insertions(+), 43 deletions(-)
---
base-commit: 39133352cbed6626956d38ed72012f49b0421e7b
change-id: 20240222-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-1b130d51bdcc

Best regards,
--
Justin Stitt <justinstitt@google.com>

