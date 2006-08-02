From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: advansys pci tweaks.
Date: Wed, 2 Aug 2006 15:34:20 -0600
Message-ID: <20060802213420.GG7606@parisc-linux.org>
References: <20060802211149.GC3639@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:30168 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932227AbWHBVeV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Aug 2006 17:34:21 -0400
Content-Disposition: inline
In-Reply-To: <20060802211149.GC3639@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org, bobf@advansys.com

On Wed, Aug 02, 2006 at 05:11:49PM -0400, Dave Jones wrote:
> Remove a lot of duplicate #defines from the advansys driver,
> and make them look like PCI IDs as defined elsewhere in the kernel.
> Also add a module table so that it automatically gets picked up
> by tools relying on modinfo output (like say, distro installers).

I'd much rather see at least the vendor ID moved to pci_ids.h; how about
#define PCI_VENDOR_ID_ADVSYS            0x10cd
for that one?

> @@ -889,10 +889,6 @@ typedef unsigned char uchar;
>  #define ASC_PCI_ID2DEV(id)    (((id) >> 11) & 0x1F)
>  #define ASC_PCI_ID2FUNC(id)   (((id) >> 8) & 0x7)
>  #define ASC_PCI_MKID(bus, dev, func) ((((dev) & 0x1F) << 11) | (((func) & 0x7) << 8) | ((bus) & 0xFF))

... those all need to be fixed too.  Sigh.  I wonder if Bob Frey is
still around to care about this driver ...

