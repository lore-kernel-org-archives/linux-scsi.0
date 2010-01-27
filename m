From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/8] lpfc 8.3.8: (BSG1) Update BSG infrastructure
Date: Tue, 26 Jan 2010 23:08:55 -0500
Message-ID: <1264565355.2972.4.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:39140 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752736Ab0A0EJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 23:09:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update BSG infrastructure to handle new vendor specific BSG commands.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    6 ++++--
 lpfc_bsg.c  |   52 +++++++++++++++++++++++++++++-----------------------
 lpfc_crtn.h |    4 ++--
 lpfc_ct.c   |    8 +++++---
 lpfc_hw.h   |    5 ++++-
 lpfc_init.c |    4 ++--
 lpfc_nl.h   |   22 +---------------------
 7 files changed, 47 insertions(+), 54 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2009-12-08 09:43:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-01-22 21:55:11.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2009 Emulex.  All rights reserved.                *
+ * Copyright (C) 2009-2010 Emulex.  All rights reserved.                *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -33,6 +33,7 @@
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
+#include "lpfc_bsg.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
@@ -476,7 +477,7 @@ enum ELX_LOOPBACK_CMD {
  * This function is called when an unsolicited CT command is received.  It
  * forwards the event to any processes registerd to receive CT events.
  */
-void
+int
 lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			struct lpfc_iocbq *piocbq)
 {
@@ -496,6 +497,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 	struct lpfc_dmabuf *bdeBuf2 = piocbq->context3;
 	struct lpfc_hbq_entry *hbqe;
 	struct lpfc_sli_ct_request *ct_req;
+	unsigned long flags;
 
 	INIT_LIST_HEAD(&head);
 	list_add_tail(&head, &piocbq->list);
@@ -519,7 +521,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 	if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
 		lpfc_sli_ringpostbuf_put(phba, pring, dmabuf);
 
-	mutex_lock(&phba->ct_event_mutex);
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
 		if (evt->req_id != evt_req_id)
 			continue;
@@ -535,7 +537,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 			break;
 		}
 
-		mutex_unlock(&phba->ct_event_mutex);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 		if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 			/* take accumulated byte count from the last iocbq */
@@ -556,9 +558,9 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 					"CT event data, size %d\n",
 					evt_dat->len);
 			kfree(evt_dat);
-			mutex_lock(&phba->ct_event_mutex);
+			spin_lock_irqsave(&phba->ct_ev_lock, flags);
 			lpfc_ct_event_unref(evt);
-			mutex_unlock(&phba->ct_event_mutex);
+			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 			goto error_ct_unsol_exit;
 		}
 
@@ -601,9 +603,11 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 						iocbq);
 					kfree(evt_dat->data);
 					kfree(evt_dat);
-					mutex_lock(&phba->ct_event_mutex);
+					spin_lock_irqsave(&phba->ct_ev_lock,
+						flags);
 					lpfc_ct_event_unref(evt);
-					mutex_unlock(&phba->ct_event_mutex);
+					spin_unlock_irqrestore(
+						&phba->ct_ev_lock, flags);
 					goto error_ct_unsol_exit;
 				}
 				memcpy((char *)(evt_dat->data) + offset,
@@ -638,7 +642,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 			}
 		}
 
-		mutex_lock(&phba->ct_event_mutex);
+		spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			evt_dat->immed_dat = phba->ctx_idx;
 			phba->ctx_idx = (phba->ctx_idx + 1) % 64;
@@ -656,13 +660,13 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 		if (evt_req_id == SLI_CT_ELX_LOOPBACK)
 			break;
 	}
-	mutex_unlock(&phba->ct_event_mutex);
+	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 error_ct_unsol_exit:
 	if (!list_empty(&head))
 		list_del(&head);
 
