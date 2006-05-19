From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] ppa: no highmem pages
Date: Fri, 19 May 2006 10:00:38 -0500
Message-ID: <1148050838.3410.32.camel@mulgrave.il.steeleye.com>
References: <20060518220744.cb986f3f.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:55443 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932331AbWESPAv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 11:00:51 -0400
In-Reply-To: <20060518220744.cb986f3f.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Thu, 2006-05-18 at 22:07 -0700, Randy.Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> ppa cannot handle highmem pages, and like imm, which already has
> this patch, the device is slow, so performance is not a big issue,
> so just force pages to be in low memory (hence mapped).
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/scsi/ppa.c |    4 ++++
>  1 files changed, 4 insertions(+)
> 
> --- linux-2.6.17-rc4.orig/drivers/scsi/ppa.c
> +++ linux-2.6.17-rc4/drivers/scsi/ppa.c
> @@ -997,6 +997,10 @@ static struct scsi_host_template ppa_tem
>  	.cmd_per_lun		= 1,
>  	.use_clustering		= ENABLE_CLUSTERING,
>  	.can_queue		= 1,
> +	.unchecked_isa_dma	= 1, /* ppa cannot deal with highmem, so
> +				      * this is an easy trick to ensure
> +				      * all io pages for this host reside
> +				      * in low memory */

This is the wrong thing to do.  You'll force all allocations for this
device to go through ZONE_DMA, which is a horrifically constrained
resource at 16MB.  If it can take anything in lowmem because the driver
is unconverted, then you want it to specify BLK_BOUNCE_HIGH as the queue
limit.

James


