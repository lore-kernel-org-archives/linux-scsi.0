From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/8] fcoe: Prevent creation of an NPIV port with duplicate WWPN
Date: Mon, 16 May 2011 16:45:29 -0700
Message-ID: <20110516234529.24502.21133.stgit@localhost6.localdomain6>
References: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27368 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab1EPXpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 19:45:30 -0400
In-Reply-To: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Neerav Parikh <Neerav.Parikh@intel.com>

From: Neerav Parikh <Neerav.Parikh@intel.com>

This patch adds a validation step before allowing creation of a new NPIV port.
It checks whether the WWPN passed for the new NPIV port to be created is unique
for the given physical port.

Signed-off-by: Neerav Parikh <Neerav.Parikh@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe.h |   10 ++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 5d3700d..1c55a61 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -137,6 +137,7 @@ static int fcoe_vport_create(struct fc_vport *, bool disabled);
 static int fcoe_vport_disable(struct fc_vport *, bool disable);
 static void fcoe_set_vport_symbolic_name(struct fc_vport *);
 static void fcoe_set_port_id(struct fc_lport *, u32, struct fc_frame *);
+static int fcoe_validate_vport_create(struct fc_vport *);
 
 static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
@@ -2348,6 +2349,17 @@ static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
 	struct fcoe_interface *fcoe = port->priv;
 	struct net_device *netdev = fcoe->netdev;
 	struct fc_lport *vn_port;
+	int rc;
+	char buf[32];
+
+	rc = fcoe_validate_vport_create(vport);
+	if (rc) {
+		wwn_to_str(vport->port_name, buf, sizeof(buf));
+		printk(KERN_ERR "fcoe: Failed to create vport, "
+			"WWPN (0x%s) already exists\n",
+			buf);
+		return rc;
+	}
 
 	mutex_lock(&fcoe_config_mutex);
 	vn_port = fcoe_if_create(fcoe, &vport->dev, 1);
@@ -2494,3 +2506,49 @@ static void fcoe_set_port_id(struct fc_lport *lport,
 	if (fp && fc_frame_payload_op(fp) == ELS_FLOGI)
 		fcoe_ctlr_recv_flogi(&fcoe->ctlr, lport, fp);
 }
+
+/**
+ * fcoe_validate_vport_create() - Validate a vport before creating it
+ * @vport: NPIV port to be created
+ *
+ * This routine is meant to add validation for a vport before creating it
+ * via fcoe_vport_create().
+ * Current validations are:
+ *      - WWPN supplied is unique for given lport
+ *
+ *
+*/
+static int fcoe_validate_vport_create(struct fc_vport *vport)
+{
+	struct Scsi_Host *shost = vport_to_shost(vport);
+	struct fc_lport *n_port = shost_priv(shost);
+	struct fc_lport *vn_port;
+	int rc = 0;
+	char buf[32];
+
+	mutex_lock(&n_port->lp_mutex);
+
+	wwn_to_str(vport->port_name, buf, sizeof(buf));
+	/* Check if the wwpn is not same as that of the lport */
+	if (!memcmp(&n_port->wwpn, &vport->port_name, sizeof(u64))) {
+		FCOE_DBG("vport WWPN 0x%s is same as that of the "
+			"base port WWPN\n", buf);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/* Check if there is any existing vport with same wwpn */
+	list_for_each_entry(vn_port, &n_port->vports, list) {
+		if (!memcmp(&vn_port->wwpn, &vport->port_name, sizeof(u64))) {
+			FCOE_DBG("vport with given WWPN 0x%s already "
+			"exists\n", buf);
+			rc = -EINVAL;
+			break;
+		}
+	}
+
+out:
+	mutex_unlock(&n_port->lp_mutex);
+
+	return rc;
+}
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 408a6fd..c4a9399 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -99,4 +99,14 @@ static inline struct net_device *fcoe_netdev(const struct fc_lport *lport)
 			((struct fcoe_port *)lport_priv(lport))->priv)->netdev;
 }
 
+static inline void wwn_to_str(u64 wwn, char *buf, int len)
+{
+	u8 wwpn[8];
+
+	u64_to_wwn(wwn, wwpn);
+	snprintf(buf, len, "%02x%02x%02x%02x%02x%02x%02x%02x",
+		wwpn[0], wwpn[1], wwpn[2], wwpn[3],
+		wwpn[4], wwpn[5], wwpn[6], wwpn[7]);
+}
+
 #endif /* _FCOE_H_ */

