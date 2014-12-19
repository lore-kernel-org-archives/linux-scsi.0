From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH v2 2/3] [SCSI] mpt2sas: Simplify the code of
 mpt2sas_scsih_tm_flag
Date: Fri, 19 Dec 2014 13:40:21 +0100
Message-ID: <20141219124021.GA20285@sloth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Since skip was only used to pass through the rest of the loop,
a break statment is called where skip was previously assigned 1.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index a6f89fd..6162a89 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2265,18 +2265,15 @@ mpt2sas_scsih_tm_flag(struct MPT2SAS_ADAPTER *ioc, u16 handle, u8 action)
 {
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
-	u8 skip = 0;
 
 	shost_for_each_device(sdev, ioc->shost) {
-		if (skip)
-			continue;
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data)
 			continue;
 		if (sas_device_priv_data->sas_target->handle == handle) {
 			sas_device_priv_data->sas_target->tm_busy = action;
-			skip = 1;
 			ioc->ignore_loginfos = action;
+			break;
 		}
 	}
 }
-- 
1.9.1
