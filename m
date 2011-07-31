From: Anton Blanchard <anton@samba.org>
Subject: [SCSI] mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in
 interrupt context
Date: Sun, 31 Jul 2011 19:29:09 +1000
Message-ID: <20110731192909.16bb341e@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:33111 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1GaJ3O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2011 05:29:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@lsi.com, eric.moore@lsi.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org


_scsih_smart_predicted_fault is called in an interrupt and therefore
must allocate memory using GFP_ATOMIC.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
---

Index: linux-2.6/drivers/scsi/mpt2sas/mpt2sas_scsih.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2011-07-31 09:58:36.000000000 +1000
+++ linux-2.6/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2011-07-31 17:31:53.000000000 +1000
@@ -4210,7 +4210,7 @@ _scsih_smart_predicted_fault(struct MPT2
 	/* insert into event log */
 	sz = offsetof(Mpi2EventNotificationReply_t, EventData) +
 	     sizeof(Mpi2EventDataSasDeviceStatusChange_t);
-	event_reply = kzalloc(sz, GFP_KERNEL);
+	event_reply = kzalloc(sz, GFP_ATOMIC);
 	if (!event_reply) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
