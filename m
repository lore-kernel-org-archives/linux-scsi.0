From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi device recovery
Date: Thu, 13 Dec 2007 09:18:33 -0500
Message-ID: <1197555513.3154.30.camel@localhost.localdomain>
References: <200712121354.14474.bs@q-leap.de>
	 <200712121536.10665.bs@q-leap.de>
	 <1197475177.4203.29.camel@localhost.localdomain>
	 <200712121854.42669.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:34139
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833AbXLMOSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 09:18:41 -0500
In-Reply-To: <200712121854.42669.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>


On Wed, 2007-12-12 at 18:54 +0100, Bernd Schubert wrote:
> [Hmm, resending since mail after more than 30min still not on the ML, maybe 
> the attachment was too large? I have uploaded the log to 
> http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/scsi/kern.log.1]
> 
> On Wednesday 12 December 2007 16:59:36 James Bottomley wrote:
> > On Wed, 2007-12-12 at 15:36 +0100, Bernd Schubert wrote:
> > > On Wednesday 12 December 2007 14:39:27 Matthew Wilcox wrote:
> > > > On Wed, Dec 12, 2007 at 01:54:14PM +0100, Bernd Schubert wrote:
> > > > > below is a patch introducing device recovery, trying to prevent i/o
> > > > > errors when a DID_NO_CONNECT or SOFT_ERROR does happen.
> > > >
> > > > Why doesn't the regular scsi_eh do what you need?
> > >
> > > First of all, it is presently simply not called when the two errors above
> > > do happen. This could be changed, of course.
> >
> > Erm, I think you'll find the error handler does activate on
> > DID_SOFT_ERROR.  It causes a retry via the eh.  DID_NO_CONNECT is an
> 
> Dec  7 23:48:45 beo-96 kernel: [94605.297924] sd 2:0:5:0: [sdd] Result: 
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
> Dec  7 23:48:45 beo-96 kernel: [94605.297932] end_request: I/O error, dev sdd, 
> sector 7706802052
> Dec  7 23:48:45 beo-96 kernel: [94605.297937] raid5:md5: read error not 
> correctable (sector 871932472 on sdd3).

This is some type of ioc internal error.  What we do on DID_SOFT_ERROR
is retry for the usual number of times up to the timeout limit.
Unfortunately, the retries are fixed at SD_MAX_RETRIES in sd.c.  Without
diagnosing what's going wrong in the fusion, it's impossible to say if
this is reasonable, but your fusion is signalling ioc errors (firmware
errors).

> Full log attached.
> 
> > immediate error with no eh intervention because it means that the target
> > went away.  Handling this as a retryable error isn't an option because
> > it will interfere with hotplug.
> 
> Then we need a sysfs flag one can set to manually enable eh for these devices
> on DID_NO_CONNECT. 

No, because that will seriously damage a lot of other systems.

The DID_NO_CONNECT looks to be a genuine reselection issue caused by a
device out of spec on the bus.  The SPI standard says a device should
respond in 250ms, which is what most HBA's take as the default selection
timeout.  I'd say for the device you have, you need to increase this.
Unfortunately doing this for the fusion is some type of mode page
setting, I think, but I don't have the doc in front of me.  I'd be
amenable to putting the selection timeout as a parameter in the spi
transport class, since others might find it valuable occasionally to
control.

> >
> > > Secondly, I think scsi_eh is in most cases doing too much. We are
> > > fighting with flaky Infortrend boxes here, and scsi_eh sometimes manages
> > > to crash their scsi channels. In most cases it is sufficient to stall any
> > > io to the device and then to resume.
> >
> > But that's basically the default behaviour of the error handler (stall
> > then resume).
> >
> > > For most scsi devices one probably doesn't need a suspend time or it can
> > > be very small, this still needs to become configurable via sysfs.
> >
> > You mean a wait time beyond what the error handler currently does
> > (basically it waits for the quiesce, begins error handling and then
> > sends a test unit ready when it finishes before restarting).
> 
> In deh just waits on the first error and then only does a DV. For 
> these infortrend devices, thats mostly sufficient.

> > > Thirdly, scsi_eh doesn't give up, in most cases, when the scsi channel of
> > > a Infortrend box crashed, it tried forever to recover.
> > > To improve this is still on my todo list.
> >
> > Could you send traces for this.  I thought the error handler had been
> > fixed over the last few years always to terminate.  If there's a case
> > where it doesn't, this needs fixing.
> 
> I'm attaching the syslog, this is 2.6.22 + additional printks, dump_stack()'s
> and msleep()'s.
> At 03:59:36 the system finally went into wait_for_completion(), similar
> to the "everything in wait_for_completion, what is my system doing?" thread.

This looks like a genuine bug.  I missed the thread, since my email
system went off line while I was on holiday for two weeks.  The symptoms
look to be lost commands, but I can't see why from the traces.  There's
a known bug where we can hang in domain validation because of a resource
starvation issue, but I know of none where everything hangs just after
error recovery completes.

James


