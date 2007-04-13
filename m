From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: qla_wxyz pci_set_mwi question
Date: Fri, 13 Apr 2007 12:43:43 +1000
Message-ID: <1176432224.5764.59.camel@localhost.localdomain>
References: <20070411221507.69c97257.randy.dunlap@oracle.com>
	 <20070412172038.GG10124@andrew-vasquezs-computer.local>
	 <20070412185347.GL26692@parisc-linux.org>
	 <20070412193713.GB14510@andrew-vasquezs-computer.local>
	 <20070412200438.GM26692@parisc-linux.org>
	 <1176431662.5764.56.camel@localhost.localdomain>
	 <461EEDAA.7090503@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:58744 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbXDMCoD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Apr 2007 22:44:03 -0400
In-Reply-To: <461EEDAA.7090503@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Vasquez <andrew.vasquez@qlogic.com>, scsi <linux-scsi@vger.kernel.org>, gregkh <greg@kroah.com>, David Somayajulu <david.somayajulu@qlogic.com>, linuxppc-dev@ozlabs.org, linux-driver@qlogic.com, PCI <linux-pci@atrey.karlin.mff.cuni.cz>


> Willy was referring to this from include/asm-powerpc/pci.h:
> 
> #ifdef CONFIG_PPC64
> 
> /*
>  * We want to avoid touching the cacheline size or MWI bit.
>  * pSeries firmware sets the cacheline size (which is not the cpu cacheline
>  * size in all cases) and hardware treats MWI the same as memory write.
>  */
> #define PCI_DISABLE_MWI
> 
> 
> which makes pci_set_mwi() do nothing other than return 0;

Interesting... I think I missed that we had that bit for some time :-)

Well, I suppose that on pSeries and probably pmac too, the firmware will
set the MWI bit for us anyway, but that's a bit dodgy to apply that to
all ppc64... they aren't all pSeries.

I'll have to look into that again one of these days.

Cheers,
Ben.


