From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fill in scsi_host_template module owner
Date: Wed, 2 May 2007 09:37:07 +0100
Message-ID: <20070502083707.GA24804@infradead.org>
References: <200704301653.56687.okir@lst.de> <20070430160233.GA27438@infradead.org> <200705021007.44764.okir@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42818 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992907AbXEBIhI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2007 04:37:08 -0400
Content-Disposition: inline
In-Reply-To: <200705021007.44764.okir@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Kirch <okir@lst.de>
Cc: linux-scsi@vger.kernel.org

[please don't remove me from the To: or Cc: line, please - I tend
to read personal email much faster than list traffic, and it's the
normal policy for most kernel development lists these days]

On Wed, May 02, 2007 at 10:07:43AM +0200, Olaf Kirch wrote:
> On Monday 30 April 2007 18:02, Christoph Hellwig wrote:
> >  - a driver should handle hot unplugs proper, even if THIS_MODULE
> >    is set this can happen if the hardware just goes away.
> 
> In the case of the iscsi bug I looked at, it wasn't so much the
> hardware going away, it was the rmmod that was kind of hurtful ;)

In the iscsi case this is true as it's not a traditional driver
with a ->remove method that is called on a hot unplug.  Every pci
or usb driver needs to handle hot removal, though.  And yes, I expect
a lot of lingering bug in those areas outside of the few drivers used
on modern highend systems.

> I also thought about adding something like this to
> scsi_add_host:
> 
> +       if (sht->module == NULL && sht->queuecommand &&
> +           !core_kernel_text((unsigned long) sht->queuecommand))
> +               printk(KERN_ERR "%s: didn't set module owner field\n", sht->name);
> 
> But maybe that's overdoing things a little.

->queuecommand is also mandatory, so you could remove the check for it
beeing present, but I think this is really overding things a little.
