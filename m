From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] PCI Error Recovery: Symbios SCSI device driver
Date: Wed, 18 Jan 2006 10:07:16 -0700
Message-ID: <20060118170716.GA9569@parisc-linux.org>
References: <20060118165345.GA31920@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:64713 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751379AbWARRHR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2006 12:07:17 -0500
Content-Disposition: inline
In-Reply-To: <20060118165345.GA31920@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linas <linas@austin.ibm.com>
Cc: James.Bottomley@steeleye.com, brking@us.ibm.com, gregkh@suse.de, linux-scsi@vger.kernel.org

On Wed, Jan 18, 2006 at 10:53:45AM -0600, linas wrote:
> Hi James,

Actually, I'm the sym2 maintainer.

> +static void sym_eeh_timeout(u_long p)

Please don't propagate more uses of this u_long crap.  I haven't got
rid of all of them, but there's no need to add more.

> @@ -1630,6 +1682,8 @@ static struct Scsi_Host * __devinit sym_
>  	np->maxoffs	= dev->chip.offset_max;
>  	np->maxburst	= dev->chip.burst_max;
>  	np->myaddr	= dev->host_id;
> +	np->s.io_state = pci_channel_io_normal;
> +	np->s.io_reset_wait = NULL;

Is there a good reason to put them in the 's'?  It's really a dirty
hack.

> +/* ------------- PCI Error Recovery infrastructure -------------- */
> +/** sym2_io_error_detected() is called when PCI error is detected */
> +static pci_ers_result_t sym2_io_error_detected (struct pci_dev *pdev, pci_channel_state_t state)
> +{
> +	struct sym_hcb *np = pci_get_drvdata(pdev);
> +
> +	np->s.io_state = state;
> +	// XXX If slot is permanently frozen, then what?
> +	// Should we scsi_remove_host() maybe ??
> +
> +	/* Request a slot slot reset. */
> +	return PCI_ERS_RESULT_NEED_RESET;
> +}

Don't use C99 comments, don't put a space between the function name and
the opening bracket, and don't exceed 80 columns.

> +/** sym2_io_slot_reset is called when the pci bus has been reset.
> + *  Restart the card from scratch. */

kerneldoc style comment, but not in kerneldoc format.

> +	/* Perform host reset only on one instance of the card */
> +	if (0 == PCI_FUNC (pdev->devfn))

I really hate "if (constant == variable)".

