From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] aic7xxx: Add suspend/resume support
Date: Fri, 19 Oct 2007 09:44:07 +0100
Message-ID: <20071019084407.GA23211@infradead.org>
References: <20071019083222.11DAE18C61E@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53001 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbXJSIoJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 04:44:09 -0400
Content-Disposition: inline
In-Reply-To: <20071019083222.11DAE18C61E@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

I think this needs a little restructuring. ahd_pci_suspend/ahd_pci_resume
should be merged into their callers and use the normal Linux pci accessors,
and ahd_suspend/ahd_resume are tiny enough to merged into the caller aswell.

> +#ifdef CONFIG_PM
> +	.suspend	= ahd_linux_pci_dev_suspend,
> +	.resume		= ahd_linux_pci_dev_resume,
> +#endif
>  	.remove		= ahd_linux_pci_dev_remove,
>  	.id_table	= ahd_linux_pci_id_table
>  };
>  
> +static int
> +ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)

I think this needsa #ifdef CONFIG_PM aswell.  Also any chance you
could implement functions before their use so we can avoid forward
declarations.

> +{
> +	struct ahd_softc *ahd = pci_get_drvdata(pdev);
> +	int rc;
> +
> +	if ((rc = ahd_suspend(ahd)))
> +		return rc;

	rc = ahd_suspend(ahd)
	if (rc)
		return rc;

but as I mentioned above better just inline the content of ahd_suspend
into this function. That would also catch that ahd_suspend returns
positive errno values and we'd have to invert them here.

Same comments apply to the aic7xxx portion.
