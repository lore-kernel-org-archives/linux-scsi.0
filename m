From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/7] Allow requeuement on DID_SOFT_ERROR
Date: Wed, 03 Dec 2008 09:16:31 -0600
Message-ID: <1228317391.5551.14.camel@localhost.localdomain>
References: <200811261840.45360.bs@q-leap.de>
	 <200811261846.51644.bs@q-leap.de>
	 <1227725267.3387.20.camel@localhost.localdomain>
	 <200812031317.37096.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52630 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbYLCPQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 10:16:29 -0500
In-Reply-To: <200812031317.37096.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-12-03 at 13:17 +0100, Bernd Schubert wrote:
> On Wednesday 26 November 2008 19:47:47 James Bottomley wrote:
> > On Wed, 2008-11-26 at 18:46 +0100, Bernd Schubert wrote:
> > > Activate the error handler if DID_SOFT_ERROR failed to often, but only
> > > for commands which have a scmd->allowed > 1.
> > > Also make a function out of a goto-block.
> >
> > What is the rationale for this?  It really doesn't look right since
> > DID_SOFT_ERROR is supposed to be for temporary out of resource
> > conditions in the HBA driver ... activating the error handler isn't
> > really going to fix this because the eh is taking us through a state
> > model for device conditions, which DID_SOFT_ERROR shouldn't be.
> 
> What do you suggest instead of? Just returning an I/O error without even to 
> try to recover the device isn't nice.

it doesn't do that ... it retries up to the retry limit before failing
the command.  There is an argument that we should treat this as other
temporary resource conditions like BUSY and QUEUE_FULL, so return
ADD_TO_MLQUEUE.  On the other hand, DID_REQUEUE already does that, so
this would lose the only unconditional DID_ code going generically
through the retry path.

> >
> > If you just need a DID_FAIL to activate the eh, it can be added without
> > changing the meaning of DID_SOFT_ERROR.
> >
> > Also, you changed the return to make it device blocking (which also
> > doesn't look right) but didn't document that in the change log.
> 
> Last year you suggested to switch from NEEDS_RETRY to ADD_TO_MLQUEUE
> 
> http://www.mail-archive.com/linux-scsi%40vger.kernel.org/msg12475.html
> 
> When I wrote the patch documentation, I already forgot about it, sorry. 
> Unfortunately, it didn't help much for our devices. So I made it to activate 
> the eh only, if it fails too often. With activated eh, devices sometimes can 
> be recovered. But I'm certainly grateful for any hints to further improve 
> recovery and to prevent i/o errors. 

Well, what exactly is the problem?  changing to ADD_TO_MLQUEUE will
retry intermittently up to the command timeout.  If activating the error
handler actually fixes the problem, then the driver was probably wrongly
returning DID_SOFT_ERROR.

James


