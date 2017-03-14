From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH] scsi: storvsc: Add support for FC rport.
Date: Tue, 14 Mar 2017 12:01:03 -0400
Message-ID: <1489507263-21365-1-git-send-email-cavery@redhat.com>
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
To: kys@microsoft.com, hch@infradead.org, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Included in the current storvsc driver for Hyper-V is the ability
to access luns on an FC fabric via a virtualized fiber channel
adapter exposed by the Hyper-V host. The driver also attaches to the FC
transport to allow host and port names to be published under
/sys/class/fc_host/hostX. Current customer tools running on the VM
require that these names be available in the well known standard
location under fc_host/hostX.

A problem arose when attaching to the FC transport. The scsi_scan
code attempts to call fc_user_scan which has basically become a no-op
due to the fact that the virtualized FC device does not expose rports.
At this point you cannot refresh the scsi bus after mapping or unmapping
luns on the SAN without a reboot of the VM.

This patch stubs in an rport per fc_host in storvsc so that the
requirement of a defined rport is now met within the fc_transport and
echo "- - -" > /sys/class/scsi_host/hostX/scan now works.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 638e5f4..c6c0316 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -478,6 +478,9 @@ struct storvsc_device {
 	 */
 	u64 node_name;
 	u64 port_name;
+#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
+	struct fc_rport *rport;
+#endif
 };
 
 struct hv_host_device {
@@ -1823,8 +1826,16 @@ static int storvsc_probe(struct hv_device *device,
 	}
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 	if (host->transportt == fc_transport_template) {
+		struct fc_rport_identifiers ids;
+
+		ids.node_name = 0;
+		ids.port_name = 0;
+		ids.port_id = 0;
+		ids.roles |= FC_PORT_ROLE_FCP_TARGET;
+
 		fc_host_node_name(host) = stor_device->node_name;
 		fc_host_port_name(host) = stor_device->port_name;
+		stor_device->rport = fc_remote_port_add(host, 0, &ids);
 	}
 #endif
 	return 0;
@@ -1854,8 +1865,10 @@ static int storvsc_remove(struct hv_device *dev)
 	struct Scsi_Host *host = stor_device->host;
 
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
-	if (host->transportt == fc_transport_template)
+	if (host->transportt == fc_transport_template) {
+		fc_remote_port_delete(stor_device->rport);
 		fc_remove_host(host);
+	}
 #endif
 	scsi_remove_host(host);
 	storvsc_dev_remove(dev);
-- 
2.5.0
