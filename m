From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Date: Tue,  8 Jul 2014 17:46:50 -0700
Message-ID: <1404866812-26950-6-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Implement a simple abort handler. The host does not support "Abort"; just
ensure that all inflight I/Os have been accounted for.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8f1b263..82fb590 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1524,6 +1524,27 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	return SUCCESS;
 }
 
+static int storvsc_host_abort_handler(struct scsi_cmnd *scmnd)
+{
+	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
+	struct hv_device *device = host_dev->dev;
+
+	struct storvsc_device *stor_device;
+
+
+	stor_device = get_out_stor_device(device);
+	if (!stor_device)
+		return FAILED;
+
+	/*
+	 * Just wait for all in flight I/O's to complete.
+	 */
+
+	storvsc_wait_to_drain(stor_device);
+
+	return SUCCESS;
+}
+
 static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 {
 	bool allowed = true;
@@ -1699,6 +1720,7 @@ static struct scsi_host_template scsi_driver = {
 	.bios_param =		storvsc_get_chs,
 	.queuecommand =		storvsc_queuecommand,
 	.eh_host_reset_handler =	storvsc_host_reset_handler,
+	.eh_abort_handler =	storvsc_host_abort_handler,
 	.slave_alloc =		storvsc_device_alloc,
 	.slave_destroy =	storvsc_device_destroy,
 	.slave_configure =	storvsc_device_configure,
-- 
1.7.4.1
