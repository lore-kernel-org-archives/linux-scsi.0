From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Correct order for device unregistration in aic7xxx
Date: Tue, 24 May 2005 11:44:46 +0100
Message-ID: <20050524104446.GA11829@infradead.org>
References: <429300F7.6010106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53649 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262054AbVEXKos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 06:44:48 -0400
Content-Disposition: inline
In-Reply-To: <429300F7.6010106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>

On Tue, May 24, 2005 at 12:24:55PM +0200, Hannes Reinecke wrote:
> --- linux-2.6.12-rc4/drivers/scsi/aic7xxx/aic7xxx_osm.c.orig	2005-05-24 11:53:51.000000000 +0200
> +++ linux-2.6.12-rc4/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-05-24 11:55:30.000000000 +0200
> @@ -1748,12 +1748,6 @@ ahc_platform_free(struct ahc_softc *ahc)
>  	if (ahc->platform_data != NULL) {
>  		del_timer_sync(&ahc->platform_data->completeq_timer);
>  		tasklet_kill(&ahc->platform_data->runq_tasklet);
> -		if (ahc->platform_data->host != NULL) {
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
> -			scsi_remove_host(ahc->platform_data->host);
> -#endif
> -			scsi_host_put(ahc->platform_data->host);
> -		}
>  
>  		/* destroy all of the device and target objects */
>  		for (i = 0; i < AHC_NUM_TARGETS; i++) {
> @@ -3623,6 +3617,20 @@ ahc_linux_init(void)
>  static void
>  ahc_linux_exit(void)
>  {
> +	struct ahd_softc *ahc;
> +
> +	/*
> +	 * Tear down midlayer first
> +	 */
> +	TAILQ_FOREACH(ahc, &ahd_tailq, links) {
> +		if (ahc->platform_data->host != NULL) {
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
> +			scsi_remove_host(ahc->platform_data->host);
> +#endif
> +			scsi_host_put(ahc->platform_data->host);
> +		}
> +	}
> +

Sorrym this is not acceptable at all.  Please leave the host unregistration
in ->remove (and while we're at it the scsi_host_put happens far too early
in there) and move tearing down the DV thread later in ->remove.

You're current patch completely breaks hot removal.  Also please look
at aic7xxx in current Linus' tree - it's using the SPI transport class
and doesn't have it's own dv mechanisms anymore, only aic79xx needs
fixes or preferably someone porting over the recent aic7xxx changes.

