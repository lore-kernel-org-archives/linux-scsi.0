From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [PATCH 2.4] sym53c8xx_2 error handler fix
Date: Wed, 17 Nov 2004 11:59:24 -0200
Message-ID: <20041117135924.GE20533@logos.cnet>
References: <04Nov1.162535est.332407@cyborg.cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:25516 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262467AbUKQSGr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 13:06:47 -0500
Content-Disposition: inline
In-Reply-To: <04Nov1.162535est.332407@cyborg.cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org


Tony, 

I've applied all of your patches. Thanks!

On Mon, Nov 01, 2004 at 04:25:58PM -0500, Tony Battersby wrote:
> The sym53c8xx_2 driver in lk 2.4.x is unmaintained.  This is a backported
> fix from lk 2.6.x for a problem with the error handler never successfully
> completing an abort, bus reset, device reset, or host reset.  This patch has
> been well tested at my company.  Please apply.
> 
> --- linux-2.4.26-vanilla/drivers/scsi/sym53c8xx_2/sym_glue.c	Thu Nov 28 18:53:14 2002
> +++ linux-2.4.26-asp/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri May 21 11:43:51 2004
> @@ -1149,7 +1149,6 @@
>  	switch(to_do) {
>  	default:
>  	case SYM_EH_DO_IGNORE:
> -		goto finish;
>  		break;
>  	case SYM_EH_DO_WAIT:
>  #if LINUX_VERSION_CODE > LinuxVersionCode(2,3,0)
> @@ -1193,7 +1192,6 @@
>  		to_do = SYM_EH_DO_IGNORE;
>  	}
>  
> -finish:
>  	ep->to_do = to_do;
>  	/* Complete the command with locks held as required by the driver */
>  	if (to_do == SYM_EH_DO_COMPLETE)
> 
> 
> Anthony J. Battersby
> Cybernetics
