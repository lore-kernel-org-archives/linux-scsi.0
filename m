From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/6] isci: initialization
Date: Fri, 18 Mar 2011 12:51:07 -0400
Message-ID: <20110318165107.GA10206@infradead.org>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
 <20110207003440.27040.22825.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41816 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab1CRQvK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2011 12:51:10 -0400
Content-Disposition: inline
In-Reply-To: <20110207003440.27040.22825.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

> +	/*
> +	 *  Since this is a legacy interrupt, either or both
> +	 *  controllers could have triggered it.  Thus, we have to call
> +	 *  the legacy interrupt handler for all controllers on the
> +	 *  PCI function.
> +	 */
> +	for_each_isci_host(isci_host, pdev) {

Just one request_irq for each host, and the core irq layer will handle
it fine.

> +static inline struct isci_pci_info *to_pci_info(struct pci_dev *pdev)
> +{
> +	return pci_get_drvdata(pdev);
> +}

Pretty pointless as pci_get_drvdata returns a void pointer, which you can
assign directly to a struct isci_pci_info *

> +static inline
> +enum isci_status isci_host_get_state(
> +	struct isci_host *isci_host)
> +{
> +	return isci_host->status;
> +}

Completely pointless.

> +/**
> + * isci_host_scan_start() -
> + *
> + * This function is one of the SCSI Host Template function, called by the SCSI
> + * mid layer berfore a target scan begins. The core library controller start
> + * routine is called from here.
> + */

Why do you have pseudo-kerneldoc comments in the headers?  That's not
going to be parserd by the kerneldoc tools and just confuses everyone.

> +static int __devinit isci_pci_probe(
> +	struct pci_dev *pdev,
> +	const struct pci_device_id *device_id_p);
> +
> +static void __devexit isci_pci_remove(struct pci_dev *pdev);

Just move the pci_driver table behing the implementation.

> +#if defined(CONFIG_PBG_HBA_A0)
> +int isci_si_rev = ISCI_SI_REVA0;
> +#elif defined(CONFIG_PBG_HBA_A2)
> +int isci_si_rev = ISCI_SI_REVA2;
> +#else
> +int isci_si_rev = ISCI_SI_REVB0;
> +#endif
> +module_param(isci_si_rev, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(isci_si_rev, "override default si rev (0: A0 1: A2 2: B0)");

The revision needs to be in the device specific structure, not a global
variable.

> +/******************************************************************************
> +* P R O T E C T E D  M E T H O D S
> +******************************************************************************/

Err, no..

> +/**
> + * isci_register_sas_ha() - This method initializes various lldd
> + *    specific members of the sas_ha struct and calls the libsas
> + *    sas_register_ha() function.
> + * @isci_host: This parameter specifies the lldd specific wrapper for the
> + *    libsas sas_ha struct.
> + *
> + * This method returns an error code indicating sucess or failure. The user
> + * should check for possible memory allocation error return otherwise, a zero
> + * indicates success.
> + */

It's not a method but a function.  And the documentation really doesn't
tell anything worthwhile while we're at it.

> +static void isci_unregister_sas_ha(struct isci_host *isci_host)
> +{
> +	if (!isci_host)
> +		return;

How could this happen?

> +/**
> + * This file contains the isci_module object definition.
> + *
> + * isci.h
> + */

Ok, and what exactly does this comment try to tell us?

> +
> +#if !defined(_SCI_MODULE_H_)
> +#define _SCI_MODULE_H_
> +
> +/**
> + * This file contains the SCI low level driver interface to the SCI and Libsas
> + *    Libraries.
> + *
> + * isci.h
> + */

Or this one just five lines later?

