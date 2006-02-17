From: Roland Dreier <rdreier@cisco.com>
Subject: Re: Problems with MSI-X on ia64
Date: Fri, 17 Feb 2006 12:21:37 -0800
Message-ID: <aday809d9da.fsf@cisco.com>
References: <B8E391BBE9FE384DAA4C5C003888BE6F05BF610F@scsmsx401.amr.corp.intel.com>
	<20060217200454.GA24942@esmail.cup.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:44084 "EHLO
	sj-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S1750904AbWBQUVx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 15:21:53 -0500
In-Reply-To: <20060217200454.GA24942@esmail.cup.hp.com> (Grant Grundler's
 message of "Fri, 17 Feb 2006 12:04:54 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <iod00d@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Chris Wedgwood <cw@f00f.org>, Grant Grundler <grundler@parisc-linux.org>, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>

BARs above 4G on i386 raise all sorts of issues.  I think Grant's
original patch (which changes phys_addr in drivers/pci/msi.c to
unsigned long) is correct as it stands, because the MSI code is going
to use that address to ioremap() the MSI-X table.  And the address
passed to ioremap is unsigned long anyway.

Some extension like ioremap_pfn() or something like that is going to
needed to handling giving the kernel access to BARs above 4G on 32-bit
archs.

 - R.
