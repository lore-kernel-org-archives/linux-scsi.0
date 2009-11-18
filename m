From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH]  [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
 resources.
Date: Wed, 18 Nov 2009 16:41:29 +1100
Message-ID: <1258522889.2140.659.camel@pasglop>
References: <1258503401-7779-1-git-send-email-pbathija@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:55865 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZKRFls (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Nov 2009 00:41:48 -0500
In-Reply-To: <1258503401-7779-1-git-send-email-pbathija@amcc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pbathija@amcc.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, jwboyer@linux.vnet.ibm.com, Eric.Moore@lsi.com

On Tue, 2009-11-17 at 16:16 -0800, pbathija@amcc.com wrote:
> From: Pravin Bathija <pbathija@amcc.com>
> 
>   Powerpc 44x uses 36 bit real address while the real address defined
>   in MPT Fusion driver is of type 32 bit. This causes ioremap to fail and driver
>   fails to initialize. This fix changes the data types representing the real
>   address from unsigned long 32-bit types to "phys_addr_t" which is 64-bit. The
>   driver has been tested, the disks get discovered correctly and can do IO. Removed
>   ioremap and used hose->io_base_virt for IO space to make it platform independent.
> Content-Type: text/plain; charset=utf-8

Except that this is all wrong :-) You basically made it powerpc specific
since none of that pci controller stuff is generic. I don't understand
what you are trying to do though. The -only- change you need to do is
to change the longs into resource_size_t.

IO Port numbers are "special" and handled as such already (and besides
are never bigger than 32-bit neither, at least on x86 and powerpc).

Just leave the PIO code alone, hopefully, if the driver isn't full of
crack, the code should be fine already. If the driver does something
wrong then you can attempt to fix it separately.

The only problem that you need to address afaik, is purely that
pci_resource_start() can return a resource_size_t which can be 64-bit,
and as such it is broken for the driver to manipulate and store that
value as an unsigned long or a u32.

Cheers,
Ben.


