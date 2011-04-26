From: Martin George <marting@netapp.com>
Subject: [PATCH] [SCSI] scsi_dh_alua: Attach to UNAVAILABLE/OFFLINE AAS devices
Date: Tue, 26 Apr 2011 18:27:05 +0530
Message-ID: <201104261827.06024.marting@netapp.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:13135 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234Ab1DZM5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2011 08:57:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

The SCSI ALUA handler currently fails to attach to devices
reporting an UNAVAILABLE/OFFLINE AAS. But given that an
UNAVAILABLE/OFFLINE AAS can transition to other states
like ACTIVE/OPTIMIZED, ACTIVE/NON-OPTIMIZED, etc. as per
SPC4, this ALUA handler behavior should be rectified so
as to attach to devices which also report an
UNAVAILABLE/OFFLINE AAS.

The below patch enables the same.

Signed-off-by: Martin George <marting@netapp.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 42fe529..6fec9fe 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -782,7 +782,7 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	h->sdev = sdev;
 
 	err = alua_initialize(sdev, h);
-	if (err != SCSI_DH_OK)
+	if ((err != SCSI_DH_OK) && (err != SCSI_DH_DEV_OFFLINED))
 		goto failed;
 
 	if (!try_module_get(THIS_MODULE))
-- 
1.6.3.3

