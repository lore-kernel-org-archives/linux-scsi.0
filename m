Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BB520ED
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2025 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751919752; cv=none; b=pZSOb/JeuwFTMf7095AUAKo0NmLjNwz/zwhKtqHUdJyGS8vVACATrCVnE/hqg95DdcF/joAxue+chhtm6W+ffvetDsLg/CT0l0JEPqHcQe4RseSLaxjnk6fe7yPKgrie7qKA7erTIHQmaITBpH8VMggCEFCp20xq9ETxxAEoCWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751919752; c=relaxed/simple;
	bh=r02NFkcHQmgLCxNbP7AjbtESdTQsLLQcpBEzWgCohg8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jMYTKFzUzgO5ZgPCn6nif7j8vWv8kXYrHW5csZKDHOQtiKqq6CqSEM58kMArLoTsd22ofsLTs/WKS+fabyQ+6lCRwGN9jVybapFQZ/SX9zoqXgaSCHZQifwxqfTCdibHZeXfc75h2O5RCPBUjLNQWvjZwg28Sgi4lUV3hIzr5hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JVSTxp/S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JVSTxp/S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751919749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kx5R2RRX2D7gH96AeoMdH41uQLnzndT2HAXyc/qhXXA=;
	b=JVSTxp/Sb1it9DL2Qx4rtP3gmjdG/InEQ8zFpJJ0171vkbsXXUUq992KP1A63jXeYdlfbi
	uC9jn0DDvvdP9gw7H+BwHlfsigGI8WNDPPPooqVHyybhypxcz5WPSgrgu926MWhUW8ZJ5m
	rQ1aTeFyep+CpUTSkEMHKOm5c2IS3DY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-349-ZA_-qi7oPiu9l36JMY0OCw-1; Mon,
 07 Jul 2025 16:22:27 -0400
X-MC-Unique: ZA_-qi7oPiu9l36JMY0OCw-1
X-Mimecast-MFC-AGG-ID: ZA_-qi7oPiu9l36JMY0OCw_1751919747
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36B7B18011FE
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2025 20:22:27 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.22.80.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 80146180035E
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2025 20:22:26 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: scsi_transport_fc: Change to use per-rport devloss_work_q
Date: Mon,  7 Jul 2025 16:22:25 -0400
Message-ID: <20250707202225.1203189-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Configurations with large numbers of FC rports per host instance are taking a
very long time to complete all devloss work.  Increase potential parallelism
by using a per-rport devloss_work_q for dev_loss_work and fast_io_fail_work.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_transport_fc.c | 70 ++++++++++++++++++--------------
 include/scsi/scsi_transport_fc.h |  5 +--
 2 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 6b165a3ec6de..82d091d627c0 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -446,13 +446,6 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 		return -ENOMEM;
 
 	fc_host->dev_loss_tmo = fc_dev_loss_tmo;
-	fc_host->devloss_work_q = alloc_workqueue("fc_dl_%d", 0, 0,
-					shost->host_no);
-	if (!fc_host->devloss_work_q) {
-		destroy_workqueue(fc_host->work_q);
-		fc_host->work_q = NULL;
-		return -ENOMEM;
-	}
 
 	fc_bsg_hostadd(shost, fc_host);
 	/* ignore any bsg add error - we just can't do sgio */
@@ -2821,10 +2814,10 @@ fc_flush_work(struct Scsi_Host *shost)
  * 	1 on success / 0 already queued / < 0 for error
  */
 static int
