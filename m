From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: osd_uld: fix mismerge
Date: Wed, 19 Apr 2017 19:44:01 +0200
Message-ID: <20170419174415.4029467-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A mismerge between two branches in linux-next reintroduced a warning that was
previously resolved:

drivers/scsi/osd/osd_uld.c: In function 'osd_probe':
drivers/scsi/osd/osd_uld.c:457:2: error: ignoring return value of 'scsi_device_get', declared with attribute warn_unused_result [-Werror=unused-result]

The original fix had more complex error unrolling, but as far as I
can tell, this simpler version is now sufficient.

Fixes: c02465fa13b6 ("scsi: osd_uld: Check scsi_device_get() return value")
Fixes: ac1ddc584e98 ("scsi: utilize new cdev_device_add helper function")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/osd/osd_uld.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 8b9941a5687a..0e56f1eb05dc 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -454,7 +454,8 @@ static int osd_probe(struct device *dev)
 	/* hold one more reference to the scsi_device that will get released
 	 * in __release, in case a logout is happening while fs is mounted
 	 */
-	scsi_device_get(scsi_device);
+	if (scsi_device_get(scsi_device))
+		goto err_retract_minor;
 	osd_dev_init(&oud->od, scsi_device);
 
 	/* allocate a disk and set it up */
-- 
2.9.0
