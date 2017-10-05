From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: isci: Convert timers to use timer_setup()
Date: Wed, 4 Oct 2017 17:48:14 -0700
Message-ID: <20171005004814.GA22954@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:48134 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdJEAsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2017 20:48:17 -0400
Received: by mail-pf0-f182.google.com with SMTP id n24so7120216pfk.5
        for <linux-scsi@vger.kernel.org>; Wed, 04 Oct 2017 17:48:16 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/scsi/isci/host.c        | 12 ++++++------
 drivers/scsi/isci/isci.h        |  6 ++----
 drivers/scsi/isci/phy.c         |  4 ++--
 drivers/scsi/isci/port.c        |  4 ++--
 drivers/scsi/isci/port_config.c |  8 ++++----
 5 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 609dafd661d1..13b37cdffa8e 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -958,9 +958,9 @@ static enum sci_status sci_controller_start_next_phy(struct isci_host *ihost)
 	return status;
 }
 
-static void phy_startup_timeout(unsigned long data)
+static void phy_startup_timeout(struct timer_list *t)
 {
-	struct sci_timer *tmr = (struct sci_timer *)data;
+	struct sci_timer *tmr = from_timer(tmr, t, timer);
 	struct isci_host *ihost = container_of(tmr, typeof(*ihost), phy_timer);
 	unsigned long flags;
 	enum sci_status status;
@@ -1592,9 +1592,9 @@ static const struct sci_base_state sci_controller_state_table[] = {
 	[SCIC_FAILED] = {}
 };
 
-static void controller_timeout(unsigned long data)
+static void controller_timeout(struct timer_list *t)
 {
-	struct sci_timer *tmr = (struct sci_timer *)data;
+	struct sci_timer *tmr = from_timer(tmr, t, timer);
 	struct isci_host *ihost = container_of(tmr, typeof(*ihost), timer);
 	struct sci_base_state_machine *sm = &ihost->sm;
 	unsigned long flags;
@@ -1737,9 +1737,9 @@ static u8 max_spin_up(struct isci_host *ihost)
 			     MAX_CONCURRENT_DEVICE_SPIN_UP_COUNT);
 }
 
-static void power_control_timeout(unsigned long data)
+static void power_control_timeout(struct timer_list *t)
 {
-	struct sci_timer *tmr = (struct sci_timer *)data;
+	struct sci_timer *tmr = from_timer(tmr, t, timer);
 	struct isci_host *ihost = container_of(tmr, typeof(*ihost), power_control.timer);
 	struct isci_phy *iphy;
 	unsigned long flags;
diff --git a/drivers/scsi/isci/isci.h b/drivers/scsi/isci/isci.h
index 234ab46fce33..680e30947671 100644
--- a/drivers/scsi/isci/isci.h
+++ b/drivers/scsi/isci/isci.h
@@ -498,12 +498,10 @@ struct sci_timer {
 };
 
 static inline
-void sci_init_timer(struct sci_timer *tmr, void (*fn)(unsigned long))
+void sci_init_timer(struct sci_timer *tmr, void (*fn)(struct timer_list *t))
 {
-	tmr->timer.function = fn;
-	tmr->timer.data = (unsigned long) tmr;
 	tmr->cancel = 0;
-	init_timer(&tmr->timer);
+	timer_setup(&tmr->timer, fn, 0);
 }
 
 static inline void sci_mod_timer(struct sci_timer *tmr, unsigned long msec)
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index cb87b2ef7c92..1deca8c5a94f 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -315,9 +315,9 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	return SCI_SUCCESS;
 }
 
-static void phy_sata_timeout(unsigned long data)
+static void phy_sata_timeout(struct timer_list *t)
 {
-	struct sci_timer *tmr = (struct sci_timer *)data;
+	struct sci_timer *tmr = from_timer(tmr, t, timer);
 	struct isci_phy *iphy = container_of(tmr, typeof(*iphy), sata_timer);
 	struct isci_host *ihost = iphy->owning_port->owning_controller;
 	unsigned long flags;
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index a4dd5c91508c..1df45f028ea7 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -769,9 +769,9 @@ bool sci_port_link_detected(struct isci_port *iport, struct isci_phy *iphy)
 	return true;
 }
 
-static void port_timeout(unsigned long data)
+static void port_timeout(struct timer_list *t)
 {
-	struct sci_timer *tmr = (struct sci_timer *)data;
+	struct sci_timer *tmr = from_timer(tmr, t, timer);
 	struct isci_port *iport = container_of(tmr, typeof(*iport), timer);
 	struct isci_host *ihost = iport->owning_controller;
 	unsigned long flags;
diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index ac879745ef80..edb7be786c65 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -319,10 +319,10 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
 	return sci_port_configuration_agent_validate_ports(ihost, port_agent);
 }
 
-static void mpc_agent_timeout(unsigned long data)
+static void mpc_agent_timeout(struct timer_list *t)
 {
 	u8 index;
-	struct sci_timer *tmr = (struct sci_timer *)data;
+	struct sci_timer *tmr = from_timer(tmr, t, timer);
 	struct sci_port_configuration_agent *port_agent;
 	struct isci_host *ihost;
 	unsigned long flags;
@@ -654,10 +654,10 @@ static void sci_apc_agent_link_down(
 }
 
 /* configure the phys into ports when the timer fires */
-static void apc_agent_timeout(unsigned long data)
+static void apc_agent_timeout(struct timer_list *t)
 {
 	u32 index;
-	struct sci_timer *tmr = (struct sci_timer *)data;
+	struct sci_timer *tmr = from_timer(tmr, t, timer);
 	struct sci_port_configuration_agent *port_agent;
 	struct isci_host *ihost;
 	unsigned long flags;
-- 
2.7.4


-- 
Kees Cook
Pixel Security
