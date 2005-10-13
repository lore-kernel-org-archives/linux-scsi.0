From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH] cleanup up mpt_attach error handling
Date: Thu, 13 Oct 2005 17:36:42 -0600
Message-ID: <20051013233642.GA16174@colo.lackof.org>
References: <91888D455306F94EBD4D168954A9457C047475A4@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:65198 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S932193AbVJMX3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:29:47 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C047475A4@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2005 at 04:14:03PM -0600, Moore, Eric Dean wrote:
> > I'm also wondering if pci_disable_device() should be added to
> > the error handling code.
> 
> I guess that sounds good adding pci_disable_device().
> Can you resend with patch that handles this(failure of pci_set_dma_mask,
> and the kmalloc right below it);

I can look at this.

> as well as calling pci_disable_device() from mpt_detach() ?

I think pci_disable_device() changes should be handled seperately.
This can have nasty side effects for driver unload/load and needs
real testing before being committed to the tree.

I'm willing to do this...but not right away.
First I want to see mpt "sort of" working on parisc-linux
and then I can bang on load/unload paths.


> > +mpterr_freeirq:
...
> Howabout using out_free_irq, and out_free_ioc, instead
> of mpterr_freeirq, and mpterr_freeioc, respectively.

Sure. I just wanted to use unique names - easier to locate
when they does show up in "grep free_irq *.c" output.

I'll resubmit after I look at the two additional error cases.

cheers,
grant
