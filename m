Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799181D2F59
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 18:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784933; cv=none; b=IWKc4D2li1S1fJPT649KzTowjpp8W2MPw60SraIM9qf/J10Mbuv/QnjhfNnfIdVksiS5YXPk6ZGbcuwCumhtoJHgktBAYYOGLDs0dNtrY8Cxfq43hqZt1c+yPvbeoHrRQ7/RUyYUtBGMgfacnFag8oU+Z8S6zn6asi2tySnbmyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784933; c=relaxed/simple;
	bh=mLitTLVIEWTLpNkQOcauNdU3fXTzZ31DmzZ7crSfCYs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ntrW/aGyG0LJBM+p85knMbd5Gi+1Z2eoicDqxjJL1+TLMKhgmJ6mMJhKpomHqVGDJyl9sUWQf1pSSJl8A4DjghR9ehRuQF7b2zD4eN2ZK9YqZPCAtoNqEm+bpofapIysxgVsg+Ov8UDIIiNrA8S8AjN9OFWt/MbnpU9ogV948BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=yfBxUzXj; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="yfBxUzXj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1724784932; x=1756320932;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mLitTLVIEWTLpNkQOcauNdU3fXTzZ31DmzZ7crSfCYs=;
  b=yfBxUzXjXXlxvrO89PLx12rSzvkMymicWZk57bsNERl6WktTkw3ZPdTk
   1h/29W5GbjOtKq5E8ZdWRIP4I+YORBwjZ35BhS8RWw5lefQXvFhnd3Cm+
   qhRs/hYFK6Tay+TK9u48K5DoKi0T+5v/j0aErVpoMMc7vSkpTokUfYxfJ
   Mi9+TRvxUvTICXhNTz07a774wAl8AnKnzxF12qZ9PyKqe7WgAAVS5U6iN
   RzkuOFP9KkaNY0RzvMpwjvEnOTXbcQly9/zj4SF+1oPTR7KOlNcDt/Ykd
   a7LVrdZvYiuMkogpLryVfQhYDC5e9DsyfkQsMGGaIj6cTsaqDgvnkbWIU
   Q==;
X-CSE-ConnectionGUID: HXogS4E1Q5emAr2ic36fkw==
X-CSE-MsgGUID: MENWVfU8Q9iZEXbUzludbg==
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="198399618"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Aug 2024 11:55:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Aug 2024 11:55:01 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 27 Aug 2024 11:55:06 -0700
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
Subject: [PATCH 6/7] smartpqi: fix volume size updates
Date: Tue, 27 Aug 2024 13:55:00 -0500
Message-ID: <20240827185501.692804-7-don.brace@microchip.com>
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

Correct logical volume size changes by moving the check for
a volume rescan outside of the check for a queue depth change.

Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d1d117d5d08d..0dab30753f0a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2303,17 +2303,23 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	 * queue depth, device size.
 	 */
 	list_for_each_entry(device, &ctrl_info->scsi_device_list, scsi_device_list_entry) {
+		/*
+		 * Check for queue depth change.
+		 */
 		if (device->sdev && device->queue_depth != device->advertised_queue_depth) {
 			device->advertised_queue_depth = device->queue_depth;
 			scsi_change_queue_depth(device->sdev, device->advertised_queue_depth);
-			spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
-			if (pqi_volume_rescan_needed(device)) {
-				device->rescan = false;
-				spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
-				scsi_rescan_device(device->sdev);
-			} else {
-				spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
-			}
+		}
+		spin_lock_irqsave(&ctrl_info->scsi_device_list_lock, flags);
+		/*
+		 * Check for changes in the device, such as size.
+		 */
+		if (pqi_volume_rescan_needed(device)) {
+			device->rescan = false;
+			spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
+			scsi_rescan_device(device->sdev);
+		} else {
+			spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 		}
 	}
 
-- 
2.46.0.421.g159f2d50e7

