From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/7] print eh activation
Date: Wed, 03 Dec 2008 09:16:30 -0600
Message-ID: <1228317390.5551.13.camel@localhost.localdomain>
References: <200811261840.45360.bs@q-leap.de>
	 <200811261844.02732.bs@q-leap.de>
	 <1227725222.3387.19.camel@localhost.localdomain>
	 <200812031219.20662.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52627 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbYLCPQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 10:16:28 -0500
In-Reply-To: <200812031219.20662.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-12-03 at 12:19 +0100, Bernd Schubert wrote:
> On Wednesday 26 November 2008 19:47:02 James Bottomley wrote:
> > On Wed, 2008-11-26 at 18:44 +0100, Bernd Schubert wrote:
> > > Print activation of the scsi error handler to let the user know what was
> > > the the error handler was activated. These information are essential to
> > > diagnose hardware issues.
> >
> > But it can be turned on already with SCSI logging ... at least the
> > activation message.  I don't think we want this to be printed all the
> > time, because the error handler can be activated in non-error situations
> > for some HBAs (like sense collection for non-ACA emulating drivers).
> 
> Sorry for the late reply, I didn't have access to my mails for a few days. 
> 
> Actually I entirely disagree, activating the error handler should be an 
> exception and as such exception, it shall print it was activated and also the 
> reason why it was activated. Without these information we see quite often in 
> our logs something like:
> 
> [12165690.357905] mptscsih: ioc1: attempting task abort! (sc=ffff81012a957500)
> [12165690.357966] sd 3:0:1:0:
> [12165690.358018]         command: cdb[0]=0x28: 28 00 37 10 e9 4f 00 00 08 00
> [12165690.732712] mptbase: ioc1: IOCStatus(0x0048): SCSI Task Terminated
> [12165690.733699] mptscsih: ioc1: task abort: SUCCESS (sc=ffff81012a957500)
> 
> But this gives you no chance to see, where it comes from. After adding the 
> additional printks from my patch, we recognized the error handler was 
> activated mostly due to command timeouts. So increasing the timeouts to >90s 
> already solved 2/3rds of our problems. Please also see patch nr. 6, the 
> additional printks did help me to recognize always only one special scsi 
> command fails.

But surely what you're arguing for then, is a printk on command timeout?

> In my opinion, if a driver needs the error handler for specific actions, we 
> should create another interface for that. Could you please point me to such a 
> non-ACA river?
> I also only see two calling functions of scsi_eh_scmd_add(), namely 
> scsi_times_out() and scsi_softirq_done() and only for these calls the 
> additinal printks will be done (since scmd is required to do the printks).

Mostly we converted the in-use drivers, but things like the parallel
port drivers still use this mechanism.

James


