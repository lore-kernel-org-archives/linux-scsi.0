From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] add stats info for FC rports
Date: Fri, 10 Dec 2010 23:13:32 +0800
Message-ID: <AANLkTimj8Ez=cUPocr8eONJUuZR87wczoV6Pe1BewOHo@mail.gmail.com>
References: <AANLkTi=mwHmJwNwCqJXxGXsfyULpnTX0t7rOq3eV9YOF@mail.gmail.com>
	<4D000183.9050804@cisco.com>
	<AANLkTikWJ-M53Qvd+bM9_xZ11it=gz3p5qVQN037fGT_@mail.gmail.com>
	<4D012B58.3030804@cisco.com>
	<AANLkTimyuEPVz6hdWk93sjY_me-+RRKLCPBc5M-1tmrJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50402 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab0LJPNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Dec 2010 10:13:34 -0500
Received: by wwa36 with SMTP id 36so3815617wwa.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2010 07:13:32 -0800 (PST)
In-Reply-To: <AANLkTimyuEPVz6hdWk93sjY_me-+RRKLCPBc5M-1tmrJ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

It is the second version with two changes.

This version could not be completed without help from Joe,
specially on rcu and tearing lport down.

Thank you, Joe.
Hillf
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
+++ b/drivers/scsi/libfc/fc_rport.c	2010-12-10 23:10:54.000000000 +0800
@@ -129,6 +129,7 @@ static struct fc_rport_priv *fc_rport_cr
 	if (!rdata)
 		return NULL;

+	lport->nr_rdata++;
 	rdata->ids.node_name = -1;
 	rdata->ids.port_name = -1;
 	rdata->ids.port_id = port_id;
@@ -171,6 +172,7 @@ static void fc_rport_destroy(struct kref
 	struct fc_rport_priv *rdata;

 	rdata = container_of(kref, struct fc_rport_priv, kref);
+	rdata->local_port->nr_rdata--;
 	call_rcu(&rdata->rcu, fc_rport_free_rcu);
 }

--- a/drivers/scsi/libfc/fc_lport.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_lport.c	2010-12-10 23:06:00.000000000 +0800
@@ -629,6 +629,10 @@ int fc_lport_destroy(struct fc_lport *lp
 	lport->tt.fcp_abort_io(lport);
 	lport->tt.disc_stop_final(lport);
 	lport->tt.exch_mgr_reset(lport, 0, 0);
+	if (lport->nr_rdata != 0)
+		printk(KERN_WARNING "libfc: %lu Leaked rports when "
+			"destroying local port (%6.6x)\n",
+			lport->nr_rdata, lport->port_id);
 	return 0;
 }
 EXPORT_SYMBOL(fc_lport_destroy);
