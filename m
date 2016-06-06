From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 3/3] scsi: Use device_match_always()
Date: Mon,  6 Jun 2016 09:32:38 +0200
Message-ID: <20160606073238.1073-3-thierry.reding@gmail.com>
References: <20160606073238.1073-1-thierry.reding@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160606073238.1073-1-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

There is now a common implementation for a match function that will
always match, so the SCSI-specific implementation can be removed.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/scsi/scsi_proc.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 7a74b82e8973..4adcdc2caf27 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -371,15 +371,10 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 	return err;
 }
 
-static int always_match(struct device *dev, void *data)
-{
-	return 1;
-}
-
 static inline struct device *next_scsi_device(struct device *start)
 {
 	struct device *next = bus_find_device(&scsi_bus_type, start, NULL,
-					      always_match);
+					      device_match_always);
 	put_device(start);
 	return next;
 }
-- 
2.8.3
