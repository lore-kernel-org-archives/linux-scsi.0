From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH v2 2/2] scsi: storvsc: Add support for FC lightweight host.
Date: Thu, 26 Jan 2017 08:39:00 -0500
Message-ID: <1485437940-18706-3-git-send-email-cavery@redhat.com>
References: <1485437940-18706-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1485437940-18706-1-git-send-email-cavery@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: kys@microsoft.com, hch@infradead.org, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: devel@linuxdriverproject.org, famz@redhat.com, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Included in the current storvsc driver for Hyper-V is the ability
to access luns on an FC fabric via a virtualized fiber channel
adapter exposed by the Hyper-V host. This was done to provide an
interface for existing customer tools that was more consistent
with a conventional FC device. The driver attaches to the FC
transport to allow host and port names to be published
under /sys/class/fc_host/hostX.

A problem arose when attaching to the FC transport. The scsi_scan
code attempts to call fc_user_scan which has basically become a no-op
due to the virtualized nature of the FC host ( missing rports,
vports, etc ).  At this point you cannot refresh the scsi bus after
mapping or unmapping luns on the SAN without a reboot.

This patch consists of:

1) storvsc elects to use the new lightweight FC host option by enabling it
in fc_function_template facilitating a fuctional scsi_scan.

2) Removes an original workaround dealing with replacing the eh_timed_out
function.  Patch 1 will not set the scsi_transport_template.eh_timed_out
function directly during lightweight fc_attach_transport(). It instead
relies on whatever was indicated as the scsi_host_template timeout handler
during scsi_times_out() scsi_error.c. So the workaround is no longer
necessary.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 888e16e..d487e00 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1878,10 +1878,17 @@ static struct hv_driver storvsc_drv = {
 	.remove = storvsc_remove,
 };
 
+/*
+ * The driver cannot functionally back all transport
+ * attributes so select only those pertinent including
+ * the lightweight model.
+ */
+
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 static struct fc_function_template fc_transport_functions = {
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
+	.lightweight_transport = 1,
 };
 #endif
 
@@ -1906,11 +1913,6 @@ static int __init storvsc_drv_init(void)
 	fc_transport_template = fc_attach_transport(&fc_transport_functions);
 	if (!fc_transport_template)
 		return -ENODEV;
-
-	/*
-	 * Install Hyper-V specific timeout handler.
-	 */
-	fc_transport_template->eh_timed_out = storvsc_eh_timed_out;
 #endif
 
 	ret = vmbus_driver_register(&storvsc_drv);
-- 
2.5.0
