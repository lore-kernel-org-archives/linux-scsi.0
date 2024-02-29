Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E33D70AD2
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709227418; cv=none; b=GPjXpbljTkFaQINwPPY0p+ospTu+LS36aUPF8G5a27GdF/KfKbCjUWR3XAvVqwNSZZEgihVmD20XuLWw3j6dQDe8QlFVFPwqdaG9zMzzJEuspFQ3O3aZ1LfaP1P/+E0M0Bq+o2E933y21VRi7LLzef4K8XcfDw89bwi+ZPWP88M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709227418; c=relaxed/simple;
	bh=lUUngd9bVi/OE1K9sKqCYKgtIyT7sebyXIuvNPn3MAI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nn80XuQeCGfsTQ6JJJ5lNZaYYo73GUqBYFb/TjTMALRK/ESUbccBVw5BVt0S1txDIm3gSy3ueqeupBFVCzIcwHmEd5h5UXJlP8/DI2rktKSRZo0tfYad/rB61xTjCKa+WB9h+C20vfImYbtTjJo/Xw4YeOlUJw7eC9/W8mGyRqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dc3b4b9b62so10553965ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 09:23:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709227416; x=1709832216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99KaCWvGHk5h37/gIICzEXrajbC8RVmcXHvWRJ2bhrk=;
        b=bkrvuNr6sSUMeOT0zcl0Hpd4xhANoRpQAFqGXacNhIrZINFML98etqlbA6s9AD+2Fk
         R3f/XXJVhho+qf71hGp4wAV6xOLT7qEhzPiCAwBmNGF5Ewb3yWGsJ1Rty1mQRxpfEGDL
         5KqPmMsGnoLx7ysg0mkpdq/lsHDW9nrYM71s3Xn56JbZmt9bvXMB5o2esVC/iMMqagBo
         /VMJqfX/RmHWiACHU/1g+/WX6zAEwftfSt70OlkzfM7vbQTPjGI37WjMshEa6v0Mh3r4
         cbOv4l68aVMIdyFiEud22qaov3ZKOtTYAgvuF83hFerW1g+lty2/wgT+mw2XbBV6UV/1
         tbOA==
X-Gm-Message-State: AOJu0YwovomfUAKI8WOFjNlccz1poTtEKnu4r2J6d6jobrIIlQyVPoBi
	ij9kTAJ0DmVfxxf5A8uJRXNyyp3TTd34v3oV9hFEvE5IoamkKl6UT3mb/6Ka
X-Google-Smtp-Source: AGHT+IHSocyq8HegzGo8FuDUc6KscD9zD95Kbie0VTZj61MeZJpf1hYFl2KrmNDHNtryRj/dachAng==
X-Received: by 2002:a17:902:ecc2:b0:1dc:7976:b52b with SMTP id a2-20020a170902ecc200b001dc7976b52bmr4206373plh.10.1709227416410;
        Thu, 29 Feb 2024 09:23:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:3174:8fc0:11f9:afc8])
        by smtp.gmail.com with ESMTPSA id q7-20020a17090311c700b001dcb7b28705sm1749753plh.26.2024.02.29.09.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 09:23:35 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi/sd_zbc: Use READ(10)/WRITE(10) for zoned UFS devices
Date: Thu, 29 Feb 2024 09:23:32 -0800
Message-ID: <20240229172333.2494378-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

READ(10) and WRITE(10) are sufficient for zoned UFS devices. UFS device
manufacturers prefer to minimize the size of their firmware and hence
also the number of SCSI commands that are supported. Hence this patch
that switches from READ(16)/WRITE(16)/SYNCHRONIZE CACHE(16) to READ(10)/
WRITE(10)/SYNCHRONIZE CACHE(10) for zoned UFS devices. The 16-byte
commands are still used for zoned devices with more than 2**32 logical
blocks because of the following code in sd_read_capacity():

	if (sdkp->capacity > 0xffffffff)
		sdp->use_16_for_rw = 1;

Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-scsi.c | 10 ++++++++--
 drivers/scsi/sd_zbc.c     |  5 -----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0a0f483124c3..a196dce4bbc3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -986,8 +986,14 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 
 void ata_scsi_sdev_config(struct scsi_device *sdev)
 {
-	sdev->use_10_for_rw = 1;
-	sdev->use_10_for_ms = 1;
+	if (sdev->type == TYPE_ZBC) {
+		/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
+		sdev->use_16_for_rw = 1;
+		sdev->use_16_for_sync = 1;
+	} else {
+		sdev->use_10_for_rw = 1;
+		sdev->use_10_for_ms = 1;
+	}
 	sdev->no_write_same = 1;
 
 	/* Schedule policy is determined by ->qc_defer() callback and
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 26af5ab7d7c1..bcdb21706d3f 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -924,11 +924,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 		return 0;
 	}
 
-	/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
-	sdkp->device->use_16_for_rw = 1;
-	sdkp->device->use_10_for_rw = 0;
-	sdkp->device->use_16_for_sync = 1;
-
 	/* Check zoned block device characteristics (unconstrained reads) */
 	ret = sd_zbc_check_zoned_characteristics(sdkp, buf);
 	if (ret)
