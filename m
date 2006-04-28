From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: EMC Symmetrix vs. no storage on LUN 0
Date: Fri, 28 Apr 2006 12:56:42 -0700
Message-ID: <20060428195642.GA29753@us.ibm.com>
References: <20060427091322.GA19126@bogon.ms20.nix> <20060428184555.GA4404@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:7091 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751442AbWD1T6W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 15:58:22 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3SJwLHk029361
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 15:58:21 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3SJwLOk147224
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 15:58:21 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k3SJwKR6000422
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 15:58:21 -0400
Content-Disposition: inline
In-Reply-To: <20060428184555.GA4404@bogon.ms20.nix>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guido Guenther <agx@sigxcpu.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 28, 2006 at 08:45:55PM +0200, Guido Guenther wrote:
> On Thu, Apr 27, 2006 at 11:13:22AM +0200, Guido Guenther wrote:
> > we have a rather old EMC Symmetrix which always has a peripheral
> > qualifier of 001b on LUN0. This has the problem that the
> > scsi_probe_and_add_lun code bails out to out_free_result: before we
> > apply the device flags (that we got from scsi_probe_lun just before this
> > check) to bflagsp. The result is that (without these flags) we stop
> [..snip..] 
> The previously attached patch has the issue that we add a device though
> not actually present just to safe the bflags. This version should do
> better:
> 
> --- orig/linux-2.6.16.7/drivers/scsi/scsi_scan.c	2006-03-20 06:53:29.000000000 +0100
> +++ linux-2.6.16.7/drivers/scsi/scsi_scan.c	2006-04-28 20:38:01.000000000 +0200
> @@ -868,6 +868,12 @@ static int scsi_probe_and_add_lun(struct
>  					"scsi scan: peripheral qualifier of 3,"
>  					" no device added\n"));
>  		res = SCSI_SCAN_TARGET_PRESENT;
> +
> +		/* don't discard the already fetched bflags for lun 0 so
> +		 * __scsi_scan_target knows about them */
> +		if (bflagsp && lun == 0)
> +			*bflagsp = bflags;
> +	   	
>  		goto out_free_result;
>  	}

A similar patch is already in scsi-misc and mm trees, you should test one
of those.

Here is the patch from Kurt that was accepted into scsi-misc:

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=blobdiff;h=820c4ad7b5817e24550d50dd35ca740cd86de4fe;hp=f14945996ede5ec514bc0e390b506ffcfaa4d461;hb=4186ab1973758190916703eb8889ebe8002c5c8f;f=drivers/scsi/scsi_scan.c

-- Patrick Mansfield
