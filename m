From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] storvsc: workaround for virtual DVD SCSI version
Date: Tue,  7 Mar 2017 09:15:53 -0800
Message-ID: <20170307171553.13247-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: kys@microsoft.com, haiyangz@microsoft.com, longli@microsoft.com, martin.petersen@oracle.com, hch@lst.de, hare@suse.de
Cc: devel@linuxdriverproject.org, Stephen Hemminger <sthemmin@microsoft.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hyper-V host emulation of SCSI for virtual DVD device reports SCSI
version 0 (UNKNOWN) but is still capable of supporting REPORTLUN. 

Without this patch, a GEN2 Linux guest on Hyper-V will not boot 4.11
successfully with virtual DVD ROM device. What happens is that the
SCSI scan process falls back to doing sequential probing by INQUIRY.
But the storvsc driver has a previous workaround that masks/blocks all
errors reports from INQUIRY (or MODE_SENSE) commands.  This workaround
causes the scan to then populate a full set of bogus LUN's on the
target and then sends kernel spinning off into a death spiral doing
block reads on the non-existent LUNs.

By setting the correct blacklist flags, the target with the
DVD device is scanned with REPORTLUN and that works correctly.

Patch needs to go in current 4.11, it is safe but not necessary
in older kernels.

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

PS: The error handling does need to be fixed (have patches pending)
but that is interrelated with hotplug and can wait.

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 638e5f427c90..19973e874830 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -400,8 +400,6 @@ MODULE_PARM_DESC(storvsc_vcpus_per_sub_channel, "Ratio of VCPUs to subchannels")
  */
 static int storvsc_timeout = 180;
 
-static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
-
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 static struct scsi_transport_template *fc_transport_template;
 #endif
@@ -1383,6 +1381,22 @@ static int storvsc_do_io(struct hv_device *device,
 	return ret;
 }
 
+static int storvsc_device_alloc(struct scsi_device *sdevice)
+{
+	/*
+	 * Set blist flag to permit the reading of the VPD pages even when
+	 * the target may claim SPC-2 compliance. MSFT targets currently
+	 * claim SPC-2 compliance while they implement post SPC-2 features.
+	 * With this flag we can correctly handle WRITE_SAME_16 issues.
+	 *
+	 * Hypervisor reports SCSI_UNKNOWN type for DVD ROM device but
+	 * still supports REPORT LUN.
+	 */
+	sdevice->sdev_bflags = BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES;
+
+	return 0;
+}
+
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
 
@@ -1396,14 +1410,6 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	sdevice->no_write_same = 1;
 
 	/*
-	 * Add blist flags to permit the reading of the VPD pages even when
-	 * the target may claim SPC-2 compliance. MSFT targets currently
-	 * claim SPC-2 compliance while they implement post SPC-2 features.
-	 * With this patch we can correctly handle WRITE_SAME_16 issues.
-	 */
-	sdevice->sdev_bflags |= msft_blist_flags;
-
-	/*
 	 * If the host is WIN8 or WIN8 R2, claim conformance to SPC-3
 	 * if the device is a MSFT virtual device.  If the host is
 	 * WIN10 or newer, allow write_same.
@@ -1661,6 +1667,7 @@ static struct scsi_host_template scsi_driver = {
 	.eh_host_reset_handler =	storvsc_host_reset_handler,
 	.proc_name =		"storvsc_host",
 	.eh_timed_out =		storvsc_eh_timed_out,
+	.slave_alloc =		storvsc_device_alloc,
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		255,
 	.this_id =		-1,
-- 
2.11.0
