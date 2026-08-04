Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382D343F8D4
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 13:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785848811; cv=none; b=mt67teioEd86Uud6uMW/gOr/1gpamSPda0G6grxOaeB3VBaf4+ihD3OF6Z3DLAp5zW5fn1hRSybcZVHUnuqu09K/WlQ+7Qb6OorKPQEuxPjKpt2FCGZILBCdZbAEIzfKQ/brCbcuCbOt7o6hlAPVIvQmpkioUPHbVg4euNEIrJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785848811; c=relaxed/simple;
	bh=zwJDS5M7XSOayNbUeGw1KSlciFCw5PkPyvSmQWis6hU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XV9yL29QU+9BDdgN+EV/pkeZJj+Jmrne4L5PWjCf2OWS7/gFQziC2OJ+49A9Z/c8dlKuSy/L1IC8JHfDD5K6Q0/x8u4YpfuugbZV6VWOFAJJJThPcP+DQYio6I9mHcXa2nTnobzCDXPbKMqnqLyVxTY503kMuyda52ug3C/D1y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ql0N1hnA; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ql0N1hnA"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39fa5e3a428so8801091fa.1
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 06:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785848808; x=1786453608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GDaBxGiFHqp5j125thlzpnjgXp8EFo5LBnP6F1rvvfM=;
        b=Ql0N1hnACxgrjn+kzTrHZVsIWr3Uewkhhy7EzWn1nMLFmQlbfAxuVHbQTUHYEycnA2
         X6igzjDJUGSc2a5nVg0m6WgT+VuBqcT8OBQD1V0ndqpLyN9/jDLlyv1PCpCMsbXqBlNh
         gys2Js1KgxMKznh8FchOPYuNnp3lr8n8qUSNcr/Q0dxx/z8ox4KEUaVSW0Vh6VvrLLX9
         p1PZyHGb/ypaWMkcj3bI2aragOWUk43MY4NsxpFKcRutON/sw9Un2tucxR74NaThrXKZ
         R0GPyAqu7bsQtyoUdH+3r4GAlpd1A7/dbZ/b3qY512kESYBDTdOWQTUzpNVPrYoG1GzE
         Lo2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785848808; x=1786453608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GDaBxGiFHqp5j125thlzpnjgXp8EFo5LBnP6F1rvvfM=;
        b=ULf8rbpFIFkHOKrsPZp8UrucH4JNcytbXDSlcjM2Th+BvRLf7YTO1Co0KuuMkH6Q0R
         8oUH6FBfD/8HZtFrZUtv39o2tC5ha/pfujbONXBRWQ2iw6rYAwCkGyQbm0klbuZVlYcw
         xVDXswOETmxt3WgDudFo6Px8fWM3DyrDXjOJvWOyot8FJYer3bpYi0ymbtHLx6RPMtAY
         a+5FBHDPIE15tZDhy1mFAQWhxt6od3JFXtedWR9qDq75YMt8mSofli3pN6djpNxXL/xe
         08ZrxQR0P7HKwyR6RbFk0xc5Y35m2wqwytxMc8BwT+calC7HGIVwfpkzGaaN8UekoHfs
         ZlNQ==
X-Gm-Message-State: AOJu0YwgyGD0f+CvUDMv4WMQE6xHFjxxHKlw3HueiY4mXI13DyOt7X3K
	rkXsGP/xYXQT0A8TAbMCy/xpiqEhh5IeRzBD+DLe8bO5/ZrvkcIo5RO/iTx3JfLiLg3qRw==
