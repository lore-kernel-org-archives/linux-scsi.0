From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [Patch] Fix Suspend I/O block/unblock patch
Date: 16 Oct 2004 18:13:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097968435.2283.341.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C08670E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:25050 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268957AbUJPXN6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Oct 2004 19:13:58 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C08670E@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-10-16 at 16:59, James.Smart@Emulex.Com wrote:
> > Could you give an example of this problem?  If there's a demonstrable
> > issue with device_for_each_child(), we can probably persuade Greg to
> > alter it.
> 
> Here's the stack trace that was giving us headaches...
> 
> Oct 11 10:04:37 daffy kernel: Debug: sleeping function called from invalid context at include/linux/rwsem.h:43
> Oct 11 10:04:37 daffy kernel: in_atomic():1, irqs_disabled():0

Yes, call from our own timer.  I was slightly worried about the amount
of work the list might have to do in the timer.  This provides another
excuse to move it to a workqueue.

How does the attached fare in this situation (it compiles but I have no
ability to test it)?

James

===== drivers/scsi/scsi_transport_fc.c 1.6 vs edited =====
--- 1.6/drivers/scsi/scsi_transport_fc.c	2004-10-11 10:03:45 -05:00
+++ edited/drivers/scsi/scsi_transport_fc.c	2004-10-16 18:03:28 -05:00
@@ -29,6 +29,8 @@
 
 static void transport_class_release(struct class_device *class_dev);
 static void host_class_release(struct class_device *class_dev);
+static void fc_timeout_blocked_host(void *data);
+static void fc_timeout_blocked_tgt(void *data);
 
 #define FC_STARGET_NUM_ATTRS 	4	/* increase this if you add attributes */
 #define FC_STARGET_OTHER_ATTRS 	0	/* increase this if you add "always on"
@@ -87,7 +89,8 @@
 	fc_starget_port_name(starget) = -1;
 	fc_starget_port_id(starget) = -1;
 	fc_starget_dev_loss_tmo(starget) = -1;
-	init_timer(&fc_starget_dev_loss_timer(starget));
+	INIT_WORK(&fc_starget_dev_loss_work(starget),
+		  fc_timeout_blocked_tgt, starget);
 	return 0;
 }
 
@@ -99,7 +102,8 @@
 	 * all transport attributes to valid values per host.
 	 */
 	fc_host_link_down_tmo(shost) = -1;
-	init_timer(&fc_host_link_down_timer(shost));
+	INIT_WORK(&fc_host_link_down_work(shost),
+		  fc_timeout_blocked_host, shost);
 	return 0;
 }
 
@@ -353,7 +357,7 @@
  *			 that fail to recover in the alloted time.
  * @data:	scsi target that failed to reappear in the alloted time.
  **/
-static void fc_timeout_blocked_tgt(unsigned long data)
+static void fc_timeout_blocked_tgt(void  *data)
 {
 	struct scsi_target *starget = (struct scsi_target *)data;
 
@@ -388,7 +392,7 @@
 fc_target_block(struct scsi_target *starget)
 {
 	int timeout = fc_starget_dev_loss_tmo(starget);
-	struct timer_list *timer = &fc_starget_dev_loss_timer(starget);
+	struct work_struct *work = &fc_starget_dev_loss_work(starget);
 
 	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
 		return -EINVAL;
@@ -396,10 +400,7 @@
 	device_for_each_child(&starget->dev, NULL, fc_device_block);
 
 	/* The scsi lld blocks this target for the timeout period only. */
-	timer->data = (unsigned long)starget;
-	timer->expires = jiffies + timeout * HZ;
-	timer->function = fc_timeout_blocked_tgt;
-	add_timer(timer);
+	schedule_delayed_work(work, timeout * HZ);
 
 	return 0;
 }
@@ -424,7 +425,7 @@
 	 * failure as the state machine state change will validate the
 	 * transaction. 
 	 */
-	del_timer_sync(&fc_starget_dev_loss_timer(starget));
+	del_timer_sync(&fc_starget_dev_loss_work(starget).timer);
 
 	device_for_each_child(&starget->dev, NULL, fc_device_unblock);
 }
@@ -436,7 +437,7 @@
  * @data:	scsi host that failed to recover its devices in the alloted
  *		time.
  **/
-static void fc_timeout_blocked_host(unsigned long data)
+static void fc_timeout_blocked_host(void  *data)
 {
 	struct Scsi_Host *shost = (struct Scsi_Host *)data;
 	struct scsi_device *sdev;
@@ -475,7 +476,7 @@
 {
 	struct scsi_device *sdev;
 	int timeout = fc_host_link_down_tmo(shost);
-	struct timer_list *timer = &fc_host_link_down_timer(shost);
+	struct work_struct *work = &fc_host_link_down_work(shost);
 
 	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
 		return -EINVAL;
@@ -484,11 +485,7 @@
 		scsi_internal_device_block(sdev);
 	}
 
-	/* The scsi lld blocks this host for the timeout period only. */
-	timer->data = (unsigned long)shost;
-	timer->expires = jiffies + timeout * HZ;
-	timer->function = fc_timeout_blocked_host;
-	add_timer(timer);
+	schedule_delayed_work(work, timeout * HZ);
 
 	return 0;
 }
@@ -516,7 +513,7 @@
 	 * failure as the state machine state change will validate the
 	 * transaction.
 	 */
-	del_timer_sync(&fc_host_link_down_timer(shost));
+	del_timer_sync(&fc_host_link_down_work(shost).timer);
 	shost_for_each_device(sdev, shost) {
 		scsi_internal_device_unblock(sdev);
 	}
===== include/scsi/scsi_transport_fc.h 1.5 vs edited =====
--- 1.5/include/scsi/scsi_transport_fc.h	2004-10-11 10:03:45 -05:00
+++ edited/include/scsi/scsi_transport_fc.h	2004-10-16 17:49:20 -05:00
@@ -29,7 +29,7 @@
 	uint64_t node_name;
 	uint64_t port_name;
 	uint32_t dev_loss_tmo;	/* Remote Port loss timeout in seconds. */
-	struct timer_list dev_loss_timer;
+	struct work_struct dev_loss_work;
 };
 
 #define fc_starget_port_id(x) \
@@ -40,18 +40,18 @@
 	(((struct fc_starget_attrs *)&(x)->starget_data)->port_name)
 #define fc_starget_dev_loss_tmo(x) \
 	(((struct fc_starget_attrs *)&(x)->starget_data)->dev_loss_tmo)
-#define fc_starget_dev_loss_timer(x) \
-	(((struct fc_starget_attrs *)&(x)->starget_data)->dev_loss_timer)
+#define fc_starget_dev_loss_work(x) \
+	(((struct fc_starget_attrs *)&(x)->starget_data)->dev_loss_work)
 
 struct fc_host_attrs {
 	uint32_t link_down_tmo;	/* Link Down timeout in seconds. */
-	struct timer_list link_down_timer;
+	struct work_struct link_down_work;
 };
 
 #define fc_host_link_down_tmo(x) \
 	(((struct fc_host_attrs *)(x)->shost_data)->link_down_tmo)
-#define fc_host_link_down_timer(x) \
-	(((struct fc_host_attrs *)(x)->shost_data)->link_down_timer)
+#define fc_host_link_down_work(x) \
+	(((struct fc_host_attrs *)(x)->shost_data)->link_down_work)
 

 /* The functions by which the transport class and the driver communicate */

