From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 8/24] mpt fusion: [2.6.30-rc6]rewrite taskmanagement
	request and completion routines
Date: Fri, 22 May 2009 15:27:06 +0000
Message-ID: <1243006026.2873.13.camel@localhost.localdomain>
References: <20090522105425.GB16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58210 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756952AbZEVP1G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 May 2009 11:27:06 -0400
In-Reply-To: <20090522105425.GB16331@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-22 at 16:24 +0530, Kashyap, Desai wrote:
> +int
> +mpt_set_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc)
> +{
> +	unsigned long	 flags;
> +	int		 retval;
> +
> +	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
> +	if (ioc->ioc_reset_in_progress || ioc->taskmgmt_in_progress ||
> +	    (ioc->alt_ioc && ioc->alt_ioc->taskmgmt_in_progress)) {
> +		retval = -1;
> +		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
remove this line ^^^^^^^^^^^

> +		goto out;
> +	}
> +	retval = 0;
> +	ioc->taskmgmt_in_progress = 1;
> +	if (ioc->alt_ioc) {
> +		ioc->alt_ioc->taskmgmt_in_progress = 1;
> +	}

And these braces.

And put the out: label here instead.

> +	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
> +
> + out:
> +	return retval;
> +}
> +EXPORT_SYMBOL(mpt_set_taskmgmt_in_progress_flag);
> +
> +/**
> + *	mpt_clear_taskmgmt_in_progress_flag - clear flags associated with task managment
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *
> + **/
> +void
> +mpt_clear_taskmgmt_in_progress_flag(MPT_ADAPTER *ioc)
> +{
> +	unsigned long	 flags;
> +
> +	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
> +	ioc->taskmgmt_in_progress = 0;
> +	if (ioc->alt_ioc) {
> +		ioc->alt_ioc->taskmgmt_in_progress = 0;
> +	}

And these braces

James


