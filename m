From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/12] fcoe: Do not switch context in vport_delete callback
Date: Fri, 10 Feb 2012 17:18:41 -0800
Message-ID: <20120211011841.7668.27533.stgit@localhost6.localdomain6>
References: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9500 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab2BKBSm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 20:18:42 -0500
In-Reply-To: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>

Currently all port deletion is routed though the FCoE
workqueue (fcoe_wq). When fc_remove_host is called on
an N_Port (for example, from fcoe_destroy) the vports
are queued into a FC Transport workqueue. fc_remove_host
flushes that queue and each vport is passed to fcoe's
fcoe_vport_destroy, which simply queues the associated
fcoe_ports for later deletion. This queue cannot be
flushed within the N_Ports destroy path because of
circular locking issues. The result is that the NPIV
ports are destroyed after the N_Port, which is reverse
of how they are created.

This quirk causes fcoe to keep references on the
fcoe_interface shared by each of these ports (N_Port
and NPIV). Changing the ordering such that NPIV ports
are destroyed before the N_Port will allow us to remove
reference counting on the fcoe_interface instances.

This patch simply allows fcoe_vport_destory to destroy
NPIV ports without deferring them to a workqueue context.
This ensures that when fc_remove_host is called the
NPIV ports will be destroyed first before the N_Port and
allows reference counting on the fcoe's fcoe_interface
to be remove in a later patch.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 449df17..f5286c4 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2099,20 +2099,14 @@ static void fcoe_destroy_work(struct work_struct *work)
 {
 	struct fcoe_port *port;
 	struct fcoe_interface *fcoe;
-	int npiv = 0;
 
 	port = container_of(work, struct fcoe_port, destroy_work);
 	mutex_lock(&fcoe_config_mutex);
 
-	/* set if this is an NPIV port */
-	npiv = port->lport->vport ? 1 : 0;
-
 	fcoe = port->priv;
 	fcoe_if_destroy(port->lport);
 
-	/* Do not tear down the fcoe interface for NPIV port */
-	if (!npiv)
-		fcoe_interface_cleanup(fcoe);
+	fcoe_interface_cleanup(fcoe);
 
 	mutex_unlock(&fcoe_config_mutex);
 }
@@ -2683,12 +2677,15 @@ static int fcoe_vport_destroy(struct fc_vport *vport)
 	struct Scsi_Host *shost = vport_to_shost(vport);
 	struct fc_lport *n_port = shost_priv(shost);
 	struct fc_lport *vn_port = vport->dd_data;
-	struct fcoe_port *port = lport_priv(vn_port);
 
 	mutex_lock(&n_port->lp_mutex);
 	list_del(&vn_port->list);
 	mutex_unlock(&n_port->lp_mutex);
-	queue_work(fcoe_wq, &port->destroy_work);
+
+	mutex_lock(&fcoe_config_mutex);
+	fcoe_if_destroy(vn_port);
+	mutex_unlock(&fcoe_config_mutex);
+
 	return 0;
 }
 

