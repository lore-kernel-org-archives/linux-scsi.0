From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] cciss 2.6: pci domain info
Date: Fri, 17 Jun 2005 20:34:47 +0100
Message-ID: <20050617193447.GA22036@infradead.org>
References: <20050617183124.GA9913@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60071 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262071AbVFQTey (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 15:34:54 -0400
Content-Disposition: inline
In-Reply-To: <20050617183124.GA9913@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 17, 2005 at 01:31:24PM -0500, mike.miller@hp.com wrote:
> This patch adds pci domain info to our CCISS_GETPCIINFO ioctl. This is to support the next generation of Itanium platforms. We had a couple of spare bytes in the structure. Impact to existing apps should be minimal. Please consider this patch for inclusion.

I don't think an unsigned int fits into padding of any platform.

> Signed-off-by: Mike Miller <mike.miller@hp.com>
> 
>  drivers/block/cciss.c       |    1 +
>  include/linux/cciss_ioctl.h |    1 +
>  2 files changed, 2 insertions(+)
> --------------------------------------------------------------------------------
> diff -burNp lx2612-rc6.orig/drivers/block/cciss.c lx2612-rc6/drivers/block/cciss.c
> --- lx2612-rc6.orig/drivers/block/cciss.c	2005-06-14 12:04:34.000000000 -0500
> +++ lx2612-rc6/drivers/block/cciss.c	2005-06-17 13:04:52.384575144 -0500
> @@ -636,6 +636,7 @@ static int cciss_ioctl(struct inode *ino
>  		cciss_pci_info_struct pciinfo;
>  
>  		if (!arg) return -EINVAL;
> +		pciinfo.domain = pci_domain_nr(host->pdev->bus);
>  		pciinfo.bus = host->pdev->bus->number;
>  		pciinfo.dev_fn = host->pdev->devfn;
>  		pciinfo.board_id = host->board_id;
> diff -burNp lx2612-rc6.orig/include/linux/cciss_ioctl.h lx2612-rc6/include/linux/cciss_ioctl.h
> --- lx2612-rc6.orig/include/linux/cciss_ioctl.h	2005-03-02 01:38:07.000000000 -0600
> +++ lx2612-rc6/include/linux/cciss_ioctl.h	2005-06-17 13:06:42.082898464 -0500
> @@ -9,6 +9,7 @@
>  
>  typedef struct _cciss_pci_info_struct
>  {
> +	unsigned int	domain;
>  	unsigned char 	bus;
>  	unsigned char 	dev_fn;
>  	__u32 		board_id;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
