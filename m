From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 1/2] sas transport: ref count update
Date: Fri, 24 Mar 2006 19:56:48 -0800
Message-ID: <20060325035648.GB19970@us.ibm.com>
References: <20060322214119.GA661@us.ibm.com> <20060322214221.GB661@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:15342 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750753AbWCYEDP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Mar 2006 23:03:15 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2P435xA022556
	for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2006 23:03:05 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2P42tJE134106
	for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2006 23:02:55 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k2P42suG015979
	for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2006 23:02:55 -0500
Content-Disposition: inline
In-Reply-To: <20060322214221.GB661@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Christoph,

Can I get your comment(s) on this change.

Mike Anderson <andmike@us.ibm.com> wrote:
> Fix puts so that release functions will be called.
> 
> Signed-off-by: Mike Anderson <andmike@us.ibm.com>
> 
>  drivers/scsi/scsi_transport_sas.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_transport_sas.c
> ===================================================================
> --- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_transport_sas.c	2006-03-22 13:22:22.000000000 -0800
> +++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_transport_sas.c	2006-03-22 13:24:27.000000000 -0800
> @@ -406,8 +406,6 @@ struct sas_phy *sas_phy_alloc(struct dev
>  	if (!phy)
>  		return NULL;
>  
> -	get_device(parent);
> -
>  	phy->number = number;
>  
>  	device_initialize(&phy->dev);
> @@ -484,7 +482,7 @@ sas_phy_delete(struct sas_phy *phy)
>  	transport_remove_device(dev);
>  	device_del(dev);
>  	transport_destroy_device(dev);
> -	put_device(dev->parent);
> +	put_device(dev);
>  }
>  EXPORT_SYMBOL(sas_phy_delete);
>  
> @@ -990,7 +988,7 @@ sas_rphy_delete(struct sas_rphy *rphy)
>  
>  	parent->rphy = NULL;
>  
> -	put_device(&parent->dev);
> +	put_device(dev);
>  }
>  EXPORT_SYMBOL(sas_rphy_delete);

-andmike
--
Michael Anderson
andmike@us.ibm.com
