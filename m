From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: build error with aic79xx on 2.4
Date: Thu, 05 Jun 2003 12:08:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1636000000.1054836526@aslan.btc.adaptec.com>
References: <1054835575.22202.2.camel@heat>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:63111 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S264784AbTFERyb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2003 13:54:31 -0400
In-Reply-To: <1054835575.22202.2.camel@heat>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Jeffrey W. Baker" <jwb@gghcwest.com>, linux-scsi@vger.kernel.org

> The latest aic79xx doesn't build in 2.4.21-rc3 because of Werror and
> this warning:
> 
> aic79xx_osm_pci.c:278: warning: `ahd_linux_pci_reserve_mem_region'
> defined but not used
> 
> That seemed harmless, so I removed Werror.  I'd try -rc7 but the
> x86-64.org patches don't work against that kernel.

It points to a bug in that memory mapped I/O is not enabled for ia64,
alpha, or mips, even though these platforms should support it.  I
don't believe that the MMAPIO define is required for 2.4.X or 2.5.X
kernels now since the PCI support files are only compiled in if
CONFIG_PCI is enabled and any PCI device should be able to attempt
to do memio if the appropriate BAR is setup.

I've removed the MMAPIO ifdefs locally and will submit an updated
driver soon.

--
Justin

