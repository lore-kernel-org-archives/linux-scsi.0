From: Suman Tripathi <stripathi@apm.com>
Subject: ahci Port to Host interrupt as edge trigger
Date: Fri, 17 Apr 2015 16:22:17 +0530
Message-ID: <CAOHikRCrbKhchHM71KPUUxSw7107ZWpBCbmTHsSSqSbUdCLJyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og123.obsmtp.com ([64.18.0.198]:58882 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932296AbbDQKwT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 06:52:19 -0400
Received: by widdi4 with SMTP id di4so17140502wid.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2015 03:52:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Loc Ho <lho@apm.com>

Hi ,

I need some suggestion .

>From the below interrupt handler in libahci.c it explains that the
interrupt from port to Host is level  triggered. Do we have any
existing implementation that handles the port to Host as Edge
triggered.

static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
{
struct ata_host *host = dev_instance;
struct ahci_host_priv *hpriv;
unsigned int i, handled = 0;
void __iomem *mmio;
u32 irq_stat, irq_masked;

VPRINTK("ENTER\n");

hpriv = host->private_data;
mmio = hpriv->mmio;

/* sigh.  0xffffffff is a valid return from h/w */
irq_stat = readl(mmio + HOST_IRQ_STAT);
if (!irq_stat)
return IRQ_NONE;

irq_masked = irq_stat & hpriv->port_map;

spin_lock(&host->lock);

for (i = 0; i < host->n_ports; i++) {
struct ata_port *ap;

if (!(irq_masked & (1 << i)))
continue;

ap = host->ports[i];
if (ap) {
ahci_port_intr(ap);
VPRINTK("port %u\n", i);
} else {
VPRINTK("port %u (no irq)\n", i);
if (ata_ratelimit())
dev_warn(host->dev,
"interrupt on disabled port %u\n", i);
}

handled = 1;
}

/* HOST_IRQ_STAT behaves as level triggered latch meaning that
* it should be cleared after all the port events are cleared;
* otherwise, it will raise a spurious interrupt after each
* valid one.  Please read section 10.6.2 of ahci 1.1 for more
* information.
*
* Also, use the unmasked value to clear interrupt as spurious
* pending event on a dummy port might cause screaming IRQ.
*/
writel(irq_stat, mmio + HOST_IRQ_STAT);

spin_unlock(&host->lock);

VPRINTK("EXIT\n");

return IRQ_RETVAL(handled);
}


-- 
Thanks,
with regards,
Suman Tripathi
