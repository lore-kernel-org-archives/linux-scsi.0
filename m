From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 5/5] srp_transport: convert to use supported_mode attribute
Date: Sat, 01 Sep 2007 02:03:39 +0900
Message-ID: <200708311703.l7VH3epH016545@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47082 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965356AbXHaRDt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 13:03:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

srp transport works for target drivers without supported_mode
attribute but it would be better to use it explicitly.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c  |    1 +
 drivers/scsi/scsi_transport_srp.c |   10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 3db03dd..82bcab6 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -820,6 +820,7 @@ static struct scsi_host_template ibmvstgt_sht = {
 	.eh_abort_handler	= ibmvstgt_eh_abort_handler,
 	.shost_attrs		= ibmvstgt_attrs,
 	.proc_name		= TGT_NAME,
+	.supported_mode		= MODE_TARGET,
 };
 
 static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 430501e..44a340b 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -222,7 +222,8 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 		return ERR_PTR(ret);
 	}
 
-	if (ids->roles == SRP_RPORT_ROLE_INITIATOR) {
+	if (shost->active_mode & MODE_TARGET &&
+	    ids->roles == SRP_RPORT_ROLE_INITIATOR) {
 		ret = srp_tgt_it_nexus_create(shost, (unsigned long)rport,
 					      rport->port_id);
 		if (ret) {
@@ -249,10 +250,11 @@ EXPORT_SYMBOL_GPL(srp_rport_add);
 void srp_rport_del(struct srp_rport *rport)
 {
 	struct device *dev = &rport->dev;
+	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 
-	if (rport->roles == SRP_RPORT_ROLE_INITIATOR)
-		srp_tgt_it_nexus_destroy(dev_to_shost(dev->parent),
-					 (unsigned long)rport);
+	if (shost->active_mode & MODE_TARGET &&
+	    rport->roles == SRP_RPORT_ROLE_INITIATOR)
+		srp_tgt_it_nexus_destroy(shost, (unsigned long)rport);
 
 	transport_remove_device(dev);
 	device_del(dev);
-- 
1.5.2.4

