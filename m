From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Fix Virtual I/O failover hang
Date: Fri, 03 Jun 2011 08:23:20 -0500
Message-ID: <201106031328.p53DSSKx001880@d03av06.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44637 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1FCNYQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2011 09:24:16 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p53D2xMN005046
	for <linux-scsi@vger.kernel.org>; Fri, 3 Jun 2011 09:02:59 -0400
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p53DNeq7322858
	for <linux-scsi@vger.kernel.org>; Fri, 3 Jun 2011 09:23:58 -0400
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p53DSTYF001924
	for <linux-scsi@vger.kernel.org>; Fri, 3 Jun 2011 07:28:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If a Virtual I/O server fails in a dual virtual I/O server multipath
configuration, ensure we delete all remote ports so that path failover
can occur. For a single path configuration, the remote ports will
go into devloss state.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_failover_hang drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_failover_hang	2011-06-02 15:33:36.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2011-06-02 15:33:45.000000000 -0500
@@ -4306,8 +4306,8 @@ static void ibmvfc_do_work(struct ibmvfc
 		spin_lock_irqsave(vhost->host->host_lock, flags);
 		if (rc == H_CLOSED)
 			vio_enable_interrupts(to_vio_dev(vhost->dev));
-		else if (rc || (rc = ibmvfc_send_crq_init(vhost)) ||
-			 (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
+		if (rc || (rc = ibmvfc_send_crq_init(vhost)) ||
+		    (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
 			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
 			dev_err(vhost->dev, "Error after reset (rc=%d)\n", rc);
 		}
_
