From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] SCSI's heuristics for enabling WRITE SAME still need
 work [was: dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 14:39:45 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309241415380.31619@file01.intranet.prod.int.rdu2.redhat.com>
References: <20130919161043.GA27081@redhat.com> <20130920212142.GA17898@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab3IXSjs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Sep 2013 14:39:48 -0400
In-Reply-To: <20130920212142.GA17898@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org



On Fri, 20 Sep 2013, Mike Snitzer wrote:

> On Thu, Sep 19 2013 at 12:13pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Workaround the SCSI layer's problematic WRITE SAME heuristics by
> > disabling WRITE SAME in the DM multipath device's queue_limits if an
> > underlying device disabled it.
> 
> ...
> 
> > This fix doesn't help configurations that have additional devices
> > stacked ontop of the mpath device (e.g. LVM created linear DM devices
> > ontop).  A proper fix that restacks all the queue_limits from the bottom
> > of the device stack up will need to be explored if SCSI will continue to
> > use this model of optimistically allowing op codes and then disabling
> > them after they fail for the first time.

Propagating the limits up the tree won't work anyway because of a race 
condition. Think of this case:

1. We test queue limits and find out that the device supports WRITE_SAME
2. We build a WRITE_SAME bio to be submitted.
3. The user reconfigures a device so that it no longer supports WRITE_SAME 
(for example, he adds a snapshot or converts linear volume to a mirror).
4. We submit the bio that we built in step 2.
5. The bio fails.


I think the correct solution is to specify that WRITE SAME request may 
fail anytime and the caller is responsible for retrying with normal WRITE 
request if WRITE SAME failed.

If the caller needs to send WRITE SAME, it should try to send it and if it 
fails, set a flag that the device doesn't support WRITE SAME and not send 
WRITE SAME in the future. (we could also reset that flag after some long 
time, in case the device was reconfigured to support WRITE SAME).


> I really don't think we can afford to keep SCSI's current heuristics for
> enabling WRITE SAME, re-stating them for the benefit of others:
> 1) check if WRITE SAME is supported by sending REPORT SUPPORTED
>    OPERATION CODES to the device
> 2a) if REPORT SUPPORTED OPERATION CODES shows WRITE SAME is supported,
>     enable WRITE SAME
> 2b) if REPORT SUPPORTED OPERATION CODES shows WRITE SAME is not
>     supported, disable WRITE SAME
> 2c) if REPORT SUPPORTED OPERATION CODES isn't supported _and_ the device
>     doesn't have an ATA Information VPD page: enable WRITE SAME
>     - if/when WRITE SAME does fail, disable it on the failing device
> 
> AFAIK the reason for these heuristics is: devices that do support WRITE
> SAME cannot properly report as much because they don't support REPORT
> SUPPORTED OPERATION CODES -- this lack of RSOC support is apparently
> very common?
> 
> I can appreciate the idea behind the current heuristics but I think the
> prevelence of the other side of the spectrum (SCSI devices that don't
> support RSOC or WRITE SAME) was underestimated.  As such we're seeing a
> fair amount of WRITE SAME error noise on these systems -- that noise is
> itself considered a bug to many.
> 
> Also, please see my comment in a related Fedora 19 BZ:
> https://bugzilla.redhat.com/show_bug.cgi?id=995271#c23
> 
> As I say in that comment:
> "A proper fix could be to make SCSI's default be to disable WRITE SAME
> for devices that don't properly report they support it.  And possibly
> have a whitelist to opt-in to enabling WRITE SAME for select targets."
> 
> I'm open to any ideas you might have.
> 
> Thanks,
> Mike

What does happend if we send WRITE SAME to a disk that doesn't support it? 
If we only get "Invalid field in CDB" or similar sense code, we could just 
propagate it up and let the caller retry.

If we could get something worse (firmware crash), we must blacklist it.



Another idea: we could kill the REQ_WRITE_SAME flag entirely - if the some 
subsystem needs to clear some area of a disk, it builds a bio with all 
vector entries pointing to the zero page. Drivers that don't support WRITE 
SAME (such as IDE) will implement it doing DMA from the zero page. Drivers 
that support WRITE SAME can detect this special case and convert a normal 
WRITE request to WRITE SAME. The request is converted to WRITE SAME at the 
lowest level (in the SCSI driver), it passes as normal WRITE request 
through dm and md midlayers - thus, we magically get WRITE SAME support in 
all md and dm drivers without writing additional code for it.

Mikulas
