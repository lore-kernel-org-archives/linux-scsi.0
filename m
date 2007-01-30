From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/12] libsas: Unknown STP devices should be reported to libata as unknown.
Date: Tue, 30 Jan 2007 01:18:52 -0800
Message-ID: <20070130091852.31530.20090.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48815 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965457AbXA3JQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:21 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9GJew023115
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:19 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9GJsf245412
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:19 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9GJSk010786
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:19 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


When libsas encounters a STP device whose protocol isn't recognized (i.e.
not ATA or ATAPI), we should set the ata_device's class to ATA_DEV_UNKNOWN
instead of ATA_DEV_ATA.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 20f3a5e..7ebda69 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -232,7 +232,7 @@ static void sas_ata_phy_reset(struct ata
 			SAS_DPRINTK("%s: Unknown SATA command set: %d.\n",
 				    __FUNCTION__,
 				    dev->sata_dev.command_set);
-			ap->device[0].class = ATA_DEV_ATA;
+			ap->device[0].class = ATA_DEV_UNKNOWN;
 			break;
 	}
 
