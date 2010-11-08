From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] add stats info for alerting memory leakage in FC transport
Date: Mon, 8 Nov 2010 21:53:39 +0800
Message-ID: <AANLkTimTKBT==QNFHz5ucN4NUtVWdgMMKxU56Yn08FTX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55689 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0KHNxy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 08:53:54 -0500
Received: by wwi17 with SMTP id 17so284wwi.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Nov 2010 05:53:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Support of BSG is implemented in FC transport, and bsg job is
allocated/freed to serve bsg request.

Since FC transport is a complicated system, it is hard to analyse and
answer when and how memory leakage could occur, specially related to
bsg job.

On other hand, it is relatively simple to catch and alert memory
leakage if it does happen.

Stats info is added in both FC host and FC rport to record the usage
of bsg job, and could alert memory leakage if it really occurs.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/include/scsi/scsi_transport_fc.h	2010-09-13 07:07:38.000000000 +0800
+++ b/include/scsi/scsi_transport_fc.h	2010-11-08 20:57:14.000000000 +0800
@@ -352,6 +352,7 @@ struct fc_rport {	/* aka fc_starget_attr
  	struct work_struct stgt_delete_work;
 	struct work_struct rport_delete_work;
 	struct request_queue *rqst_q;	/* bsg support */
+	atomic_t bsg_alloc;
 } __attribute__((aligned(sizeof(unsigned long))));

 /* bit field values for struct fc_rport "flags" field: */
@@ -517,6 +518,7 @@ struct fc_host_attrs {

 	/* bsg support */
 	struct request_queue *rqst_q;
+	atomic_t bsg_alloc;
 };

 #define shost_to_fc_host(x) \
--- a/drivers/scsi/scsi_transport_fc.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_transport_fc.c	2010-11-08 21:16:36.000000000 +0800
@@ -431,6 +431,9 @@ static int fc_host_remove(struct transpo
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);

+	if (atomic_read(&fc_host->bsg_alloc))
+		printk(KERN_WARNING "fc_host%d: bsg alloc is %d\n",
+			shost->host_no, atomic_read(&fc_host->bsg_alloc));
 	fc_bsg_remove(fc_host->rqst_q);
 	return 0;
 }
@@ -2481,6 +2484,10 @@ fc_rport_final_delete(struct work_struct
 	if (do_callback)
 		i->f->dev_loss_tmo_callbk(rport);

+	if (atomic_read(&rport->bsg_alloc))
+		printk(KERN_WARNING "rport-%d:%d-%d bsg alloc is %d\n",
+			shost->host_no, rport->channel, rport->number,
+			atomic_read(&rport->bsg_alloc));
 	fc_bsg_remove(rport->rqst_q);

 	transport_remove_device(dev);
@@ -3474,6 +3481,12 @@ fc_destroy_bsgjob(struct fc_bsg_job *job
 		spin_unlock_irqrestore(&job->job_lock, flags);
 		return;
 	}
+	if (job->rport)
+		atomic_dec(&job->rport->bsg_alloc);
+	else if (job->shost) {
+		struct fc_host_attrs *fc = shost_to_fc_host(job->shost);
+		atomic_dec(&fc->bsg_alloc);
+	}
 	spin_unlock_irqrestore(&job->job_lock, flags);

 	put_device(job->dev);	/* release reference for the request */
@@ -3883,6 +3896,15 @@ fc_bsg_request_handler(struct request_qu
 			spin_lock_irq(q->queue_lock);
 			continue;
 		}
+		else {
+			if (q->queuedata == shost) {
+				struct fc_host_attrs *fc =
+					shost_to_fc_host(shost);
+				atomic_inc(&fc->bsg_alloc);
+			}
+			else if (q->queuedata == rport)
+				atomic_inc(&rport->bsg_alloc);
+		}

 		job = req->special;
