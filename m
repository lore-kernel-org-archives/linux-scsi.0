From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] fusion: streamline ->queuecommand
Date: Sat, 2 Oct 2004 14:39:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041002133915.GR16153@parcelfarce.linux.theplanet.co.uk>
References: <20041002081355.GA13643@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:64676 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266169AbUJBNjW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Oct 2004 09:39:22 -0400
Content-Disposition: inline
In-Reply-To: <20041002081355.GA13643@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Emoore@lsil.com, linux-scsi@vger.kernel.org

On Sat, Oct 02, 2004 at 10:13:55AM +0200, Christoph Hellwig wrote:
> --- 1.50/drivers/message/fusion/mptscsih.c	2004-09-29 01:58:39 +02:00
> +++ edited/drivers/message/fusion/mptscsih.c	2004-10-01 12:45:04 +02:00
> @@ -1863,11 +1844,7 @@
>  
>  #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
> +		int dvStatus = hd->ioc->spi_data.dvStatus[target];
> +		int issueCmd = 1;
> +
> +		if (dvStatus || hd->ioc->spi_data.forceDv) {
> +
> +			if ((dvStatus & MPT_SCSICFG_NEED_DV) ||
> +				(hd->ioc->spi_data.forceDv & MPT_SCSICFG_NEED_DV)) {
> +				unsigned long lflags;
> +				/* Schedule DV if necessary */

Of course, at some point, Fusion should be switched over to use the
scsi_transport_spi domain validation code ... not urgent, just an
item for the long-term todo list.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
