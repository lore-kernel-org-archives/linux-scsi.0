Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C2945D5FA
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785851530; cv=none; b=op3inSJ+ZKE2Gi0n3+WuVHfkJQmX/605n85ZCx7aaTWpUV3Mz0C+iCOZip5JS2Kr1Zwr8Z3HEgpjqzBN6Amf+CQ7ZeiGiVoYHSoiH+GAGNVFGtHY5XeATjAKKPTnPMME8Joqj6JAZNnzS1HjJy2pNQQ5dDUYHjfIVF49vBbKdyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785851530; c=relaxed/simple;
	bh=zwJDS5M7XSOayNbUeGw1KSlciFCw5PkPyvSmQWis6hU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FQAmhzQL5Oa4iIp9n9pFqNNbyzWo3r5Pl9WEroSRwU2hawvbaYTLYIuUf4DpovqUJ/MGYSaHTJLpbDRNj6ZcIU2Itw3IBYm7lgPhurR8I413F0drf3DKQ9DgY7/uskLlAKRwnOme0hpinzyL0+j5gWZsjBO6S+3v5uPRMr8mFMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GgJA6a+r; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GgJA6a+r"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49557167508so29304475e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2026 06:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785851527; x=1786456327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GDaBxGiFHqp5j125thlzpnjgXp8EFo5LBnP6F1rvvfM=;
        b=GgJA6a+rZwFN4rWp9eWIcYezvkXOW9a5kS8VKG1rJtiQRbaBTlJGiE0ZNY7hnsEPs0
         Cevf1NFNBztuhCL6Hzl3bzKmNoN9ZUoWPFpqtRyK6sLGjKLvkSRq64FoWnpze6pb4r5+
         uhoKXRU09vJhXye6ORAx8JzScks5QnhzNjpQfZkhBJnYsV52REpMWIO/Exlev5LKz/r7
         Q3CyhlGqLqDuPQiFOx1l7WiOuxv3MCFodNaG3siMShhWaSXIt3mWSgeSSpj6PQmPz7II
         iFPWNmcOtOHd0EYfnLm73VJ9snVljjpFJb6gUHFbnOhfD+2PbJDSh4klGi6piAxowOmV
         oOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785851527; x=1786456327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GDaBxGiFHqp5j125thlzpnjgXp8EFo5LBnP6F1rvvfM=;
        b=CCPLh8ABJpcSSblktFNhApAVC52AJHeCD2wLxNC3WUS+Fl15oCYFcc0f9XMvy6GqjU
         c1SYGtAwyq5wuF3KDj8GD5QP/JciKUY6kDXvn1rbK9Ulm7LDCuDPGZ96tLmX1wngacN9
         tkVblD+aSgigOTftfcftSt3vHooJ5/Sx2hRyZb3ULyj7ZaGTudx6x4b6m51ffbz6RpI1
         ySNuHIqt1tHmlgWbP+0uGH2uBX0x2QlExCCS3PSHA5fk+D8+LS/7RI1i5entq6ZXgXcr
         f4ZKkKPaYtDSbszSBUh3RinWReS3RLVl/Q0FAeHiIsVwkxFR7U2QzyL2fPFkBzDOSf6r
         R32w==
X-Gm-Message-State: AOJu0Yy1ZYFmF6QUSx510yEa89K8tmMStfrA+1+hDo39leil2qvrTfDD
	J40j1Gr4t6suL+JTok9b4XqDd0a2A0hnvOBfZiN7G6GUi1xhWdBMsKcBFT3Rm4hA4Ztwbg==
X-Gm-Gg: AR+sD12C7AqE6d15tiGSxVc6GXcU8Wqzy/cyNFTS/QkshFifVpPTTZNVg1jodhEoxDM
	HVryXf2ibGBu6GgdpUhO0m7XMl7GM7o0JpMAWlmhz6a3tYMbh+YF2r1yZrjvaKX+orSLRbRfUne
	1o1AmAxtrEi6Ei4q2a8Ea18+ERQy0dyGuFDZ8n1OlObeTHdn4sFx+u4N2c9IXebKXvNqFg5yMlh
	EaFmK1vzff/GeaGTn5py8NXYQJE8VUAg+z/aIhH75nhKhmRejPyKDZfGOfr7sNXmmY7ujDxYUBo
	bSMIgwqm61k3nYw8xy79JCehXjo9AEvt512z5UpsgrQctL89O7fogLP+Hm3uX4+ycY6MdRjXgDg
	1tAtV70S9LlVetMQTxTKIy4+uYWzJ0erNL2dVF0s402bSmeDdvPctg+vNBG0UHjRPuyvyEMIquR
	7PAbkojjHffWD5tuaeVqIIVSH8enree3QxD4bwviqLDNDjKJ0UCf/pXVsnHY3T4ZJX9WmAKXNrB
	NlWsQ==
X-Received: by 2002:a05:600c:5914:b0:495:5cda:52ec with SMTP id 5b1f17b1804b1-4980c662d03mr295942235e9.16.1785851527011;
        Tue, 04 Aug 2026 06:52:07 -0700 (PDT)
Received: from NB-9797.corp.yadro.com ([89.207.88.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994df7e025sm577985e9.0.2026.08.04.06.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 06:52:06 -0700 (PDT)
From: Ilya Khomyakov <khomyakovilya@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Ilya Khomyakov <khomyakovilya@gmail.com>
Subject: [PATCH] scsi: mpi3mr: keep DevicePage0 SAS/SATA log on one line
Date: Tue,  4 Aug 2026 16:51:32 +0300
Message-ID: <20260804135132.3841-1-khomyakovilya@gmail.com>
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
