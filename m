Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DADB17C205
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727258; cv=none; b=DEIXlPfuJ90rsolwvIGA882UOcI65t9QmK+ZaM0SbFxknruR0fk1fO7c7gsN4sSkXWCNEQBFhZYRSFXDymyVznh7gD6aE0V/VKdruSiGmzqGYC1a9TVr1o4iyhFhien866Kks7UoXeo2q3YyfOvjSbyakiDimwO1QQ+2RZp02mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727258; c=relaxed/simple;
	bh=XreUrMx6FSys+gzL+va1kKyrZIDZrTiySIyPkMLT0eE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dM9CiLKF4+FpPlbwdLNMhd9M0qg1yiGieQ37Y3HqsVvh6pJhO69HYxAsHDCvbzhv0IqvNV7sABmmLoVdPy5Ya9zEscjK/xQaqKxvOq5dtenlKW4XS1Qa4q3w9aOiCQP0qidKkic7K48mMcK9bWZjrNYjQR+zP5Tp7Re1jf1E7+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=RR2NphBx; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="RR2NphBx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1720727256; x=1752263256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XreUrMx6FSys+gzL+va1kKyrZIDZrTiySIyPkMLT0eE=;
  b=RR2NphBx16ElfJhnOVTI6nXQ+g0iXP15aGgFqXZhldwTh43c3uKZdvBD
   j3sHTFMZv+PN/GHhPjJoTKmZIGoKL814MtdpUAtTsVYN9sulRLJ/S26cP
   U4UPsnCovLXobeo3zoxJRBsctd0EqYl4JTFiz/0LJoeac5ver31bV3vKx
   3YFqb83Fsp65qFsJcrK1Gj3oMm0uooO55k/JLsG0kRY9/A1YI1JpbpFYa
   NV5pdnIFbh2dqqZsdmbxJxminI/csVX0VHTqB9gJY8P9CazyjnXiRzkiV
   j2+uqcOgQsL81sA3aVEuTh/wCdRZEGJc/tz0AC7LYadRObgLuUX0jGIta
   w==;
X-CSE-ConnectionGUID: lpLBJxwkSjifens90ReNAw==
X-CSE-MsgGUID: aE5WJEg7QTScnO5oG4l0Ow==
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="29106955"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2024 12:47:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Jul 2024 12:47:07 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 11 Jul 2024 12:47:07 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
	<scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>,
	Martin Petersen <martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>,
	<POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 3/5] smartpqi: revert propagate-the-multipath-failure-to-SML-quickly
Date: Thu, 11 Jul 2024 14:47:02 -0500
Message-ID: <20240711194704.982400-4-don.brace@microchip.com>
X-Mailer: git-send-email 2.45.2.827.g557ae147e6
In-Reply-To: <20240711194704.982400-1-don.brace@microchip.com>
References: <20240711194704.982400-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Gilbert Wu <Gilbert.Wu@microchip.com>

Correct a rare multipath failure issue by reverting:
commit 94a68c814328
("scsi: smartpqi: Quickly propagate path failures to SCSI midlayer")
Link: https://lore.kernel.org/all/164375209313.440833.9992416628621839233.stgit@brunhilda.pdev.net/

Reason for revert: The patch propagated the path failure to SML
quickly when one of the path fails during IO and AIO path gets
disabled for a multipath device.

But it created a new issue: when creating a volume on an
encryption-enabled controller, the firmware reports the AIO path is
disabled, which cause the driver to report a path failure to SML for
a multipath device.

There will be a new fix to handle "Illegal request" and "Invalid field
in parameter list" on RAID path when the AIO path is disabled on a
multipath device.

Fixes: 94a68c814328 ("scsi: smartpqi: Quickly propagate path failures to SCSI midlayer")

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Gilbert Wu <Gilbert.Wu@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index eaebe3cc00aa..d8df7440bbe1 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2365,14 +2365,6 @@ static inline void pqi_mask_device(u8 *scsi3addr)
 	scsi3addr[3] |= 0xc0;
 }
 
-static inline bool pqi_is_multipath_device(struct pqi_scsi_dev *device)
-{
-	if (pqi_is_logical_device(device))
-		return false;
-
-	return (device->path_map & (device->path_map - 1)) != 0;
-}
-
 static inline bool pqi_expose_device(struct pqi_scsi_dev *device)
 {
 	return !device->is_physical_device || !pqi_skip_device(device->scsi3addr);
@@ -3269,14 +3261,12 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 	int residual_count;
 	int xfer_count;
 	bool device_offline;
-	struct pqi_scsi_dev *device;
 
 	scmd = io_request->scmd;
 	error_info = io_request->error_info;
 	host_byte = DID_OK;
 	sense_data_length = 0;
 	device_offline = false;
-	device = scmd->device->hostdata;
 
 	switch (error_info->service_response) {
 	case PQI_AIO_SERV_RESPONSE_COMPLETE:
@@ -3301,14 +3291,8 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 			break;
 		case PQI_AIO_STATUS_AIO_PATH_DISABLED:
 			pqi_aio_path_disabled(io_request);
-			if (pqi_is_multipath_device(device)) {
-				pqi_device_remove_start(device);
-				host_byte = DID_NO_CONNECT;
-				scsi_status = SAM_STAT_CHECK_CONDITION;
-			} else {
-				scsi_status = SAM_STAT_GOOD;
-				io_request->status = -EAGAIN;
-			}
+			scsi_status = SAM_STAT_GOOD;
+			io_request->status = -EAGAIN;
 			break;
 		case PQI_AIO_STATUS_NO_PATH_TO_DEVICE:
 		case PQI_AIO_STATUS_INVALID_DEVICE:
-- 
2.45.2.827.g557ae147e6

