From: Steven Honeyman <stevenhoneyman@gmail.com>
Subject: [PATCH] sd: assign more appropriate log levels for two messages
Date: Sat, 13 Sep 2014 22:25:14 +0100
Message-ID: <CABz95_CLet-UzaUq-z1pRMvEpzkCTYbKbYWBcS0dQZ1iYGryzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

KERN_ERR is too high severity for an "assumption" message, so I moved
them down to KERN_WARNING

Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c2041c..bb7d6e9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2468,7 +2468,7 @@ sd_read_cache_type(struct scsi_disk *sdkp,
unsigned char *buffer)
             }
         }

-        sd_first_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+        sd_first_printk(KERN_WARNING, sdkp, "No Caching mode page found\n");
         goto defaults;

     Page_found:
@@ -2518,7 +2518,7 @@ defaults:
                 "Assuming drive cache: write back\n");
         sdkp->WCE = 1;
     } else {
-        sd_first_printk(KERN_ERR, sdkp,
+        sd_first_printk(KERN_WARNING, sdkp,
                 "Assuming drive cache: write through\n");
         sdkp->WCE = 0;
     }
-- 
2.1.0
