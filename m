From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [SCSI]: ARM: remove deprecated IRQF_DISABLED
Date: Sun,  6 Oct 2013 07:58:56 +0200
Message-ID: <1381039136-11749-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:51124 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256Ab3JFF7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Oct 2013 01:59:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@arm.linux.org.uk, JBottomley@parallels.com
Cc: linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/arm/acornscsi.c | 2 +-
 drivers/scsi/arm/cumana_1.c  | 2 +-
 drivers/scsi/arm/cumana_2.c  | 2 +-
 drivers/scsi/arm/powertec.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 09ba186..059ff47 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2971,7 +2971,7 @@ static int acornscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 	ec->irqaddr	= ashost->fast + INT_REG;
 	ec->irqmask	= 0x0a;
 
-	ret = request_irq(host->irq, acornscsi_intr, IRQF_DISABLED, "acornscsi", ashost);
+	ret = request_irq(host->irq, acornscsi_intr, 0, "acornscsi", ashost);
 	if (ret) {
 		printk(KERN_CRIT "scsi%d: IRQ%d not free: %d\n",
 			host->host_no, ashost->scsi.irq, ret);
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index b679778..f8e0609 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -262,7 +262,7 @@ static int cumanascsi1_probe(struct expansion_card *ec,
 		goto out_unmap;
 	}
 
-	ret = request_irq(host->irq, cumanascsi_intr, IRQF_DISABLED,
+	ret = request_irq(host->irq, cumanascsi_intr, 0,
 			  "CumanaSCSI-1", host);
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 58915f2..abc66f5 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -431,7 +431,7 @@ static int cumanascsi2_probe(struct expansion_card *ec,
 		goto out_free;
 
 	ret = request_irq(ec->irq, cumanascsi_2_intr,
-			  IRQF_DISABLED, "cumanascsi2", info);
+			  0, "cumanascsi2", info);
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
 		       host->host_no, ec->irq, ret);
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index abc9593..5e1b73e 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -358,7 +358,7 @@ static int powertecscsi_probe(struct expansion_card *ec,
 		goto out_free;
 
 	ret = request_irq(ec->irq, powertecscsi_intr,
-			  IRQF_DISABLED, "powertec", info);
+			  0, "powertec", info);
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
 		       host->host_no, ec->irq, ret);
-- 
1.8.1.2

