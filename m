Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C0F3F39FB
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 14:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785853784; cv=none; b=Tf9A1uk3tXLo5H5AOu3hyd/Z7gjVwvJJyQx2eoe0MigNtWVT/bc6H870m09pzn5EEF/89+JyNpmX29ivmX5Ljw4tIGvGKQI6UvgmS2BdY21QZLOz6puaW1scTl/AmYnZkUumjg2wkQBWDnnL4oW4pAiSYEAaGxTODOgvonuOY9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785853784; c=relaxed/simple;
	bh=zwJDS5M7XSOayNbUeGw1KSlciFCw5PkPyvSmQWis6hU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LgQWNloCRpIuPa3NyDJDt9BOyOiLszgXZ8V/i5Q19AbTKbFnsVEOYrzYfV+XPmt/0EcUguYjqThfaNbCw/pGq4N58f5nwmafCXiScd/O8ckMYcLzKToX1J1523ZRylIBKl6IBr3G6wrycf/2pV1LTXKWQAKBqS+4EbRHCGsftXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G5Z+toO8; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G5Z+toO8"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b011edaf7dso4551614e87.2
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 07:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785853762; x=1786458562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GDaBxGiFHqp5j125thlzpnjgXp8EFo5LBnP6F1rvvfM=;
        b=G5Z+toO8dbtFYNriGcx+E4jP6CQKpyKGO32JVG4JqCZamhxRtAAElH+x0LZik0UAX/
         OTDm1w/1v7jUK1Gc/B3LczLU5NWGaUupdLLgGLO/RLsYPzs07ON0dYW1ch98gzQ1UKJS
         /3VOvOxkorvg5ZCh5jwRjZGirVbu8MFIGG6HZX16UKBeqRSzeM38eObMF+IzPDvxRanM
         aUuBTk2xVhYM1KFEM140R9pSOHNvAe6rPQs65n3ddPbxOy1HQeRDA16MKYlAcKP3Gpq8
         4fCj9G089TPjVYXd2jKRuSd8LV9ctbB6dRpq3GXlFDCJrUSRU5UHpSc/QFt9ASTnZo2a
         OHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785853762; x=1786458562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GDaBxGiFHqp5j125thlzpnjgXp8EFo5LBnP6F1rvvfM=;
        b=BBBjU11dxU67QAjG2cxOGWJ+NO9WT3HP4uVN9ZXYH8MLatymot/387cRlBOMnXkW1Z
         H4tB3DR8+r6c9wYLIaXcmXZ4OmcEAXAGXkwWfAKV2GNGPNfc6OKUMWw3TAGX9UQYCshv
         NR292Gf9zyy/f+tk4obpAOqMAZ1mvbTcwTH3HIR6ZiAzC1v+Wl5vfJP5B/fEcviH8ATB
         7Vc1Bpjmwj9gOkvhDxfbiU72LvGayUe3GSUx5wyNqdqc8kxIVNnjmrv32E/pryLeSaKp
         iDLdksIl+DC3GuwsR0+yjbY5n87LbigX3Yb6Vm0aUCfoTEvRIgUJLAMiOaA9Nwhkbezz
         SteA==
X-Forwarded-Encrypted: i=1; AHgh+RoKKWmgVlg7ghXL1Sh44z/X4w0z0lwgy9NJbFCPo8vzcAKfJLgKtFouwoc83Dg2l3slI6kPmCQbWEoL@vger.kernel.org
X-Gm-Message-State: AOJu0Yy51SFgctnHdHrf/LbzWfEN8dwIeqVnNJtrWKBUSqUsMVWRxXeY
	p8/7Z3L3dBXYO5zLKtqKgHjj+gAD1Iiw4MF1gLQc7g2oqOEyhlRIYpj3
X-Gm-Gg: AR+sD11ETY4QVAx3Bbg8jlVKEoY1mh2BmKei2IpK7npcQvw2shMsynlYdna0gkOcDbn
	3qWiaU3A8eSHcHhNMX9h3dkBIgxnXbuymRiS2KGDNaVacDy5cuOb8d0QRxU8UutQZWIFHVSczpM
	8XcoKRblucMcNfPVGx86v2zsgDQxWjBBGJmREXWJ6Vzjb/vfZgqJ/SoWxLzdZ9o2bJ3R0ZRRjoD
	Q1gDXBRf9kj238Q6YFzKymbOL9fV5krkqrqW2KEaG310cwMOzlqtLi57n7erEycNsmpvbYDF6eG
	M4bu9/QJdBJRxKcYZue9Hd0goBwQxHOXvZTxnT5x7n+iDBRd2WiAo5/maNh5l6pEHfZmEMIscNk
	4VUA/wsuxG+frlo7nb49Hlexvhdo8A5vsCyJ0/z/F6Nyom2B9gouWolM+s/o1yWEFzE7TND/3Aw
	pLkyOExpjD4tixe/FvMjTi3QbANf8FWz4jMfAiOgGc+0jHXSJHJmN85MEgETqFT2I7pYqMflTxk
	TD9Dw==
X-Received: by 2002:ac2:4856:0:b0:5b2:9599:b5f1 with SMTP id 2adb3069b0e04-5b2e4f6d57cmr1883681e87.42.1785853762238;
        Tue, 04 Aug 2026 07:29:22 -0700 (PDT)
Received: from NB-9797.corp.yadro.com ([89.207.88.244])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e245c0ccsm2703630e87.80.2026.08.04.07.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:29:21 -0700 (PDT)
From: Ilya Khomyakov <khomyakovilya@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ilya Khomyakov <khomyakovilya@gmail.com>
Subject: [PATCH] scsi: mpi3mr: keep DevicePage0 SAS/SATA log on one line
Date: Tue,  4 Aug 2026 17:29:01 +0300
Message-ID: <20260804142901.4406-1-khomyakovilya@gmail.com>
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
