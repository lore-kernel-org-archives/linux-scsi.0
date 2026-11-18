Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043411;
	b=y6SdJMn1nt0UePZEVbM3ZSI22bLo1r77qH1BUffjLmLxAOmpYS3CYei9GsiXULrg4jlq
	 NSvZ3xlEXrtB9gK84HM2dRXc5isDpnhl+FzOb6oQ05rjO/pxXttQZVj0MwB4OTZpkTB+2
	 h86TWy3qkMzkM1xxo43uUBVCpFzsPIQAnHjrMdCL+IQXxjDY4ZiQdMRZdV6PKtvkP8g0Q
	 HC+K56H300kUMLeHTavBKGUsoYiVpCi9yyPDQrk/2VjQZANwc/iXKoHJtOIyP1m6Ppox1
	 MCBaXYkJml9lB0hHnnl+4hKJ5J7zSvfWfc+X4JdAbY0B5Rmo6WaG3IZpUar7gGh6vUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043411;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=E5/pucnNMI/c2ojblg/G0Oa6lamaWazaHZpn915p/WM=;
	b=a+mqq0US80k02U0451eNKTl+9MVkxfoSbc1XKq2CjZ48ek/cGgPpeA3v/xHRCC6KiiSS
	 ddb5ykreFRyHYkj22KmYfdzvPnEHWqngkTYhj1oeyvxKH+NJX7fq64yoU+4VWu0IBNkfO
	 2d7kk0JxVlAX3NOX6EKVqXh4vQYTcZmjiv6aPiua8dRxKId70Eknw2REcPTIee9/fX87F
	 PdM2qfGdJocVatISUhf0PkYFoE66kvOY5MvUroHPkix/1fbTxWbGhllS4VEM878ECDc/Q
	 vseHfEaTcN6XqaE5UQDW1AgW5+X97XqyEGycyTh5Ev6AJVyjP8ENNRQ9XM7RD3xUQhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZvxGWAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB669606A331;
	Wed, 18 Nov 2026 23:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZvxGWAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256831F000C6;
	Wed, 18 Nov 2026 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043411;
	bh=E5/pucnNMI/c2ojblg/G0Oa6lamaWazaHZpn915p/WM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BZvxGWAYDoXj3WfvktNcbkQwI9/VCpuuIkzJzDTyo9RucZy+eGfc4E41LxP0sCsOp
	 apNhVJzmC7qrPIoPleCoRZ5/jsPwwr1iGh8tstb25YhVMbEr+kslLJfdhPOyOfIACn
	 0bgpt5JV0/nQ5wecCekvgU+oyC7q/RFTWH8mnJsKlI4B9Gm+l7jwXRG2bMGzMd+En1
	 ftLLt0Trwa6iAsGTiOANhAEHDEzGnrYzUX9ZfIC97gcGSUBtIUCM8guqHk4L3k+LsR
	 hgmVjNcR49N7wQLWzvgDF7Pqz6epnuW3bqM9Bw/laI6543HlaI8ymg7tu5+NYoqEiA
	 kxU7pOoLXovRg==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:09:58 -0800
Subject: [PATCH v3 01/11] scsi: mpt3sas: Don't leave requeued firmware
 events pending at teardown
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
Message-Id: <20261118-sas-abba-v3-1-5562d690cf61@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5227; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=13z5+kTDnv8IEmsjpCIo3UEfpOKkYSck2pI/NA8WCjI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBQPCcoIcOb4S7VvS+BMTQUzlKJV+GtaZ6L6
 27OJTfpd2+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUAAKCRAADmhBGVaC
 FYbCEACx79sN5qaZwim867A3PgMGW2wM1PErEAXOGWTF5uCguXKLBSBhxUN/DKZ96ThQYV3o9Tl
 0tgGvnZBh7erahHifsNwKJLqOC5UIdS3V3AxtqVcjEPfIj9ey6EA30wuMse7C8Vg/Za8Rj2MAqx
 Ws+4Q6/1vun7/g1sQTui+E2MiVYLFhZUwhAfrcHbaNjT+vPrlRC9cQD2f8Iy93/WSou+kNiyfTG
 33f80dvJINrUrImhcdQ3caQ2mCFJMFxk+tD5BcEo/EIuuEu5PDCKT1h2aR9QTu+th+BzfO42c5J
 NcK4F0Xod0pTO8IzcEGuLewSK9OoLHfmFJ7dXT/clpAwYzReQ2idKIjRa+w9mnjIk5xKSKgYXOU
 xbBJO06zJkNS10+9hk+U5H89VaRvq+dfcjH+he/ok9j15zdFDQRGanvyuMicVbDWuqG9CCWTx/l
 3L9E/mU63sfqfE6KkxoE/+3sYpjP6cGi4cIkFd0SP+LoMikcUMyjFmFsphJtt57rfFZPO6wQeis
 IfOEKic9loml/5gaztRFlxG+JMXk7eWCUuoUk8ADdKgCl9givJ7z+ykvXfLal93UeZUrXTsEKtv
 vFv4WVl0cTAjNnhsW/SrrNa7xenlvHekFj4ORZZDNBtK4B6gSccCxHzeF+tgypx5uoBPwN6MVp3
 4kcu3zlHc10r3DA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

