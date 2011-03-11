From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 2/2] ISCSID: Added ISCSI_HOST_PARAM_VLAN setting
Date: Thu, 10 Mar 2011 18:21:13 -0800
Message-ID: <1299810073-7339-3-git-send-email-eddie.wai@broadcom.com>
References: <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3454 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab1CKCV2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 21:21:28 -0500
In-Reply-To: <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Propagate the VLAN setting from the iface file to the HBA via the
iscsi_host_set_net_params path prior to the ep_connect request.

This will allow the connection request to have the correct VLAN
tag setup.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 include/iscsi_if.h     |    1 +
 usr/iface.h            |    1 +
 usr/initiator_common.c |   10 ++++++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/iscsi_if.h b/include/iscsi_if.h
index d804f66..b885fa7 100644
--- a/include/iscsi_if.h
+++ b/include/iscsi_if.h
@@ -361,6 +361,7 @@ enum iscsi_host_param {
 	ISCSI_HOST_PARAM_INITIATOR_NAME,
 	ISCSI_HOST_PARAM_NETDEV_NAME,
 	ISCSI_HOST_PARAM_IPADDRESS,
+	ISCSI_HOST_PARAM_VLAN,
 	ISCSI_HOST_PARAM_MAX,
 };
 
diff --git a/usr/iface.h b/usr/iface.h
index 1e39cbf..509776a 100644
--- a/usr/iface.h
+++ b/usr/iface.h
@@ -34,6 +34,7 @@ extern void iface_setup_defaults(struct iface_rec *iface);
 extern int iface_is_bound_by_hwaddr(struct iface_rec *iface);
 extern int iface_is_bound_by_netdev(struct iface_rec *iface);
 extern int iface_is_bound_by_ipaddr(struct iface_rec *iface);
+extern int iface_is_bound_by_vlan(struct iface_rec *iface);
 extern int iface_is_bound_by_uiolib(struct iface_rec *iface);
 typedef int (iface_op_fn)(void *data, struct iface_rec *iface);
 extern int iface_for_each_iface(void *data, int *nr_found,
diff --git a/usr/initiator_common.c b/usr/initiator_common.c
index 8bf22be..b0c2cbe 100644
--- a/usr/initiator_common.c
+++ b/usr/initiator_common.c
@@ -400,5 +400,15 @@ int iscsi_host_set_net_params(struct iface_rec *iface,
 		if (rc)
 			return rc;
 	}
+
+	if (iface_is_bound_by_vlan(iface)) {
+		log_error("initiator_common set host vlan=%s", iface->vlan);
+		rc = host_set_param(t, session->hostno,
+				    ISCSI_HOST_PARAM_VLAN,
+				    iface->vlan, ISCSI_STRING);
+		if (rc)
+			return rc;
+	}
+
 	return 0;
 }
-- 
1.7.0.5


