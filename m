From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC][PATCH] move dma_mask into struct device
Date: Fri, 15 Nov 2002 16:19:14 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021116001914.GA3153@beaverton.ibm.com>
References: <200211152034.gAFKYC404219@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211152034.gAFKYC404219@localhost.localdomain>
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, grundler@dsl2.external.hp.com, willy@debian.org
List-Id: linux-scsi@vger.kernel.org

J.E.J. Bottomley [James.Bottomley@steeleye.com] wrote:

> ===== drivers/pci/probe.c 1.17 vs edited =====
> --- 1.17/drivers/pci/probe.c	Fri Nov  1 12:33:02 2002
> +++ edited/drivers/pci/probe.c	Fri Nov 15 14:00:46 2002
> @@ -449,6 +449,7 @@
>  	/* now put in global tree */
>  	strcpy(dev->dev.name,dev->name);
>  	strcpy(dev->dev.bus_id,dev->slot_name);
> +	dev->dev->dma_mask = &dev->dma_mask;

I got a compile error here. This should be.
	dev->dev.dma_mask = &dev->dma_mask;

I did not have a current bk handy on the lab machine, but I ran it on
a 2.5.47 view with a few offset warnings.

The machine is a 2x pci systems with the following drivers loaded:
	aic7xxx, ips, qlogicisp.

It just booted and ran a little IO.

-andmike
--
Michael Anderson
andmike@us.ibm.com