When a topology change event finds a busy device,
_scsih_fw_event_requeue() retries the event. It queues the event's
delayed_work on firmware_event_thread, with a one-second delay.
_scsih_fw_event_cleanup_queue() cancels only the event's work, not its
delayed_work. Thus the timer stays armed. Then scsih_remove() destroys
the workqueue. After the workqueue is freed, the timer queues
_firmware_event_work_delayed() on it:

  BUG: KASAN: slab-use-after-free in __queue_work+0xa12/0xb50
  Read of size 4 at addr ffff88814fefd1c0 by task swapper/10/0
   __queue_work
   call_timer_fn
   __run_timer_base
   ...
  Allocated by task 11:
   __alloc_workqueue
   alloc_workqueue_noprof
   _scsih_probe [mpt3sas]
  Freed by task 0:
   kfree
   rcu_core
  ...
  workqueue: cannot queue _firmware_event_work_delayed [mpt3sas] on wq fw_event_mpt3sas0

The cleanup does not wait for a running topology change event. If such
an event finds a busy device, it requeues itself. This can occur after
the cleanup passes the event.

Fix this:

 - In the cleanup, cancel the delayed_work of a requeued event.

 - Do not requeue an event while the cleanup runs or while the driver
   removes the host. Do this check under fw_event_lock, which the
   cleanup also takes.

 - Instead of a requeue, drop the reference that the work held.
   Previously, this reference leaked when firmware_event_thread was
   NULL.

 - Also drop the reference if the delayed_work cannot be queued.
   Cleanups can overlap. Thus one cleanup can clear fw_events_cleanup
   while another cleanup cancels the delayed_work. The cancel disables
   the delayed_work.

 - Initialize the delayed_work when the driver allocates the event, not
   at the first requeue. Thus a cleanup never cancels the delayed_work
   before it is initialized.

Fixes: ad5957193107 ("scsi: mpt3sas: Add firmware event requeue support for busy devices")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 49 ++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 04255286a2a6..545913123d01 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -320,6 +320,11 @@ static struct fw_event_work *alloc_fw_event_work(int len)
 		return NULL;
 
 	kref_init(&fw_event->refcount);
+	/*
+	 * Initialize the delayed_work up front: a cleanup may cancel it
+	 * while the event is being requeued.
+	 */
+	INIT_DELAYED_WORK(&fw_event->delayed_work, _firmware_event_work_delayed);
 	return fw_event;
 }
 
@@ -3696,6 +3701,9 @@ _scsih_fw_event_del_from_list(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
  *
  * Context: This function will acquire ioc->fw_event_lock.
  *
+ * The reference held by the work that ran @fw_event passes to the delayed
+ * work.  If the event can't be requeued, that reference is dropped.
+ *
  * Return nothing.
  */
 static void
@@ -3704,20 +3712,31 @@ _scsih_fw_event_requeue(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
 {
 	unsigned long flags;
 
-	if (ioc->firmware_event_thread == NULL)
-		return;
-
 	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	/*
+	 * Don't rearm the event while the queue is being flushed or the
+	 * host is going away.  _scsih_fw_event_cleanup_queue() may already
+	 * be past it, and the timer could then fire after the workqueue
+	 * has been destroyed.
+	 */
+	if (!ioc->firmware_event_thread || ioc->remove_host ||
+	    ioc->fw_events_cleanup)
+		goto drop;
+	fw_event->delayed_work_active = 1;
+	/*
+	 * Cleanups can overlap, and one can clear fw_events_cleanup while
+	 * another is cancelling, and so disabling, the delayed work.
+	 */
+	if (!queue_delayed_work(ioc->firmware_event_thread,
+	    &fw_event->delayed_work, msecs_to_jiffies(delay)))
+		goto drop;
 	fw_event_work_get(fw_event);
 	list_add_tail(&fw_event->list, &ioc->fw_event_list);
-	if (!fw_event->delayed_work_active) {
-		fw_event->delayed_work_active = 1;
-		INIT_DELAYED_WORK(&fw_event->delayed_work,
-		    _firmware_event_work_delayed);
-	}
-	queue_delayed_work(ioc->firmware_event_thread, &fw_event->delayed_work,
-	    msecs_to_jiffies(delay));
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+	return;
+drop:
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+	fw_event_work_put(fw_event);
 }
 
  /**
@@ -3869,9 +3888,17 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		 *
 		 * If it did execute, we wait for it to finish, and the put will
 		 * happen from _firmware_event_work()
+		 *
+		 * An event requeued by _scsih_fw_event_requeue() is pending
+		 * on its delayed_work instead, and its timer must not fire
+		 * after the workqueue is destroyed.
 		 */
-		if (cancel_work_sync(&fw_event->work))
+		if (fw_event->delayed_work_active) {
+			if (cancel_delayed_work_sync(&fw_event->delayed_work))
+				fw_event_work_put(fw_event);
+		} else if (cancel_work_sync(&fw_event->work)) {
 			fw_event_work_put(fw_event);
+		}
 
 	}
 	ioc->fw_events_cleanup = 0;

-- 
2.56.1

