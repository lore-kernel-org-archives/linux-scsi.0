From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/6] isci: initialization
Date: Thu, 17 Feb 2011 03:25:44 -0500
Message-ID: <20110217082544.GA23662@infradead.org>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
 <20110207003440.27040.22825.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1BQIZr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2011 03:25:47 -0500
Content-Disposition: inline
In-Reply-To: <20110207003440.27040.22825.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

> +irqreturn_t isci_isr(int vec, void *data)
> +{
> +	struct isci_host *isci_host
> +		= (struct isci_host *)data;
> +	struct scic_controller_handler_methods *handlers
> +		= &isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
> +	irqreturn_t ret = IRQ_NONE;

> +	if (isci_host_get_state(isci_host) != isci_starting
> +	    && handlers->interrupt_handler) {

Also there should be no need for a state check here.  register_irq
must not happen before you're ready to handle the interrupt.

