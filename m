From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi device recovery
Date: Wed, 12 Dec 2007 10:59:36 -0500
Message-ID: <1197475177.4203.29.camel@localhost.localdomain>
References: <200712121354.14474.bs@q-leap.de>
	 <20071212133927.GI26334@parisc-linux.org> <200712121536.10665.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:40151
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382AbXLLP7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2007 10:59:43 -0500
In-Reply-To: <200712121536.10665.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org


On Wed, 2007-12-12 at 15:36 +0100, Bernd Schubert wrote:
> On Wednesday 12 December 2007 14:39:27 Matthew Wilcox wrote:
> > On Wed, Dec 12, 2007 at 01:54:14PM +0100, Bernd Schubert wrote:
> > > below is a patch introducing device recovery, trying to prevent i/o
> > > errors when a DID_NO_CONNECT or SOFT_ERROR does happen.
> >
> > Why doesn't the regular scsi_eh do what you need?
> 
> First of all, it is presently simply not called when the two errors above do 
> happen. This could be changed, of course.

Erm, I think you'll find the error handler does activate on
DID_SOFT_ERROR.  It causes a retry via the eh.  DID_NO_CONNECT is an
immediate error with no eh intervention because it means that the target
went away.  Handling this as a retryable error isn't an option because
it will interfere with hotplug.

> Secondly, I think scsi_eh is in most cases doing too much. We are fighting 
> with flaky Infortrend boxes here, and scsi_eh sometimes manages to crash 
> their scsi channels. In most cases it is sufficient to stall any io to the 
> device and then to resume.

But that's basically the default behaviour of the error handler (stall
then resume).

> For most scsi devices one probably doesn't need a suspend time or it can be 
> very small, this still needs to become configurable via sysfs.

You mean a wait time beyond what the error handler currently does
(basically it waits for the quiesce, begins error handling and then
sends a test unit ready when it finishes before restarting).

> Thirdly, scsi_eh doesn't give up, in most cases, when the scsi channel of a 
> Infortrend box crashed, it tried forever to recover.
> To improve this is still on my todo list.

Could you send traces for this.  I thought the error handler had been
fixed over the last few years always to terminate.  If there's a case
where it doesn't, this needs fixing.

James


