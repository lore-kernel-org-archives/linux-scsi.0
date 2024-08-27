Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7809B1D2F57
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 18:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784935; cv=none; b=fAYjzKOPG6sNSImrbeojRpgquwNKoO9S6IQsc6Xx2b880CaIoFKwyiZ7mgjT1L+VGV1MJBKOzTXq3dPb0Bq4+VtAJ2f7sfvEvhZNS22YRHDPaVptbxiPAOdnhf8xcGnuAdQ8uTKAhZQS0O22rOPdUGUXDIxQxIxDJLGWAcywC6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784935; c=relaxed/simple;
	bh=EkjeigIzbeUE0Dot+e8ArizcQGN5koMeaQY0OldUnkQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZPnTmCvXGpXCmnpG7uJN5aAFIdJ9VgvgWgclZTJ0rBbbrKzmUqvSQVm7xzRXO0lGX7pJxQ8v4V16cZEfAadV5uB0QhXLalrv3cZlkVjZ9O80ACzJm03R+U/y/WTdZxWpUmeqFSDcBJOiIwxm0wqf00/C5uXzi+bzbPPUL/YTcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=G1SeTW4D; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="G1SeTW4D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1724784932; x=1756320932;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EkjeigIzbeUE0Dot+e8ArizcQGN5koMeaQY0OldUnkQ=;
  b=G1SeTW4Dvn6T0+jCFt5uzzq0Bc75G0bg3PocwpA9NyNC2r0pQOARBoxb
   4P3CgQYotps6qND7MqRYV6tlrphT3IZ5uJ1F3S8vs/tNpM6OYg/gdbmQo
   FCu6N1gLRZVLBI8PI75DPhkotNF/rwGVD/24O+sRKtDLpRJVnNCDRAZ4I
   T9kXTjeZEDLBy9+feD6HLBIX1qvYIw3lzJIK+uN237xwkDWhr5M6Lb+mN
   ASyuV9algDG4tj1D6BuwY9dyQkuFAXCytEWi14tmABW4e02PO5HBPjsuH
   vgX18WHwW90ol+3BC6LR1XOJeJNVUrkmBWTmqSmlnkQB+siUcwNDKdRP8
   Q==;
X-CSE-ConnectionGUID: HXogS4E1Q5emAr2ic36fkw==
X-CSE-MsgGUID: 5Y5EdCAyTWaRBOIqMGGc8Q==
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="198399617"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Aug 2024 11:55:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Aug 2024 11:55:00 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 27 Aug 2024 11:55:05 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
	<gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
	<mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
	<kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
	<david.strahan@microchip.com>, <hch@infradead.org>, James Bottomley
	<James.Bottomley@HansenPartnership.com>, Martin Petersen
	<martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 5/7] smartpqi: fix rare system hang during LUN reset
Date: Tue, 27 Aug 2024 13:54:59 -0500
Message-ID: <20240827185501.692804-6-don.brace@microchip.com>
X-Mailer: git-send-email 2.46.0.421.g159f2d50e7
In-Reply-To: <20240827185501.692804-1-don.brace@microchip.com>
References: <20240827185501.692804-1-don.brace@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Correct a rare case where in a LUN reset occurs on a device
and I/O requests for other devices persist in the driver's internal
request queue.

Part of a LUN reset involves waiting for our internal request queue
to empty before proceeding. The internal request queue contains requests
not yet sent down to the controller.

We were clearing the requests queued for the LUN undergoing a reset, but
not all of the queued requests. Causing a hang.

For all requests in our internal request queue:
   Complete requests with DID_RESET for queued requests for the device
   undergoing a reset.

   Complete requests with DID_REQUEUE for all other queued requests.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 46bef2cf95c4..d1d117d5d08d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6200,14 +6200,12 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 					continue;
 
 				scsi_device = scmd->device->hostdata;
-				if (scsi_device != device)
-					continue;
-
-				if ((u8)scmd->device->lun != lun)
-					continue;
 
 				list_del(&io_request->request_list_entry);
-				set_host_byte(scmd, DID_RESET);
+				if (scsi_device == device && (u8)scmd->device->lun == lun)
+					set_host_byte(scmd, DID_RESET);
+				else
+					set_host_byte(scmd, DID_REQUEUE);
 				pqi_free_io_request(io_request);
 				scsi_dma_unmap(scmd);
 				pqi_scsi_done(scmd);
-- 
2.46.0.421.g159f2d50e7

