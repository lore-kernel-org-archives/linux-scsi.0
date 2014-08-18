From: jgross@suse.com
Subject: [PATCH V5 1/5] xen/events: support threaded irqs for interdomain event channels
Date: Mon, 18 Aug 2014 11:31:46 +0200
Message-ID: <1408354310-6362-2-git-send-email-jgross@suse.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1408354310-6362-1-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com, nab@linux-iscsi.org
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-scsi@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Export bind_interdomain_evtchn_to_irq() so drivers can use threaded
interrupt handlers with:

 irq = bind_interdomain_evtchn_to_irq(remote_dom, remote_port);
 if (irq < 0)
     /* error */
 ret = request_threaded_irq(...);

Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/xen/events/events_base.c | 5 +++--
 include/xen/events.h             | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 5b5c5ff..b4bca2d 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -900,8 +900,8 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 	return irq;
 }
 
-static int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
-					  unsigned int remote_port)
+int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
+				   unsigned int remote_port)
 {
 	struct evtchn_bind_interdomain bind_interdomain;
 	int err;
@@ -914,6 +914,7 @@ static int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
 
 	return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
 }
+EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irq);
 
 static int find_virq(unsigned int virq, unsigned int cpu)
 {
diff --git a/include/xen/events.h b/include/xen/events.h
index 8bee7a7..5321cd9 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -28,6 +28,8 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 			   unsigned long irqflags,
 			   const char *devname,
 			   void *dev_id);
+int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
+				   unsigned int remote_port);
 int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
 					  unsigned int remote_port,
 					  irq_handler_t handler,
-- 
1.8.4.5