X-Gm-Gg: AR+sD13HQZJkPhHdiVP3aK2DiXDxyJhGSyjXMxbUawxLb99BBOoH1LnY6SaDiBFVT4k
	VxkvpoSWWLA2fQdyUwMUQTZwa7ZvW2uyeafheHuVKnh3bLBlWnqxbxvNWXunsmoSvQbbGCTvoTQ
	kRZ8GM5GulOOTR4WyEA1g2Omdaie43FH1q70+TK9Ohy/zTnItBBtwNb9eJn/EEPI3nxNvclIOmy
	iadhTKi5vxtmswkk0IAcaD7kcHDmwo0qLUoXJJX5Km7yyUKv19Jc4jt01utJsK2W0R9B3IXfd6a
	REJG221XSRrHD9jQNS+axTf5Yer3xyOR7expeui9hbccqNEccWT0xpCiSeWg8Adplzcm0sZhsbi
	BWZq5FjJz1/vGOnbf+jlDiNs4itlvnol2GDFaCW+v0IC0X9ZHuwB8/wn6Nzgk6FQ8shZY+plBoB
	OLEfx3KeCSTVuncbS+F9mQ+H8HF7+T4GaqkpEKqp5wscQBG5lv2yzrHcPg3LzwXkp5tza1tb5g2
	f9N5g==
X-Received: by 2002:a05:651c:a393:20b0:39c:956e:77de with SMTP id 38308e7fff4ca-39fb3118d1cmr6270011fa.6.1785848807818;
        Tue, 04 Aug 2026 06:06:47 -0700 (PDT)
Received: from NB-9797.corp.yadro.com ([89.207.88.244])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f810a0592sm17412701fa.7.2026.08.04.06.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 06:06:47 -0700 (PDT)
From: Ilya Khomyakov <khomyakovilya@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Ilya Khomyakov <khomyakovilya@gmail.com>
Subject: [PATCH] scsi: mpi3mr: keep DevicePage0 SAS/SATA log on one line
Date: Tue,  4 Aug 2026 16:06:22 +0300
Message-ID: <20260804130622.3421-1-khomyakovilya@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The DevicePage0 SAS/SATA diagnostic message contains an embedded newline
inside a single ioc_info() format string.

The first record receives the normal mpi3mr prefix, while the continuation
starts directly with device_info. Consequently, common filtered captures
such as

  dmesg | grep -i mpi3mr

retain only the first part of the message and omit device_info, phy_num,
attached_phy_id, and negotiated_link_rate. These fields are useful when
diagnosing SAS discovery and negotiated link-rate problems.

Before the change, a filtered capture stopped after:

  mpi3mr0: device_pg0: sas_sata:
  sas_address(0x5000cca2708a13c2),flags(0x0000),

Remove the embedded newline and retain only the final newline so the entire
message is emitted as one prefixed kernel log record. Also add the missing
spaces after commas in the format string.

After the change, the same device is reported in one record as:

  mpi3mr0: device_pg0: sas_sata: sas_address(0x5000cca2708a13c2),
  flags(0x0000), device_info(0x0101), phy_num(18),
  attached_phy_id(1), negotiated_link_rate(0x0b)

The wrapping above is only for the changelog. The kernel emits the actual
message on one line.

The change was tested with an out-of-tree mpi3mr 8.17.1.0.4 build. All nine
DevicePage0 SAS/SATA records retained every field in the output of
`dmesg | grep -i mpi3mr`.

This is a diagnostic-output-only change. It does not modify discovery, I/O,
or link-management behavior.

Signed-off-by: Ilya Khomyakov <khomyakovilya@gmail.com>

---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1290,8 +1290,9 @@ mpi3mr_debug_dump_devpg0(struct mpi3mr_ioc *mrioc, struct mpi3_device_page0 *dev
 		struct mpi3_device0_sas_sata_format *sasinf =
 		    &dev_pg0->device_specific.sas_sata_format;
 		ioc_info(mrioc,
-		    "device_pg0: sas_sata: sas_address(0x%016llx),flags(0x%04x),\n"
-		    "device_info(0x%04x), phy_num(%d), attached_phy_id(%d),negotiated_link_rate(0x%02x)\n",
+		    "device_pg0: sas_sata: sas_address(0x%016llx), flags(0x%04x), "
+		    "device_info(0x%04x), phy_num(%d), attached_phy_id(%d), "
+		    "negotiated_link_rate(0x%02x)\n",
 		    le64_to_cpu(sasinf->sas_address),
 		    le16_to_cpu(sasinf->flags),
 		    le16_to_cpu(sasinf->device_info), sasinf->phy_num,
