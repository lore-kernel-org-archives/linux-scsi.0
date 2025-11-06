Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEEA34D911
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447218; cv=none; b=DtdrmvCO8WhA8gJ7edyMIp6NcJoriGYO5ufqXoxaZmz0mnyjlsWAkd+iSIfRbYPO0BiiFqObsDLEM9F+YGS1UYGNv8bXMf/eN4h7+aPkz4fmhZAmodT+7d+JhDKgjCfe/3t4Y/AYfHvO3uPdZLG6f0kJwUV6kguyLO1AtCqgO74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447218; c=relaxed/simple;
	bh=SPEXGCEFcy+WYc/hmNTITq6Pe1Bb59WUjuGuRIeitmU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FlnX/AcPvHhks1Es5zGj/RgRLfTpT9sCaTHw5j0kIZc3pQBP+PKIakqkJUdVvskMx6pgGriQLNaKvKsf8Pfa123/dxBIsP5j5Nrv+mpTJnvw66Boj3L7l084Uuzq9afuF82A3oGAgqYO+eah7Yp+BSuLHYSLgFjpLvcU95R/+VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=uZYgklM6; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="uZYgklM6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1762447216; x=1793983216;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SPEXGCEFcy+WYc/hmNTITq6Pe1Bb59WUjuGuRIeitmU=;
  b=uZYgklM6XbJpdi7BHnm0VqpjtW8s8Uzye4kEGLJ1nH31sKgg4Ng9mD1a
   RhYEcKU9ENKZQbah69InAeOA6E63drHpgcwotPJFI3lgIQXs0m3XywvSt
   xUt66BwbBnAionA+W5QtogEihaQB/p6JxZGGdmnjrxlukHZ9xP57NSt57
   keJHcZlskZsK3XJdr3Nu3AYWtihPDQWqxMOGMepevR5xHY1x9nMYxVSbB
   Dp7rJhcJNQJXe0LPbS0SQ5QI2Fnb9mQu9FcqmXmZMlCvcg8lo3gANIsd4
   VVbGDt7cGdTDqmCenERspKmElO5pbEnH7+PSknTiy6bXxtvaAjVtSs0IT
   g==;
X-CSE-ConnectionGUID: FkxUJLUhRWymx9kU3XqpHw==
X-CSE-MsgGUID: cJ+BaMWgRP+H/IksDsVAhQ==
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="48142662"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 09:39:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex3.mchp-main.com (10.10.87.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Thu, 6 Nov 2025 09:38:24 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 6 Nov 2025 09:38:23 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
	<hch@infradead.org>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
	<cameron.cumberland@suse.com>, Yi Zhang <yi.zhang@redhat.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/4] smartpqi updates
Date: Thu, 6 Nov 2025 10:38:18 -0600
Message-ID: <20251106163823.786828-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.52.0.rc0.28.g4cf919bd7b
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

These patches are based on Martin Petersen's 6.19/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  6.19/scsi-queue

This patch series includes four patches, with two main functional changes:

1. smartpqi-Add-timeout-value-to-RAID-path-requests-to-physical-devices

   Sets a timeout value for requests sent to physical devices via the
   RAID path. This prevents the controller firmware from waiting
   indefinitely and allows it to time out requests a few seconds before
   the OS issues Target Management Function (TMF) commands.

   The timeout value sent to the firmware is set to 3 seconds less than
   the OS timeout, which significantly reduces TMF invocations.

2. smartpqi-fix-Device-resources-accessed-after-device-removal
   Fixes a race condition during device removal by: 
     * Checking for device removal in the reset handler and canceling any
       pending reset work if the device is no longer present. 
     * Canceling outstanding TMF work items in the .sdev_destroy handler.

   Together, these changes eliminate races between reset operations
   and device removal.

The other two patches:
3. smartpqi-add-new-Hurray-Data-pci-device
   Adds support for new Hurray Data PCI device.
   No functional changes.
4. smartpqi-update-driver-version-to-2.1.36-026
   Updates the driver version string.
   No functional changes.

---

David Strahan (1):
  smartpqi: add support for Hurray Data new controller PCI device

Don Brace (1):
  smartpqi: update version to 2.1.36-026

Mike McGowen (2):
  smartpqi: Add timeout value to RAID path requests to physical devices
  smartpqi: Fix device resources accessed after device removal

 drivers/scsi/smartpqi/smartpqi_init.c | 46 +++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 3 deletions(-)

-- 
2.52.0.rc0.28.g4cf919bd7b

