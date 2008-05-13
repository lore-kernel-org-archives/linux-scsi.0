From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.26-rc2
Date: Tue, 13 May 2008 12:20:09 -0500
Message-ID: <1210699209.3077.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33684 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbYEMRUN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2008 13:20:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Just a small set of clear bug fixes (OK all but two of them are 2.6.25
regressions as well).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short change log is:

James Bottomley (4):
      aha152x: Fix oops on module removal
      aha152x: fix init suspiciously returned 1, it should follow 0/-E conventio
      gdth: fix Error: Driver 'gdth' is already registered, aborting...
      gdth: fix timer handling

Jeremy Higdon (1):
      qla1280: Fix queue depth problem

Mike Christie (2):
      libiscsi regression in 2.6.25: fix setting of recv timer
      libiscsi regression in 2.6.25: fix nop timer handling


The diffstat is:

 aha152x.c  |    8 ++++----
 gdth.c     |   51 ++++++++++++++++++++++++++++++++++-----------------
 libiscsi.c |   29 +++++++++++++++--------------
 qla1280.c  |    4 ++--
 4 files changed, 55 insertions(+), 37 deletions(-)

And the actual diff below.

James

---

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f5215fd..1dca177 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3830,7 +3830,7 @@ static int __init aha152x_init(void)
 			iounmap(p);
 		}
 		if (!ok && setup_count == 0)
-			return 0;
+			return -ENODEV;
 
 		printk(KERN_INFO "aha152x: BIOS test: passed, ");
 #else
@@ -3909,14 +3909,14 @@ static int __init aha152x_init(void)
 #endif
 	}
 
