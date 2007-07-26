From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 3/21] advansys: Convert to pci_register_driver interface
Date: Thu, 26 Jul 2007 14:49:15 -0600
Message-ID: <20070726204915.GS19275@parisc-linux.org>
References: <11854705774041-git-send-email-matthew@wil.cx> <46A8F689.108@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60530 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbXGZUtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 16:49:20 -0400
Content-Disposition: inline
In-Reply-To: <46A8F689.108@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2007 at 03:31:21PM -0400, Jeff Garzik wrote:
> 1) you should propagate pci_enable_device return value to caller on error

ok.  I'll return -ENODEV if I don't get a Scsi_Host back, though.
Unless you think it's worth going through the PTR_ERR/IS_ERR/ERR_PTR
hooplah.  It's not like this is "what's scrogging my filesystem", it's
"my driver didn't load".

> 2) you dropped the check for pci_resource_start() returning zero (look 
> for 'iop == 0' in original code)

That's not actually something that could happen through that path.

> 3) what happened to PCI BAR #1 ?  shouldn't you move that call here too? 
>  it gets ioremapped (look at 'pci_memory_address' in old code, right 
> next to pci_resource_start call)

That'll move later, once I'm on the iomap path.  We don't have the
structure to stash the result in at this point.

> 4) it is often wise to add sanity checks that ensure that PCI BAR #0 == 
> IORESOURCE_IO and PCI BAR #1 == IORESOURCE_MEM

Why is that?  There's no danger of advansys producing any more cards ;-)

> 5) call pci_set_drvdata(pdev, NULL) as with other PCI drivers

Why?

> 6) suggestions:  tab alignment for struct member values; makes it far 
> easier to read.

ok

> 7) bug: don't unregister, if pci_register_driver() failed during init

I assumed that pci_unregister_driver handled that, for the same reason that
kfree(NULL) works.  Otherwise I have to keep track of that in the driver
somewhere.

> >+	for (i = 0; i < asc_board_count; i++) {
> >+		struct Scsi_Host *host = asc_host[i];
> >+		if (!host)
> >+			continue;
> >+		scsi_remove_host(host);
> >+		advansys_release(host);
> >+		asc_host[i] = NULL;
> 
> this last line of code is rather pointless, isn't it?

No ... see advansys_interrupt.  Yes, that needs to be cleaned up *too*,
but I can't fix everything at once.  Eventually, the asc_host array will
disappear.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
