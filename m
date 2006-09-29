From: Frederik Deweerdt <deweerdt@free.fr>
Subject: Re: 2.6.18-mm2
Date: Fri, 29 Sep 2006 23:50:54 +0000
Message-ID: <20060929235054.GB2020@slug>
References: <20060928014623.ccc9b885.akpm@osdl.org> <20060929155738.7076f0c8@werewolf> <20060929143949.GL5017@parisc-linux.org> <1159550143.13029.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:19929 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S1422848AbWI2VwP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Sep 2006 17:52:15 -0400
Received: by ug-out-1314.google.com with SMTP id o38so319935ugd
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2006 14:52:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1159550143.13029.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, "J.A. Magall??n" <jamagallon@ono.com>, Andrew Morton <akpm@osdl.org>, "Linux-Kernel," <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Fri, Sep 29, 2006 at 06:15:42PM +0100, Alan Cox wrote:
> Ar Gwe, 2006-09-29 am 08:39 -0600, ysgrifennodd Matthew Wilcox:
> > On Fri, Sep 29, 2006 at 03:57:38PM +0200, J.A. Magall??n wrote:
> > > aic7xxx oopses on boot:
> > > 
> > > PCI: Setting latency timer of device 0000:00:0e.0 to 64
> > > IRQ handler type mismatch for IRQ 0
> > 
> > Of course, this isn't a scsi problem, it's a peecee hardware problem.
> > Or maybe a PCI subsystem problem.  But it's clearly not aic7xxx's fault.
> 
> AIC7xxx finding it has no IRQ configured is valid (annoying, stupid and
> valid) so the driver should check before requesting "no IRQ"
> 
Alan,

Does this patch makes sense in that case? If yes, I'll put up a patch
for the remaining cases in the drivers/scsi/aic7xxx/ directory.
Also, aic7xxx's coding style would put parenthesis around the returned
value, should I follow it?

Regards,
Frederik

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index ea5687d..38f5ca7 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -185,6 +185,9 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 	int		 error;
 	struct device	*dev = &pdev->dev;
 
+	if (!pdev->irq)
+		return -ENODEV;
+
 	pci = pdev;
 	entry = ahc_find_pci_device(pci);
 	if (entry == NULL)
