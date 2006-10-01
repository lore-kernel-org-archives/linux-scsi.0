From: Frederik Deweerdt <deweerdt@free.fr>
Subject: Re: [-mm patch] aic7xxx: check irq validity (was Re: 2.6.18-mm2)
Date: Sun, 1 Oct 2006 21:31:47 +0000
Message-ID: <20061001213147.GA2900@slug>
References: <20060928014623.ccc9b885.akpm@osdl.org> <20060929155738.7076f0c8@werewolf> <20060929143949.GL5017@parisc-linux.org> <1159550143.13029.36.camel@localhost.localdomain> <20060929235054.GB2020@slug> <1159573404.13029.96.camel@localhost.localdomain> <20060930140946.GA1195@slug> <451F049A.1010404@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:57945 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S932237AbWJATdL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 15:33:11 -0400
Received: by ug-out-1314.google.com with SMTP id o38so443309ugd
        for <linux-scsi@vger.kernel.org>; Sun, 01 Oct 2006 12:33:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <451F049A.1010404@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Wilcox <matthew@wil.cx>, "J.A. Magall??n" <jamagallon@ono.com>, "Linux-Kernel," <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sat, Sep 30, 2006 at 07:58:18PM -0400, Jeff Garzik wrote:
> Frederik Deweerdt wrote:
> >On Sat, Sep 30, 2006 at 12:43:24AM +0100, Alan Cox wrote:
> >>Ar Gwe, 2006-09-29 am 23:50 +0000, ysgrifennodd Frederik Deweerdt:
> >>>Does this patch makes sense in that case? If yes, I'll put up a patch
> >>>for the remaining cases in the drivers/scsi/aic7xxx/ directory.
> >>>Also, aic7xxx's coding style would put parenthesis around the returned
> >>>value, should I follow it?
> >>Yes - but perhaps with a warning message so users know why ?
> >>
> >>As to coding style - kernel style is unbracketed so I wouldnt worry
> >>about either.
> >>
> >Thanks for the advices. The following patch checks whenever the irq is valid before issuing a
> >request_irq() for AIC7XXX and AIC79XX. An error message is displayed to
> >let the user know what went wrong.
> >Regards,
> >Frederik
> >Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> 
> Actually, rather than adding this check to every driver, I would rather do something like the attached patch:  create a 
> pci_request_irq(), and pass a struct pci_device to it.  Then the driver author doesn't have to worry about such details.
> 
That's better, indeed. 
[...]
> +#ifndef ARCH_VALIDATE_PCI_IRQ
> +int pci_valid_irq(struct pci_dev *pdev)
> +{
> +	if (pdev->irq == 0)
> +		return -EINVAL;
                        ^^^^^^
Woulnd't this rather be ENODEV? Admitedly, from pci_valid_irq() (or
is_irq_valid()) point of view, it _has_ been passed an invalid value. But
from userspace's point of view, it's like the device was not present.

Regards,
Frederik
