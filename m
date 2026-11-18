Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043412;
	b=0S1eqeZvhGFyo7VYRZrwQNz/15cTpwymY5mCenZ+YDLUZ5x1ej+3Xn/X6GF1YMwtrBxC
	 XXB6Rqfe+06BrFkbtHtxqCJJYQ1wW78jTB5tzS3YiMD08//1skieHJfHfH6jh7v8ob7eB
	 dkxxJ/akq1SZ/JmAJJQMRTGtO1L7foAY4VtgnLxPf2hWXYDFGPhB9W095J4XDdeeF12FA
	 PVqj5vfps78qlz8F4AAqbqHUAK+21nptsCF5EhNDDic6RONl0YRniLR6A/4a98BTL/mjR
	 aCJCZ1ThSEsGSavXh+JI+X+wB71eUfmddP8FzN3Hkj5jggxmIR63HLxzkKxseThD0JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043412;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=y4Jxp7UZQxXrZbbS7bpxSw0MXOx+R/LCCuxpS41G5t4=;
	b=JmnFz2huHAAWrug4gAdVfkYQFrVDo5qYDfxKfHMvu58hedUcFP3h477Pk9rlui99z20G
	 7s1v/g9ohKFjO8RjtaLI4EstMRaWfr3okL7IPHEUxD1nt9JDZMWaCV1ZxdLiNWBWCFHqL
	 qQrSlay+dfBJ0aedCMjUVWS+1MstWEju5ikMDHMxPlf85ws17B50xoOa2gcEBXWRMXzFn
	 F/NnUvPed6WgMawuNhgqChZBeiArI/+Yuhmi6XOqKVE+3lPlEePT/ZDPhbEBrAbG/LbMH
	 vRX/Z9wh4+5gpvyZKC2iiwVEPiDnrXamJcmg4oSGbgypaWhgkBD1MEQp3fIdqnpC8AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mxxryj+v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419D960A2600;
	Wed, 18 Nov 2026 23:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mxxryj+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7CF1F000C9;
	Wed, 18 Nov 2026 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043412;
	bh=y4Jxp7UZQxXrZbbS7bpxSw0MXOx+R/LCCuxpS41G5t4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mxxryj+vBX5Xg+qj5Ym0W2cayHFw4hm0ApcLB4mNlHCJmsiNC5wkC0JMxOuxR0jWC
	 Pvmxf0JfaDpW5Xm5Z46T/bgFTOcb6DyxqjXav4zim6GVQ4f9UtVSiZyG0ZrKqAdKME
	 YwFHtXj/eO0a6n5qO6/0CooNrdqRYvMuTeozjzbvpYIF68mYRgQQ14Opwl89w8eVgw
	 Bv4kmuLALB23ErH7A8L7iPKEEJcZx1GMBznXXGiDd0C9SI6o+PtlWfdDLqncqwNIMJ
	 +rOV4UzsoOegj/hJUyXvNAKiM9r6W4zJEWJnLIRv9axkce1tp3bJcWB8jf/7XGChwy
	 a97pe/g7uTN+w==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:09:59 -0800
