From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla_wxyz pci_set_mwi question
Date: Thu, 12 Apr 2007 12:37:13 -0700
Message-ID: <20070412193713.GB14510@andrew-vasquezs-computer.local>
References: <20070411221507.69c97257.randy.dunlap@oracle.com> <20070412172038.GG10124@andrew-vasquezs-computer.local> <20070412185347.GL26692@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:28660 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbXDLTiR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2007 15:38:17 -0400
Content-Disposition: inline
In-Reply-To: <20070412185347.GL26692@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, David Somayajulu <david.somayajulu@qlogic.com>, scsi <linux-scsi@vger.kernel.org>, PCI <linux-pci@atrey.karlin.mff.cuni.cz>, linux-driver@qlogic.com, gregkh <greg@kroah.com>

On Thu, 12 Apr 2007, Matthew Wilcox wrote:

> On Thu, Apr 12, 2007 at 10:20:38AM -0700, Andrew Vasquez wrote:
> > No, the current logic doesn't make much sense at all, initialization
> > should not continue if MWI is not set... I'll queue-up something like
> > the patch below for our next batch-of-qla2xxx-updates.
> 
> Why should it fail?  If there's a platform which can't support a
> cacheline size that the qla2xyz card can handle, it should be able to
> happily fall back to doing plain writes instead of MWIs.  IMO, it should
> just call pci_set_mwi() and ignore the result.

I believe there were some erratas on some ISP2xxx chips where MWI
needed to be set for proper operation.  I'll go back, verify and
update the patch accordingly.

> >  	pci_set_master(ha->pdev);
> > -	mwi = 0;
> > -	if (pci_set_mwi(ha->pdev))
> > -		mwi = PCI_COMMAND_INVALIDATE;
> > +	if (pci_set_mwi(ha->pdev) < 0)
> > +		return QLA_FUNCTION_FAILED;
> >  
> >  	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
> > -	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
> > +	w |= PCI_COMMAND_PARITY | PCI_COMMAND_SERR;
> >  	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
> 
> However, setting the msi bit here was redundant.  pci_set_mwi() already
> sets the PCI_COMMAND_INVALIDATE bit.