-	return;
+	return 1;
 }
 
 /**
@@ -676,6 +680,7 @@ lpfc_bsg_set_event(struct fc_bsg_job *jo
 	struct lpfc_hba *phba = vport->phba;
 	struct set_ct_event *event_req;
 	struct lpfc_ct_event *evt;
+	unsigned long flags;
 	int rc = 0;
 
 	if (job->request_len <
@@ -689,7 +694,7 @@ lpfc_bsg_set_event(struct fc_bsg_job *jo
 	event_req = (struct set_ct_event *)
 		job->request->rqst_data.h_vendor.vendor_cmd;
 
-	mutex_lock(&phba->ct_event_mutex);
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
 		if (evt->reg_id == event_req->ev_reg_id) {
 			lpfc_ct_event_ref(evt);
@@ -697,7 +702,7 @@ lpfc_bsg_set_event(struct fc_bsg_job *jo
 			break;
 		}
 	}
-	mutex_unlock(&phba->ct_event_mutex);
+	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 	if (&evt->node == &phba->ct_ev_waiters) {
 		/* no event waiting struct yet - first call */
@@ -710,19 +715,19 @@ lpfc_bsg_set_event(struct fc_bsg_job *jo
 			return -ENOMEM;
 		}
 
-		mutex_lock(&phba->ct_event_mutex);
+		spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		list_add(&evt->node, &phba->ct_ev_waiters);
 		lpfc_ct_event_ref(evt);
-		mutex_unlock(&phba->ct_event_mutex);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 	}
 
 	evt->waiting = 1;
 	if (wait_event_interruptible(evt->wq,
 				     !list_empty(&evt->events_to_see))) {
-		mutex_lock(&phba->ct_event_mutex);
+		spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		lpfc_ct_event_unref(evt); /* release ref */
 		lpfc_ct_event_unref(evt); /* delete */
-		mutex_unlock(&phba->ct_event_mutex);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		rc = -EINTR;
 		goto set_event_out;
 	}
