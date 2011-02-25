From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 8/8] fcoe: fix broken fcoe interface reset
Date: Fri, 25 Feb 2011 15:03:28 -0800
Message-ID: <20110225230328.9310.86069.stgit@localhost6.localdomain6>
References: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:15289 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1BYXD3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:03:29 -0500
In-Reply-To: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Reset using "fcoeadm -r" also needs to restart FIP before
doing libfc lport reset, this is needed for new switch firmware
requiring FIP solicitation before doing FLOGI again during reset.
So this patch does this by doing fcoe_ctlr_link_down and then
fcoe_ctlr_link_up to reset the interface.

The fcoe_ctlr_link_down call path also does lport reset
and then fcoe_ctlr_link_up re-starts the fabric login after
doing FIP solicitation first to get reset feature working
again.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0b44d05..94fb480 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2130,7 +2130,13 @@ void fcoe_percpu_clean(struct fc_lport *lport)
 int fcoe_reset(struct Scsi_Host *shost)
 {
 	struct fc_lport *lport = shost_priv(shost);
-	fc_lport_reset(lport);
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->priv;
+
+	fcoe_ctlr_link_down(&fcoe->ctlr);
+	fcoe_clean_pending_queue(fcoe->ctlr.lp);
+	if (!fcoe_link_ok(fcoe->ctlr.lp))
+		fcoe_ctlr_link_up(&fcoe->ctlr);
 	return 0;
 }
 

