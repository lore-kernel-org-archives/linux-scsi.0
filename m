From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 1/4] mpt2sas: correct scsi_{target,device} hostdata allocation
Date: Mon, 2 Jun 2014 10:34:29 -0400
Message-ID: <1401719672-18352-2-git-send-email-joe.lawrence@stratus.com>
References: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o147.mxlogic.net ([208.65.145.80]:58578 "EHLO
	p02c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbaFBOex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 10:34:53 -0400
In-Reply-To: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Joe Lawrence <joe.lawrence@stratus.com>

In _scsih_{slave,target}_alloc, an incorrect structure type is passed
to sizeof() when allocating storage for hostdata.  Luckily larger
structure types were used, so at least the wrong sizes were safe:

  struct scsi_device (1784 bytes) > struct MPT2SAS_DEVICE (24 bytes)
  struct scsi_target (760 bytes)  > struct MPT2SAS_TARGET (40 bytes)

This fixes the following smatch warnings:

  drivers/scsi/mpt2sas/mpt2sas_scsih.c:1295 _scsih_target_alloc()
    warn: struct type mismatch 'MPT2SAS_TARGET vs scsi_target'

  drivers/scsi/mpt2sas/mpt2sas_scsih.c:1409 _scsih_slave_alloc()
    warn: struct type mismatch 'MPT2SAS_DEVICE vs scsi_device'

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6fd7d40..deb0bd2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1292,7 +1292,8 @@ _scsih_target_alloc(struct scsi_target *starget)
 	unsigned long flags;
 	struct sas_rphy *rphy;
 
-	sas_target_priv_data = kzalloc(sizeof(struct scsi_target), GFP_KERNEL);
+	sas_target_priv_data = kzalloc(sizeof(*sas_target_priv_data),
+				       GFP_KERNEL);
 	if (!sas_target_priv_data)
 		return -ENOMEM;
 
@@ -1406,7 +1407,8 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 	struct _sas_device *sas_device;
 	unsigned long flags;
 
-	sas_device_priv_data = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	sas_device_priv_data = kzalloc(sizeof(*sas_device_priv_data),
+				       GFP_KERNEL);
 	if (!sas_device_priv_data)
 		return -ENOMEM;
 
-- 
1.7.10.4

