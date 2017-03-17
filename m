From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH v2] scsi: storvsc: Add support for FC rport.
Date: Fri, 17 Mar 2017 11:17:41 -0400
Message-ID: <1489763861-18384-1-git-send-email-cavery@redhat.com>
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
adapter exposed by the Hyper-V host. The driver also attaches to
the FC transport to allow host and port names to be published under
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
Changes since v1:
- Fix fc_rport_identifiers init [Stephen Hemminger]
- Better error checking
---
 drivers/scsi/storvsc_drv.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 638e5f4..37646d1 100644
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
@@ -1816,19 +1819,27 @@ static int storvsc_probe(struct hv_device *device,
 		target = (device->dev_instance.b[5] << 8 |
 			 device->dev_instance.b[4]);
 		ret = scsi_add_device(host, 0, target, 0);
-		if (ret) {
-			scsi_remove_host(host);
-			goto err_out2;
-		}
+		if (ret)
+			goto err_out3;
 	}
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 	if (host->transportt == fc_transport_template) {
+		struct fc_rport_identifiers ids = {
+			.roles = FC_PORT_ROLE_FCP_TARGET,
+		};
+
 		fc_host_node_name(host) = stor_device->node_name;
 		fc_host_port_name(host) = stor_device->port_name;
+		stor_device->rport = fc_remote_port_add(host, 0, &ids);
+		if (!stor_device->rport)
+			goto err_out3;
 	}
 #endif
 	return 0;
 
+err_out3:
+	scsi_remove_host(host);
+
 err_out2:
 	/*
 	 * Once we have connected with the host, we would need to
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
