From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: final scsi_host_put in ->remove()?
Date: Mon, 29 Sep 2003 23:41:08 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030929134108.GA12018@twibble.org>
References: <Pine.LNX.4.53.0309290733480.1740@montezuma.fsmlabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:65468 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S263371AbTI2Nln (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 09:41:43 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0309290733480.1740@montezuma.fsmlabs.com>
List-Id: linux-scsi@vger.kernel.org
To: Zwane Mwaikambo <zwane@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org, willy@debian.org

On Mon, Sep 29, 2003 at 07:48:48AM -0400, Zwane Mwaikambo wrote:
[...]
> An updated driver such as NCR_D700 has the following in it's ->remove()
> path. Whilst sym53c8xx_2 doesn't have any scsi_remove_host at all,
> dc395x.c does

Well, I wouldn't trust the dc395x driver since I'm responsible for
that one ;)

> static void NCR_D700_remove_one(struct Scsi_Host *host)
> {
> 	scsi_remove_host(host);
> 	NCR_700_release(host);
> 	kfree((struct NCR_700_Host_Parameters *)host->hostdata[0]);
> 	free_irq(host->irq, host);
> 	release_region(host->base, 64);
> }
> 
> Is it possible that scsi_remove_host does the final put? In which case 

The scsi_remove_host just removes devices from the host (calls back
via the slave_destroy template function) and removes various other
external references to the host structure such as from the scsi bus
in sysfs, and the proc entry etc. It does not remove the host
structure itself, so it's still safe to use the host structure at
this point but nothing else should be using.

> using the host pointer afterwards wouldn't be safe. Otherwise wouldn't a 
> scsi_host_put be required in that function? The scsi_remove_host section 

Yes. I think it needs a scsi_host_put and the end of the function.

The sym53c8xx_2 looks wrong to me. It appears to need a scsi_host_put
and the end of sym_detach. It also doesn't call scsi_remove_host
either.... which I suspect it probably should be doing.

-- 
 Jamie Lenehan <lenehan@twibble.org>
