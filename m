From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] powerpc: cleanup from l64 to ll64 change: drivers/scsi
Date: Wed, 7 Jan 2009 11:59:00 +1100
Message-ID: <20090107115900.17c0dbb6.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:54107 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006AbZAGA7N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2009 19:59:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: ppc-dev <linuxppc-dev@ozlabs.org>, linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>

This is a powerpc specific driver.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |   14 +++++++-------
 drivers/scsi/ibmvscsi/ibmvfc.h |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

This patch on its own will generate several warnings - it depends on the
actual l64 to ll64 patch that is pending in the powerp queue.  It may be
easier for someone to just ack this patch so that it can be fed through
the powerpc tree.

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 44f202f..be6cf09 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -933,7 +933,7 @@ static void ibmvfc_get_host_speed(struct Scsi_Host *shost)
 			fc_host_speed(shost) = FC_PORTSPEED_16GBIT;
 			break;
 		default:
-			ibmvfc_log(vhost, 3, "Unknown port speed: %ld Gbit\n",
+			ibmvfc_log(vhost, 3, "Unknown port speed: %lld Gbit\n",
 				   vhost->login_buf->resp.link_speed / 100);
 			fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 			break;
@@ -2149,8 +2149,8 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 {
 	const char *desc = ibmvfc_get_ae_desc(crq->event);
 
-	ibmvfc_log(vhost, 3, "%s event received. scsi_id: %lx, wwpn: %lx,"
-		   " node_name: %lx\n", desc, crq->scsi_id, crq->wwpn, crq->node_name);
+	ibmvfc_log(vhost, 3, "%s event received. scsi_id: %llx, wwpn: %llx,"
+		   " node_name: %llx\n", desc, crq->scsi_id, crq->wwpn, crq->node_name);
 
 	switch (crq->event) {
 	case IBMVFC_AE_LINK_UP:
@@ -2184,7 +2184,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 		ibmvfc_link_down(vhost, IBMVFC_HALTED);
 		break;
 	default:
-		dev_err(vhost->dev, "Unknown async event received: %ld\n", crq->event);
+		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event);
 		break;
 	};
 }
@@ -2261,13 +2261,13 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
 	 * actually sent
 	 */
 	if (unlikely(!ibmvfc_valid_event(&vhost->pool, evt))) {
-		dev_err(vhost->dev, "Returned correlation_token 0x%08lx is invalid!\n",
+		dev_err(vhost->dev, "Returned correlation_token 0x%08llx is invalid!\n",
 			crq->ioba);
 		return;
 	}
 
 	if (unlikely(atomic_read(&evt->free))) {
-		dev_err(vhost->dev, "Received duplicate correlation_token 0x%08lx!\n",
+		dev_err(vhost->dev, "Received duplicate correlation_token 0x%08llx!\n",
 			crq->ioba);
 		return;
 	}
@@ -3259,7 +3259,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost, u64 scsi_id)
 
 	tgt = mempool_alloc(vhost->tgt_pool, GFP_KERNEL);
 	if (!tgt) {
-		dev_err(vhost->dev, "Target allocation failure for scsi id %08lx\n",
+		dev_err(vhost->dev, "Target allocation failure for scsi id %08llx\n",
 			scsi_id);
 		return -ENOMEM;
 	}
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index babdf3d..87dafd0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -691,13 +691,13 @@ struct ibmvfc_host {
 #define DBG_CMD(CMD) do { if (ibmvfc_debug) CMD; } while (0)
 
 #define tgt_dbg(t, fmt, ...)			\
-	DBG_CMD(dev_info((t)->vhost->dev, "%lX: " fmt, (t)->scsi_id, ##__VA_ARGS__))
+	DBG_CMD(dev_info((t)->vhost->dev, "%llX: " fmt, (t)->scsi_id, ##__VA_ARGS__))
 
 #define tgt_info(t, fmt, ...)		\
-	dev_info((t)->vhost->dev, "%lX: " fmt, (t)->scsi_id, ##__VA_ARGS__)
+	dev_info((t)->vhost->dev, "%llX: " fmt, (t)->scsi_id, ##__VA_ARGS__)
 
 #define tgt_err(t, fmt, ...)		\
-	dev_err((t)->vhost->dev, "%lX: " fmt, (t)->scsi_id, ##__VA_ARGS__)
+	dev_err((t)->vhost->dev, "%llX: " fmt, (t)->scsi_id, ##__VA_ARGS__)
 
 #define ibmvfc_dbg(vhost, ...) \
 	DBG_CMD(dev_info((vhost)->dev, ##__VA_ARGS__))
-- 
1.6.0.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
