From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH 5/5] mptfusion: Allow fast timed-out io recovery
Date: Mon, 20 May 2013 15:15:03 +0800
Message-ID: <1369034103-31644-6-git-send-email-renmx@cn.fujitsu.com>
References: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, james.smart@emulex.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, michaelc@cs.wisc.edu
Cc: robert.w.love@intel.com, dgilbert@interlog.com, hare@suse.de, bprakash@broadcom.com, agk@redhat.com, neilb@suse.de, gregkh@linuxfoundation.org, axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

This patch implements fast timed-out io recovery in LLDD(mptfusion)
by checking the corresponding bit fields specified in the new added
interface "fast_io_tmo_flags" and returning "FAST_IO" to avoid the
scsi_eh recovery actions on corresponding levels.

This is mainly for redundant configurations. To non-redundant
systems, the thorough recovery is necessary.

Furthermore, userland tools such as mdadm should ensure that this
policy is available only if there are more than one mirrored
devices active, which will be implemented later.

NOTE: the device reset handler isn't implemented and the bus rest
handler isn't defined for mptsas_driver_template.

Here is an example which can show the improvement of this patch on
md-raid1 devices:

  before:
    - takes about 69s to write 8GB normally
    # dd if=/dev/zero of=/dev/md0 bs=4k count=2000000
    2000000+0 records in
    2000000+0 records out
    8192000000 bytes (8.2 GB) copied, 68.7898 s, 119 MB/s

    - takes about 188s to write 8GB when I/Os timed out
    # grep mptsas_driver_template /proc/kallsyms
    ffffffffa00485c0 d mptsas_driver_template   [mptsas]
    # insmod scsi_timeout.ko param=0xffffffffa00485c0,1:0:1:0[*]
    # dd if=/dev/zero of=/dev/md0 bs=4k count=2000000
    2000000+0 records in
    2000000+0 records out
    8192000000 bytes (8.2 GB) copied, 187.857 s, 43.6 MB/s

  after:
    - takes about 129s to write 8GB by using this patch when I/Os
      timed out
    # echo 0x1f > /sys/devices/pci0000:00/0000:00:03.0/\
                   0000:01:00.0/0000:02:00.0/0000:03:00.0/\
                   0000:04:03.0/0000:08:00.0/host1/port-1:1/\
                   end_device-1:1/sas_device/end_device-1:1/\
                   fast_io_tmo_flags
    # insmod scsi_timeout.ko param=0xffffffffa00485c0,1:0:1:0
    # dd if=/dev/zero of=/dev/md127 bs=4k count=2000000
    2000000+0 records in
    2000000+0 records out
    8192000000 bytes (8.2 GB) copied, 129.478 s, 63.3 MB/s

  * scsi_timeout.ko is a self-made module which wraps the scsi
    queuecommand handler and ignores I/Os to the specified device
    and any I/Os are not passed to LLDD.
    Reference:
      http://www.spinics.net/lists/linux-scsi/msg35091.html

So with this patch, we just spend time writing(about 69s) and
waiting through timeout(60s), and save about 59s in scsi eh.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
 drivers/message/fusion/mptscsih.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..47ef776 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -62,6 +62,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_transport_sas.h>
 
 #include "mptbase.h"
 #include "mptscsih.h"
@@ -1698,6 +1699,12 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	int		 retval;
 	VirtDevice	 *vdevice;
 	MPT_ADAPTER	*ioc;
+	struct sas_rphy	*rphy = target_to_rphy(SCpnt->device->sdev_target);
+
+	if (rphy->fast_io_tmo_flags & SAS_RPHY_IGN_ABORT_CMDS) {
+		scsi_device_set_state(SCpnt->device, SDEV_OFFLINE);
+		return FAST_IO;
+	}
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1818,6 +1825,12 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 	int		 retval;
 	VirtDevice	 *vdevice;
 	MPT_ADAPTER	*ioc;
+	struct sas_rphy	*rphy = target_to_rphy(SCpnt->device->sdev_target);
+
+	if (rphy->fast_io_tmo_flags & SAS_RPHY_IGN_TARGET_RESET) {
+		scsi_device_set_state(SCpnt->device, SDEV_OFFLINE);
+		return FAST_IO;
+	}
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1878,6 +1891,12 @@ mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 	int		 retval;
 	VirtDevice	 *vdevice;
 	MPT_ADAPTER	*ioc;
+	struct sas_rphy	*rphy = target_to_rphy(SCpnt->device->sdev_target);
+
+	if (rphy->fast_io_tmo_flags & SAS_RPHY_IGN_BUS_RESET) {
+		scsi_device_set_state(SCpnt->device, SDEV_OFFLINE);
+		return FAST_IO;
+	}
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -1924,10 +1943,16 @@ mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 int
 mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 {
-	MPT_SCSI_HOST *  hd;
-	int              status = SUCCESS;
+	MPT_SCSI_HOST	*hd;
+	int		status = SUCCESS;
 	MPT_ADAPTER	*ioc;
 	int		retval;
+	struct sas_rphy	*rphy = target_to_rphy(SCpnt->device->sdev_target);
+
+	if (rphy->fast_io_tmo_flags & SAS_RPHY_IGN_HOST_RESET) {
+		scsi_device_set_state(SCpnt->device, SDEV_OFFLINE);
+		return FAST_IO;
+	}
 
 	/*  If we can't locate the host to reset, then we failed. */
 	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
-- 
1.7.1
