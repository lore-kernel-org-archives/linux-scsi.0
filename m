From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] mpt fusion: Fix for module load error when mptctl
	and mptsas are loaded in parallel
Date: Fri, 11 Jan 2008 12:26:36 -0600
Message-ID: <1200075996.3286.46.camel@localhost.localdomain>
References: <20080111091630.GD4161@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46626 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756729AbYAKS0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 13:26:43 -0500
In-Reply-To: <20080111091630.GD4161@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com


On Fri, 2008-01-11 at 14:46 +0530, Prakash, Sathya wrote:
> This patch fixes a panic at mptctl_probe -> mutex_init if the mptsas and mptcl module are loaded in parallel, this is because IOC is NULL, the fix is in mpt_device_register to call probe only with non-zero IOC pointer.
> 
> signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> ---
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index d733438..042bc86 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -729,6 +729,8 @@ mpt_device_driver_register(struct mpt_pci_driver * dd_cbfunc, u8 cb_idx)
>  
>  	/* call per pci device probe entry point */
>  	list_for_each_entry(ioc, &ioc_list, list) {
> +		if (!pci_get_drvdata(ioc->pcidev))
> +			continue;

This looks rather dubious ... it doesn't fix the race, it just manifests
differently (and non fatally) by apparently not attaching the mptctl.

Isn't a better fix to set the drvdata earlier in the process, say in
mpt_attach *before* you add the ioc to the ioc_list?  That way the race
can never occur in the first place.

James


