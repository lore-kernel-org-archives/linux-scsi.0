From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6/7] ahci: Add functions to manage runtime PM of AHCI ports
Date: Thu, 18 Feb 2016 10:54:16 +0200
Message-ID: <1455785657-22924-7-git-send-email-mika.westerberg@linux.intel.com>
References: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add new functions ahci_rpm_get_port()/ahci_rpm_put_port() that change
runtime PM status of AHCI ports. Depending if the AHCI host has runtime PM
enabled or disabled calling these may trigger runtime suspend/resume of the
host controller.

We also call these functions in appropriate places to make sure host
controller registers are available before using them.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/ata/libahci.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 2ce4c638714e..a5dc80810a5e 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -224,6 +224,31 @@ static void ahci_enable_ahci(void __iomem *mmio)
 	WARN_ON(1);
 }
 
+/**
+ *	ahci_rpm_get_port - Make sure the port is powered on
+ *	@ap: Port to power on
+ *
+ *	Whenever there is need to access the AHCI host registers outside of
+ *	normal execution paths, call this function to make sure the host is
+ *	actually powered on.
+ */
+static int ahci_rpm_get_port(struct ata_port *ap)
+{
+	return pm_runtime_get_sync(ap->dev);
+}
+
+/**
+ *	ahci_rpm_put_port - Undoes ahci_rpm_get_port()
+ *	@ap: Port to power down
+ *
+ *	Undoes ahci_rpm_get_port() and possibly powers down the AHCI host
+ *	if it has no more active users.
+ */
+static void ahci_rpm_put_port(struct ata_port *ap)
+{
+	pm_runtime_put(ap->dev);
+}
+
 static ssize_t ahci_show_host_caps(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -260,8 +285,13 @@ static ssize_t ahci_show_port_cmd(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ata_port *ap = ata_shost_to_port(shost);
 	void __iomem *port_mmio = ahci_port_base(ap);
+	ssize_t ret;
 
-	return sprintf(buf, "%x\n", readl(port_mmio + PORT_CMD));
+	ahci_rpm_get_port(ap);
+	ret = sprintf(buf, "%x\n", readl(port_mmio + PORT_CMD));
+	ahci_rpm_put_port(ap);
+
+	return ret;
 }
 
 static ssize_t ahci_read_em_buffer(struct device *dev,
@@ -277,17 +307,20 @@ static ssize_t ahci_read_em_buffer(struct device *dev,
 	size_t count;
 	int i;
 
+	ahci_rpm_get_port(ap);
 	spin_lock_irqsave(ap->lock, flags);
 
 	em_ctl = readl(mmio + HOST_EM_CTL);
 	if (!(ap->flags & ATA_FLAG_EM) || em_ctl & EM_CTL_XMT ||
 	    !(hpriv->em_msg_type & EM_MSG_TYPE_SGPIO)) {
 		spin_unlock_irqrestore(ap->lock, flags);
+		ahci_rpm_put_port(ap);
 		return -EINVAL;
 	}
 
 	if (!(em_ctl & EM_CTL_MR)) {
 		spin_unlock_irqrestore(ap->lock, flags);
+		ahci_rpm_put_port(ap);
 		return -EAGAIN;
 	}
 
@@ -315,6 +348,7 @@ static ssize_t ahci_read_em_buffer(struct device *dev,
 	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
+	ahci_rpm_put_port(ap);
 
 	return i;
 }
@@ -339,11 +373,13 @@ static ssize_t ahci_store_em_buffer(struct device *dev,
 	    size % 4 || size > hpriv->em_buf_sz)
 		return -EINVAL;
 
+	ahci_rpm_get_port(ap);
 	spin_lock_irqsave(ap->lock, flags);
 
 	em_ctl = readl(mmio + HOST_EM_CTL);
 	if (em_ctl & EM_CTL_TM) {
 		spin_unlock_irqrestore(ap->lock, flags);
+		ahci_rpm_put_port(ap);
 		return -EBUSY;
 	}
 
@@ -356,6 +392,7 @@ static ssize_t ahci_store_em_buffer(struct device *dev,
 	writel(em_ctl | EM_CTL_TM, mmio + HOST_EM_CTL);
 
 	spin_unlock_irqrestore(ap->lock, flags);
+	ahci_rpm_put_port(ap);
 
 	return size;
 }
@@ -369,7 +406,9 @@ static ssize_t ahci_show_em_supported(struct device *dev,
 	void __iomem *mmio = hpriv->mmio;
 	u32 em_ctl;
 
+	ahci_rpm_get_port(ap);
 	em_ctl = readl(mmio + HOST_EM_CTL);
+	ahci_rpm_put_port(ap);
 
 	return sprintf(buf, "%s%s%s%s\n",
 		       em_ctl & EM_CTL_LED ? "led " : "",
@@ -1010,6 +1049,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 	else
 		return -EINVAL;
 
+	ahci_rpm_get_port(ap);
 	spin_lock_irqsave(ap->lock, flags);
 
 	/*
@@ -1019,6 +1059,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 	em_ctl = readl(mmio + HOST_EM_CTL);
 	if (em_ctl & EM_CTL_TM) {
 		spin_unlock_irqrestore(ap->lock, flags);
+		ahci_rpm_put_port(ap);
 		return -EBUSY;
 	}
 
@@ -1046,6 +1087,8 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 	emp->led_state = state;
 
 	spin_unlock_irqrestore(ap->lock, flags);
+	ahci_rpm_put_port(ap);
+
 	return size;
 }
 
@@ -2248,6 +2291,8 @@ static void ahci_pmp_detach(struct ata_port *ap)
 
 int ahci_port_resume(struct ata_port *ap)
 {
+	ahci_rpm_get_port(ap);
+
 	ahci_power_up(ap);
 	ahci_start_port(ap);
 
@@ -2274,6 +2319,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 		ata_port_freeze(ap);
 	}
 
+	ahci_rpm_put_port(ap);
 	return rc;
 }
 #endif
-- 
2.7.0
