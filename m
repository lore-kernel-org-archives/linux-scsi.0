From: Loc Ho <lho@apm.com>
Subject: [PATCH v2 1/5] ata: Export AHCI library functions required by APM X-Gene SATA driver
Date: Sat,  9 Nov 2013 00:00:27 -0700
Message-ID: <1383980431-6572-2-git-send-email-lho@apm.com>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:34569 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758673Ab3KIHAp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 02:00:45 -0500
Received: by mail-pb0-f44.google.com with SMTP id rp16so3062430pbb.17
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2013 23:00:44 -0800 (PST)
In-Reply-To: <1383980431-6572-1-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

ata: Export required functions by APM X-Gene SATA driver to avoid duplicate code.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci.h    |    6 ++++++
 drivers/ata/libahci.c |   13 ++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 1145637..cf881e0 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -368,6 +368,12 @@ irqreturn_t ahci_hw_interrupt(int irq, void *dev_instance);
 irqreturn_t ahci_thread_fn(int irq, void *dev_instance);
 void ahci_print_info(struct ata_host *host, const char *scc_s);
 int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis);
+void ahci_sw_activity(struct ata_link *link);
+int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
+void ahci_error_intr(struct ata_port *ap, u32 irq_stat);
+int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
+				struct ata_taskfile *tf, int is_cmd, u16 flags,
+				unsigned long timeout_msec);
 
 static inline void __iomem *__ahci_port_base(struct ata_host *host,
 					     unsigned int port_no)
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index aaac4fb..de7e074 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -68,7 +68,6 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 
 
 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
-static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
@@ -553,7 +552,7 @@ static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val)
 	return -EINVAL;
 }
 
-static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
+int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 {
 	void __iomem *port_mmio = ahci_port_base(link->ap);
 	int offset = ahci_scr_offset(link->ap, sc_reg);
@@ -564,6 +563,7 @@ static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(ahci_scr_write);
 
 void ahci_start_engine(struct ata_port *ap)
 {
@@ -869,7 +869,7 @@ int ahci_reset_controller(struct ata_host *host)
 }
 EXPORT_SYMBOL_GPL(ahci_reset_controller);
 
-static void ahci_sw_activity(struct ata_link *link)
+void ahci_sw_activity(struct ata_link *link)
 {
 	struct ata_port *ap = link->ap;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -882,6 +882,7 @@ static void ahci_sw_activity(struct ata_link *link)
 	if (!timer_pending(&emp->timer))
 		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
 }
+EXPORT_SYMBOL_GPL(ahci_sw_activity);
 
 static void ahci_sw_activity_blink(unsigned long arg)
 {
@@ -1239,7 +1240,7 @@ int ahci_kick_engine(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ahci_kick_engine);
 
-static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
+int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
 				struct ata_taskfile *tf, int is_cmd, u16 flags,
 				unsigned long timeout_msec)
 {
@@ -1268,6 +1269,7 @@ static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_exec_polled_cmd);
 
 int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 		      int pmp, unsigned long deadline,
@@ -1552,7 +1554,7 @@ static void ahci_fbs_dec_intr(struct ata_port *ap)
 		dev_err(ap->host->dev, "failed to clear device error\n");
 }
 
-static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
+void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 {
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -1662,6 +1664,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	} else
 		ata_port_abort(ap);
 }
+EXPORT_SYMBOL_GPL(ahci_error_intr);
 
 static void ahci_handle_port_interrupt(struct ata_port *ap,
 				       void __iomem *port_mmio, u32 status)
-- 
1.5.5

