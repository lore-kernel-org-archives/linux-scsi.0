From: David Singleton <davsingl@cisco.com>
Subject: [PATCH] sd: assign appropriate log level
Date: Mon, 17 Oct 2016 09:51:07 -0700
Message-ID: <20161017165108.29718-4-davsingl@cisco.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shikhar Dogra <shidogra@cisco.com>, xe-kernel@external.cisco.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Shikhar Dogra <shidogra@cisco.com>

Reduce chatter on console for usb hotplug.
KERN_ERR is too high severity for these messages, moving them
to KERN_WARNING

USB devices never have a Caching Mode page, it doesn't make
sense to make it an error when you have tons of USB devices where
the print is useless, and not an error.

For second message, the condition is not an error. The existing
workaround of assuming a write through cache doesn't limit
functionality in any way.

Cc: xe-kernel@external.cisco.com
Signed-off-by: Shikhar Dogra <shidogra@cisco.com>
Signed-off-by: David Singleton <davsingl@cisco.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 51e5629..ab7bfe3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2540,7 +2540,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			}
 		}
 
-		sd_first_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		sd_first_printk(KERN_WARNING, sdkp, "No Caching mode page found\n");
 		goto defaults;
 
 	Page_found:
@@ -2594,7 +2594,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 				"Assuming drive cache: write back\n");
 		sdkp->WCE = 1;
 	} else {
-		sd_first_printk(KERN_ERR, sdkp,
+		sd_first_printk(KERN_WARNING, sdkp,
 				"Assuming drive cache: write through\n");
 		sdkp->WCE = 0;
 	}
-- 
2.9.3
