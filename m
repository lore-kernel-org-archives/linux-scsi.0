From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Re: sleeping in scsi EH
Date: Fri, 27 May 2005 15:17:18 +0100
Message-ID: <20050527141718.GD14929@parcelfarce.linux.theplanet.co.uk>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org> <4296DC49.5020907@pobox.com> <20050527084220.GA29352@infradead.org> <4296FA61.4010003@pobox.com> <42972A72.8060600@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39300 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261680AbVE0OQt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 10:16:49 -0400
Content-Disposition: inline
In-Reply-To: <42972A72.8060600@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, May 27, 2005 at 09:10:58AM -0500, Brian King wrote:
> diff -puN drivers/scsi/ipr.c~ipr_abort_locking drivers/scsi/ipr.c
> --- linux-2.6.12-rc5/drivers/scsi/ipr.c~ipr_abort_locking	2005-05-27 08:57:49.000000000 -0500
> +++ linux-2.6.12-rc5-bjking1/drivers/scsi/ipr.c	2005-05-27 09:00:48.000000000 -0500
> @@ -3069,6 +3069,11 @@ static int ipr_cancel_op(struct scsi_cmn
>  	ioa_cfg = (struct ipr_ioa_cfg *)scsi_cmd->device->host->hostdata;
>  	res = scsi_cmd->device->hostdata;
>  
> +	/* If we are currently going through reset/reload, return failed. This will force the
> +	   mid-layer to call ipr_eh_host_reset, which will then go to sleep and wait for the
> +	   reset to complete */
> +	if (ioa_cfg->in_reset_reload || ioa_cfg->ioa_is_dead)
> +		return FAILED;

I appreciate you've only moved this comment from elsewhere, but could
you reformat it to fewer than 80 columns please?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