-	return 1;
+	return 0;
 }
 
 static void __exit aha152x_exit(void)
 {
-	struct aha152x_hostdata *hd;
+	struct aha152x_hostdata *hd, *tmp;
 
-	list_for_each_entry(hd, &aha152x_host_list, host_list) {
+	list_for_each_entry_safe(hd, tmp, &aha152x_host_list, host_list) {
 		struct Scsi_Host *shost = container_of((void *)hd, struct Scsi_Host, hostdata);
 
 		aha152x_release(shost);
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 8e2e964..46771d4 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -550,7 +550,6 @@ static int __init gdth_search_isa(ulong32 bios_adr)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_PCI
-static bool gdth_pci_registered;
 
 static bool gdth_search_vortex(ushort device)
 {
@@ -3724,6 +3723,8 @@ static void gdth_log_event(gdth_evt_data *dvr, char *buffer)
 }
 
 #ifdef GDTH_STATISTICS
+static unchar	gdth_timer_running;
+
 static void gdth_timeout(ulong data)
 {
     ulong32 i;
@@ -3731,7 +3732,10 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
-    BUG_ON(list_empty(&gdth_instances));
+    if(unlikely(list_empty(&gdth_instances))) {
+	    gdth_timer_running = 0;
+	    return;
+    }
 
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -3751,6 +3755,22 @@ static void gdth_timeout(ulong data)
     add_timer(&gdth_timer);
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
+
+static void gdth_timer_init(void)
+{
+	if (gdth_timer_running)
+		return;
+	gdth_timer_running = 1;
+	TRACE2(("gdth_detect(): Initializing timer !\n"));
+	gdth_timer.expires = jiffies + HZ;
+	gdth_timer.data = 0L;
+	gdth_timer.function = gdth_timeout;
+	add_timer(&gdth_timer);
+}
+#else
+static inline void gdth_timer_init(void)
+{
+}
 #endif
 
 static void __init internal_setup(char *str,int *ints)
@@ -4735,6 +4755,7 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+	gdth_timer_init();
 
 	scsi_scan_host(shp);
 
@@ -4865,6 +4886,7 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+	gdth_timer_init();
 
 	scsi_scan_host(shp);
 
@@ -5011,6 +5033,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 	list_add_tail(&ha->list, &gdth_instances);
 
 	pci_set_drvdata(ha->pdev, ha);
+	gdth_timer_init();
 
 	scsi_scan_host(shp);
 
@@ -5110,6 +5133,7 @@ static int __init gdth_init(void)
 	/* initializations */
 	gdth_polling = TRUE;
 	gdth_clear_events();
+	init_timer(&gdth_timer);
 
 	/* As default we do not probe for EISA or ISA controllers */
 	if (probe_eisa_isa) {
@@ -5132,23 +5156,17 @@ static int __init gdth_init(void)
 
 #ifdef CONFIG_PCI
 	/* scanning for PCI controllers */
-	if (pci_register_driver(&gdth_pci_driver) == 0)
-		gdth_pci_registered = true;
+	if (pci_register_driver(&gdth_pci_driver)) {
+		gdth_ha_str *ha;
+
+		list_for_each_entry(ha, &gdth_instances, list)
+			gdth_remove_one(ha);
+		return -ENODEV;
+	}
 #endif /* CONFIG_PCI */
 
 	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
 
-	if (list_empty(&gdth_instances))
-		return -ENODEV;
-
-#ifdef GDTH_STATISTICS
-	TRACE2(("gdth_detect(): Initializing timer !\n"));
-	init_timer(&gdth_timer);
-	gdth_timer.expires = jiffies + HZ;
-	gdth_timer.data = 0L;
-	gdth_timer.function = gdth_timeout;
-	add_timer(&gdth_timer);
-#endif
 	major = register_chrdev(0,"gdth", &gdth_fops);
 	register_reboot_notifier(&gdth_notifier);
 	gdth_polling = FALSE;
@@ -5167,8 +5185,7 @@ static void __exit gdth_exit(void)
 #endif
 
 #ifdef CONFIG_PCI
-	if (gdth_pci_registered)
-		pci_unregister_driver(&gdth_pci_driver);
+	pci_unregister_driver(&gdth_pci_driver);
 #endif
 
 	list_for_each_entry(ha, &gdth_instances, list)
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 010c1b9..b43bf1d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -730,7 +730,9 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 				if (iscsi_recv_pdu(conn->cls_conn, hdr, data,
 						   datalen))
 					rc = ISCSI_ERR_CONN_FAILED;
-			}
+			} else
+				mod_timer(&conn->transport_timer,
+					  jiffies + conn->recv_timeout);
 			iscsi_free_mgmt_task(conn, mtask);
 			break;
 		default:
@@ -1453,19 +1455,20 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 {
 	struct iscsi_conn *conn = (struct iscsi_conn *)data;
 	struct iscsi_session *session = conn->session;
-	unsigned long timeout, next_timeout = 0, last_recv;
+	unsigned long recv_timeout, next_timeout = 0, last_recv;
 
 	spin_lock(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN)
 		goto done;
 
-	timeout = conn->recv_timeout;
-	if (!timeout)
+	recv_timeout = conn->recv_timeout;
+	if (!recv_timeout)
 		goto done;
 
-	timeout *= HZ;
+	recv_timeout *= HZ;
 	last_recv = conn->last_recv;
-	if (time_before_eq(last_recv + timeout + (conn->ping_timeout * HZ),
+	if (conn->ping_mtask &&
+	    time_before_eq(conn->last_ping + (conn->ping_timeout * HZ),
 			   jiffies)) {
 		iscsi_conn_printk(KERN_ERR, conn, "ping timeout of %d secs "
 				  "expired, last rx %lu, last ping %lu, "
@@ -1476,15 +1479,13 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 		return;
 	}
 
-	if (time_before_eq(last_recv + timeout, jiffies)) {
-		if (time_before_eq(conn->last_ping, last_recv)) {
-			/* send a ping to try to provoke some traffic */
-			debug_scsi("Sending nopout as ping on conn %p\n", conn);
-			iscsi_send_nopout(conn, NULL);
-		}
-		next_timeout = last_recv + timeout + (conn->ping_timeout * HZ);
+	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
+		/* send a ping to try to provoke some traffic */
+		debug_scsi("Sending nopout as ping on conn %p\n", conn);
+		iscsi_send_nopout(conn, NULL);
+		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
 	} else
-		next_timeout = last_recv + timeout;
+		next_timeout = last_recv + recv_timeout;
 
 	debug_scsi("Setting next tmo %lu\n", next_timeout);
 	mod_timer(&conn->transport_timer, next_timeout);
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index fa06093..51e2f29 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2007,7 +2007,7 @@ qla1280_set_defaults(struct scsi_qla_host *ha)
 		nv->bus[bus].config_2.req_ack_active_negation = 1;
 		nv->bus[bus].config_2.data_line_active_negation = 1;
 		nv->bus[bus].selection_timeout = 250;
-		nv->bus[bus].max_queue_depth = 256;
+		nv->bus[bus].max_queue_depth = 32;
 
 		if (IS_ISP1040(ha)) {
 			nv->bus[bus].bus_reset_delay = 3;
@@ -2051,7 +2051,7 @@ qla1280_config_target(struct scsi_qla_host *ha, int bus, int target)
 	status = qla1280_mailbox_command(ha, 0x0f, mb);
 
 	/* Save Tag queuing enable flag. */
-	flag = (BIT_0 << target) & mb[0];
+	flag = (BIT_0 << target);
 	if (nv->bus[bus].target[target].parameter.tag_queuing)
 		ha->bus_settings[bus].qtag_enables |= flag;
 


