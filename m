From: Paul Mackerras <paulus@ozlabs.org>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Thu, 8 Oct 2015 15:59:37 +1100
Message-ID: <20151008045937.GB2952@iris.ozlabs.ibm.com>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
 <20150925151802.GB20282@lst.de>
 <1443202278.2188.13.camel@HansenPartnership.com>
 <20150930151449.GC26299@lst.de>
 <20151001043453.GA2893@iris.ozlabs.ibm.com>
 <20151002125224.GA14899@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:50411 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbbJHE7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Oct 2015 00:59:43 -0400
Content-Disposition: inline
In-Reply-To: <20151002125224.GA14899@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Fri, Oct 02, 2015 at 02:52:24PM +0200, Christoph Hellwig wrote:
> On Thu, Oct 01, 2015 at 02:34:54PM +1000, Paul Mackerras wrote:
> > I still get the warning:
> 
> Ok, I sent you the wrong patch.  scsi_dh_add_device is the function that
> needs to switch to use __scsi_dh_lookup.  New version below:
> 
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index edb044a..cc9ea81 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -226,7 +226,7 @@ int scsi_dh_add_device(struct scsi_device *sdev)
>  
>  	drv = scsi_dh_find_driver(sdev);
>  	if (drv)
> -		devinfo = scsi_dh_lookup(drv);
> +		devinfo = __scsi_dh_lookup(drv);
>  	if (devinfo)
>  		err = scsi_dh_handler_attach(sdev, devinfo);
>  	return err;

That boots up OK and there is no warning.

Paul.