-fc_queue_devloss_work(struct Scsi_Host *shost, struct delayed_work *work,
-				unsigned long delay)
+fc_queue_devloss_work(struct Scsi_Host *shost, struct fc_rport *rport,
+		      struct delayed_work *work, unsigned long delay)
 {
-	if (unlikely(!fc_host_devloss_work_q(shost))) {
+	if (unlikely(!rport->devloss_work_q)) {
 		printk(KERN_ERR
 			"ERROR: FC host '%s' attempted to queue work, "
 			"when no workqueue created.\n", shost->hostt->name);
@@ -2833,7 +2826,7 @@ fc_queue_devloss_work(struct Scsi_Host *shost, struct delayed_work *work,
 		return -EINVAL;
 	}
 
-	return queue_delayed_work(fc_host_devloss_work_q(shost), work, delay);
+	return queue_delayed_work(rport->devloss_work_q, work, delay);
 }
 
 /**
@@ -2841,9 +2834,9 @@ fc_queue_devloss_work(struct Scsi_Host *shost, struct delayed_work *work,
  * @shost:	Pointer to Scsi_Host bound to fc_host.
  */
 static void
-fc_flush_devloss(struct Scsi_Host *shost)
+fc_flush_devloss(struct Scsi_Host *shost, struct fc_rport *rport)
 {
-	if (!fc_host_devloss_work_q(shost)) {
+	if (unlikely(!rport->devloss_work_q)) {
 		printk(KERN_ERR
 			"ERROR: FC host '%s' attempted to flush work, "
 			"when no workqueue created.\n", shost->hostt->name);
@@ -2851,7 +2844,7 @@ fc_flush_devloss(struct Scsi_Host *shost)
 		return;
 	}
 
-	flush_workqueue(fc_host_devloss_work_q(shost));
+	flush_workqueue(rport->devloss_work_q);
 }
 
 
@@ -2913,13 +2906,6 @@ fc_remove_host(struct Scsi_Host *shost)
 		fc_host->work_q = NULL;
 		destroy_workqueue(work_q);
 	}
-
-	/* flush all devloss work items, then kill it  */
-	if (fc_host->devloss_work_q) {
-		work_q = fc_host->devloss_work_q;
-		fc_host->devloss_work_q = NULL;
-		destroy_workqueue(work_q);
-	}
 }
 EXPORT_SYMBOL(fc_remove_host);
 
@@ -2967,6 +2953,7 @@ fc_rport_final_delete(struct work_struct *work)
 	struct device *dev = &rport->dev;
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
+	struct workqueue_struct *work_q;
 	unsigned long flags;
 	int do_callback = 0;
 
@@ -2988,9 +2975,9 @@ fc_rport_final_delete(struct work_struct *work)
 	if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		if (!cancel_delayed_work(&rport->fail_io_work))
-			fc_flush_devloss(shost);
+			fc_flush_devloss(shost, rport);
 		if (!cancel_delayed_work(&rport->dev_loss_work))
-			fc_flush_devloss(shost);
+			fc_flush_devloss(shost, rport);
 		cancel_work_sync(&rport->scan_work);
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
@@ -3021,6 +3008,12 @@ fc_rport_final_delete(struct work_struct *work)
 
 	fc_bsg_remove(rport->rqst_q);
 
+	if (rport->devloss_work_q) {
+		work_q = rport->devloss_work_q;
+		rport->devloss_work_q = NULL;
+		destroy_workqueue(work_q);
+	}
+
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
@@ -3093,6 +3086,22 @@ fc_remote_port_create(struct Scsi_Host *shost, int channel,
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
+	rport->devloss_work_q = alloc_workqueue("fc_dl_%d_%d", 0, 0,
+						shost->host_no, rport->number);
+	if (!rport->devloss_work_q) {
+		printk(KERN_ERR "FC Remote Port alloc_workqueue failed\n");
+/*
+ * Note that we have not yet called device_initialize() / get_device()
+ * Cannot reclaim incremented rport->number because we released host_lock
+ */
+		spin_lock_irqsave(shost->host_lock, flags);
+		list_del(&rport->peers);
+		scsi_host_put(shost);			/* for fc_host->rport list */
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		kfree(rport);
+		return NULL;
+	}
+
 	dev = &rport->dev;
 	device_initialize(dev);			/* takes self reference */
 	dev->parent = get_device(&shost->shost_gendev); /* parent reference */
@@ -3255,9 +3264,9 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 				 * be checked and will NOOP the function.
 				 */
 				if (!cancel_delayed_work(&rport->fail_io_work))
-					fc_flush_devloss(shost);
+					fc_flush_devloss(shost, rport);
 				if (!cancel_delayed_work(&rport->dev_loss_work))
-					fc_flush_devloss(shost);
+					fc_flush_devloss(shost, rport);
 
 				spin_lock_irqsave(shost->host_lock, flags);
 
@@ -3451,11 +3460,12 @@ fc_remote_port_delete(struct fc_rport  *rport)
 	/* see if we need to kill io faster than waiting for device loss */
 	if ((rport->fast_io_fail_tmo != -1) &&
 	    (rport->fast_io_fail_tmo < timeout))
-		fc_queue_devloss_work(shost, &rport->fail_io_work,
-					rport->fast_io_fail_tmo * HZ);
+		fc_queue_devloss_work(shost, rport, &rport->fail_io_work,
+				      rport->fast_io_fail_tmo * HZ);
 
 	/* cap the length the devices can be blocked until they are deleted */
-	fc_queue_devloss_work(shost, &rport->dev_loss_work, timeout * HZ);
+	fc_queue_devloss_work(shost, rport, &rport->dev_loss_work,
+			      timeout * HZ);
 }
 EXPORT_SYMBOL(fc_remote_port_delete);
 
@@ -3514,9 +3524,9 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 		 * transaction.
 		 */
 		if (!cancel_delayed_work(&rport->fail_io_work))
-			fc_flush_devloss(shost);
+			fc_flush_devloss(shost, rport);
 		if (!cancel_delayed_work(&rport->dev_loss_work))
-			fc_flush_devloss(shost);
+			fc_flush_devloss(shost, rport);
 
 		spin_lock_irqsave(shost->host_lock, flags);
 		rport->flags &= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index d02b55261307..b908aacfef48 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -383,6 +383,8 @@ struct fc_rport {	/* aka fc_starget_attrs */
  	struct work_struct stgt_delete_work;
 	struct work_struct rport_delete_work;
 	struct request_queue *rqst_q;	/* bsg support */
+
+	struct workqueue_struct *devloss_work_q;
 } __attribute__((aligned(sizeof(unsigned long))));
 
 /* bit field values for struct fc_rport "flags" field: */
@@ -576,7 +578,6 @@ struct fc_host_attrs {
 
 	/* work queues for rport state manipulation */
 	struct workqueue_struct *work_q;
-	struct workqueue_struct *devloss_work_q;
 
 	/* bsg support */
 	struct request_queue *rqst_q;
@@ -654,8 +655,6 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->npiv_vports_inuse)
 #define fc_host_work_q(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->work_q)
-#define fc_host_devloss_work_q(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
 #define fc_host_dev_loss_tmo(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->dev_loss_tmo)
 #define fc_host_max_ct_payload(x)  \
-- 
2.43.0

