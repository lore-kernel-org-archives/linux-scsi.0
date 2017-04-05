From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH v3 2/2] scsi: storvsc: Add support for FC rport.
Date: Wed,  5 Apr 2017 14:45:13 -0400
Message-ID: <1491417913-21530-3-git-send-email-cavery@redhat.com>
References: <1491417913-21530-1-git-send-email-cavery@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1491417913-21530-1-git-send-email-cavery@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kys@microsoft.com, hch@infradead.org, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: stephen@networkplumber.org, dan.carpenter@oracle.com, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Included in the current storvsc driver for Hyper-V is the ability
to access luns on an FC fabric via a virtualized fiber channel
adapter exposed by the Hyper-V host. The driver also attaches to
the FC transport to allow host and port names to be published under
/sys/class/fc_host/hostX. Current customer tools running on the VM
require that these names be available in the well known standard
location under fc_host/hostX.

This patch stubs in an rport per fc_host and sets its rport role
as FC_PORT_ROLE_FCP_DUMMY_INITIATOR to indicate to the fc_transport
that it is a pseudo rport in order to scan the scsi stack via
echo "- - -" > /sys/class/scsi_host/hostX/scan.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 016639d..1ec8579 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -476,6 +476,9 @@ struct storvsc_device {
 	 */
 	u64 node_name;
 	u64 port_name;
+#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
+	struct fc_rport *rport;
+#endif
 };
 
 struct hv_host_device {
@@ -1823,19 +1826,27 @@ static int storvsc_probe(struct hv_device *device,
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
+			.roles = FC_PORT_ROLE_FCP_DUMMY_INITIATOR,
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
@@ -1861,8 +1872,10 @@ static int storvsc_remove(struct hv_device *dev)
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
