From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch 2/3] support swsusp for aic7xxx
Date: Tue, 27 Apr 2004 12:19:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427101939.GA10593@elf.ucw.cz>
References: <200404270501.i3R51c207731@mail.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs214-177.eurotel.cz ([160.218.214.177]:35968 "EHLO
	amd.ucw.cz") by vger.kernel.org with ESMTP id S263975AbUD0KT6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 06:19:58 -0400
Content-Disposition: inline
In-Reply-To: <200404270501.i3R51c207731@mail.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, gibbs@scsiguy.com, linux-scsi@vger.kernel.org

Hi!

> From: Pavel Machek <pavel@ucw.cz>
> 
> Marks threads as needed for suspend.
> DESC
> aic79xx_osm.c build fix
> EDESC
> 
> drivers/scsi/aic7xxx/aic79xx_osm.c: In function `ahd_linux_dv_thread':
> drivers/scsi/aic7xxx/aic79xx_osm.c:2594: `PF_IOTHREAD' undeclared
> (first use in this function)

That's wrong fix. PF_IOTHREAD was renamed to PF_NOFREEZE by Nigel. He
probably missed this one because it was pending. But PF_FREEZE is
completely different thing. *NO* is missing there.
								Pavel


> 
> 
> ---
> 
>  25-akpm/drivers/scsi/aic7xxx/aic79xx_osm.c |    1 +
>  25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~aic7xxx-swsusp-support drivers/scsi/aic7xxx/aic79xx_osm.c
> --- 25/drivers/scsi/aic7xxx/aic79xx_osm.c~aic7xxx-swsusp-support	2004-04-25 23:09:37.428392128 -0700
> +++ 25-akpm/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-04-25 23:09:37.436390912 -0700
> @@ -2591,6 +2591,7 @@ ahd_linux_dv_thread(void *data)
>  	sprintf(current->comm, "ahd_dv_%d", ahd->unit);
>  #else
>  	daemonize("ahd_dv_%d", ahd->unit);
> +	current->flags |= PF_FREEZE;
>  #endif
>  	unlock_kernel();
>  
> diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-swsusp-support drivers/scsi/aic7xxx/aic7xxx_osm.c
> --- 25/drivers/scsi/aic7xxx/aic7xxx_osm.c~aic7xxx-swsusp-support	2004-04-25 23:09:37.430391824 -0700
> +++ 25-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-04-25 23:09:37.440390304 -0700
> @@ -2307,6 +2307,7 @@ ahc_linux_dv_thread(void *data)
>  	sprintf(current->comm, "ahc_dv_%d", ahc->unit);
>  #else
>  	daemonize("ahc_dv_%d", ahc->unit);
> +	current->flags |= PF_FREEZE;
>  #endif
>  	unlock_kernel();
>  
> 
> _

-- 
934a471f20d6580d5aad759bf0d97ddc
