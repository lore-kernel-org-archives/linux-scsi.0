From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x - list handling cleanups
Date: Mon, 18 Aug 2003 00:26:06 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030817142606.GA4603@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:32188 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S270210AbTHQO0J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2003 10:26:09 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Here's another patch in the "try and make the driver readable"
cleanup series. This one cleans up all of the list handling.

Description: Replaced the various hand crafted scsi req lists
(waiting and going in the dcb and free in the acb) and the dcb list
(in the acb) with the generic linux lists. This makes all of the list
related code a *lot* more readable then it was previously.


diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-18 00:04:53.951487880 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-18 00:05:03.449044032 +1000
@@ -60,6 +60,7 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/list.h>
 
 /*---------------------------------------------------------------------------
                                   Features
@@ -306,7 +307,7 @@
   SCSI Request Block
   -----------------------------------------------------------------------*/
 struct ScsiReqBlk {
-	struct ScsiReqBlk *next;
+	struct list_head list;		/* next/prev ptrs for srb lists */
 	struct DeviceCtlBlk *dcb;
 
 	/* HW scatter list (up to 64 entries) */
@@ -350,22 +351,16 @@
   Device Control Block
   -----------------------------------------------------------------------*/
 struct DeviceCtlBlk {
-	struct DeviceCtlBlk *next;
+	struct list_head list;		/* next/prev ptrs for the dcb list */
 	struct AdapterCtlBlk *acb;
-
-	struct ScsiReqBlk *going_srb;
-	struct ScsiReqBlk *going_last;
-
-	struct ScsiReqBlk *waiting_srb;
-	struct ScsiReqBlk *wait_list;
+	struct list_head srb_going_list;	/* head of going srb list */
+	struct list_head srb_waiting_list;	/* head of waiting srb list */
 
 	struct ScsiReqBlk *active_srb;
 	u32 tag_mask;
 
 	u16 max_command;
 
-	u16 going_srb_count;
-	u16 waiting_srb_count;
 	u8 target_id;		/* SCSI Target ID  (SCSI Only) */
 	u8 target_lun;		/* SCSI Log.  Unit (SCSI Only) */
 	u8 identify_msg;
@@ -390,20 +385,17 @@
 
 	u16 IOPortBase;
 
-	struct DeviceCtlBlk *link_dcb;
-	struct DeviceCtlBlk *last_dcb;
+	struct list_head dcb_list;		/* head of going dcb list */
 	struct DeviceCtlBlk *dcb_run_robin;
-
 	struct DeviceCtlBlk *active_dcb;
 
-	struct ScsiReqBlk *free_srb;
+	struct list_head srb_free_list;		/* head of free srb list */
 	struct ScsiReqBlk *tmp_srb;
 	struct timer_list waiting_timer;
 	struct timer_list selto_timer;
 
 	u16 srb_count;
 
-	u8 dcb_count;
 	u8 sel_timeout;
 
 	u8 irq_level;
@@ -824,6 +816,60 @@
 /*---------------------------------------------------------------------------
  ---------------------------------------------------------------------------*/
 
+/**
+ * list_size - Returns the size (in number of entries) of the
+ * supplied list.
+ *
+ * @head: The pointer to the head of the list to count the items in.
+ **/
+unsigned int list_size(struct list_head *head)
+{
+	unsigned int count = 0;
+	struct list_head *pos;
+	list_for_each(pos, head)
+		count++;
+	return count;
+}                                                                                        
+
+
+/**
+ * dcb_get_next - Given a dcb return the next dcb in the list of
+ * dcb's, wrapping back to the start of the dcb list if required.
+ * Returns the supplied dcb if there is only one dcb in the list.
+ *
+ * @head: The pointer to the head of the list to count the items in.
+ * @pos: The pointer the dcb for which we are searching for the
+ *       following dcb.
+ **/
+struct DeviceCtlBlk *dcb_get_next(
+		struct list_head *head,
+		struct DeviceCtlBlk *pos)
+{
+	int use_next = 0;
+	struct DeviceCtlBlk* next = NULL;	
+	struct DeviceCtlBlk* i;
+
+	if (list_empty(head))
+		return NULL;
+
+	/* find supplied dcb and then select the next one */
+	list_for_each_entry(i, head, list)
+		if (use_next) {
+			next = i;
+			break;
+		} else if (i == pos) {
+			use_next = 1;
+		}
+	/* if no next one take the head one (ie, wraparound) */
+	if (!next)
+        	list_for_each_entry(i, head, list) {
+        		next = i;
+        		break;
+        	}
+
+	return next;
+}
+
 
 /*
  * Queueing philosphy:
@@ -851,200 +897,153 @@
 
 /* Find cmd in SRB list */
 inline static
-struct ScsiReqBlk *find_cmd(Scsi_Cmnd * cmd,
-			    struct ScsiReqBlk *start)
+struct ScsiReqBlk *find_cmd(Scsi_Cmnd *cmd,
+			    struct list_head *head)
 {
-	struct ScsiReqBlk *psrb = start;
-	if (!start)
-		return 0;
-	do {
-		if (psrb->cmd == cmd)
-			return psrb;
-		psrb = psrb->next;
-	} while (psrb && psrb != start);
-	return 0;
+	struct ScsiReqBlk *i;
+	list_for_each_entry(i, head, list)
+		if (i->cmd == cmd)
+			return i;
+	return NULL;
 }
 
 
-/* Return next free SRB */
-static inline
-struct ScsiReqBlk *get_srb_free(struct AdapterCtlBlk *acb)
+/*
+ * srb_get_free - Return a free srb from the list of free SRBs that
+ * is stored with the acb.
+ */
+static
+struct ScsiReqBlk *srb_get_free(struct AdapterCtlBlk *acb)
 {
+	struct list_head *head = &acb->srb_free_list;
 	struct ScsiReqBlk *srb;
 
-	/*DC395x_Free_integrity (acb); */
-	srb = acb->free_srb;
-	if (!srb)
+	if (!list_empty(head)) {
+		srb = list_entry(head->next, struct ScsiReqBlk, list);
+		list_del(head->next);
+		dprintkdbg(DBG_0, "srb_get_free: got srb %p\n", srb);
+	} else {
+		srb = NULL;
 		dprintkl(KERN_ERR, "Out of Free SRBs :-(\n");
-	if (srb) {
-		acb->free_srb = srb->next;
-		srb->next = NULL;
 	}
-
 	return srb;
 }
 
 
-/* Insert SRB oin top of free list */
-static inline
-void insert_srb_free(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
+/*
+ * srb_free_insert - Insert an srb to the head of the free list
+ * stored in the acb.
+ */
+static
+void srb_free_insert(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "Free SRB %p\n", srb);
-	srb->next = acb->free_srb;
-	acb->free_srb = srb;
+	dprintkdbg(DBG_0, "srb_free_insert: put srb %p\n", srb);
+        list_add_tail(&srb->list, &acb->srb_free_list);
 }
 
 
-/* Inserts a SRB to the top of the Waiting list */
-static inline
-void insert_srb_waiting(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
+/*
+ * srb_waiting_insert - Insert an srb to the head of the wiating list
+ * stored in the dcb.
+ */
+static
+void srb_waiting_insert(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "Insert srb %p cmd %li to Waiting\n", srb, srb->cmd->pid);
-	srb->next = dcb->waiting_srb;
-	if (!dcb->waiting_srb)
-		dcb->wait_list = srb;
-	dcb->waiting_srb = srb;
-	dcb->waiting_srb_count++;
+	dprintkdbg(DBG_0, "srb_waiting_insert: srb %p cmd %li\n", srb, srb->cmd->pid);
+        list_add(&srb->list, &dcb->srb_waiting_list);
 }
 
 
-/* Queue SRB to waiting list */
+/*
+ * srb_waiting_append - Append an srb to the tail of the waiting list
+ * stored in the dcb.
+ */
 static inline
-void append_srb_waiting(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
+void srb_waiting_append(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "Append srb %p cmd %li to Waiting\n", srb, srb->cmd->pid);
-	if (dcb->waiting_srb)
-		dcb->wait_list->next = srb;
-	else
-		dcb->waiting_srb = srb;
-
-	dcb->wait_list = srb;
-	/* No next one in waiting list */
-	srb->next = NULL;
-	dcb->waiting_srb_count++;
+	dprintkdbg(DBG_0, "srb_waiting_append: srb %p cmd %li\n", srb, srb->cmd->pid);
+        list_add_tail(&srb->list, &dcb->srb_waiting_list);
 }
 
 
+/*
+ * srb_going_append - Append an srb to the tail of the going list
+ * stored in the dcb.
+ */
 static inline
-void append_srb_going(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
-{
-	dprintkdbg(DBG_0, "Append SRB %p to Going\n", srb);
-	/* Append to the list of Going commands */
-	if (dcb->going_srb)
-		dcb->going_last->next = srb;
-	else
-		dcb->going_srb = srb;
-
-	dcb->going_last = srb;
-	/* No next one in sent list */
-	srb->next = NULL;
-	dcb->going_srb_count++;
-}
-
-
-/* Find predecessor SRB */
-inline static
-struct ScsiReqBlk *find_srb_prev(struct ScsiReqBlk *srb,
-				 struct ScsiReqBlk *start)
+void srb_going_append(struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
-	struct ScsiReqBlk *p = start;
-	if (!start)
-		return 0;
-	do {
-		if (p->next == srb)
-			return p;
-		p = p->next;
-	} while (p && p != start);
-	return 0;
+	dprintkdbg(DBG_0, "srb_going_append: srb %p\n", srb);
+        list_add_tail(&srb->list, &dcb->srb_going_list);
 }
 
 
-/* Remove SRB from SRB queue */
-inline static
-struct ScsiReqBlk *remove_srb(struct ScsiReqBlk *srb,
-			      struct ScsiReqBlk *pre)
-{
-	if (pre->next != srb)
-		pre = find_srb_prev(srb, pre);
-	if (!pre) {
-		dprintkl(KERN_ERR, "Internal ERROR: SRB to rmv not found in Q!\n");
-		return 0;
-	}
-	pre->next = srb->next;
-	/*srb->next = NULL; */
-	return pre;
-}
-
 
-/* Remove SRB from Going queue */
+/*
+ * srb_going_remove - Remove an srb from the going list stored in the
+ * dcb.
+ */
 static
-void remove_srb_going(struct DeviceCtlBlk *dcb,
-		      struct ScsiReqBlk *srb,
-		      struct ScsiReqBlk *hint)
+void srb_going_remove(struct DeviceCtlBlk *dcb,
+		      struct ScsiReqBlk *srb)
 {
-	struct ScsiReqBlk *pre = NULL;
-	dprintkdbg(DBG_0, "Remove SRB %p from Going\n", srb);
-	if (!srb)
-		dprintkl(KERN_ERR, "Going_remove %p!\n", srb);
-	if (srb == dcb->going_srb)
-		dcb->going_srb = srb->next;
-	else if (hint && hint->next == srb)
-		pre = remove_srb(srb, hint);
-	else
-		pre = remove_srb(srb, dcb->going_srb);
-	if (srb == dcb->going_last)
-		dcb->going_last = pre;
-	dcb->going_srb_count--;
+	struct ScsiReqBlk *i;
+	struct ScsiReqBlk *tmp;
+	dprintkdbg(DBG_0, "srb_going_remove: srb %p\n", srb);
+
+	list_for_each_entry_safe(i, tmp, &dcb->srb_going_list, list)
+		if (i == srb) {
+			list_del(&srb->list);
+			break;
+		}
 }
 
 
-/* Remove SRB from Waiting queue */
+/*
+ * srb_waiting_remove - Remove an srb from the waiting list stored in the
+ * dcb.
+ */
 static
-void remove_srb_waiting(struct DeviceCtlBlk *dcb,
-			struct ScsiReqBlk *srb,
-			struct ScsiReqBlk *hint)
+void srb_waiting_remove(struct DeviceCtlBlk *dcb,
+			struct ScsiReqBlk *srb)
 {
-	struct ScsiReqBlk *pre = NULL;
-	dprintkdbg(DBG_0, "Remove SRB %p from Waiting\n", srb);
-	if (!srb)
-		dprintkl(KERN_ERR, "Waiting_remove %p!\n", srb);
-	if (srb == dcb->waiting_srb)
-		dcb->waiting_srb = srb->next;
-	else if (hint && hint->next == srb)
-		pre = remove_srb(srb, hint);
-	else
-		pre = remove_srb(srb, dcb->waiting_srb);
-	if (srb == dcb->wait_list)
-		dcb->wait_list = pre;
-	dcb->waiting_srb_count--;
+	struct ScsiReqBlk *i;
+	struct ScsiReqBlk *tmp;
+	dprintkdbg(DBG_0, "srb_waiting_remove: srb %p\n", srb);
+
+	list_for_each_entry_safe(i, tmp, &dcb->srb_waiting_list, list)
+		if (i == srb) {
+			list_del(&srb->list);
+			break;
+		}
 }
 
 
-/* Moves SRB from Going list to the top of Waiting list */
+/*
+ * srb_going_to_waiting_move - Remove an srb from the going list in
+ * the dcb and insert it at the head of the waiting list in the dcb.
+ */
 static
-void move_srb_going_to_waiting(struct DeviceCtlBlk *dcb,
+void srb_going_to_waiting_move(struct DeviceCtlBlk *dcb,
 			       struct ScsiReqBlk *srb)
 {
-	dprintkdbg(DBG_0, "Going_to_Waiting (SRB %p) pid = %li\n", srb, srb->cmd->pid);
-	/* Remove SRB from Going */
-	remove_srb_going(dcb, srb, 0);
-	TRACEPRINTF("GtW *");
-	/* Insert on top of Waiting */
-	insert_srb_waiting(dcb, srb);
-	/* Tag Mask must be freed elsewhere ! (KG, 99/06/18) */
+	dprintkdbg(DBG_0, "srb_going_waiting_move: srb %p, pid = %li\n", srb, srb->cmd->pid);
+	list_move(&srb->list, &dcb->srb_waiting_list);
 }
 
 
-/* Moves first SRB from Waiting list to Going list */
-static inline
-void move_srb_waiting_to_going(struct DeviceCtlBlk *dcb,
+/*
+ * srb_waiting_to_going_move - Remove an srb from the waiting list in
+ * the dcb and insert it at the head of the going list in the dcb.
+ */
+static
+void srb_waiting_to_going_move(struct DeviceCtlBlk *dcb,
 			       struct ScsiReqBlk *srb)
 {
 	/* Remove from waiting list */
-	dprintkdbg(DBG_0, "Remove SRB %p from head of Waiting\n", srb);
-	remove_srb_waiting(dcb, srb, 0);
+	dprintkdbg(DBG_0, "srb_waiting_to_going: srb %p\n", srb);
 	TRACEPRINTF("WtG *");
-	append_srb_going(dcb, srb);
+	list_move(&srb->list, &dcb->srb_going_list);
 }
 
 
@@ -1070,39 +1069,66 @@
 static
 void waiting_process_next(struct AdapterCtlBlk *acb)
 {
-	struct DeviceCtlBlk *ptr;
-	struct DeviceCtlBlk *ptr1;
+	struct DeviceCtlBlk *start = NULL;
+	struct DeviceCtlBlk *pos;
+	struct DeviceCtlBlk *dcb;
 	struct ScsiReqBlk *srb;
+	struct list_head *dcb_list_head = &acb->dcb_list;
 
 	if ((acb->active_dcb)
 	    || (acb->acb_flag & (RESET_DETECT + RESET_DONE + RESET_DEV)))
 		return;
+
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
-	ptr = acb->dcb_run_robin;
-	if (!ptr) {		/* This can happen! */
-		ptr = acb->link_dcb;
-		acb->dcb_run_robin = ptr;
-	}
-	ptr1 = ptr;
-	if (!ptr1)
+
+	if (list_empty(dcb_list_head))
 		return;
+
+	/*
+	 * Find the starting dcb. Need to find it again in the list
+	 * since the list may have changed since we set the ptr to it
+	 */
+	list_for_each_entry(dcb, dcb_list_head, list)
+		if (dcb == acb->dcb_run_robin) {
+			start = dcb;
+			break;
+		}
+	if (!start) {
+		/* This can happen! */
+		start = list_entry(dcb_list_head->next, typeof(*start), list);
+		acb->dcb_run_robin = start;
+	}
+
+
+	/*
+	 * Loop over the dcb, but we start somewhere (potentially) in
+	 * the middle of the loop so we need to manully do this.
+	 */
+	pos = start;
 	do {
+		struct list_head *waiting_list_head = &pos->srb_waiting_list;
+
 		/* Make sure, the next another device gets scheduled ... */
-		acb->dcb_run_robin = ptr1->next;
-		if (!(srb = ptr1->waiting_srb)
-		    || (ptr1->max_command <= ptr1->going_srb_count))
-			ptr1 = ptr1->next;
-		else {
+		acb->dcb_run_robin = dcb_get_next(dcb_list_head,
+						  acb->dcb_run_robin);
+
+		if (list_empty(waiting_list_head) ||
+		    pos->max_command <= list_size(&pos->srb_going_list)) {
+			/* move to next dcb */
+			pos = dcb_get_next(dcb_list_head, pos);
+		} else {
+			srb = list_entry(waiting_list_head->next,
+					 struct ScsiReqBlk, list);
+
 			/* Try to send to the bus */
-			if (!start_scsi(acb, ptr1, srb))
-				move_srb_waiting_to_going(ptr1, srb);
+			if (!start_scsi(acb, pos, srb))
+				srb_waiting_to_going_move(pos, srb);
 			else
-				waiting_set_timer(acb, HZ / 50);
+				waiting_set_timer(acb, HZ/50);
 			break;
 		}
-	} while (ptr1 != ptr);
-	return;
+	} while (pos != start);
 }
 
 
@@ -1141,30 +1167,18 @@
 	struct DeviceCtlBlk *dcb;
 
 	dcb = srb->dcb;
-	if ((dcb->max_command <= dcb->going_srb_count) ||
-	    (acb->active_dcb) ||
+	if (dcb->max_command <= list_size(&dcb->srb_going_list) ||
+	    acb->active_dcb ||
 	    (acb->acb_flag & (RESET_DETECT + RESET_DONE + RESET_DEV))) {
-		append_srb_waiting(dcb, srb);
+		srb_waiting_append(dcb, srb);
 		waiting_process_next(acb);
 		return;
 	}
-#if 0
-	if (dcb->waiting_srb) {
-		append_srb_waiting(dcb, srb);
-		/*      srb = waiting_srb_get(dcb); *//* non-existent */
-		srb = dcb->waiting_srb;
-		/* Remove from waiting list */
-		dcb->waiting_srb = srb->next;
-		srb->next = NULL;
-		if (!dcb->waiting_srb)
-			dcb->wait_list = NULL;
-	}
-#endif
 
-	if (!start_scsi(acb, dcb, srb))
-		append_srb_going(dcb, srb);
-	else {
-		insert_srb_waiting(dcb, srb);
+	if (!start_scsi(acb, dcb, srb)) {
+		srb_going_append(dcb, srb);
+	} else {
+		srb_waiting_insert(dcb, srb);
 		waiting_set_timer(acb, HZ / 50);
 	}
 }
@@ -1391,7 +1405,7 @@
 	cmd->result = 0;
 
 	/* get a free SRB */
-	srb = get_srb_free(acb);
+	srb = srb_get_free(acb);
 	if (!srb)
 	{
 		/*
@@ -1405,9 +1419,9 @@
 	/* build srb for the command */
 	build_srb(cmd, dcb, srb);
 
-	if (dcb->waiting_srb) {
+	if (!list_empty(&dcb->srb_waiting_list)) {
 		/* append to waiting queue */
-		append_srb_waiting(dcb, srb);
+		srb_waiting_append(dcb, srb);
 		waiting_process_next(acb);
 	} else {
 		/* process immediately */
@@ -1609,17 +1623,13 @@
  */
 static void reset_dev_param(struct AdapterCtlBlk *acb)
 {
-	struct DeviceCtlBlk *dcb = acb->link_dcb;
-	struct DeviceCtlBlk *dcb_temp;
+	struct DeviceCtlBlk *dcb;
 	struct NvRamType *eeprom = &acb->eeprom;
-	u8 period_index;
 
 	dprintkdbg(DBG_0, "reset_dev_param..............\n");
-	if (dcb == NULL)
-		return;
+	list_for_each_entry(dcb, &acb->dcb_list, list) {
+		u8 period_index;
 
-	dcb_temp = dcb;
-	do {
 		dcb->sync_mode &= ~(SYNC_NEGO_DONE + WIDE_NEGO_DONE);
 		dcb->sync_period = 0;
 		dcb->sync_offset = 0;
@@ -1631,10 +1641,7 @@
 		if (!(dcb->dev_mode & NTC_DO_WIDE_NEGO)
 		    || !(acb->config & HCC_WIDE_CARD))
 			dcb->sync_mode &= ~WIDE_NEGO_ENABLE;
-
-		dcb = dcb->next;
 	}
-	while (dcb_temp != dcb && dcb != NULL);
 }
 
 
@@ -1729,18 +1736,18 @@
 		return FAILED;
 	}
 
-	srb = find_cmd(cmd, dcb->waiting_srb);
+	srb = find_cmd(cmd, &dcb->srb_waiting_list);
 	if (srb) {
-		remove_srb_waiting(dcb, srb, 0);
+		srb_waiting_remove(dcb, srb);
 		pci_unmap_srb_sense(acb, srb);
 		pci_unmap_srb(acb, srb);
 		free_tag(dcb, srb);
-		insert_srb_free(acb, srb);
+		srb_free_insert(acb, srb);
 		dprintkl(KERN_DEBUG, "abort - command found in waiting commands queue");
 		cmd->result = DID_ABORT << 16;
 		return SUCCESS;
 	}
-	srb = find_cmd(cmd, dcb->going_srb);
+	srb = find_cmd(cmd, &dcb->srb_going_list);
 	if (srb) {
 		dprintkl(KERN_DEBUG, "abort - command currently in progress");
 		/* XXX: Should abort the command here */
@@ -3322,23 +3329,27 @@
 			      struct DeviceCtlBlk *dcb,
 			      u8 tag)
 {
-	struct ScsiReqBlk *last_srb = dcb->going_last;
-	struct ScsiReqBlk *srb = dcb->going_srb;
+	struct ScsiReqBlk *srb = NULL;
+	struct ScsiReqBlk *i;
+	        
+
 	dprintkdbg(DBG_0, "QTag Msg (SRB %p): %i\n", srb, tag);
 	if (!(dcb->tag_mask & (1 << tag)))
 		dprintkl(KERN_DEBUG,
 		       "MsgIn_QTag: tag_mask (%08x) does not reserve tag %i!\n",
 		       dcb->tag_mask, tag);
 
-	if (!srb)
+	if (list_empty(&dcb->srb_going_list))
 		goto mingx0;
-	while (srb) {
-		if (srb->tag_number == tag)
+	list_for_each_entry(i, &dcb->srb_going_list, list) {
+		if (i->tag_number == tag) {
+			srb = i;
 			break;
-		if (srb == last_srb)
-			goto mingx0;
-		srb = srb->next;
+		}
 	}
+	if (!srb)
+		goto mingx0;
+
 	dprintkdbg(DBG_0, "pid %li (%i-%i)\n", srb->cmd->pid,
 	       srb->dcb->target_id, srb->dcb->target_lun);
 	if (dcb->flag & ABORT_DEV_) {
@@ -3350,13 +3361,18 @@
 		goto mingx0;
 
 	/* Tag found */
-	TRACEPRINTF("[%s]*", dcb->active_srb->debugtrace);
-	TRACEPRINTF("RTag*");
-	/* Just for debugging ... */
-	last_srb = srb;
-	srb = dcb->active_srb;
-	TRACEPRINTF("Found.*");
-	srb = last_srb;
+	{
+		struct ScsiReqBlk *last_srb;
+		        
+		TRACEPRINTF("[%s]*", dcb->active_srb->debugtrace);
+		TRACEPRINTF("RTag*");
+		/* Just for debugging ... */
+		
+		last_srb = srb;
+		srb = dcb->active_srb;
+		TRACEPRINTF("Found.*");
+		srb = last_srb;
+	}
 
 	memcpy(srb->msgin_buf, dcb->active_srb->msgin_buf, acb->msg_len);
 	srb->state |= dcb->active_srb->state;
@@ -3774,36 +3790,26 @@
 static
 void set_xfer_rate(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
 {
-	u8 bval;
-	u16 cnt, i;
-	struct DeviceCtlBlk *dcb_temp;
+	struct DeviceCtlBlk *i;
 
 	/*
-	 ** set all lun device's  period , offset
+	 * set all lun device's  period , offset
 	 */
-	if (!(dcb->identify_msg & 0x07)) {
-		if (acb->scan_devices)
-			current_sync_offset = dcb->sync_offset;
-		else {
-			dcb_temp = acb->link_dcb;
-			cnt = acb->dcb_count;
-			bval = dcb->target_id;
-			for (i = 0; i < cnt; i++) {
-				if (dcb_temp->target_id == bval) {
-					dcb_temp->sync_period =
-					    dcb->sync_period;
-					dcb_temp->sync_offset =
-					    dcb->sync_offset;
-					dcb_temp->sync_mode =
-					    dcb->sync_mode;
-					dcb_temp->min_nego_period =
-					    dcb->min_nego_period;
-				}
-				dcb_temp = dcb_temp->next;
-			}
-		}
+	if (dcb->identify_msg & 0x07)
+		return;
+
+	if (acb->scan_devices) {
+		current_sync_offset = dcb->sync_offset;
+		return;
 	}
-	return;
+
+	list_for_each_entry(i, &acb->dcb_list, list)
+		if (i->target_id == dcb->target_id) {
+			i->sync_period = dcb->sync_period;
+			i->sync_offset = dcb->sync_offset;
+			i->sync_mode = dcb->sync_mode;
+			i->min_nego_period = dcb->min_nego_period;
+		}
 }
 
 
@@ -3882,7 +3888,7 @@
 					goto disc1;
 				}
 				free_tag(dcb, srb);
-				move_srb_going_to_waiting(dcb, srb);
+				srb_going_to_waiting_move(dcb, srb);
 				dprintkdbg(DBG_KG, "Retry pid %li ...\n",
 				       srb->cmd->pid);
 				waiting_set_timer(acb, HZ / 20);
@@ -3964,7 +3970,7 @@
 
 			srb->state = SRB_READY;
 			free_tag(dcb, srb);
-			move_srb_going_to_waiting(dcb, srb);
+			srb_going_to_waiting_move(dcb, srb);
 			waiting_set_timer(acb, HZ / 20);
 
 			/* return; */
@@ -4049,43 +4055,32 @@
 static
 void remove_dev(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
 {
-	struct DeviceCtlBlk *pPrevDCB = acb->link_dcb;
+	struct DeviceCtlBlk *i;
+	struct DeviceCtlBlk *tmp;
 
 	dprintkdbg(DBG_0, "remove_dev\n");
-	if (dcb->going_srb_count > 1) {
+	if (list_size(&dcb->srb_going_list) > 1) {
 		dprintkdbg(DBG_DCB, "Driver won't free DCB (ID %i, LUN %i): 0x%08x because of SRBCnt %i\n",
 			  dcb->target_id, dcb->target_lun, (int) dcb,
-			  dcb->going_srb_count);
+			  list_size(&dcb->srb_going_list));
 		return;
 	}
 	acb->dcb_map[dcb->target_id] &= ~(1 << dcb->target_lun);
 	acb->children[dcb->target_id][dcb->target_lun] = NULL;
 
-	/* The first one */
-	if (dcb == acb->link_dcb) {
-		/* The last one */
-		if (acb->last_dcb == dcb) {
-			dcb->next = NULL;
-			acb->last_dcb = NULL;
+	list_for_each_entry_safe(i, tmp, &acb->dcb_list, list) {
+		if (dcb == i) {
+			list_del(&i->list);
+			break;
 		}
-		acb->link_dcb = dcb->next;
-	} else {
-		while (pPrevDCB->next != dcb)
-			pPrevDCB = pPrevDCB->next;
-		pPrevDCB->next = dcb->next;
-		if (dcb == acb->last_dcb)
-			acb->last_dcb = pPrevDCB;
-	}
+	}			                        
 
 	dprintkdbg(DBG_DCB, "Driver about to free DCB (ID %i, LUN %i): %p\n",
 		  dcb->target_id, dcb->target_lun, dcb);
 	if (dcb == acb->active_dcb)
 		acb->active_dcb = NULL;
-	if (dcb == acb->link_dcb)
-		acb->link_dcb = dcb->next;
 	if (dcb == acb->dcb_run_robin)
-		acb->dcb_run_robin = dcb->next;
-	acb->dcb_count--;
+		acb->dcb_run_robin = dcb_get_next(&acb->dcb_list, dcb);
 	dc395x_kfree(dcb);
 }
 
@@ -4320,7 +4315,7 @@
 			request_sense(acb, dcb, srb);
 			return;
 		} else if (status_byte(status) == QUEUE_FULL) {
-			tempcnt = (u8) dcb->going_srb_count;
+			tempcnt = (u8)list_size(&dcb->srb_going_list);
 			printk
 			    ("\nDC395x:  QUEUE_FULL for dev %02i-%i with %i cmnds\n",
 			     dcb->target_id, dcb->target_lun, tempcnt);
@@ -4328,7 +4323,7 @@
 				tempcnt--;
 			dcb->max_command = tempcnt;
 			free_tag(dcb, srb);
-			move_srb_going_to_waiting(dcb, srb);
+			srb_going_to_waiting_move(dcb, srb);
 			waiting_set_timer(acb, HZ / 20);
 			srb->adapter_status = 0;
 			srb->target_status = 0;
@@ -4409,12 +4404,12 @@
 			     cmd->device->lun, srb->total_xfer_length);
 	}
 
-	remove_srb_going(dcb, srb, 0);
+	srb_going_remove(dcb, srb);
 	/* Add to free list */
 	if (srb == acb->tmp_srb)
 		dprintkl(KERN_ERR, "ERROR! Completed Cmnd with tmp_srb!\n");
 	else
-		insert_srb_free(acb, srb);
+		srb_free_insert(acb, srb);
 
 	dprintkdbg(DBG_0, "SRBdone: done pid %li\n", cmd->pid);
 	if (debug_enabled(DBG_KG)) {
@@ -4444,30 +4439,21 @@
 		    Scsi_Cmnd * cmd, u8 force)
 {
 	struct DeviceCtlBlk *dcb;
-	struct ScsiReqBlk *srb;
-	struct ScsiReqBlk *srb_temp;
-	u16 cnt;
-	Scsi_Cmnd *p;
 
-	dcb = acb->link_dcb;
-	if (!dcb)
-		return;
 	dprintkl(KERN_INFO, "doing_srb_done: pids ");
-	do {
-		/* As the ML may queue cmnds again, cache old values */
-		struct ScsiReqBlk *waiting_srb = dcb->waiting_srb;
-		/*struct ScsiReqBlk* wait_list = dcb->wait_list; */
-		u16 waiting_srb_count = dcb->waiting_srb_count;
-		/* Going queue */
-		cnt = dcb->going_srb_count;
-		srb = dcb->going_srb;
-		while (cnt--) {
+	list_for_each_entry(dcb, &acb->dcb_list, list) {
+		struct ScsiReqBlk *srb;
+		struct ScsiReqBlk *tmp;
+		Scsi_Cmnd *p;
+
+		list_for_each_entry_safe(srb, tmp, &dcb->srb_going_list, list) {
 			int result;
 			int dir;
-			srb_temp = srb->next;
+
 			p = srb->cmd;
 			dir = scsi_to_pci_dma_dir(p->sc_data_direction);
 			result = MK_RES(0, did_flag, 0, 0);
+
 			/*result = MK_RES(0,DID_RESET,0,0); */
 			TRACEPRINTF("Reset(%li):%08x*", jiffies, result);
 			printk(" (G)");
@@ -4476,12 +4462,10 @@
 			       p->device->id, p->device->lun);
 #endif
 			TRACEOUT("%s\n", srb->debugtrace);
-			dcb->going_srb = srb_temp;
-			dcb->going_srb_count--;
-			if (!srb_temp)
-				dcb->going_last = NULL;
+
+			srb_going_remove(dcb, srb);
 			free_tag(dcb, srb);
-			insert_srb_free(acb, srb);
+			srb_free_insert(acb, srb);
 			p->result = result;
 			pci_unmap_srb_sense(acb, srb);
 			pci_unmap_srb(acb, srb);
@@ -4490,9 +4474,8 @@
 				 * as they all complete or all time out */
 				p->scsi_done(p);
 			}
-			srb = srb_temp;
 		}
-		if (dcb->going_srb)
+		if (!list_empty(&dcb->srb_going_list))
 			dprintkl(KERN_DEBUG, 
 			       "How could the ML send cmnds to the Going queue? (%02i-%i)!!\n",
 			       dcb->target_id, dcb->target_lun);
@@ -4501,16 +4484,12 @@
 			       "tag_mask for %02i-%i should be empty, is %08x!\n",
 			       dcb->target_id, dcb->target_lun,
 			       dcb->tag_mask);
-		/*dcb->going_srb_count = 0;; */
-		/*dcb->going_srb = NULL; dcb->going_last = NULL; */
 
 		/* Waiting queue */
-		cnt = waiting_srb_count;
-		srb = waiting_srb;
-		while (cnt--) {
+		list_for_each_entry_safe(srb, tmp, &dcb->srb_waiting_list, list) {
 			int result;
-			srb_temp = srb->next;
 			p = srb->cmd;
+
 			result = MK_RES(0, did_flag, 0, 0);
 			TRACEPRINTF("Reset(%li):%08x*", jiffies, result);
 			printk(" (W)");
@@ -4519,11 +4498,8 @@
 			       p->device->lun);
 #endif
 			TRACEOUT("%s\n", srb->debugtrace);
-			dcb->waiting_srb = srb_temp;
-			dcb->waiting_srb_count--;
-			if (!srb_temp)
-				dcb->wait_list = NULL;
-			insert_srb_free(acb, srb);
+			srb_waiting_remove(dcb, srb);
+			srb_free_insert(acb, srb);
 
 			p->result = result;
 			pci_unmap_srb_sense(acb, srb);
@@ -4532,21 +4508,16 @@
 				/* For new EH, we normally don't need to give commands back,
 				 * as they all complete or all time out */
 				cmd->scsi_done(cmd);
-				srb = srb_temp;
 			}
 		}
-		if (dcb->waiting_srb_count)
+		if (!list_empty(&dcb->srb_waiting_list))
 			printk
 			    ("\nDC395x: Debug: ML queued %i cmnds again to %02i-%i\n",
-			     dcb->waiting_srb_count, dcb->target_id,
+			     list_size(&dcb->srb_waiting_list), dcb->target_id,
 			     dcb->target_lun);
-		/* The ML could have queued the cmnds again! */
-		/*dcb->waiting_srb_count = 0;; */
-		/*dcb->waiting_srb = NULL; dcb->wait_list = NULL; */
+
 		dcb->flag &= ~ABORT_DEV_;
-		dcb = dcb->next;
 	}
-	while (dcb != acb->link_dcb && dcb);
 	printk("\n");
 }
 
@@ -4703,7 +4674,7 @@
 		       "Request Sense failed for pid %li (%02i-%i)!\n",
 		       srb->cmd->pid, dcb->target_id, dcb->target_lun);
 		TRACEPRINTF("?*");
-		move_srb_going_to_waiting(dcb, srb);
+		srb_going_to_waiting_move(dcb, srb);
 		waiting_set_timer(acb, HZ / 100);
 	}
 	TRACEPRINTF(".*");
@@ -4736,26 +4707,17 @@
 	if (!dcb)
 		return;
 
-	if (acb->dcb_count == 0) {
-		acb->link_dcb = dcb;
+	INIT_LIST_HEAD(&dcb->srb_waiting_list);
+	INIT_LIST_HEAD(&dcb->srb_going_list);
+	if (list_empty(&acb->dcb_list))
 		acb->dcb_run_robin = dcb;
-	} else {
-		acb->last_dcb->next = dcb;
-	}
-
-	acb->dcb_count++;
-	dcb->next = acb->link_dcb;
-	acb->last_dcb = dcb;
+	list_add_tail(&dcb->list, &acb->dcb_list);
 
 	/* $$$$$$$ */
 	dcb->acb = acb;
 	dcb->target_id = target;
 	dcb->target_lun = lun;
 	/* $$$$$$$ */
-	dcb->waiting_srb = NULL;
-	dcb->going_srb = NULL;
-	dcb->going_srb_count = 0;
-	dcb->waiting_srb_count = 0;
 	dcb->active_srb = NULL;
 	/* $$$$$$$ */
 	dcb->tag_mask = 0;
@@ -4792,9 +4754,10 @@
 	/* $$$$$$$ */
 	if (dcb->target_lun != 0) {
 		/* Copy settings */
-		struct DeviceCtlBlk *prevDCB = acb->link_dcb;
-		while (prevDCB->target_id != dcb->target_id)
-			prevDCB = prevDCB->next;
+		struct DeviceCtlBlk *prevDCB;
+		list_for_each_entry(prevDCB, &acb->dcb_list, list)
+			if (prevDCB->target_id == dcb->target_id)
+				break;
 		dprintkdbg(DBG_KG,
 		       "Copy settings from %02i-%02i to %02i-%02i\n",
 		       prevDCB->target_id, prevDCB->target_lun,
@@ -4924,9 +4887,7 @@
 	int i;
 
 	for (i = 0; i < acb->srb_count - 1; i++)
-		acb->srb_array[i].next = &acb->srb_array[i + 1];
-	acb->srb_array[i].next = NULL;
-	/*DC395x_Free_integrity (acb);     */
+		srb_free_insert(acb, &acb->srb_array[i]);
 }
 
 
@@ -4974,14 +4935,12 @@
 	 */
 	acb->scsi_host = host;
 	acb->IOPortBase = (u16) io_port;
-	acb->link_dcb = NULL;
 	acb->dcb_run_robin = NULL;
 	acb->active_dcb = NULL;
 	acb->srb_count = DC395x_MAX_SRB_CNT;
 	acb->scsi_host->this_id = eeprom->scsi_id;
 	acb->hostid_bit = (1 << acb->scsi_host->this_id);
 	/*acb->scsi_host->this_lun = 0; */
-	acb->dcb_count = 0;
 	acb->irq_level = irq;
 	acb->tag_max_num = 1 << eeprom->max_tag;
 	if (acb->tag_max_num > 30)
@@ -5006,14 +4965,14 @@
 		return 1;
 	}
 #endif
+	INIT_LIST_HEAD(&acb->dcb_list);
+	INIT_LIST_HEAD(&acb->srb_free_list);
 	link_srb(acb);
-	acb->free_srb = acb->srb_array;
+
 	/* 
 	 * temp SRB for Q tag used or abort command used 
 	 */
 	acb->tmp_srb = &acb->srb;
-	acb->srb.dcb = NULL;
-	acb->srb.next = NULL;
 	init_timer(&acb->waiting_timer);
 
 	for (i = 0; i < DC395x_MAX_SCSI_ID; i++)
@@ -5550,10 +5509,11 @@
 		     int inout)
 {
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)host->hostdata;
-	int dev, spd, spd1;
+	int spd, spd1;
 	char *pos = buffer;
 	struct DeviceCtlBlk *dcb;
 	unsigned long flags;
+	int dev;
 
 	if (inout)		/* Has data been written to the file ? */
 		return -EPERM;
@@ -5580,7 +5540,7 @@
 	SPRINTF(", DelayReset %is\n", acb->eeprom.delay_time);
 	/*SPRINTF("\n"); */
 
-	SPRINTF("Nr of DCBs: %i\n", acb->dcb_count);
+	SPRINTF("Nr of DCBs: %i\n", list_size(&acb->dcb_list));
 	SPRINTF
 	    ("Map of attached LUNs: %02x %02x %02x %02x %02x %02x %02x %02x\n",
 	     acb->dcb_map[0], acb->dcb_map[1], acb->dcb_map[2],
@@ -5595,8 +5555,8 @@
 	SPRINTF
 	    ("Un ID LUN Prty Sync Wide DsCn SndS TagQ nego_period SyncFreq SyncOffs MaxCmd\n");
 
-	dcb = acb->link_dcb;
-	for (dev = 0; dev < acb->dcb_count; dev++) {
+	dev = 0;
+	list_for_each_entry(dcb, &acb->dcb_list, list) {
 		int nego_period;
 		SPRINTF("%02i %02i  %02i ", dev, dcb->target_id,
 			dcb->target_lun);
@@ -5606,8 +5566,7 @@
 		YESNO(dcb->dev_mode & NTC_DO_DISCONNECT);
 		YESNO(dcb->dev_mode & NTC_DO_SEND_START);
 		YESNO(dcb->sync_mode & EN_TAG_QUEUEING);
-		nego_period =
-		    clock_period[dcb->sync_period & 0x07] << 2;
+		nego_period = clock_period[dcb->sync_period & 0x07] << 2;
 		if (dcb->sync_offset)
 			SPRINTF("  %03i ns ", nego_period);
 		else
@@ -5624,45 +5583,42 @@
 
 		/* Add more info ... */
 		SPRINTF("     %02i\n", dcb->max_command);
-		dcb = dcb->next;
+		dev++;
 	}
 
 	if (timer_pending(&acb->waiting_timer))
 		SPRINTF("Waiting queue timer running\n");
 	else
 		SPRINTF("\n");
-	dcb = acb->link_dcb;
 
-	for (dev = 0; dev < acb->dcb_count; dev++) {
+	list_for_each_entry(dcb, &acb->dcb_list, list) {
 		struct ScsiReqBlk *srb;
-		if (dcb->waiting_srb_count)
+		if (!list_empty(&dcb->srb_waiting_list))
 			SPRINTF("DCB (%02i-%i): Waiting: %i:",
 				dcb->target_id, dcb->target_lun,
-				dcb->waiting_srb_count);
-		for (srb = dcb->waiting_srb; srb; srb = srb->next)
+				list_size(&dcb->srb_waiting_list));
+                list_for_each_entry(srb, &dcb->srb_waiting_list, list)
 			SPRINTF(" %li", srb->cmd->pid);
-		if (dcb->going_srb_count)
+		if (!list_empty(&dcb->srb_going_list))
 			SPRINTF("\nDCB (%02i-%i): Going  : %i:",
 				dcb->target_id, dcb->target_lun,
-				dcb->going_srb_count);
-		for (srb = dcb->going_srb; srb; srb = srb->next)
+				list_size(&dcb->srb_going_list));
+		list_for_each_entry(srb, &dcb->srb_going_list, list)
 #if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 			SPRINTF("\n  %s", srb->debugtrace);
 #else
 			SPRINTF(" %li", srb->cmd->pid);
 #endif
-		if (dcb->waiting_srb_count || dcb->going_srb_count)
+		if (!list_empty(&dcb->srb_waiting_list) || !list_empty(&dcb->srb_going_list))
 			SPRINTF("\n");
-		dcb = dcb->next;
 	}
 
 	if (debug_enabled(DBG_DCB)) {
 		SPRINTF("DCB list for ACB %p:\n", acb);
-		dcb = acb->link_dcb;
-		SPRINTF("%p", dcb);
-		for (dev = 0; dev < acb->dcb_count; dev++, dcb = dcb->next)
-			SPRINTF("->%p", dcb->next);
-		SPRINTF("\n");
+		list_for_each_entry(dcb, &acb->dcb_list, list) {
+			SPRINTF("%p -> ", dcb);
+		}
+		SPRINTF("END\n");
 	}
 
 	*start = buffer + offset;
@@ -5721,19 +5677,13 @@
 void free_dcbs(struct AdapterCtlBlk* acb)
 {
 	struct DeviceCtlBlk *dcb;
-	struct DeviceCtlBlk *dcb_next;
+	struct DeviceCtlBlk *tmp;
 
-	dprintkdbg(DBG_DCB, "Free %i DCBs\n", acb->dcb_count);
+	dprintkdbg(DBG_DCB, "Free %i DCBs\n", list_size(&acb->dcb_list));
 
-	for (dcb = acb->link_dcb; dcb != NULL; dcb = dcb_next)
-	{
-		dcb_next = dcb->next;
+	list_for_each_entry_safe(dcb, tmp, &acb->dcb_list, list) {
 		dprintkdbg(DBG_DCB, "Free DCB (ID %i, LUN %i): %p\n",
 			             dcb->target_id, dcb->target_lun, dcb);
-		/*
-		 * Free the DCB. This removes the entry from the
-		 * link_dcb list and decrements the count in dcb_count
-		 */
 		remove_dev(acb, dcb);
 	}
 }

-- 
 Jamie Lenehan <lenehan@twibble.org>
