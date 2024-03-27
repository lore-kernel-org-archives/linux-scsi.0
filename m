Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51484210FF
	for <linux-scsi@vger.kernel.org>; Wed, 27 Mar 2024 02:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504885; cv=none; b=lsQLTjUkjfMeLlEe2vhUKytAovBAIzsf7reXOd6fM2q8udndy0OSrtHmGqMdDZ2S6MgEi+4LyMI/u8rg0FTllXfksb5vNcWSrO71m3yV0VG6kQ3KYmcD6JaGKoFr26cM1imSfUJpbhkAS/6aVC4cfcv3YJi9jVRHySnCiYxLtD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504885; c=relaxed/simple;
	bh=gPUuYcRbBoGhc9WOmgE0490yOxh2n/7f8T8Z1YJYPqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HSAk5HGDzvr6ZMPNV3eWBF21xuG1eawyT+8CjVJ/xiDoLC2X1OJFcbuHTMNdqLs8u72E/h6K83DHwYuCWsg9p+7C2QrNKBH3imjBFwjH+u6m1cQHA4co4gg4hP+SFVpxCCjHyiTqX6h9VK0Uxu9/UDALMYAIDOkWQoO0RKQD4cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCE8deY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCE8deY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902FEC433C7;
	Wed, 27 Mar 2024 02:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504885;
	bh=gPUuYcRbBoGhc9WOmgE0490yOxh2n/7f8T8Z1YJYPqQ=;
	h=From:To:Cc:Subject:Date:From;
	b=vCE8deY7z9sL+V6Lv5kjgb4b2CP31e1lpj+Kf3v4s2CXG93gckwTNGS3IbPRKuPcm
	 l6d8rK0EBjXN7qEhMSuncaRsNCqkv+SSSQ35WMUuO0MdVMmsV3DsVKnVEgqYsR5mCu
	 4Jl5YxuYxMKATUyu9vh6M5P6t8VQzKvt5/V2KqD0PTMocTERm+U3F1aYkls73mpLWx
	 G7k4THe5z6LP8fA9klUXmc04sOP/7Cnt+8Djigl6r6WuzEI2gIGNmeL3NNyckUpWoY
	 M9jC8jspKL1URJkaSp/p3v5Ws3PzkjNHQy9pqpT2Oo1mn1/eJnkt8l5BXy/14rkBuh
	 fMyZ0ZPL0HxAg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH] scsi: libsas: Fix declaration of ncq priority attributes
Date: Wed, 27 Mar 2024 11:01:22 +0900
Message-ID: <20240327020122.439424-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit b4d3ddd2df7 ("scsi: libsas: Define NCQ Priority sysfs attributes
for SATA devices") introduced support for ATA NCQ priority control for
ATA devices managed by libsas. This commit introduces the
ncq_prio_supported and ncq_prio_enable sysfs device attributes to
discover and control the use of this features, similarly to libata.
However, libata publicly declares these device attributes and export
them for use in ATA low level drivers. This leads to a compilation error
when libsas and libata are built-in due to the double definition:

ld: drivers/ata/libata-sata.o:/home/Linux/scsi/drivers/ata/libata-sata.c:900:
multiple definition of `dev_attr_ncq_prio_supported';
drivers/scsi/libsas/sas_ata.o:/home/Linux/scsi/drivers/scsi/libsas/sas_ata.c:984:
first defined here
ld: drivers/ata/libata-sata.o:/home/Linux/scsi/drivers/ata/libata-sata.c:1026:
multiple definition of `dev_attr_ncq_prio_enable';
drivers/scsi/libsas/sas_ata.o:/home/Linux/scsi/drivers/scsi/libsas/sas_ata.c:1022:
first defined here

Resolve this problem by directly declaring the libsas attributes instead
of using the DEVICE_ATTR() macro. And for good measure, the device
attribute variables are also renamed.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: b4d3ddd2df7 ("scsi: libsas: Define NCQ Priority sysfs attributes for SATA devices")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/libsas/sas_ata.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index b57c041a5544..4c69fc63c119 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -981,7 +981,8 @@ static ssize_t sas_ncq_prio_supported_show(struct device *device,
 	return sysfs_emit(buf, "%d\n", supported);
 }
 
-DEVICE_ATTR(ncq_prio_supported, S_IRUGO, sas_ncq_prio_supported_show, NULL);
+static struct device_attribute dev_attr_sas_ncq_prio_supported =
+	__ATTR(ncq_prio_supported, S_IRUGO, sas_ncq_prio_supported_show, NULL);
 
 static ssize_t sas_ncq_prio_enable_show(struct device *device,
 					struct device_attribute *attr,
@@ -1019,12 +1020,13 @@ static ssize_t sas_ncq_prio_enable_store(struct device *device,
 	return len;
 }
 
-DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
-	    sas_ncq_prio_enable_show, sas_ncq_prio_enable_store);
+static struct device_attribute dev_attr_sas_ncq_prio_enable =
+	__ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
+	       sas_ncq_prio_enable_show, sas_ncq_prio_enable_store);
 
 static struct attribute *sas_ata_sdev_attrs[] = {
-	&dev_attr_ncq_prio_supported.attr,
-	&dev_attr_ncq_prio_enable.attr,
+	&dev_attr_sas_ncq_prio_supported.attr,
+	&dev_attr_sas_ncq_prio_enable.attr,
 	NULL
 };
 
-- 
2.44.0

