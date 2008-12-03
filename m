From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH 2/7] Allow requeuement on DID_SOFT_ERROR
Date: Wed, 3 Dec 2008 18:06:01 +0100
Message-ID: <200812031806.02179.bs@q-leap.de>
References: <200811261840.45360.bs@q-leap.de> <200812031700.50334.bs@q-leap.de> <1228321762.5551.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:59537 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYLCRGI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2008 12:06:08 -0500
In-Reply-To: <1228321762.5551.23.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday 03 December 2008 17:29:22 James Bottomley wrote:
> On Wed, 2008-12-03 at 17:00 +0100, Bernd Schubert wrote:
> > On Wednesday 03 December 2008 16:16:31 James Bottomley wrote:
> > > On Wed, 2008-12-03 at 13:17 +0100, Bernd Schubert wrote:
> > > > On Wednesday 26 November 2008 19:47:47 James Bottomley wrote:
> > > > > On Wed, 2008-11-26 at 18:46 +0100, Bernd Schubert wrote:
> > > > > > Activate the error handler if DID_SOFT_ERROR failed to often, but
> > > > > > only for commands which have a scmd->allowed > 1.
> > > > > > Also make a function out of a goto-block.
> > > > >
> > > > > What is the rationale for this?  It really doesn't look right since
> > > > > DID_SOFT_ERROR is supposed to be for temporary out of resource
> > > > > conditions in the HBA driver ... activating the error handler isn't
> > > > > really going to fix this because the eh is taking us through a
> > > > > state model for device conditions, which DID_SOFT_ERROR shouldn't
> > > > > be.
> > > >
> > > > What do you suggest instead of? Just returning an I/O error without
> > > > even to try to recover the device isn't nice.
> > >
> > > it doesn't do that ... it retries up to the retry limit before failing
> > > the command.  There is an argument that we should treat this as other
> > > temporary resource conditions like BUSY and QUEUE_FULL, so return
> > > ADD_TO_MLQUEUE.  On the other hand, DID_REQUEUE already does that, so
> > > this would lose the only unconditional DID_ code going generically
> > > through the retry path.
> > >
> > > > > If you just need a DID_FAIL to activate the eh, it can be added
> > > > > without changing the meaning of DID_SOFT_ERROR.
> > > > >
> > > > > Also, you changed the return to make it device blocking (which also
> > > > > doesn't look right) but didn't document that in the change log.
> > > >
> > > > Last year you suggested to switch from NEEDS_RETRY to ADD_TO_MLQUEUE
> > > >
> > > > http://www.mail-archive.com/linux-scsi%40vger.kernel.org/msg12475.htm
> > > >l
> > > >
> > > > When I wrote the patch documentation, I already forgot about it,
> > > > sorry. Unfortunately, it didn't help much for our devices. So I made
> > > > it to activate the eh only, if it fails too often. With activated eh,
> > > > devices sometimes can be recovered. But I'm certainly grateful for
> > > > any hints to further improve recovery and to prevent i/o errors.
> > >
> > > Well, what exactly is the problem?  changing to ADD_TO_MLQUEUE will
> > > retry intermittently up to the command timeout.  If activating the
> > > error handler actually fixes the problem, then the driver was probably
> > > wrongly returning DID_SOFT_ERROR.
> >
> > Well, I have certainly no experience with hardware/driver programming but
> > all drivers I have looked at, seem to use DID_SOFT_ERROR as something
> > like DID_UNKNOWN_ERROR.
>
> DID_SOFT_ERROR means specifically that the driver ran into a resource or
> other soft (as in retryable) error.
>
> > I certainly do not insist on using ADD_TO_MLQUEUE instead of NEEDS_RETRY
> > and I will happlily modify the patch, if you think NEEDS_RETRY is better.
> > But I would really prefer to try to recover the device when
> > DID_SOFT_ERROR came up. I mean without the eh we get an I/O error anyway.
> > So as last attempt to try to do some device resets won't hurt, will it?
>
> Yes, it will on a SAN.  For an error condition internal to the driver
> what is the point of causing external disruptions to the devices?

Hrm, right. For SAN it is really a problem :(

>
> > And I have really seen some successful mpt fusion device recoveries.
>
> Well, my guess there would be the internal sequencer is hosed and the
> host reset corrected it, is that right?  In which case, there might be a
> place where mpt fusion is returning DID_SOFT_ERROR incorrectly.

Well, these DID_SOFT_ERRORs are not easily reproducibly. If they would, I 
already would have debugged it more in detail.

Any idea what we can do?

Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
