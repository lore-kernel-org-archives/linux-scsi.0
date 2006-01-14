From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fusion - adding support for FC949ES
Date: Sat, 14 Jan 2006 12:31:51 +0100
Message-ID: <20060114113151.GD19567@lst.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7EB@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:19346 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932181AbWANLb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 06:31:57 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7EB@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@steeleye.com

On Fri, Jan 13, 2006 at 04:25:26PM -0700, Moore, Eric wrote:
> Add software recognition for the new LSI Logic Fibre Channel controller.
> 
> It relies on patch I posted yesterday:
> http://marc.theaimsgroup.com/?l=linux-kernel&m=113710143305078&w=2
> 
> Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
> 
> diff -uarN b/drivers/message/fusion/mptbase.c
> a/drivers/message/fusion/mptbase.c
> --- b/drivers/message/fusion/mptbase.c	2006-01-13 13:51:07.000000000
> -0700
> +++ a/drivers/message/fusion/mptbase.c	2006-01-13 15:42:07.000000000
> -0700
> @@ -1378,6 +1378,10 @@
>  		ioc->bus_type = FC;
>  		ioc->errata_flag_1064 = 1;
>  	}
> +	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC949E) {
> +		ioc->prod_name = "LSIFC949E";
> +		ioc->bus_type = FC;
> +	}
>  	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_53C1030) {

Why is this (and the existing ids) using the ids from the lsi/ headers
and not from pci_ids.h?  looks a bit inconsistant, but let's go for this
variant for now..

