From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Asynchronous target discovery, version 10
Date: Mon, 24 Jul 2006 10:24:07 -0600
Message-ID: <20060724162407.GH29603@parisc-linux.org>
References: <20060721155710.GB9214@parisc-linux.org> <44C4CF1E.8090700@emulex.com> <20060724150223.GG29603@parisc-linux.org> <44C4ECA8.2050007@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:26082 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751379AbWGXQYI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 12:24:08 -0400
Content-Disposition: inline
In-Reply-To: <44C4ECA8.2050007@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Jack Steiner <steiner@sgi.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Anton Blanchard <anton@samba.org>, Justin Chen <justin.chen@hp.com>

On Mon, Jul 24, 2006 at 11:52:08AM -0400, James Smart wrote:
> Matthew Wilcox wrote:
> >On Mon, Jul 24, 2006 at 09:46:06AM -0400, James Smart wrote:
> >>- I disagree with the handing off of a function pointer, with no real
> >>  bounds on it's "lifetime". There are windows with the current code
> >>  that if the driver were to then fail attachment and tear down
> >>  the shost, it would lead to bogus function calls, as well as
> >>  threads, etc that are essentially orphaned.
> >
> >Can't happen; we take a reference on the shost and only release it once
> >it's done:
> >
> >        data->shost = scsi_host_get(shost);
> 
> True for the scsi host data structure itself. But, not true for the driver
> which has essentially torn down the contents of the data structure and
> killed the adapter, making the state checking code perhaps erroneous...
> and if the state checking code is hosed, then the thread may never get a
> positive, so it and the async scan is hanging out...

If the shost still has a reference, then we still have the hostdata
available.  I'm comfortable with the driver having to change the
contents of the hostdata to make any subsequent call to *finished return
true.

> >I'm open to this.  I think what I'd prefer to see is the FC drivers
> >setting a SHT->scan_finished() method, then calling scsi_scan_host()
> >which would then do something completely different for drivers which
> >have a scan_finished method than it would for SPI drivers.
> 
> Isn't it enough that they (essentially via the transport) are calling
> scsi_scan_target() ?  We should be able to handle it there.

I don't see how that's possible.  The requirement is to set the
shost->async_scan() flag and add ourselves to the list of scanning
hosts before we scan the first target (easy), then after we think we've
discovered all the targets, we need to sleep until all hosts with prior
claims have finished their scans, add our own devices, and get out of the
way for other hosts.

Most of this work is done by scsi_prep_async_scan and
scsi_finish_async_scan(), the trick is calling them at the right time.
The most recent posted patch did this through scsi_target_discovery(),
but it could be done by the driver, transport or some other way in the
midlayer.  I just noticed an interesting race in that patch; if the
transport is calling scsi_scan_target() at the same time we call
scsi_finish_async_scan(), we can get the same device added twice.  Bad.

> >Yes, indeed.  It occurs to me that the async scanning code does actually
> >give us a chance to sort devices before they get added to sysfs (and
> >named).  I don't understand the exact problem that FC has, but this
> >could give us back the sort order that you had when you were doing your
> >own discovery, right?
> 
> Not really. And it really has nothing to do with the before and after of
> your patch. What you propose just suffers from the same realities for FC.
> Basically, you have no guarantee that:
> - All devices are up and ready for discovery list when you go to probe.
>   They may not show up for a little while while the device or link settles.
> - There is any repeated order in which the rports are reported to you
>   via the nameserver lists
> - nor how fast the targets respond to your discovery requests
> and is compounded by whether the driver/firmware does discovery in parallel,
> how it processes addresses and nameserver lists, and by the target id's
> being non-persistently assigned at each boot.

Right.  I'm saying that before we call scsi_finish_async_scan(), we could
do a sort on the devices found.  They're all hanging off shost->__devices.
I'm not sure what criteria you used to use to get a persistent sort
order in the past.

> >Clearly I haven't done a good enough job explaining how this patch
> >works.  I'm going to do a design document now ...
> 
> I didn't think it was that bad. And perhaps my missing your tutorial with
> Andrew/Eric was my problem.

Sure, but at some point I'm going to have to explain it to the zfcp
maintainer, the SAS people and maybe even the SATA people.

