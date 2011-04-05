From: Michal Marek <mmarek@suse.cz>
Subject: [PATCH 32/34] pmcraid: Drop __DATE__ usage
Date: Tue,  5 Apr 2011 16:59:19 +0200
Message-ID: <1302015561-21047-33-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kbuild-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/scsi/pmcraid.c |    9 ++++-----
 drivers/scsi/pmcraid.h |    1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 321cf3a..7c13201 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4249,8 +4249,8 @@ static ssize_t pmcraid_show_drv_version(
 	char *buf
 )
 {
-	return snprintf(buf, PAGE_SIZE, "version: %s, build date: %s\n",
-			PMCRAID_DRIVER_VERSION, PMCRAID_DRIVER_DATE);
+	return snprintf(buf, PAGE_SIZE, "version: %s\n",
+			PMCRAID_DRIVER_VERSION);
 }
 
 static struct device_attribute pmcraid_driver_version_attr = {
@@ -6093,9 +6093,8 @@ static int __init pmcraid_init(void)
 	dev_t dev;
 	int error;
 
-	pmcraid_info("%s Device Driver version: %s %s\n",
-			 PMCRAID_DRIVER_NAME,
-			 PMCRAID_DRIVER_VERSION, PMCRAID_DRIVER_DATE);
+	pmcraid_info("%s Device Driver version: %s\n",
+			 PMCRAID_DRIVER_NAME, PMCRAID_DRIVER_VERSION);
 
 	error = alloc_chrdev_region(&dev, 0,
 				    PMCRAID_MAX_ADAPTERS,
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 4db210d..d302737 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -43,7 +43,6 @@
 #define PMCRAID_DRIVER_NAME		"PMC MaxRAID"
 #define PMCRAID_DEVFILE			"pmcsas"
 #define PMCRAID_DRIVER_VERSION		"1.0.3"
-#define PMCRAID_DRIVER_DATE		__DATE__
 
 #define PMCRAID_FW_VERSION_1		0x002
 
-- 
1.7.4.1

