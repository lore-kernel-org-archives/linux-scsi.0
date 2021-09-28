Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F114C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0462A60C41
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243341AbhI1X4d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:33 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8279 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243327AbhI1X4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873284; x=1664409284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H25nqRc0aQRSWZUYHIISSMrlXidIM8OGoS0Ve9vfChI=;
  b=l1Cd+Oh/3EH8aRIQDH4woXsHIZ9lA2vtZSyn3B+SjqruxFuDxq4bVGo7
   MiL6Kx0aoEp/NRe41Pf+51WtB03yjX0cn5wkVZirquEkUY2Yo21TURuX2
   tAKEN0IJpiG5ntKnYOXVYn6hr+Cc35iYe8UcVK0PPkeA//jqrD+j1RPHB
   fT9gp0nmXGa/S/pcBkOcu9NlXbI3546f0foQC11PRHonvxt7viDgzjR0A
   3ukSU+9rGJCTNq0O3zCX7cQ98wBFA0EEu9Ykb0lRYDbyBpl/4IWIbA1rD
   QDbXQ/wKcqjDxolE7d9O63dTlqUtRZlg4qRnawM0/ZzEla06Y6xodEfbP
   w==;
IronPort-SDR: z5Qt2VIffvKGom0hk/9YsLCEM2hCHrZzkvLmOZP0sywueJcAbsoMxSQsq8fO4cTVfRHXgXTiXj
 RlcIkhuWj9cPCg/3nTZLMAR80Q6dDZHWUQ6NrH4Ty3G+pIWSyQEFZOgxra4g/XDSmwP0pzvuu7
 R3ynFoDI0pM84P1CIf1i2a23s98wyJA2dGuG9XslONjNrbinbbaOomrSLtWgRxOFoPH5jas7Bg
 0OQhTHXqZjN99WkHeJJVT1/PBnRVzEH72FjOviaIC/V3qBDJmijzUC8BISVGIngW6xHlxL8Dze
 N/7sP6bE87XqX1DFKpJTKr3G
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="138333252"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:43 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 91AB470291B; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate device nodes for tape changers
Date:   Tue, 28 Sep 2021 18:54:40 -0500
Message-ID: <20210928235442.201875-10-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Stop the OS from re-discovering multiple LUNs for
tape drive and medium changer.

Duplicate device nodes for Ultrium tape drive and
medium changer are being created.

The Ultrium tape drive is a multi-LUN SCSI target.
It presents a LUN for the tape drive and a 2nd
LUN for the medium changer.
Our controller FW lists both LUNs in the RPL
results.

As a result, the smartpqi driver exposes both
devices to the OS. Then the OS does its normal
device discovery via the SCSI REPORT LUNS command,
which causes it to re-discover both devices a 2nd time,
which results in the duplicate device nodes.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |  1 +
 drivers/scsi/smartpqi/smartpqi_init.c | 23 +++++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index c439583a4ca5..aac88ac0a0b7 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1106,6 +1106,7 @@ struct pqi_scsi_dev {
 	u8	keep_device : 1;
 	u8	volume_offline : 1;
 	u8	rescan : 1;
+	u8	ignore_device : 1;
 	bool	aio_enabled;		/* only valid for physical disks */
 	bool	in_remove;
 	bool	device_offline;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c28eb7ea4a24..8be116992cb0 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6297,9 +6297,13 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
 		rphy = target_to_rphy(starget);
 		device = pqi_find_device_by_sas_rphy(ctrl_info, rphy);
 		if (device) {
-			device->target = sdev_id(sdev);
-			device->lun = sdev->lun;
-			device->target_lun_valid = true;
+			if (device->target_lun_valid) {
+				device->ignore_device = true;
+			} else {
+				device->target = sdev_id(sdev);
+				device->lun = sdev->lun;
+				device->target_lun_valid = true;
+			}
 		}
 	} else {
 		device = pqi_find_scsi_dev(ctrl_info, sdev_channel(sdev),
@@ -6336,14 +6340,25 @@ static int pqi_map_queues(struct Scsi_Host *shost)
 					ctrl_info->pci_dev, 0);
 }
 
+static inline bool pqi_is_tape_changer_device(struct pqi_scsi_dev *device)
+{
+	return device->devtype == TYPE_TAPE || device->devtype == TYPE_MEDIUM_CHANGER;
+}
+
 static int pqi_slave_configure(struct scsi_device *sdev)
 {
+	int rc = 0;
 	struct pqi_scsi_dev *device;
 
 	device = sdev->hostdata;
 	device->devtype = sdev->type;
 
-	return 0;
+	if (pqi_is_tape_changer_device(device) && device->ignore_device) {
+		rc = -ENXIO;
+		device->ignore_device = false;
+	}
+
+	return rc;
 }
 
 static int pqi_getpciinfo_ioctl(struct pqi_ctrl_info *ctrl_info, void __user *arg)
-- 
2.28.0.rc1.9.ge7ae437ac1

