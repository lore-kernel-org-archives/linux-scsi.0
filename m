From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 7/8][SCSI] mpt2sas: Fix for kernel panic when driver loads
 with HBA connected to non LUN 0 configured expander
Date: Thu, 25 Jul 2013 11:32:51 +0530
Message-ID: <20130725060251.GA29914@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:43228
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318Ab3GYGDl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 02:03:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com

With some enclosures when LUN 0 is not created but LUN 1 or LUN X is created
then SCSI scan procedure calls target_alloc, slave_alloc call back functions
for LUN 0 and slave_destory() for same LUN 0.

In these kind of cases within slave_destroy, pointer to scsi_target in
_sas_device structure is set to NULL, following which when slave_alloc for
LUN 1 is called then starget would not be set properly for this LUN.
So, scsi_target pointer pointing to NULL value would lead to a crash later
in the discovery procedure.

To solve this issue set the sas_device's scsi_target pointer to scsi_device's
scsi_target if it is NULL earlier in slave_alloc callback function.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5bd5d05..c89348a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1403,6 +1403,7 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct scsi_target *starget;
 	struct _raid_device *raid_device;
+	struct _sas_device *sas_device;
 	unsigned long flags;
 
 	sas_device_priv_data = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
@@ -1431,6 +1432,19 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 	}
 
+	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+				sas_target_priv_data->sas_address);
+		if (sas_device && (sas_device->starget == NULL)) {
+			sdev_printk(KERN_INFO, sdev,
+			     "%s : sas_device->starget set to starget @ %d\n",
+			     __func__, __LINE__);
+			sas_device->starget = starget;
+		}
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	}
+
 	return 0;
 }
 
-- 
1.7.3


