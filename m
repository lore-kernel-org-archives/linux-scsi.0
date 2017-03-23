From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: osd_uld: remove an unneeded NULL check
Date: Thu, 23 Mar 2017 13:41:42 +0300
Message-ID: <20170323104142.GD20154@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: Benny Halevy <bhalevy@primarydata.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We don't call the remove() function unless probe() succeeds so "oud"
can't be NULL here.  Plus, if it were NULL, we dereference it on the
next line so it would crash anyway.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 4101c3178411..8b9941a5687a 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -507,10 +507,9 @@ static int osd_remove(struct device *dev)
 	struct scsi_device *scsi_device = to_scsi_device(dev);
 	struct osd_uld_device *oud = dev_get_drvdata(dev);
 
-	if (!oud || (oud->od.scsi_device != scsi_device)) {
-		OSD_ERR("Half cooked osd-device %p,%p || %p!=%p",
-			dev, oud, oud ? oud->od.scsi_device : NULL,
-			scsi_device);
+	if (oud->od.scsi_device != scsi_device) {
+		OSD_ERR("Half cooked osd-device %p, || %p!=%p",
+			dev, oud->od.scsi_device, scsi_device);
 	}
 
 	cdev_device_del(&oud->cdev, &oud->class_dev);
