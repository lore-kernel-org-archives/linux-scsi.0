From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] hpsa: correct lockup detector pci_disable_device
Date: Thu, 27 Oct 2016 08:19:03 -0700
Message-ID: <20161027151903.GA4602@infradead.org>
References: <147752001094.813.10247306839794156732.stgit@brunhilda>
 <147752050626.813.15549750881571218281.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34703 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933490AbcJ0PTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2016 11:19:07 -0400
Content-Disposition: inline
In-Reply-To: <147752050626.813.15549750881571218281.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com, linux-scsi@vger.kernel.org

> -	pci_disable_device(h->pdev);
> +	if (pci_is_enabled(h->pdev))
> +		pci_disable_device(h->pdev);
>  	fail_all_outstanding_cmds(h);

Humm.  How can this even happen when the device isn't enabled?
