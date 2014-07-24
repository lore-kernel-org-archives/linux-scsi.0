From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: [PATCH 1/3] [SCSI] Add quirk for forcing logical block provisioning
 tests
Date: Thu, 24 Jul 2014 08:52:07 +0100
Message-ID: <20140724075207.GB15127@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723141028.GA22724@sucs.org>
 <20140723141558.GA9705@infradead.org>
 <20140723201341.GA10292@sucs.org> <20140724074739.GA15127@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20140724074739.GA15127@sucs.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

Despite supporting modern SCSI features (such an UNMAP) some storage
devices continue to claim conformance to an older version of the SPC
spec for compatibility with legacy operating systems.

Linux by default will not attempt to read VPD pages on devices that
claim SPC-2 or older.

Introduce a blacklist flag that allows the forcing of the paths leading
to logical block provisioning tests.

See https://lkml.org/lkml/2014/7/13/59 for the previous version.

Reported-by: K. Y. Srinivasan <kys@microsoft.com>
Original-patch-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 drivers/scsi/scsi_scan.c    |  4 +++-
 drivers/scsi/sd.c           |  8 ++++++++
 drivers/scsi/storvsc_drv.c  | 10 ++++++++++
 include/scsi/scsi_device.h  |  1 +
 include/scsi/scsi_devinfo.h |  2 ++
 5 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e02b3aa..02ca1c2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -950,7 +950,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
-	if (*bflags & BLIST_SKIP_VPD_PAGES)
+	if (*bflags & BLIST_TRY_LBP)
+		sdev->try_lbp = 1;
+	else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
 	transport_configure_device(&sdev->sdev_gendev);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6825eda..8249e51 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2109,6 +2109,8 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 		return 1;
 	if (scsi_device_protection(sdp))
 		return 1;
+	if (sdp->try_lbp)
+		return 1;
 	return 0;
 }
 
@@ -2682,6 +2684,12 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 static int sd_try_extended_inquiry(struct scsi_device *sdp)
 {
 	/*
+	 * Attempt VPD inquiry if the device blacklist explicitly calls
+	 * for it.
+	 */
+	if (sdp->try_lbp)
+		return 1;
+	/*
 	 * Although VPD inquiries can go to SCSI-2 type devices,
 	 * some USB ones crash on receiving them, and the pages
 	 * we currently ask for are for SPC-3 and beyond
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9969fa1..5ad2810 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -326,6 +326,8 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
  */
 static int storvsc_timeout = 180;
 
+static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
+
 #define STORVSC_MAX_IO_REQUESTS				200
 
 static void storvsc_on_channel_callback(void *context);
@@ -1441,6 +1443,14 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 
+	/*
+	 * Add blist flags to permit the reading of the VPD pages even when
+	 * the target may claim SPC-2 compliance. MSFT targets currently
+	 * claim SPC-2 compliance while they implement post SPC-2 features.
+	 * With this patch we can correctly handle WRITE_SAME_16 issues.
+	 */
+	sdevice->sdev_bflags |= msft_blist_flags;
+
 	return 0;
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 27ab310..0a5c6fa 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -155,6 +155,7 @@ struct scsi_device {
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
+	unsigned try_lbp:1;		/* Try LBP tests */
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 447d2d7..9d15d78 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -32,4 +32,6 @@
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
+#define BLIST_TRY_LBP		0x10000000 /* Check Logical Block Provisioning
+					      even on < SPC-3 devices */
 #endif
-- 
1.9.3
