From: "Dr. Ernst Molitor" <molitor@uni-bonn.de>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical
	address >16Mb used for aha1542" at boot time
Date: Fri, 20 Feb 2004 21:17:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077308246.1277.4.camel@felicia>
References: <20040218171212.0eb6618a.akpm@osdl.org>
	 <1077243517.2164.61.camel@mulgrave>  <1077265837.1297.9.camel@felicia>
	 <1077295765.1937.0.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mibi03.meb.uni-bonn.de ([131.220.21.4]:54800 "EHLO
	mibi03.meb.uni-bonn.de") by vger.kernel.org with ESMTP
	id S261401AbUBTURg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 15:17:36 -0500
In-Reply-To: <1077295765.1937.0.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, molitor@uni-bonn.de

Dear James Bottomley, 

thank you very much for your patch; I have applied it, but it does not
appreciably change things. The messages (as far as I can read it - I'm
still missing the first few lines...) have not changed at all, and
booting still ends up in a kernel panic. 

I'd be more than happy to check out additional patches ...

Best wishes and regards, 

Ernst

On Fri, 2004-02-20 at 08:49 -0800, James Bottomley wrote:

> On Fri, 2004-02-20 at 00:30, Dr. Ernst Molitor wrote:
> > Please don't hesitate to contact me if I can be of any further help in
> > this matter.
> 
> The problem seems to be a non-GFP_DMA allocation in sr.c.  Could you try
> this patch?
> 
> Thanks,
> 
> James
> 
> ===== drivers/scsi/sr.c 1.98 vs edited =====
> --- 1.98/drivers/scsi/sr.c	Mon Feb  9 12:59:10 2004
> +++ edited/drivers/scsi/sr.c	Fri Feb 20 08:47:55 2004
> @@ -716,7 +716,7 @@
>  	set_disk_ro(cd->disk, 1);
>  
>  	/* allocate a request for the TEST_UNIT_READY */
> -	SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL);
> +	SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL | GFP_DMA);
>  	if (!SRpnt) {
>  		printk(KERN_WARNING "(get_capabilities:) Request allocation "
>  		       "failure.\n");
> 
> 
> ______________________________________
> Inflex - installed on mailserver for domain @mibi03.meb.uni-bonn.de
> Queries to: postmaster@mibi03.meb.uni-bonn.de

