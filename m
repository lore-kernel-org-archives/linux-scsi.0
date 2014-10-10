From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: [PATCH 2/3] scsi: add try_rc16 blacklist flag
Date: Fri, 10 Oct 2014 08:52:51 +0100
Message-ID: <20141010075251.GC32028@sucs.org>
References: <20141010074901.GA32028@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20141010074901.GA32028@sucs.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Microsoft Hyper-V virtual disks currently only claim SPC-2 compliance causing
the kernel skip checks for features such as thin provisioning even though the
virtual disk advertises them.

Add a blacklist flag that can allow such devices to quirk past READ
CAPACITY(16) guards.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 drivers/scsi/scsi_scan.c    | 3 +++
 drivers/scsi/sd.c           | 3 +++
 include/scsi/scsi_device.h  | 1 +
 include/scsi/scsi_devinfo.h | 1 +
 4 files changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ba3f1e8..d3f6267 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -962,6 +962,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
+	if (*bflags & BLIST_TRY_RC16)
+		sdev->try_rc16 = 1;
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0cb5c9f..0ccf372 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2143,6 +2143,9 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 		return 0;
 	if (sdp->scsi_level > SCSI_SPC_2)
 		return 1;
+	if (sdp->try_rc16) {
+		return 1;
+	}
 	if (scsi_device_protection(sdp))
 		return 1;
 	return 0;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 27ecee7..d6e2bd8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -155,6 +155,7 @@ struct scsi_device {
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
 	unsigned try_vpd_pages:1;	/* attempt to read VPD pages */
+	unsigned try_rc16:1;		/* attempt READ CAPACITY(16) */
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 183eaab..9431f5e 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -36,5 +36,6 @@
 					     for sequential scan */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
+#define BLIST_TRY_RC16		0x40000000 /* Attempt READ CAPACITY(16) */
 
 #endif
-- 
1.9.3
