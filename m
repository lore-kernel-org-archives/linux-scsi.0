From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Sat, 28 Jun 2003 16:12:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030628161219.A6160@infradead.org>
References: <20030627110259.A3751@infradead.org> <Pine.LNX.4.44L0.0306271347250.774-100000@ida.rowland.org> <20030627190434.A10771@infradead.org> <20030627192321.GA3338@beaverton.ibm.com> <20030628093403.A8591@infradead.org> <3EFDAF74.3030301@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:21252 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265256AbTF1O6L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jun 2003 10:58:11 -0400
Content-Disposition: inline
In-Reply-To: <3EFDAF74.3030301@pobox.com>; from jgarzik@pobox.com on Sat, Jun 28, 2003 at 11:08:36AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, Jun 28, 2003 at 11:08:36AM -0400, Jeff Garzik wrote:
> The future netdev api could be summarized as
> 
> 	alloc_<foo>dev -- allocate structure, init
> 	register_netdev[ice] -- register
> 	unregister_netdev[ice] -- unregister

Yeah, this maps nicely to

	scsi_host_alloc, scsi_add_host, scsi_remove_host

> 	release_netdev -- unref

This is the final scsi_host_put.

> We actually have this now, once you do s/kfree(dev)/release_netdev(dev)/

But what's more interesting are the driver model core changes to mark
a struct (class_)device dead so it won't ever call back into the driver.

IIRC DaveM's words correctly this was the central part of the netdev
refcounting changes.

