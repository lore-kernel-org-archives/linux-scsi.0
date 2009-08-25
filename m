From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 17/64] fcoe: remove fcoe_interface->priv pointer
Date: Tue, 25 Aug 2009 13:59:56 -0700
Message-ID: <20090825205956.1553.91104.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119AbZHYU7z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:55 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

The priv pointer is no longer needed, and once NPIV is enabled
fcoe_interface:fc_lport becomes a one-to-many relationship.

Remove the single pointer.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    2 --
 drivers/scsi/fcoe/fcoe.h |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index bb59a7a..7f14c63 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -640,9 +640,7 @@ static struct fc_lport *fcoe_if_create(struct net_device *netdev,
 	}
 	lport = shost_priv(shost);
 	port = lport_priv(lport);
-
 	port->fcoe = fcoe;
-	fcoe->priv = port;
 
 	/* configure fc_lport, e.g., em */
 	rc = fcoe_lport_config(lport);
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 26e8595..673e70e 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -79,9 +79,6 @@ struct fcoe_percpu_s {
  */
 struct fcoe_interface {
 	struct list_head list;
-	/* This will be removed once all the shared values are
-	 * moved out of fcoe_port */
-	struct fcoe_port *priv;
 	struct net_device *netdev;
 	struct packet_type  fcoe_packet_type;
 	struct packet_type  fip_packet_type;

