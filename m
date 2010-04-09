From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/12] libfc,
	fcoe: normalize format specifies for world wide names
Date: Fri, 09 Apr 2010 14:23:16 -0700
Message-ID: <20100409212315.1968.95457.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65217 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab0DIVXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:23:16 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

Print all world wide node names (node, port and fabric) with the same
format specifier of "%16.16llx".  That makes sure they all print as a
16 character hex string, with lower case letters, no 0x prefix, and
without stripping off any leading 0s.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c      |    3 ++-
 drivers/scsi/fcoe/libfcoe.c   |   21 ++++++++++++---------
 drivers/scsi/libfc/fc_disc.c  |    2 +-
 drivers/scsi/libfc/fc_lport.c |    4 ++--
 4 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 25a7ce5..aba839e 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -934,7 +934,8 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	}
 
 	if (npiv) {
-		FCOE_NETDEV_DBG(netdev, "Setting vport names, 0x%llX 0x%llX\n",
+		FCOE_NETDEV_DBG(netdev, "Setting vport names, "
+				"%16.16llx %16.16llx\n",
 				vport->node_name, vport->port_name);
 		fc_set_wwnn(lport, vport->node_name);
 		fc_set_wwpn(lport, vport->port_name);
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index de5c329..aadd249 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -583,7 +583,7 @@ static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 					    smp_processor_id());
 			stats->MissDiscAdvCount++;
 			printk(KERN_INFO "libfcoe: host%d: Missing Discovery "
-			       "Advertisement for fab %llx count %lld\n",
+			       "Advertisement for fab %16.16llx count %lld\n",
 			       fip->lp->host->host_no, fcf->fabric_name,
 			       stats->MissDiscAdvCount);
 		}
@@ -780,7 +780,8 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	mtu_valid = fcoe_ctlr_mtu_valid(fcf);
 	fcf->time = jiffies;
 	if (!found) {
-		LIBFCOE_FIP_DBG(fip, "New FCF for fab %llx map %x val %d\n",
+		LIBFCOE_FIP_DBG(fip, "New FCF for fab %16.16llx "
+				"map %x val %d\n",
 				fcf->fabric_name, fcf->fc_map, mtu_valid);
 	}
 
@@ -1108,15 +1109,17 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 	struct fcoe_fcf *best = NULL;
 
 	list_for_each_entry(fcf, &fip->fcfs, list) {
-		LIBFCOE_FIP_DBG(fip, "consider FCF for fab %llx VFID %d map %x "
-				"val %d\n", fcf->fabric_name, fcf->vfid,
+		LIBFCOE_FIP_DBG(fip, "consider FCF for fab %16.16llx "
+				"VFID %d map %x val %d\n",
+				fcf->fabric_name, fcf->vfid,
 				fcf->fc_map, fcoe_ctlr_mtu_valid(fcf));
 		if (!fcoe_ctlr_fcf_usable(fcf)) {
-			LIBFCOE_FIP_DBG(fip, "FCF for fab %llx map %x %svalid "
-					"%savailable\n", fcf->fabric_name,
-					fcf->fc_map, (fcf->flags & FIP_FL_SOL)
-					? "" : "in", (fcf->flags & FIP_FL_AVAIL)
-					? "" : "un");
+			LIBFCOE_FIP_DBG(fip, "FCF for fab %16.16llx "
+					"map %x %svalid %savailable\n",
+					fcf->fabric_name, fcf->fc_map,
+					(fcf->flags & FIP_FL_SOL) ? "" : "in",
+					(fcf->flags & FIP_FL_AVAIL) ?
+					"" : "un");
 			continue;
 		}
 		if (!best) {
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 83314a1..b292272 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -607,7 +607,7 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 			rdata->ids.port_name = port_name;
 		else if (rdata->ids.port_name != port_name) {
 			FC_DISC_DBG(disc, "GPN_ID accepted.  WWPN changed. "
-				    "Port-id %6.6x wwpn %llx\n",
+				    "Port-id %6.6x wwpn %16.16llx\n",
 				    rdata->ids.port_id, port_name);
 			lport->tt.rport_logoff(rdata);
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e89bdd5..ef25e11 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -800,11 +800,11 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
 	if (remote_wwpn == lport->wwpn) {
 		printk(KERN_WARNING "host%d: libfc: Received FLOGI from port "
-		       "with same WWPN %llx\n",
+		       "with same WWPN %16.16llx\n",
 		       lport->host->host_no, remote_wwpn);
 		goto out;
 	}
-	FC_LPORT_DBG(lport, "FLOGI from port WWPN %llx\n", remote_wwpn);
+	FC_LPORT_DBG(lport, "FLOGI from port WWPN %16.16llx\n", remote_wwpn);
 
 	/*
 	 * XXX what is the right thing to do for FIDs?

