From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/2] scsi_scan: Send TEST UNIT READY to the LUN before
 scanning
Date: Wed, 11 Jun 2014 15:25:31 +0000
Message-ID: <1402500330.2523.31.camel@dabdike.int.hansenpartnership.com>
References: <1401953203-103015-1-git-send-email-hare@suse.de>
			 <1401953203-103015-2-git-send-email-hare@suse.de>
		 <1402496658.2523.7.camel@dabdike.int.hansenpartnership.com>
		 <539868C2.50406@suse.de>
	 <1402498000.2523.11.camel@dabdike.int.hansenpartnership.com>
	 <53987222.6060600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:36655 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbaFKPZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 11:25:33 -0400
In-Reply-To: <53987222.6060600@suse.de>
Content-Language: en-US
Content-ID: <E1B02F68DE685D4A93CF3B000E33C356@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "elliot@hp.com" <elliot@hp.com>

On Wed, 2014-06-11 at 17:13 +0200, Hannes Reinecke wrote:
> On 06/11/2014 04:46 PM, James Bottomley wrote:
> > On Wed, 2014-06-11 at 16:33 +0200, Hannes Reinecke wrote:
> >> On 06/11/2014 04:24 PM, James Bottomley wrote:
> >>> On Thu, 2014-06-05 at 09:26 +0200, Hannes Reinecke wrote:
> >>>> REPORT_LUN_SCAN does not report any outstanding unit attention
> >>>> condition as per SAM. However, the target might not be fully
> >>>> initialized at that time, so we might end up getting a
> >>>> default entry (or even a partially filled one).
> >>>> But as we're not able to process the REPORT LUN DATA HAS CHANGED
> >>>> unit attention correctly we'll be missing out some LUNs during
> >>>> startup.
> >>>> So it's better to send a TEST UNIT READY for modern implementations
> >>>> and wait until the unit attention condition goes away.
> >>>
> >>> Are you sure this is a good idea: we just spent ages tuning SCSI init so
> >>> we don't slow systems down.  This patch, in the event the array is
> >>> having a power on problem, takes us right back to waiting for init
> >>> again ... basically the busy wait in scsi_test_lun.
> >>>
> >>> Since the array should send us a UA anyway when it's got itself sorted
> >>> out, what's wrong with just processing the report luns data has changed
> >>> condition?
> >>>
> >> Because we can't.
> >>
> >> _If_ we were attempting this we'd run into several issues:
> >> a) Boot will fail, as REPORT LUNs will return 0 LUNs (or just LUN 0).
> >>      So the scanning code will assume everything's fine. Booting will
> >>      continue, only to figure out that no LUNs are present.
> >>      As there is _no_ indication that REPORT LUNs should indeed have
> >>      returned an error (only it can't due to SAM) we wouldn't even
> >>      now that there _is_ an issue.
> >>      (In fact, that's what triggered the patchset in the first place.)
> >> b) Even _if_ we're able so somehow recover from that we will have
> >>      to rescan the host and any attached devices.
> >>      The only way to do this currently is to _remove_ all devices
> >>      from that host and then do a full rescan.
> >>      Trying this with any devices which are already part of some
> >>      complex setup will become ... interesting.
> >
> > OK, go back to first principles and tell us what the actual problem is,
> > with traces and details.  Is this some weird SCSI-3 device with a single
> > LUN that's screwing up report luns ... in which case we can just
> > blacklist it.  Or is it boot from an array?
> >
> The problem is as follows:
> 
>  > Right after the "inquiry" the scsi subsystem sends a "report luns"
>  > to the RAID array.
>  > The RAID answers the "report luns" with only the 8 byte header
>  > and an empty (i.e. not existing) LUN list after this header
>  > because the LUNs still execute their initialization phase and
>  > did not reach their ready state yet.
>  > The RAID manufacturer describes this behaviour as an indication
>  > for: "there are no LUNs available".
>  >
>  > Then immediately follows a "test unit ready" command from the
>  > scsi subsystem to LUN 0  which is answered by the RAID firmware
>  > with a "check condition"  "not ready, initialisation in progress".
>  >
> As per SPC 'REPORT LUN' cannot return any check condition.
> So we cannot distinguish by evaluating the 'REPORT LUN' response
> whether it refers to a valid response or not.
> 
> Hence my approach to send a TEST UNIT READY prior to REPORT LUN,
> as this would return any outstanding unit attention codes and
> we can wait until the initialisation is finished.
> Plus we're sending a TEST UNIT READY anyway when we're scanning
> the LUN from sd.c:spin_up_disk(), so in effect we're just
> moving the call.
> 
> >> So the easy way out here is indeed just to send a TEST UNIT READY.
> >> And as we're checking for a reasonably SCSI compliance we should
> >> be catching most of the oddballs.
> >
> > I don't object hugely to TUR ... except it binds us to spin up because
> > most devices will respond not ready.  I do object to busy waiting in the
> > init thread until we get the right answer.
> >
> The problem is indeed in SPC:
> 
> The REPORT LUNS parameter data should be returned even though the 
> device server is not ready for other commands. The report of the 
> logical unit inventory should be available without incurring any 
> media access delays. If the device server is not ready with the 
> logical unit inventory or if the inventory list is null for the
> requesting I_T nexus and the SELECT REPORT field set to 02h, then 
> the device server shall provide a default logical unit inventory 
> that contains at least LUN 0 or the REPORT LUNS well known logical 
> unit (see 8.2). A non-empty peripheral device logical unit inventory 
> that does not contain either LUN 0 or the REPORT LUNS
> well known logical unit is valid.
> 
> So the above array is perfectly within spec.

What array is this?  Presumably its a server box with an internal array?

I'm not really bothered about what the spec allows; most things boot
from physical (or virtual) discs.  In the 99.99% case report luns just
works as we expect.  We can't damage boot for the 0.01% case.

If it's just a single array, we can use the INQUIRY tag to add a
blacklist that either waits for it to be ready or does an automatic boot
timeout.  If we do this generally, the specific problem you're going to
cause is SAN connected arrays.  Chances are at some point one of them
will go into this condition and every booting system on the SAN will
then do an unexpected and unnecessary wait.

James

