From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Dell 2850 build in (LSI) PERC4/Di 2.6 kernel driver.
Date: Fri, 1 Apr 2005 10:32:10 -0600
Message-ID: <20050401163210.GC18094@lists.us.dell.com>
References: <424945E8.4040502@basenet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:25716 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S262781AbVDAQc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2005 11:32:28 -0500
Content-Disposition: inline
In-Reply-To: <424945E8.4040502@basenet.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Veldema <paul@basenet.nl>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 29, 2005 at 02:11:20PM +0200, Paul Veldema wrote:
> Hello developers,
> 
> For the last two months I've been strugling with a driver problem. Our 
> company bought two Dell PowerEdge 2850's
> to try our production kernel version 2.6.8 (debian sarge) on since the 
> 2650 are no longer sold. The Dell PE 2650's had Perc4/DC cards in
> them (which work fine with the drivers and kernel 2.6.X) supposedly the 
> same thing as the build in Perc4/Di controllers in the PE2850's.
> According to Dell the LSI chipset in the PERC4 is de LSI53C1020.
> 
> However, the megaraid drivers don't detect the Perc4/Di controllers 
> resulting in a
> kernel panic when linux wants to start load stuff from disk (can't find 
> file bla).

I don't have the debian sarge source handy, but the kernel.org 2.6.8
kernel's drivers/scsi/megaraid.[ch] driver indeed does not have the
PCI IDs for these controllers present.  Looks like I misremembered
when I put that text on linux.dell.com, I've corrected it.

kernel.org 2.6.9 drivers/scsi/megaraid/megaraid_mbox.c  does have the
PCI IDs for this adapter.


[snip]
> >From source "*megaraid_mbox*":
> #define MEGARAID_VERSION        "2.20.3.1"
> 
> ...
> 
> #define PCI_DEVICE_ID_PERC4E_DI_KOBUK                   0x0013
> #define PCI_SUBSYS_ID_PERC4E_DI_KOBUK                   0x016d

Right, this are the right IDs, as your working 2.4 scenario shows:

> megaraid: found 0x1028:0x0013:bus 2:slot 14:func 0


so your 2.6.9 kernel should work.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
