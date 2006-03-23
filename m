From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: [PATCH] ibmvscsi: prevent scsi commands being sent in invalid state
Date: Thu, 23 Mar 2006 13:47:07 -0600
Message-ID: <17442.64315.534058.405189@hound.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.33.102]:61407 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1751489AbWCWTs2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Mar 2006 14:48:28 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 8E61A5C4C6
	for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2006 13:48:28 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (mail.cs.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 04816-01-6 for <linux-scsi@vger.kernel.org>;
 Thu, 23 Mar 2006 13:48:27 -0600 (CST)
Received: from oxygen.cs.umn.edu (oxygen.cs.umn.edu [128.101.35.179])
	by mail.cs.umn.edu (Postfix) with ESMTP id 206E25C44F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2006 13:48:27 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


There is a window where we can be re-enabling an adapter, but
still allow SCSI commands to be sent to the target.  This fix
sets our window (request_limit) to -1 as soon as we know the
adapter is being reenabled, and closes a very teeny tiny
window where we could set the window back to 1 before we
grab a lock.

Signed-off-by: Dave Boutcher <sleddog@us.ibm.com>

---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

80a091aa369a57350c0496cb6c1594e5833ade6c
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index eaefedd..a279d0a 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -853,14 +853,15 @@ static int send_srp_login(struct ibmvscs
 	login->max_requested_initiator_to_target_iulen = sizeof(union srp_iu);
 	login->required_buffer_formats = 0x0006;
 	
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	/* Start out with a request limit of 1, since this is negotiated in
 	 * the login request we are just sending
 	 */
 	atomic_set(&hostdata->request_limit, 1);
 
-	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	rc = ibmvscsi_send_srp_event(evt_struct, hostdata);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	printk("ibmvscsic: sent SRP login\n");
 	return rc;
 };
 
@@ -1179,6 +1180,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 			/* We need to re-setup the interpartition connection */
 			printk(KERN_INFO
 			       "ibmvscsi: Re-enabling adapter!\n");
+			atomic_set(&hostdata->request_limit, -1);
 			purge_requests(hostdata, DID_REQUEUE);
 			if (ibmvscsi_reenable_crq_queue(&hostdata->queue,
 							hostdata) == 0)
-- 
1.2.4.gc98264

-- 
Dave Boutcher
