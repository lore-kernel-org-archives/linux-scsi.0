From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Sun, 20 Jul 2014 20:33:42 -0700
Message-ID: <1405913622-14266-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, apw@canonical.com, jasowang@redhat.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add blist flags to permit the reading of the VPD pages even when
the target may claim SPC-2 compliance. MSFT targets currently
claim SPC-2 compliance while they implement post SPC-2 features.
With this patch we can correctly handle WRITE_SAME_16 issues.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 29d0329..2a58dc4 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -42,6 +42,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_dbg.h>
+#include "scsi_priv.h"
 
 /*
  * All wire protocol details (storage protocol between the guest and the host)
@@ -327,6 +328,8 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
  */
 static int storvsc_timeout = 180;
 
+static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
+
 #define STORVSC_MAX_IO_REQUESTS				200
 
 static void storvsc_on_channel_callback(void *context);
@@ -1438,6 +1441,8 @@ static void storvsc_device_destroy(struct scsi_device *sdevice)
 
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
+	int blist_flags;
+
 	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
 				STORVSC_MAX_IO_REQUESTS);
 
@@ -1449,6 +1454,14 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 
+	blist_flags = scsi_get_device_flags_keyed(sdevice, "Msft",
+						  "Virtual Disk",
+						  SCSI_DEVINFO_GLOBAL);
+
+	if (blist_flags != msft_blist_flags)
+		scsi_dev_info_list_add_keyed(1, "Msft", "Virtual Disk", NULL,
+					     msft_blist_flags,
+					     SCSI_DEVINFO_GLOBAL);
 	return 0;
 }
 
-- 
1.7.4.1
