From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] SCSI: remove noop in fc_remote_port_add()
Date: Fri, 24 Sep 2010 22:24:42 +0800
Message-ID: <AANLkTik-pmP9_ovxiX+SBD2AvxtsWbtj2F-RJbL3w+AY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43647 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab0IXOcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2010 10:32:09 -0400
Received: by wyb28 with SMTP id 28so1956144wyb.19
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2010 07:32:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "James E.J. Bottomley" <James.>

For a deleted scsi target marked as FC_PORTSTATE_BLOCKED,  rescanning
it looks fine.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- o/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-13
07:07:38.000000000 +0800
+++ m/linux-2.6.36-rc4/drivers/scsi/scsi_transport_fc.c	2010-09-24
22:16:26.000000000 +0800
@@ -50,7 +50,6 @@ static int fc_vport_setup(struct Scsi_Ho
 static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
 static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
 static void fc_bsg_remove(struct request_queue *);
-static void fc_bsg_goose_queue(struct fc_rport *);

 /*
  * Redefine so that we can have same named attributes in the
@@ -2737,8 +2736,6 @@ fc_remote_port_add(struct Scsi_Host *sho
 					spin_unlock_irqrestore(shost->host_lock,
 							flags);

-				fc_bsg_goose_queue(rport);
-
 				return rport;
 			}
 		}
@@ -3753,33 +3750,6 @@ fail_host_msg:
 }


-/*
- * fc_bsg_goose_queue - restart rport queue in case it was stopped
- * @rport:	rport to be restarted
- */
-static void
-fc_bsg_goose_queue(struct fc_rport *rport)
-{
-	int flagset;
-	unsigned long flags;
-
-	if (!rport->rqst_q)
-		return;
-
-	get_device(&rport->dev);
-
-	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
-	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
-		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
-	if (flagset)
-		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
-	__blk_run_queue(rport->rqst_q);
-	if (flagset)
-		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
-	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
-
-	put_device(&rport->dev);
-}


 /**
