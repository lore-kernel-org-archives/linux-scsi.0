From: Zwane Mwaikambo <zwane@arm.linux.org.uk>
Subject: Re: final scsi_host_put in ->remove()?
Date: Mon, 29 Sep 2003 16:46:20 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0309291643410.1740@montezuma.fsmlabs.com>
References: <Pine.LNX.4.53.0309290733480.1740@montezuma.fsmlabs.com>
 <20030929134108.GA12018@twibble.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [66.212.224.118] ([66.212.224.118]:3333 "EHLO
	hemi.commfireservices.com") by vger.kernel.org with ESMTP
	id S261476AbTI2Uq2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 16:46:28 -0400
In-Reply-To: <20030929134108.GA12018@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: linux-scsi@vger.kernel.org, willy@debian.org

is itOn Mon, 29 Sep 2003, Jamie Lenehan wrote:

> On Mon, Sep 29, 2003 at 07:48:48AM -0400, Zwane Mwaikambo wrote:
> [...]
> > An updated driver such as NCR_D700 has the following in it's ->remove()
> > path. Whilst sym53c8xx_2 doesn't have any scsi_remove_host at all,
> > dc395x.c does
> 
> Well, I wouldn't trust the dc395x driver since I'm responsible for
> that one ;)

=)

> > static void NCR_D700_remove_one(struct Scsi_Host *host)
> > {
> > 	scsi_remove_host(host);
> > 	NCR_700_release(host);
> > 	kfree((struct NCR_700_Host_Parameters *)host->hostdata[0]);
> > 	free_irq(host->irq, host);
> > 	release_region(host->base, 64);
> > }
> > 
> > Is it possible that scsi_remove_host does the final put? In which case 
> 
> The scsi_remove_host just removes devices from the host (calls back
> via the slave_destroy template function) and removes various other
> external references to the host structure such as from the scsi bus
> in sysfs, and the proc entry etc. It does not remove the host
> structure itself, so it's still safe to use the host structure at
> this point but nothing else should be using.
> 
> > using the host pointer afterwards wouldn't be safe. Otherwise wouldn't a 
> > scsi_host_put be required in that function? The scsi_remove_host section 
> 
> Yes. I think it needs a scsi_host_put and the end of the function.

Thanks for the confirmation, i'll send patches in.

> The sym53c8xx_2 looks wrong to me. It appears to need a scsi_host_put
> and the end of sym_detach. It also doesn't call scsi_remove_host
> either.... which I suspect it probably should be doing.

I'll leave that one to Willy

