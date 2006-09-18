From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Switch some more scsi drivers to pci_get_device and refcounted pci structures
Date: Mon, 18 Sep 2006 20:01:55 +0100
Message-ID: <20060918190155.GE17670@infradead.org>
References: <1158330872.29932.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:21453 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751808AbWIRTCS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 15:02:18 -0400
Content-Disposition: inline
In-Reply-To: <1158330872.29932.61.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, Sep 15, 2006 at 03:34:32PM +0100, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c linux-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c
> --- linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c	2006-09-11 17:00:17.000000000 +0100
> +++ linux-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c	2006-09-14 16:50:25.000000000 +0100
> @@ -9194,7 +9194,7 @@
>      for (i = 0; i < ARRAY_SIZE(aic_pdevs); i++)
>      {
>        pdev = NULL;
> -      while ((pdev = pci_find_device(aic_pdevs[i].vendor_id,
> +      while ((pdev = pci_get_device(aic_pdevs[i].vendor_id,
>                                       aic_pdevs[i].device_id,

NACK.  This doesn't help us forward at all.  In case you have
the hardware please do a full conversion to the real pci probing API.

