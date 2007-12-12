From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH] scsi device recovery
Date: Wed, 12 Dec 2007 18:54:42 +0100
Message-ID: <200712121854.42669.bs@q-leap.de>
References: <200712121354.14474.bs@q-leap.de> <200712121536.10665.bs@q-leap.de> <1197475177.4203.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:38174 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbXLLRyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2007 12:54:44 -0500
In-Reply-To: <1197475177.4203.29.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

[Hmm, resending since mail after more than 30min still not on the ML, maybe 
the attachment was too large? I have uploaded the log to 
http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/scsi/kern.log.1]

On Wednesday 12 December 2007 16:59:36 James Bottomley wrote:
> On Wed, 2007-12-12 at 15:36 +0100, Bernd Schubert wrote:
> > On Wednesday 12 December 2007 14:39:27 Matthew Wilcox wrote:
> > > On Wed, Dec 12, 2007 at 01:54:14PM +0100, Bernd Schubert wrote:
> > > > below is a patch introducing device recovery, trying to prevent i/o
> > > > errors when a DID_NO_CONNECT or SOFT_ERROR does happen.
> > >
> > > Why doesn't the regular scsi_eh do what you need?
> >
> > First of all, it is presently simply not called when the two errors above
> > do happen. This could be changed, of course.
>
> Erm, I think you'll find the error handler does activate on
> DID_SOFT_ERROR.  It causes a retry via the eh.  DID_NO_CONNECT is an

Dec  7 23:48:45 beo-96 kernel: [94605.297924] sd 2:0:5:0: [sdd] Result: 
hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Dec  7 23:48:45 beo-96 kernel: [94605.297932] end_request: I/O error, dev sdd, 
sector 7706802052
Dec  7 23:48:45 beo-96 kernel: [94605.297937] raid5:md5: read error not 
correctable (sector 871932472 on sdd3).

Full log attached.

> immediate error with no eh intervention because it means that the target
> went away.  Handling this as a retryable error isn't an option because
> it will interfere with hotplug.

Then we need a sysfs flag one can set to manually enable eh for these devices
on DID_NO_CONNECT. 

>
> > Secondly, I think scsi_eh is in most cases doing too much. We are
> > fighting with flaky Infortrend boxes here, and scsi_eh sometimes manages
> > to crash their scsi channels. In most cases it is sufficient to stall any
> > io to the device and then to resume.
>
> But that's basically the default behaviour of the error handler (stall
> then resume).
>
> > For most scsi devices one probably doesn't need a suspend time or it can
> > be very small, this still needs to become configurable via sysfs.
>
> You mean a wait time beyond what the error handler currently does
> (basically it waits for the quiesce, begins error handling and then
> sends a test unit ready when it finishes before restarting).

In deh just waits on the first error and then only does a DV. For 
these infortrend devices, thats mostly sufficient.

>
> > Thirdly, scsi_eh doesn't give up, in most cases, when the scsi channel of
> > a Infortrend box crashed, it tried forever to recover.
> > To improve this is still on my todo list.
>
> Could you send traces for this.  I thought the error handler had been
> fixed over the last few years always to terminate.  If there's a case
> where it doesn't, this needs fixing.

I'm attaching the syslog, this is 2.6.22 + additional printks, dump_stack()'s
and msleep()'s.
At 03:59:36 the system finally went into wait_for_completion(), similar
to the "everything in wait_for_completion, what is my system doing?" thread.


Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
