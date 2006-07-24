From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] Asynchronous target discovery, version 10
Date: Mon, 24 Jul 2006 11:52:08 -0400
Message-ID: <44C4ECA8.2050007@emulex.com>
References: <20060721155710.GB9214@parisc-linux.org> <44C4CF1E.8090700@emulex.com> <20060724150223.GG29603@parisc-linux.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38550 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751145AbWGXPwN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 11:52:13 -0400
In-Reply-To: <20060724150223.GG29603@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Jack Steiner <steiner@sgi.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Anton Blanchard <anton@samba.org>, Justin Chen <justin.chen@hp.com>



Matthew Wilcox wrote:
> On Mon, Jul 24, 2006 at 09:46:06AM -0400, James Smart wrote:
>> - I disagree with the handing off of a function pointer, with no real
>>   bounds on it's "lifetime". There are windows with the current code
>>   that if the driver were to then fail attachment and tear down
>>   the shost, it would lead to bogus function calls, as well as
>>   threads, etc that are essentially orphaned.
> 
> Can't happen; we take a reference on the shost and only release it once
> it's done:
> 
>         data->shost = scsi_host_get(shost);

True for the scsi host data structure itself. But, not true for the driver
which has essentially torn down the contents of the data structure and
killed the adapter, making the state checking code perhaps erroneous...
and if the state checking code is hosed, then the thread may never get a
positive, so it and the async scan is hanging out...

> I'm open to this.  I think what I'd prefer to see is the FC drivers
> setting a SHT->scan_finished() method, then calling scsi_scan_host()
> which would then do something completely different for drivers which
> have a scan_finished method than it would for SPI drivers.

Isn't it enough that they (essentially via the transport) are calling
scsi_scan_target() ?  We should be able to handle it there.

Calling scsi_scan_host(), with non-async scan enabled, doesn't seem the
right thing.

> Yes, indeed.  It occurs to me that the async scanning code does actually
> give us a chance to sort devices before they get added to sysfs (and
> named).  I don't understand the exact problem that FC has, but this
> could give us back the sort order that you had when you were doing your
> own discovery, right?

Not really. And it really has nothing to do with the before and after of
your patch. What you propose just suffers from the same realities for FC.
Basically, you have no guarantee that:
- All devices are up and ready for discovery list when you go to probe.
   They may not show up for a little while while the device or link settles.
- There is any repeated order in which the rports are reported to you
   via the nameserver lists
- nor how fast the targets respond to your discovery requests
and is compounded by whether the driver/firmware does discovery in parallel,
how it processes addresses and nameserver lists, and by the target id's
being non-persistently assigned at each boot.

> Clearly I haven't done a good enough job explaining how this patch
> works.  I'm going to do a design document now ...

I didn't think it was that bad. And perhaps my missing your tutorial with
Andrew/Eric was my problem.

-- james s
