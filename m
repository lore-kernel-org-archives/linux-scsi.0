From: Jens Axboe <axboe@suse.de>
Subject: Re: bug 2400
Date: Tue, 6 Apr 2004 11:22:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040406092244.GH28109@suse.de>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave> <20040404213307.A29446@beaverton.ibm.com> <1081199233.2105.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:19159 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262800AbUDFJXy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 05:23:54 -0400
Content-Disposition: inline
In-Reply-To: <1081199233.2105.45.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Apr 05 2004, James Bottomley wrote:
> On Sun, 2004-04-04 at 23:33, Patrick Mansfield wrote:
> > How is unregister_cdrom(&cd->cdi) called if the device is not open?
> 
> OK, the attached does everything correctly (as I should have done at
> first) by using a kobject to hold the compound references.
> 
> I've stressed this one nicely.  Unfortunately, it's showing up a bug in
> scsi_sysfs (hold device open, remove it and re-add it at the same HCTL
> and you'll see an "error 1").

Really? It doesn't even compile :-)

> @@ -514,12 +542,18 @@
>  	if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
>  		goto fail;
>  
> +	if ((err = scsi_device_get(sdev)) != 0)
> +		goto fail_put_sdev;
> +
>  	error = -ENOMEM;
>  	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
>  	if (!cd)
>  		goto fail;
>  	memset(cd, 0, sizeof(*cd));

-- 
Jens Axboe

