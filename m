From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ PATCH ] mptsas: Fix oops for insmod during kexec
Date: Fri, 9 Mar 2007 21:22:37 +0000
Message-ID: <20070309212237.GA25326@infradead.org>
References: <20070309210744.GD1006@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44033 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965819AbXCIVWl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Mar 2007 16:22:41 -0500
Content-Disposition: inline
In-Reply-To: <20070309210744.GD1006@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Judith Lebzelter <judith@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, mpt_linux_developer@lsi.com, Eric.Moore@lsi.com, James.Bottomley@SteelEye.com

On Fri, Mar 09, 2007 at 01:07:44PM -0800, Judith Lebzelter wrote:
> Hello,
> 
> This patch is to fix an oops on insmod for mptsas during kexec.
> This applies to 2.6.21-rc3.
> 
> Signed-off-by:  Judith Lebzelter <judith@osdl.org
> 
> ---
> 
> 
> Index: linux-2.6.21-rc3/drivers/message/fusion/mptsas.c
> ===================================================================
> --- linux-2.6.21-rc3.orig/drivers/message/fusion/mptsas.c
> +++ linux-2.6.21-rc3/drivers/message/fusion/mptsas.c
> @@ -815,7 +815,7 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *io
>  static int
>  mptsas_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
>  {
> -	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
> +	MPT_SCSI_HOST	*hd;
>  	struct mptsas_target_reset_event *target_reset_list, *n;
>  	int rc;
>  
> @@ -827,7 +827,10 @@ mptsas_ioc_reset(MPT_ADAPTER *ioc, int r
>  	if (reset_phase != MPT_IOC_POST_RESET)
>  		goto out;
>  
> -	if (!hd || !hd->ioc)
> +	if (!ioc->sh || !ioc->sh->hostdata)
> +		goto out;
> +	hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
> +	if (!hd->ioc)

This needs a much better explanation.  Please show the codepath
leading to this.

