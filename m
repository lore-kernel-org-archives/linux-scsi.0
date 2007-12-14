From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH] scsi device recovery
Date: Fri, 14 Dec 2007 13:04:12 +0100
Message-ID: <200712141304.12490.bs@q-leap.de>
References: <200712121354.14474.bs@q-leap.de> <200712121854.42669.bs@q-leap.de> <1197555513.3154.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:39635 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbXLNMEO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Dec 2007 07:04:14 -0500
In-Reply-To: <1197555513.3154.30.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

Hello James,

On Thursday 13 December 2007 15:18:33 James Bottomley wrote:
> On Wed, 2007-12-12 at 18:54 +0100, Bernd Schubert wrote:
> > [Hmm, resending since mail after more than 30min still not on the ML,
> > maybe the attachment was too large? I have uploaded the log to
> > http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/scsi/kern.log.1]
> >
> > On Wednesday 12 December 2007 16:59:36 James Bottomley wrote:
> > > On Wed, 2007-12-12 at 15:36 +0100, Bernd Schubert wrote:
> > > > On Wednesday 12 December 2007 14:39:27 Matthew Wilcox wrote:
> > > > > On Wed, Dec 12, 2007 at 01:54:14PM +0100, Bernd Schubert wrote:
> > > > > > below is a patch introducing device recovery, trying to prevent
> > > > > > i/o errors when a DID_NO_CONNECT or SOFT_ERROR does happen.
> > > > >
> > > > > Why doesn't the regular scsi_eh do what you need?
> > > >
> > > > First of all, it is presently simply not called when the two errors
> > > > above do happen. This could be changed, of course.
> > >
> > > Erm, I think you'll find the error handler does activate on
> > > DID_SOFT_ERROR.  It causes a retry via the eh.  DID_NO_CONNECT is an
> >
> > Dec  7 23:48:45 beo-96 kernel: [94605.297924] sd 2:0:5:0: [sdd] Result:
> > hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
> > Dec  7 23:48:45 beo-96 kernel: [94605.297932] end_request: I/O error, dev
> > sdd, sector 7706802052
> > Dec  7 23:48:45 beo-96 kernel: [94605.297937] raid5:md5: read error not
> > correctable (sector 871932472 on sdd3).
>
> This is some type of ioc internal error.  What we do on DID_SOFT_ERROR
> is retry for the usual number of times up to the timeout limit.
> Unfortunately, the retries are fixed at SD_MAX_RETRIES in sd.c.  Without
> diagnosing what's going wrong in the fusion, it's impossible to say if
> this is reasonable, but your fusion is signalling ioc errors (firmware
> errors).

besides this seems to be a fusion driver or firmware problem, I still think eh 
is not activated for this error. I'm not absulutely sure, but I think with my 
patch deh and later on eh would be triggered, wouldn't it?

>
> > Full log attached.
> >
> > > immediate error with no eh intervention because it means that the
> > > target went away.  Handling this as a retryable error isn't an option
> > > because it will interfere with hotplug.
> >
> > Then we need a sysfs flag one can set to manually enable eh for these
> > devices on DID_NO_CONNECT.
>
> No, because that will seriously damage a lot of other systems.

How would it, if we create a device specific sysfs parameter defaulting to 
off? If you think users could activate it by accident, we could also print a 
big warning when the paramter is read from userspace.
Furthermore, as far as I did understand you, DID_NO_CONNECT is only required 
for hotplugging. But real scsi doesn't do automatic hotplugging, does it? One 
always needs to do it manually, e.g. with scsiadd or similar tools. So is 
DID_NO_CONNECT really required for native scsi? If not, we also could make 
the scsi-drivers to set a flag to activate eh on DID_NO_CONNECT.

>
> The DID_NO_CONNECT looks to be a genuine reselection issue caused by a
> device out of spec on the bus.  The SPI standard says a device should
> respond in 250ms, which is what most HBA's take as the default selection
> timeout.  I'd say for the device you have, you need to increase this.
> Unfortunately doing this for the fusion is some type of mode page
> setting, I think, but I don't have the doc in front of me.  I'd be
> amenable to putting the selection timeout as a parameter in the spi
> transport class, since others might find it valuable occasionally to
> control.

Its of course optimal to fix the real cause of our problems. I have ask 
Infortrend now which value should be used for their devices.

Eric, I would be greatful if you could point me to the code fragment using or 
setting the respond timeout.


[...]

> > I'm attaching the syslog, this is 2.6.22 + additional printks,
> > dump_stack()'s and msleep()'s.
> > At 03:59:36 the system finally went into wait_for_completion(), similar
> > to the "everything in wait_for_completion, what is my system doing?"
> > thread.
>
> This looks like a genuine bug.  I missed the thread, since my email
> system went off line while I was on holiday for two weeks.  The symptoms
> look to be lost commands, but I can't see why from the traces.  There's
> a known bug where we can hang in domain validation because of a resource
> starvation issue, but I know of none where everything hangs just after
> error recovery completes.

Since still not much happend to solve this bug, shall I create a bugzilla 
entry?


Thanks a lot,
Bernd

PS: Do you have some links to scsi and SPI specs? 

-- 
Bernd Schubert
Q-Leap Networks GmbH
