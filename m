From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: ibmvscsi: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 03:06:07 -0700
Message-ID: <20171025100607.GA145026@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:56763 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932577AbdJYKGJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2017 06:06:09 -0400
Received: by mail-pg0-f65.google.com with SMTP id m18so16912841pgd.13
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 03:06:09 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c   | 14 ++++++--------
 drivers/scsi/ibmvscsi/ibmvscsi.c |  7 +++----
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b491af31a5f8..0d2f7eb3acb6 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1393,8 +1393,9 @@ static int ibmvfc_map_sg_data(struct scsi_cmnd *scmd,
  *
  * Called when an internally generated command times out
  **/
-static void ibmvfc_timeout(struct ibmvfc_event *evt)
+static void ibmvfc_timeout(struct timer_list *t)
 {
+	struct ibmvfc_event *evt = from_timer(evt, t, timer);
 	struct ibmvfc_host *vhost = evt->vhost;
 	dev_err(vhost->dev, "Command timed out (%p). Resetting connection\n", evt);
 	ibmvfc_reset_host(vhost);
@@ -1424,12 +1425,10 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 		BUG();
 
 	list_add_tail(&evt->queue, &vhost->sent);
-	init_timer(&evt->timer);
+	timer_setup(&evt->timer, ibmvfc_timeout, 0);
 
 	if (timeout) {
-		evt->timer.data = (unsigned long) evt;
 		evt->timer.expires = jiffies + (timeout * HZ);
-		evt->timer.function = (void (*)(unsigned long))ibmvfc_timeout;
 		add_timer(&evt->timer);
 	}
 
@@ -3692,8 +3691,9 @@ static void ibmvfc_tgt_adisc_cancel_done(struct ibmvfc_event *evt)
  * out, reset the CRQ. When the ADISC comes back as cancelled,
  * log back into the target.
  **/
-static void ibmvfc_adisc_timeout(struct ibmvfc_target *tgt)
+static void ibmvfc_adisc_timeout(struct timer_list *t)
 {
+	struct ibmvfc_target *tgt = from_timer(tgt, t, timer);
 	struct ibmvfc_host *vhost = tgt->vhost;
 	struct ibmvfc_event *evt;
 	struct ibmvfc_tmf *tmf;
@@ -3778,9 +3778,7 @@ static void ibmvfc_tgt_adisc(struct ibmvfc_target *tgt)
 	if (timer_pending(&tgt->timer))
 		mod_timer(&tgt->timer, jiffies + (IBMVFC_ADISC_TIMEOUT * HZ));
 	else {
-		tgt->timer.data = (unsigned long) tgt;
 		tgt->timer.expires = jiffies + (IBMVFC_ADISC_TIMEOUT * HZ);
-		tgt->timer.function = (void (*)(unsigned long))ibmvfc_adisc_timeout;
 		add_timer(&tgt->timer);
 	}
 
@@ -3912,7 +3910,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *vhost, u64 scsi_id)
 	tgt->vhost = vhost;
 	tgt->need_login = 1;
 	tgt->cancel_key = vhost->task_set++;
-	init_timer(&tgt->timer);
+	timer_setup(&tgt->timer, ibmvfc_adisc_timeout, 0);
 	kref_init(&tgt->kref);
 	ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
 	spin_lock_irqsave(vhost->host->host_lock, flags);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 7d156b161482..17df76f0be3c 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -837,8 +837,9 @@ static void ibmvscsi_reset_host(struct ibmvscsi_host_data *hostdata)
  *
  * Called when an internally generated command times out
 */
-static void ibmvscsi_timeout(struct srp_event_struct *evt_struct)
+static void ibmvscsi_timeout(struct timer_list *t)
 {
+	struct srp_event_struct *evt_struct = from_timer(evt_struct, t, timer);
 	struct ibmvscsi_host_data *hostdata = evt_struct->hostdata;
 
 	dev_err(hostdata->dev, "Command timed out (%x). Resetting connection\n",
@@ -927,11 +928,9 @@ static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
 	 */
 	list_add_tail(&evt_struct->list, &hostdata->sent);
 
-	init_timer(&evt_struct->timer);
+	timer_setup(&evt_struct->timer, ibmvscsi_timeout, 0);
 	if (timeout) {
-		evt_struct->timer.data = (unsigned long) evt_struct;
 		evt_struct->timer.expires = jiffies + (timeout * HZ);
-		evt_struct->timer.function = (void (*)(unsigned long))ibmvscsi_timeout;
 		add_timer(&evt_struct->timer);
 	}
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
