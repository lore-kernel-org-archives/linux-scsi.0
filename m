From: Frank Lichtenheld <frank@lichtenheld.de>
Subject: Re: [PATCH] [SCSI] aic7xxx: Fix warnings with CONFIG_PM=n
Date: Fri, 9 Nov 2007 01:12:01 +0100
Message-ID: <20071109001201.GW2961@planck.djpig.de>
References: <1194563028-19364-1-git-send-email-frank@lichtenheld.de> <20071108155834.7751f2f6.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from planck.djpig.de ([85.10.192.180]:3413 "EHLO planck.djpig.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbXKICNT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Nov 2007 21:13:19 -0500
Content-Disposition: inline
In-Reply-To: <20071108155834.7751f2f6.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Thu, Nov 08, 2007 at 03:58:34PM -0800, Randy Dunlap wrote:
> Hi,
> The preferred method of fixing this type of warning is to
> (warning, not a full patch here):
> 
> a.  change the struct pci_driver not to use #ifdef CONFIG_PM/#endif;
> instead, it always says:
> 
> 	.suspend	= ahd_linux_pci_dev_suspend,
> 	.resume		= ahd_linux_pci_dev_resume,
> 
> and those pointers are built depending on CONFIG_PM like so:
> 
> #ifdef CONFIG_PM
> 	... functions as they are now ...
> #else
> #define ahd_linux_pci_dev_suspend	NULL
> #define ahd_linux_pci_dev_resume	NULL
> #endif
> 
> so the ifdef/endif blocks are localized to one place in each driver.

Hmm, technically _two_ places since you still need them around both
declaration and definition of the functions, right?

Gruesse,
-- 
Frank Lichtenheld <frank@lichtenheld.de>
www: http://www.djpig.de/
