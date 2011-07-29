From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 3/7] fcoe: Don't hold fcoe_config_mutex for
 fcoe_if_destroy or fcoe_interface_cleanup
Date: Fri, 29 Jul 2011 16:38:39 -0700
Message-ID: <20110729233839.12794.3614.stgit@localhost6.localdomain6>
References: <20110729233823.12794.94487.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5770 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab1G2Xil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 19:38:41 -0400
In-Reply-To: <20110729233823.12794.94487.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, giridhar.malavali@qlogic.com, james.smart@emulex.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: neerav.parikh@intel.com

The fcoe_config_mutex is used to synchronize the hostlist,
to protect EM creation and cloning and to serialize the
creating and deltion of fcoe instances.

It is not needed to protect anything in either
fcoe_if_destroy or fcoe_interface_cleanup. This unnecessary
locking causes later problems with the usage of upcoming
FC Transport API extensions.

This patch simply removes the unnecessary use of the
fcoe_config_mutex.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c701bd9..226cf88 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1945,18 +1945,13 @@ out_nodev:
  */
 static void fcoe_destroy_work(struct work_struct *work)
 {
-	struct fcoe_port *port;
-	struct fcoe_interface *fcoe;
-
-	port = container_of(work, struct fcoe_port, destroy_work);
-	mutex_lock(&fcoe_config_mutex);
+	struct fcoe_port *port =
+		container_of(work, struct fcoe_port, destroy_work);
+	struct fcoe_interface *fcoe = port->priv;
 
-	fcoe = port->priv;
 	fcoe_if_destroy(port->lport);
 
 	fcoe_interface_cleanup(fcoe);
-
-	mutex_unlock(&fcoe_config_mutex);
 }
 
 /**
@@ -2488,9 +2483,7 @@ static int fcoe_vport_destroy(struct fc_vport *vport)
 	list_del(&vn_port->list);
 	mutex_unlock(&n_port->lp_mutex);
 
-	mutex_lock(&fcoe_config_mutex);
 	fcoe_if_destroy(vn_port);
-	mutex_unlock(&fcoe_config_mutex);
 
 	return 0;
 }

