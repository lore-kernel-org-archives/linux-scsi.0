From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: qla_wxyz pci_set_mwi question
Date: Thu, 12 Apr 2007 14:04:38 -0600
Message-ID: <20070412200438.GM26692@parisc-linux.org>
References: <20070411221507.69c97257.randy.dunlap@oracle.com> <20070412172038.GG10124@andrew-vasquezs-computer.local> <20070412185347.GL26692@parisc-linux.org> <20070412193713.GB14510@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58181 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030307AbXDLUEk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2007 16:04:40 -0400
Content-Disposition: inline
In-Reply-To: <20070412193713.GB14510@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, David Somayajulu <david.somayajulu@qlogic.com>, scsi <linux-scsi@vger.kernel.org>, PCI <linux-pci@atrey.karlin.mff.cuni.cz>, linux-driver@qlogic.com, gregkh <greg@kroah.com>, linuxppc-dev@ozlabs.org

On Thu, Apr 12, 2007 at 12:37:13PM -0700, Andrew Vasquez wrote:
> On Thu, 12 Apr 2007, Matthew Wilcox wrote:
> > Why should it fail?  If there's a platform which can't support a
> > cacheline size that the qla2xyz card can handle, it should be able to
> > happily fall back to doing plain writes instead of MWIs.  IMO, it should
> > just call pci_set_mwi() and ignore the result.
> 
> I believe there were some erratas on some ISP2xxx chips where MWI
> needed to be set for proper operation.  I'll go back, verify and
> update the patch accordingly.

Hmm.  The thing is that pci_set_mwi() returns success on machines where
MWI is disabled (currently only PPC64).  Perhaps it needs to fail
instead.