Subject: [PATCH v3 02/11] scsi: mpt3sas: Hold event references while
 cleaning up the event queue
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-sas-abba-v3-2-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
In-Reply-To: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=15556; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=G2tDJ610HUfV4IVKdpO+01SKoezHe7o24ckLT7sDMVY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBQ7XalvMTxKyM/4YsnNrIzdfOBZRpm56C4S
 aCm0YqM96iJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUAAKCRAADmhBGVaC
 FfP1EACjhffvhi7nKkQ3XdoqENjD1tc4ORQz8wiK7w/wPA4gZkpaq5uJndcArfwQOn8qHxRwdXl
 BS4RsJbYpl+Fsu+0UDXXPw2uXJCZoKHf19XnOE+IsPVgI0NjoVBR+ckOfq6KutXcoGgMGmL4wUC
 j9HvQJKGRM3vzZgwdyh+ZwldKwyyk7kVx+tGmkUGFMBOftVdzgrDah9pFyk6hIVOkmvLXgSh5gh
 Cly5NGUft0dtdpQ06i/sbqIiDKtiMcG4qyasU/OB5v+DL/azD2TKRfevNPcQKK6Tvae1eBGbfaI
 vwcg63+8ONrNtUFlEL6mMtBega3010BrjfwjYRzcElzIZjp691CurxzOdiweHhOzE8HHBxhaIC+
 X6D5ZHiZ1Pz2lx0jS4cbgUg1b0yNOWoMqHqJ5o0qtUkGdPWKfP0mosxV+sS9Oq82TOemURPZeHl
 Jpmlogcpmqt/C4FKTSV8ORhIX7MF4SzzROyS72cQ0imEweBmCvz3uDZvMC6YTU3IzOg/LVoessT
 nYsJXt4N3fiQ40LdRHbUIWSro1+WIzKjyekm6p5oI5+37GLtjvcec62EcAUE+MHGsTUKkXqbKn0
 mp7JU365Tt7x7uThnN+mM/q6qlhzLTID0l9EZQBhVTNC/hW8kb86tEMmBZ0MV+vb7rC/PDnaeLg
 3uD3A5quD70v2Ww==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

_scsih_fw_event_cleanup_queue() uses events without a reference to
them. But the work of an event frees the event when the work ends. This
causes these problems:

 - dequeue_next_fw_event() drops the list's reference before the
   cleanup cancels the event's work. If the work runs and ends between
   these two steps, the cleanup calls cancel_work_sync() on a freed
   event.

 - The cleanup holds no reference to an event that it finds through
   ioc->current_event. The worker drops its reference before it clears
   current_event. Thus the cleanup can find a freed event there, and
   set ->ignore on it or read its ->event. For a running
   MPT3SAS_REMOVE_UNRESPONDING_DEVICES event, cancel_work_sync() waits
   for the work. The work frees the event, and then cancel_work_sync()
   enables the work again in freed memory.

 - To identify a running event, the cleanup only compares the event
   with current_event. It waits for the work of all other events that
   it finds. But the cleanup also clears current_event. Also, cleanups
   can overlap, because _base_fault_reset_work() calls a cleanup
   without reset_in_progress_mutex. Thus a cleanup that holds
   reset_in_progress_mutex can wait for a running event. That event is
   about to take the same mutex for a hard reset.