@@ -730,10 +735,10 @@ lpfc_bsg_set_event(struct fc_bsg_job *jo
 	evt->wait_time_stamp = jiffies;
 	evt->waiting = 0;
 
-	mutex_lock(&phba->ct_event_mutex);
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_move(evt->events_to_see.prev, &evt->events_to_get);
 	lpfc_ct_event_unref(evt); /* release ref */
-	mutex_unlock(&phba->ct_event_mutex);
+	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 set_event_out:
 	/* set_event carries no reply payload */
@@ -759,6 +764,7 @@ lpfc_bsg_get_event(struct fc_bsg_job *jo
 	struct get_ct_event_reply *event_reply;
 	struct lpfc_ct_event *evt;
 	struct event_data *evt_dat = NULL;
+	unsigned long flags;
 	int rc = 0;
 
 	if (job->request_len <
@@ -775,7 +781,7 @@ lpfc_bsg_get_event(struct fc_bsg_job *jo
 	event_reply = (struct get_ct_event_reply *)
 		job->reply->reply_data.vendor_reply.vendor_rsp;
 
-	mutex_lock(&phba->ct_event_mutex);
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
 		if (evt->reg_id == event_req->ev_reg_id) {
 			if (list_empty(&evt->events_to_get))
@@ -788,7 +794,7 @@ lpfc_bsg_get_event(struct fc_bsg_job *jo
 			break;
 		}
 	}
-	mutex_unlock(&phba->ct_event_mutex);
+	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 	if (!evt_dat) {
 		job->reply->reply_payload_rcv_len = 0;
@@ -818,9 +824,9 @@ lpfc_bsg_get_event(struct fc_bsg_job *jo
 	if (evt_dat)
 		kfree(evt_dat->data);
 	kfree(evt_dat);
-	mutex_lock(&phba->ct_event_mutex);
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	lpfc_ct_event_unref(evt);
-	mutex_unlock(&phba->ct_event_mutex);
+	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 error_get_event_exit:
 	/* make error code available to userspace */
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2009-12-08 09:43:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-01-22 21:55:11.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2008 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -378,5 +378,5 @@ struct lpfc_vport *lpfc_find_vport_by_vp
 /* functions to support SGIOv4/bsg interface */
 int lpfc_bsg_request(struct fc_bsg_job *);
 int lpfc_bsg_timeout(struct fc_bsg_job *);
-void lpfc_bsg_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
+int lpfc_bsg_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			     struct lpfc_iocbq *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2009-12-08 09:43:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2010-01-22 21:55:11.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -97,7 +97,8 @@ lpfc_ct_unsol_event(struct lpfc_hba *phb
 	struct list_head head;
 	struct lpfc_dmabuf *bdeBuf;
 
-	lpfc_bsg_ct_unsol_event(phba, pring, piocbq);
+	if (lpfc_bsg_ct_unsol_event(phba, pring, piocbq) == 0)
+		return;
 
 	if (unlikely(icmd->ulpStatus == IOSTAT_NEED_BUFFER)) {
 		lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_ELS_HBQ);
@@ -181,7 +182,8 @@ lpfc_sli4_ct_abort_unsol_event(struct lp
 	uint32_t size;
 
 	/* Forward abort event to any process registered to receive ct event */
-	lpfc_bsg_ct_unsol_event(phba, pring, piocbq);
+	if (lpfc_bsg_ct_unsol_event(phba, pring, piocbq) == 0)
+		return;
 
 	/* If there is no BDE associated with IOCB, there is nothing to do */
 	if (icmd->ulpBdeCount == 0)
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2009-12-08 09:43:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2010-01-22 21:55:11.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -448,6 +448,8 @@ struct unsol_rcv_ct_ctx {
 	uint32_t ctxt_id;
 	uint32_t SID;
 	uint32_t oxid;
+	uint32_t flags;
+#define UNSOL_VALID	0x00000001
 };
 
 struct lpfc_hba {
@@ -790,7 +792,7 @@ struct lpfc_hba {
 	uint16_t vlan_id;
 	struct list_head fcf_conn_rec_list;
 
-	struct mutex ct_event_mutex; /* synchronize access to ct_ev_waiters */
+	spinlock_t ct_ev_lock; /* synchronize access to ct_ev_waiters */
 	struct list_head ct_ev_waiters;
 	struct unsol_rcv_ct_ctx ct_ctx[64];
 	uint32_t ctx_idx;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2009-12-08 09:43:11.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-01-22 21:55:11.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -1346,6 +1346,9 @@ typedef struct {		/* FireFly BIU registe
 #define MBX_HEARTBEAT       0x31
 #define MBX_WRITE_VPARMS    0x32
 #define MBX_ASYNCEVT_ENABLE 0x33
+#define MBX_READ_EVENT_LOG_STATUS 0x37
+#define MBX_READ_EVENT_LOG  0x38
+#define MBX_WRITE_EVENT_LOG 0x39
 
 #define MBX_PORT_CAPABILITIES 0x3B
 #define MBX_PORT_IOV_CONTROL 0x3C
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-01-22 21:54:42.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-01-22 21:55:11.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2010 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -4293,7 +4293,7 @@ lpfc_hba_alloc(struct pci_dev *pdev)
 		return NULL;
 	}
 
-	mutex_init(&phba->ct_event_mutex);
+	spin_lock_init(&phba->ct_ev_lock);
 	INIT_LIST_HEAD(&phba->ct_ev_waiters);
 
 	return phba;
diff -upNr a/drivers/scsi/lpfc/lpfc_nl.h b/drivers/scsi/lpfc/lpfc_nl.h
--- a/drivers/scsi/lpfc/lpfc_nl.h	2009-10-26 12:58:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nl.h	2010-01-22 21:55:11.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2008 Emulex.  All rights reserved.                *
+ * Copyright (C) 2010 Emulex.  All rights reserved.                *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -177,23 +177,3 @@ struct temp_event {
 	uint32_t data;
 };
 
-/* bsg definitions */
-#define LPFC_BSG_VENDOR_SET_CT_EVENT	1
-#define LPFC_BSG_VENDOR_GET_CT_EVENT	2
-
-struct set_ct_event {
-	uint32_t command;
-	uint32_t ev_req_id;
-	uint32_t ev_reg_id;
-};
-
-struct get_ct_event {
-	uint32_t command;
-	uint32_t ev_reg_id;
-	uint32_t ev_req_id;
-};
-
-struct get_ct_event_reply {
-	uint32_t immed_data;
-	uint32_t type;
-};


