From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 3/7][SCSI] mpt3sas: fix for kernel panic when driver loads
 with HBA conected to non LUN 0 configured expander
Date: Sat, 29 Jun 2013 03:52:03 +0530
Message-ID: <20130628222203.GA5050@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com
List-Id: linux-scsi@vger.kernel.org


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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 73d3b81..9ebc9dc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1273,6 +1273,7 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_target *starget;
 	struct _raid_device *raid_device;
+	struct _sas_device *sas_device;
 	unsigned long flags;
 
 	sas_device_priv_data = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
@@ -1301,6 +1302,19 @@ _scsih_slave_alloc(struct scsi_device *sdev)
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 	}
 
+	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+					sas_target_priv_data->sas_address);
+		if (sas_device && (sas_device->starget == NULL)) {
+			sdev_printk(KERN_INFO, sdev,
+			"%s : sas_device->starget set to starget @ %d\n",
+				__func__, __LINE__);
+			sas_device->starget = starget;
+		}
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	}
+
 	return 0;
 }
 
-- 
1.7.3
