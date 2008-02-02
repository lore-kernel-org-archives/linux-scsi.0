From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Date: Sat, 02 Feb 2008 10:51:13 -0500
Message-ID: <47A49171.2000003@garzik.org>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43859 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303AbYBBPv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Feb 2008 10:51:26 -0500
In-Reply-To: <20080202111322.GA30767@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, pcihpd-discuss@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>

Ingo Molnar wrote:
> ===================================================================
> --- linux.orig/drivers/scsi/lpfc/lpfc_init.c
> +++ linux/drivers/scsi/lpfc/lpfc_init.c
> @@ -1894,7 +1894,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
>  	uint16_t iotag;
>  	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
>  
> -	if (pci_enable_device_bars(pdev, bars))
> +	if (pci_enable_device_io(pdev))
>  		goto out;

Look at the line right above it...  AFAICS you want 
pci_enable_device_mem(), if the mask is selecting IORESOURCE_MEM BARs.

Also a CC to linux-scsi and the driver author would be nice, as they are 
the ones with hardware and can verify.

This set of changes seemed like 50% guesswork to me, without consulting 
the authors :(  And unlike many changes, you actually have to know the 
hardware [or get clues from surrounding code] to make the change.

	Jeff



