From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Handle Virtual I/O Server reboot
Date: Tue, 21 Sep 2010 10:17:11 -0500
Message-ID: <201009211517.o8LFH3ML021788@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:58368 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852Ab0IUPRL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2010 11:17:11 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o8LF4rJF010088
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 09:04:53 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8LFH5WM175734
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 09:17:06 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o8LFH4CF021807
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 09:17:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If a Virtual I/O server is rebooted, the client fibre channel sees a
transport event on its CRQ, which causes it to attempt to reconnect
to the CRQ. For a period of time during the VIOS reboot, the client's
attempts to register the CRQ will return H_CLOSED, indicating the server
side is not currently registered. The ibmvfc driver was not handling
this well and was taking the virtual adapter offline. Fix this by
re-enabling our interrupt and waiting for the event on our CRQ
indicating the server is back, at which point we can reconnect.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_reset_closed drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_reset_closed	2010-09-20 12:30:29.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2010-09-20 12:32:52.000000000 -0500
@@ -4311,8 +4311,10 @@ static void ibmvfc_do_work(struct ibmvfc
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		rc = ibmvfc_reset_crq(vhost);
 		spin_lock_irqsave(vhost->host->host_lock, flags);
-		if (rc || (rc = ibmvfc_send_crq_init(vhost)) ||
-		    (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
+		if (rc == H_CLOSED)
+			vio_enable_interrupts(to_vio_dev(vhost->dev));
+		else if (rc || (rc = ibmvfc_send_crq_init(vhost)) ||
+			 (rc = vio_enable_interrupts(to_vio_dev(vhost->dev)))) {
 			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
 			dev_err(vhost->dev, "Error after reset (rc=%d)\n", rc);
 		}
_
