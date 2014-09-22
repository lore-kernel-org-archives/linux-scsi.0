From: Joe Perches <joe@perches.com>
Subject: [PATCH] scsi: sas_ata: change ata_<foo>_printk routines to return
 void
Date: Mon, 22 Sep 2014 10:01:24 -0700
Message-ID: <1411405284.2952.42.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Todd Brandt <todd.e.brandt@intel.com>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The return value is not used by callers of this function
so change the function to return void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

 drivers/scsi/libsas/sas_ata.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 766098a..2a15a54 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -375,26 +375,23 @@ static int local_ata_check_ready(struct ata_link *link)
 	}
 }
 
-static int sas_ata_printk(const char *level, const struct domain_device *ddev,
-			  const char *fmt, ...)
+static void sas_ata_printk(const char *level, const struct domain_device *ddev,
+			   const char *fmt, ...)
 {
 	struct ata_port *ap = ddev->sata_dev.ap;
 	struct device *dev = &ddev->rphy->dev;
 	struct va_format vaf;
 	va_list args;
-	int r;
 
 	va_start(args, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	r = printk("%ssas: ata%u: %s: %pV",
-		   level, ap->print_id, dev_name(dev), &vaf);
+	printk("%ssas: ata%u: %s: %pV",
+	       level, ap->print_id, dev_name(dev), &vaf);
 
 	va_end(args);
-
-	return r;
 }
 
 static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
