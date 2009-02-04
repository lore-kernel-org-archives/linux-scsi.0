From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ibmvfc: Fix rport relogin
Date: Wed, 04 Feb 2009 16:13:12 -0600
Message-ID: <200902042213.n14MDfWo009297@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41620 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291AbZBDWOo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2009 17:14:44 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n14MCRmN009617
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:12:27 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n14MEhaZ191330
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:14:43 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n14MDfla009302
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:13:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The ibmvfc driver has a bug in its SCN handling. If it receives
an ELS event such asn an N-Port SCN event or an unsolicited PLOGI,
or any other SCN event which causes ibmvfc_reinit_host to be called,
it is possible that we will call fc_remote_port_add for a target
that already has an rport added, which can result in duplicate
rports getting created for the same targets. Fix this by calling
fc_remote_port_rolechg in this scenario instead to report any possible
role change that may have occurred.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_relogin_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_relogin_fix	2009-02-04 11:23:10.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-02-04 11:23:10.000000000 -0600
@@ -3317,6 +3317,7 @@ static int ibmvfc_alloc_target(struct ib
 		return -ENOMEM;
 	}
 
+	memset(tgt, 0, sizeof(*tgt));
 	tgt->scsi_id = scsi_id;
 	tgt->new_scsi_id = scsi_id;
 	tgt->vhost = vhost;
@@ -3627,9 +3628,18 @@ static void ibmvfc_log_ae(struct ibmvfc_
 static void ibmvfc_tgt_add_rport(struct ibmvfc_target *tgt)
 {
 	struct ibmvfc_host *vhost = tgt->vhost;
-	struct fc_rport *rport;
+	struct fc_rport *rport = tgt->rport;
 	unsigned long flags;
 
+	if (rport) {
+		tgt_dbg(tgt, "Setting rport roles\n");
+		fc_remote_port_rolechg(rport, tgt->ids.roles);
+		spin_lock_irqsave(vhost->host->host_lock, flags);
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		return;
+	}
+
 	tgt_dbg(tgt, "Adding rport\n");
 	rport = fc_remote_port_add(vhost->host, 0, &tgt->ids);
 	spin_lock_irqsave(vhost->host->host_lock, flags);
_
