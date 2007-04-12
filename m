From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: qla_wxyz pci_set_mwi question
Date: Thu, 12 Apr 2007 12:53:47 -0600
Message-ID: <20070412185347.GL26692@parisc-linux.org>
References: <20070411221507.69c97257.randy.dunlap@oracle.com> <20070412172038.GG10124@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41991 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXDLSxt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2007 14:53:49 -0400
Content-Disposition: inline
In-Reply-To: <20070412172038.GG10124@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, David Somayajulu <david.somayajulu@qlogic.com>, scsi <linux-scsi@vger.kernel.org>, PCI <linux-pci@atrey.karlin.mff.cuni.cz>, linux-driver@qlogic.com, gregkh <greg@kroah.com>

On Thu, Apr 12, 2007 at 10:20:38AM -0700, Andrew Vasquez wrote:
> No, the current logic doesn't make much sense at all, initialization
> should not continue if MWI is not set... I'll queue-up something like
> the patch below for our next batch-of-qla2xxx-updates.

Why should it fail?  If there's a platform which can't support a
cacheline size that the qla2xyz card can handle, it should be able to
happily fall back to doing plain writes instead of MWIs.  IMO, it should
just call pci_set_mwi() and ignore the result.

>  	pci_set_master(ha->pdev);
> -	mwi = 0;
> -	if (pci_set_mwi(ha->pdev))
> -		mwi = PCI_COMMAND_INVALIDATE;
> +	if (pci_set_mwi(ha->pdev) < 0)
> +		return QLA_FUNCTION_FAILED;
>  
>  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
> -	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
> +	w |= PCI_COMMAND_PARITY | PCI_COMMAND_SERR;
>  	pci_write_config_word(ha->pdev, PCI_COMMAND, w);

However, setting the msi bit here was redundant.  pci_set_mwi() already
sets the PCI_COMMAND_INVALIDATE bit.

