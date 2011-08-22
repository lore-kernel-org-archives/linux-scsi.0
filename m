From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 01/10] fcoe: Do not switch context in vport_delete
 callback
Date: Mon, 22 Aug 2011 15:48:27 -0700
Message-ID: <20110822224827.1854.15112.stgit@localhost6.localdomain6>
References: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1HVWs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 18:48:27 -0400
In-Reply-To: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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
and NPIV). This in itself is goofy, but isn't a problem
until new APIs are added to allow LLDs to create a
FC Port device. fcoe wants to allocate the fcoe_interface
as driver data of the FC Transport's FC Port. The odd
ordering creates locking problems between the Scsi_Host
mutex and the fcoe_config_mutex when destroying the
FC Port and freeing this LLD shared object.

This patch simply allows fcoe_vport_destory to destroy
NPIV ports without deferring them to a workqueue context.
This ensures that when fc_remove_host is called the
NPIV ports will be destroyed first before the N_Port and
allows reference counting on the fcoe's fcoe_interface
to be remove in a later patch.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 781fbaa..0f621d3 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1943,20 +1943,14 @@ static void fcoe_destroy_work(struct work_struct *work)
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
@@ -2485,12 +2479,15 @@ static int fcoe_vport_destroy(struct fc_vport *vport)
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
 

