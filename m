From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2 04/11] mpt3sas: correct scsi_{target,device} hostdata allocation
Date: Wed, 25 Jun 2014 17:04:22 -0400
Message-ID: <1403730262-20079-1-git-send-email-joe.lawrence@stratus.com>
References: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o145.mxlogic.net ([208.65.145.78]:53503 "EHLO
	p02c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaFYVEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 17:04:44 -0400
In-Reply-To: <1403730058-19872-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Christoph Hellwig <hch@lst.de>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Joe Lawrence <joe.lawrence@stratus.com>

In _scsih_{slave,target}_alloc, an incorrect structure type is passed
to sizeof() when allocating storage for hostdata.  Luckily larger
structure types were used, so at least the wrong sizes were safe:

  struct scsi_device (1784 bytes) > struct MPT3SAS_DEVICE (24 bytes)
  struct scsi_target (760 bytes)  > struct MPT3SAS_TARGET (32 bytes)

This fixes the following smatch warnings:

  drivers/scsi/mpt3sas/mpt3sas_scsih.c:1166 _scsih_target_alloc()
    warn: struct type mismatch 'MPT3SAS_TARGET vs scsi_target'

  drivers/scsi/mpt3sas/mpt3sas_scsih.c:1280 _scsih_slave_alloc()
    warn: struct type mismatch 'MPT3SAS_DEVICE vs scsi_device'

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 18e713d..f3ee3b4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1163,7 +1163,8 @@ _scsih_target_alloc(struct scsi_target *starget)
 	unsigned long flags;
 	struct sas_rphy *rphy;
 
-	sas_target_priv_data = kzalloc(sizeof(struct scsi_target), GFP_KERNEL);
+	sas_target_priv_data = kzalloc(sizeof(*sas_target_priv_data),
+				       GFP_KERNEL);
 	if (!sas_target_priv_data)
 		return -ENOMEM;
 
@@ -1277,7 +1278,8 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 	struct _sas_device *sas_device;
 	unsigned long flags;
 
-	sas_device_priv_data = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	sas_device_priv_data = kzalloc(sizeof(*sas_device_priv_data),
+				       GFP_KERNEL);
 	if (!sas_device_priv_data)
 		return -ENOMEM;
 
-- 
1.7.10.4

