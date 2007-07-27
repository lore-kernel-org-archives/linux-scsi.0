From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 7/24] advansys: Convert to EISA driver model
Date: Fri, 27 Jul 2007 08:40:10 -0600
Message-ID: <20070727144009.GG21219@parisc-linux.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437533612-git-send-email-matthew@wil.cx> <46AA02C2.8010702@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52453 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937219AbXG0OkL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:40:11 -0400
Content-Disposition: inline
In-Reply-To: <46AA02C2.8010702@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 10:35:46AM -0400, Jeff Garzik wrote:
> Also, general comment:
> 
> To be, or not to be:  CONFIG_PCI and CONFIG_EISA

Ah yes.  A can of worms I haven't got into yet.  I do intend to address
this, but it requires summoning up the will to build all kinds of crazy
(ie non-PCI) configs.

> I don't have an opinion either way.  On one hand, the present setup is 
> clean.  On the other hand, you are likely to run into non-ISA platforms 
> that might not be happy with building non-PCI code.  It's not the 
> eisa_register_driver() that is the problem, but other ISA-specific 
> functions you wind up using in the process.

My hope is that once the driver is a bit cleaner, it'll be easier to
delinearate which bits are ISA, which EISA, which PCI, and which are
common to all three.

I think there's a lot of code which is currently common to all three
that doesn't need to be.

> Plus, Andi likes to make a big fuss about building ISA code on x86-64 :)

Fortunately, this driver is currently limited to X86_32 by the Kconfig.
Again, I will address this ... but perhaps not in this patch series.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
