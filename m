From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] add stats info for FC rports
Date: Wed, 8 Dec 2010 21:27:01 +0800
Message-ID: <AANLkTi=mwHmJwNwCqJXxGXsfyULpnTX0t7rOq3eV9YOF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33023 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab0LHN1D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2010 08:27:03 -0500
Received: by wyb28 with SMTP id 28so1082431wyb.19
        for <linux-scsi@vger.kernel.org>; Wed, 08 Dec 2010 05:27:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

Stats info is added, in the define of local port, to monitor the usage
of remote ports.

Then it is simple to answer how many rport data leaked in the life
cycle of lport.

This work is motivated to capture mm leak of rports of
FC_FID_DIR_SERV, and thanks for dropping a reply to this message if
captured.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/include/scsi/libfc.h	2010-11-01 19:54:12.000000000 +0800
+++ b/include/scsi/libfc.h	2010-12-08 21:05:46.000000000 +0800
@@ -803,6 +803,9 @@ struct fc_lport {
 	void			       *scsi_priv;
 	struct fc_disc                 disc;

+	/* stats info of the usage of rports */
+	unsigned long			nr_rdata;
+
 	/* Virtual port information */
 	struct list_head	       vports;
 	struct fc_vport		       *vport;
--- a/drivers/scsi/libfc/fc_rport.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_rport.c	2010-12-08 21:16:40.000000000 +0800
@@ -128,7 +128,7 @@ static struct fc_rport_priv *fc_rport_cr
 	rdata = kzalloc(sizeof(*rdata) + lport->rport_priv_size, GFP_KERNEL);
 	if (!rdata)
 		return NULL;
-
+	lport->nr_rdata++;
 	rdata->ids.node_name = -1;
 	rdata->ids.port_name = -1;
 	rdata->ids.port_id = port_id;
@@ -159,6 +159,7 @@ static void fc_rport_free_rcu(struct rcu
 	struct fc_rport_priv *rdata;

 	rdata = container_of(rcu, struct fc_rport_priv, rcu);
+	rdata->local_port->nr_rdata--;
 	kfree(rdata);
 }

@@ -1880,7 +1881,7 @@ int fc_rport_init(struct fc_lport *lport

 	if (!lport->tt.rport_destroy)
 		lport->tt.rport_destroy = fc_rport_destroy;
-
+	lport->nr_rdata = 0;
 	return 0;
 }
 EXPORT_SYMBOL(fc_rport_init);
--- a/drivers/scsi/libfc/fc_fcp.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_fcp.c	2010-12-08 21:19:20.000000000 +0800
@@ -2184,6 +2184,11 @@ void fc_fcp_destroy(struct fc_lport *lpo
 {
 	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);

+	if (lport->nr_rdata != 0)
+		printk(KERN_WARNING "libfc: %lu Leaked rports when "
+			"destroying local port (%6.6x)\n",
+			lport->nr_rdata, lport->port_id);
+
 	if (!list_empty(&si->scsi_pkt_queue))
 		printk(KERN_ERR "libfc: Leaked SCSI packets when destroying "
 		       "port (%6.6x)\n", lport->port_id);