Originally, commit 146b16c8071f ("mpt3sas: Refcount fw_events and fix
unsafe list usage") kept the list's reference until after the cancel.
Then commit 9e73ed2e4cf5 ("scsi: mpt3sas: Cancel the running work
during host reset") added the current_event path. Events on this path
had no reference to drop. To fix the resulting underflow, commit
991df3dd5144 ("scsi: mpt3sas: Fix use-after-free warning") dropped the
list's reference early.

Fix the reference handling:

 - Let dequeue_next_fw_event() pass the list's reference to the cleanup
   again. The cleanup drops the reference after the cancel.

 - Set and clear current_event under fw_event_lock. Clear it before the
   worker drops its reference. Then the cleanup can take a reference to
   the current event under the lock.

 - When the worker requeues the event, clear current_event in
   _scsih_fw_event_requeue(). Do this under fw_event_lock, together
   with the requeue or the drop of the event. _scsih_fw_event_requeue()
   can now drop the reference.

 - Also do the check for events to clean up under the lock.

Thus the cleanup finds the event either as the current event or on
fw_event_list. It cannot miss the event between the two.

When the worker starts an event, remove the event from fw_event_list
and make it the current event. Do both in one step under
fw_event_lock. If the event is no longer on the list, a cleanup removed
it, so drop it. Thus an event that the cleanup removes from the list
never runs. The cancel of its work then never waits for a running
event.

Do not change current_event in the cleanup. Let the worker manage it.
Wait for the running event only if it is
MPT3SAS_REMOVE_UNRESPONDING_DEVICES, as before.

Only the broadcast primitive handler clears broadcast_aen_busy. If the
cleanup drops a broadcast primitive event, broadcast_aen_busy stays
set. Later broadcast primitives then only count as pending. An event
that the cleanup cancels before it runs already causes this. With this
change, an event that the worker drops as it starts also causes it.
When the cleanup drops such an event, clear broadcast_aen_busy and the
stale pending count.

Fixes: 9e73ed2e4cf5 ("scsi: mpt3sas: Cancel the running work during host reset")
Fixes: 991df3dd5144 ("scsi: mpt3sas: Fix use-after-free warning")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 211 ++++++++++++++++++++++++-----------
 1 file changed, 148 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 545913123d01..b455b7e5d8f3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3672,25 +3672,37 @@ _scsih_fw_event_add(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 }
 
 /**
- * _scsih_fw_event_del_from_list - delete fw_event from the list
+ * _scsih_fw_event_start - start running an event
  * @ioc: per adapter object
  * @fw_event: object describing the event
  * Context: This function will acquire ioc->fw_event_lock.
  *
- * If the fw_event is on the fw_event_list, remove it and do a put.
+ * An event is on fw_event_list from when it is queued until it starts.
+ * Take @fw_event off the list, dropping the list's reference, and make it
+ * the current event, in one step under fw_event_lock.  If it is no longer
+ * on the list, _scsih_fw_event_cleanup_queue() took it off, and may be
+ * waiting for its work to end.
+ *
+ * Return: true if @fw_event should run, false if it should be dropped.
  */
-static void
-_scsih_fw_event_del_from_list(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
-	*fw_event)
+static bool
+_scsih_fw_event_start(struct MPT3SAS_ADAPTER *ioc,
+		      struct fw_event_work *fw_event)
 {
 	unsigned long flags;
+	bool start = false;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
 	if (!list_empty(&fw_event->list)) {
 		list_del_init(&fw_event->list);
+		/* the work still holds a reference */
 		fw_event_work_put(fw_event);
+		ioc->current_event = fw_event;
+		start = true;
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+
+	return start;
 }
 
 /**
@@ -3704,6 +3716,12 @@ _scsih_fw_event_del_from_list(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
  * The reference held by the work that ran @fw_event passes to the delayed
  * work.  If the event can't be requeued, that reference is dropped.
  *
+ * The worker is done with @fw_event, so this also clears
+ * ioc->current_event.  That happens under fw_event_lock together with
+ * requeueing or dropping the event, so that
+ * _scsih_fw_event_cleanup_queue() finds the event either as the current
+ * one or on fw_event_list.
+ *
  * Return nothing.
  */
 static void
@@ -3713,6 +3731,8 @@ _scsih_fw_event_requeue(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	if (ioc->current_event == fw_event)
+		ioc->current_event = NULL;
 	/*
 	 * Don't rearm the event while the queue is being flushed or the
 	 * host is going away.  _scsih_fw_event_cleanup_queue() may already
@@ -3800,6 +3820,10 @@ mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc)
 	fw_event_work_put(fw_event);
 }
 
+/*
+ * Remove the first event from fw_event_list and return it, with the
+ * reference the list held.  The caller puts it.
+ */
 static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 {
 	unsigned long flags;
@@ -3810,13 +3834,47 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 		fw_event = list_first_entry(&ioc->fw_event_list,
 				struct fw_event_work, list);
 		list_del_init(&fw_event->list);
-		fw_event_work_put(fw_event);
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
 	return fw_event;
 }
 
+/*
+ * ioc->current_event is set and cleared under fw_event_lock, and cleared
+ * before the worker drops its reference to the event.  While it is set
+ * under the lock, the event is live.
+ */
+static void
+_scsih_set_current_event(struct MPT3SAS_ADAPTER *ioc,
+			 struct fw_event_work *fw_event)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	ioc->current_event = fw_event;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+}
+
+/*
+ * Return the event the worker is running, with a reference that the
+ * caller puts, or NULL if there is none.
+ */
+static struct fw_event_work *
+_scsih_get_current_event(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct fw_event_work *fw_event;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	fw_event = ioc->current_event;
+	if (fw_event)
+		fw_event_work_get(fw_event);
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+
+	return fw_event;
+}
+
 /**
  * _scsih_fw_event_cleanup_queue - cleanup event queue
  * @ioc: per adapter object
@@ -3830,10 +3888,13 @@ static void
 _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct fw_event_work *fw_event;
+	unsigned long flags;
+	bool idle;
 
-	if ((list_empty(&ioc->fw_event_list) && !ioc->current_event) ||
-	    !ioc->firmware_event_thread)
+	if (!ioc->firmware_event_thread)
 		return;
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	idle = list_empty(&ioc->fw_event_list) && !ioc->current_event;
 	/*
 	 * Set current running event as ignore, so that
 	 * current running event will exit quickly.
@@ -3842,64 +3903,87 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 	 */
 	if (ioc->shost_recovery && ioc->current_event)
 		ioc->current_event->ignore = 1;
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+	if (idle)
+		return;
 
+	/*
+	 * Hold a reference to each event while it is handled here: its work
+	 * can drop the last one as soon as it ends.
+	 *
+	 * Don't wait for the running event, other than
+	 * MPT3SAS_REMOVE_UNRESPONDING_DEVICES, which stops waiting for the
+	 * host reset when fw_events_cleanup is set.  Another event may be
+	 * issuing the hard reset this cleanup is part of, and cleanups can
+	 * overlap, so whether an event is running doesn't depend on another
+	 * cleanup.  An event taken off fw_event_list here doesn't run, see
+	 * _scsih_fw_event_start(), so cancelling it never waits for one.
+	 *
+	 * Orginal logic of cleaning the current_event is added
+	 * for handling the back to back host reset issued by the user.
+	 * i.e. during back to back host reset, driver use to process
+	 * the two instances of MPT3SAS_REMOVE_UNRESPONDING_DEVICES
+	 * event back to back and this made the drives to unregister
+	 * the devices from SML.
+	 */
 	ioc->fw_events_cleanup = 1;
-	while ((fw_event = dequeue_next_fw_event(ioc)) ||
-	     (fw_event = ioc->current_event)) {
+	for (;;) {
+		while ((fw_event = dequeue_next_fw_event(ioc))) {
+			/*
+			 * Driver has to clear ioc->start_scan flag when
+			 * it is cleaning up MPT3SAS_PORT_ENABLE_COMPLETE,
+			 * otherwise scsi_scan_host() API waits for the
+			 * 5 minute timer to expire. If we exit from
+			 * scsi_scan_host() early then we can issue the
+			 * new port enable request as part of current diag
+			 * reset.
+			 */
+			if (fw_event->event == MPT3SAS_PORT_ENABLE_COMPLETE) {
+				ioc->port_enable_cmds.status |= MPT3_CMD_RESET;
+				ioc->start_scan = 0;
+			}
 
-		/*
-		 * Don't call cancel_work_sync() for current_event
-		 * other than MPT3SAS_REMOVE_UNRESPONDING_DEVICES;
-		 * otherwise we may observe deadlock if current
-		 * hard reset issued as part of processing the current_event.
-		 *
-		 * Orginal logic of cleaning the current_event is added
-		 * for handling the back to back host reset issued by the user.
-		 * i.e. during back to back host reset, driver use to process
-		 * the two instances of MPT3SAS_REMOVE_UNRESPONDING_DEVICES
-		 * event back to back and this made the drives to unregister
-		 * the devices from SML.
-		 */
+			/*
+			 * If this returns 1, the event never ran, and the
+			 * reference its work held needs a put.  Otherwise
+			 * its work drops that reference.
+			 *
+			 * An event requeued by _scsih_fw_event_requeue() is
+			 * pending on its delayed_work instead, and its timer
+			 * must not fire after the workqueue is destroyed.
+			 */
+			if (fw_event->delayed_work_active) {
+				if (cancel_delayed_work_sync(&fw_event->delayed_work))
+					fw_event_work_put(fw_event);
+			} else if (cancel_work_sync(&fw_event->work)) {
+				fw_event_work_put(fw_event);
+			}
 
-		if (fw_event == ioc->current_event &&
-		    ioc->current_event->event !=
-		    MPT3SAS_REMOVE_UNRESPONDING_DEVICES) {
-			ioc->current_event = NULL;
-			continue;
-		}
+			/*
+			 * The broadcast callback queues one broadcast
+			 * primitive event at a time, and only its handler,
+			 * which won't run now, clears broadcast_aen_busy.
+			 */
+			if (fw_event->event ==
+			    MPI2_EVENT_SAS_BROADCAST_PRIMITIVE) {
+				ioc->broadcast_aen_busy = 0;
+				ioc->broadcast_aen_pending = 0;
+			}
 
-		/*
-		 * Driver has to clear ioc->start_scan flag when
-		 * it is cleaning up MPT3SAS_PORT_ENABLE_COMPLETE,
-		 * otherwise scsi_scan_host() API waits for the
-		 * 5 minute timer to expire. If we exit from
-		 * scsi_scan_host() early then we can issue the
-		 * new port enable request as part of current diag reset.
-		 */
-		if (fw_event->event == MPT3SAS_PORT_ENABLE_COMPLETE) {
-			ioc->port_enable_cmds.status |= MPT3_CMD_RESET;
-			ioc->start_scan = 0;
+			fw_event_work_put(fw_event);
 		}
 
-		/*
-		 * Wait on the fw_event to complete. If this returns 1, then
-		 * the event was never executed, and we need a put for the
-		 * reference the work had on the fw_event.
-		 *
-		 * If it did execute, we wait for it to finish, and the put will
-		 * happen from _firmware_event_work()
-		 *
-		 * An event requeued by _scsih_fw_event_requeue() is pending
-		 * on its delayed_work instead, and its timer must not fire
-		 * after the workqueue is destroyed.
-		 */
-		if (fw_event->delayed_work_active) {
-			if (cancel_delayed_work_sync(&fw_event->delayed_work))
-				fw_event_work_put(fw_event);
-		} else if (cancel_work_sync(&fw_event->work)) {
+		fw_event = _scsih_get_current_event(ioc);
+		if (!fw_event)
+			break;
+		if (fw_event->event != MPT3SAS_REMOVE_UNRESPONDING_DEVICES) {
 			fw_event_work_put(fw_event);
+			break;
 		}
-
+		/* wait for it, then flush what was queued meanwhile */
+		if (cancel_work_sync(&fw_event->work))
+			fw_event_work_put(fw_event);
+		fw_event_work_put(fw_event);
 	}
 	ioc->fw_events_cleanup = 0;
 }
@@ -11985,13 +12069,16 @@ mpt3sas_scsih_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 static void
 _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 {
-	ioc->current_event = fw_event;
-	_scsih_fw_event_del_from_list(ioc, fw_event);
+	if (!_scsih_fw_event_start(ioc, fw_event)) {
+		/* _scsih_fw_event_cleanup_queue() took it off the list */
+		fw_event_work_put(fw_event);
+		return;
+	}
 
 	/* the queue is being flushed so ignore this event */
 	if (ioc->remove_host || ioc->pci_error_recovery) {
+		_scsih_set_current_event(ioc, NULL);
 		fw_event_work_put(fw_event);
-		ioc->current_event = NULL;
 		return;
 	}
 
@@ -12046,7 +12133,6 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
 		if (_scsih_sas_topology_change_event(ioc, fw_event)) {
 			_scsih_fw_event_requeue(ioc, fw_event, 1000);
-			ioc->current_event = NULL;
 			return;
 		}
 		break;
@@ -12090,14 +12176,13 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
 		if (_scsih_pcie_topology_change_event(ioc, fw_event)) {
 			_scsih_fw_event_requeue(ioc, fw_event, 1000);
-			ioc->current_event = NULL;
 			return;
 		}
 		break;
 	}
 out:
+	_scsih_set_current_event(ioc, NULL);
 	fw_event_work_put(fw_event);
-	ioc->current_event = NULL;
 }
 
 /**

-- 
2.56.1

