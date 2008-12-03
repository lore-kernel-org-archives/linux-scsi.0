From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH 1/7] print eh activation
Date: Wed, 3 Dec 2008 16:52:58 +0100
Message-ID: <200812031652.58723.bs@q-leap.de>
References: <200811261840.45360.bs@q-leap.de> <200812031219.20662.bs@q-leap.de> <1228317390.5551.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:53691 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYLCPxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2008 10:53:03 -0500
In-Reply-To: <1228317390.5551.13.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday 03 December 2008 16:16:30 James Bottomley wrote:
> On Wed, 2008-12-03 at 12:19 +0100, Bernd Schubert wrote:
> > On Wednesday 26 November 2008 19:47:02 James Bottomley wrote:
> > > On Wed, 2008-11-26 at 18:44 +0100, Bernd Schubert wrote:
> > > > Print activation of the scsi error handler to let the user know what
> > > > was the the error handler was activated. These information are
> > > > essential to diagnose hardware issues.
> > >
> > > But it can be turned on already with SCSI logging ... at least the
> > > activation message.  I don't think we want this to be printed all the
> > > time, because the error handler can be activated in non-error
> > > situations for some HBAs (like sense collection for non-ACA emulating
> > > drivers).
> >
> > Sorry for the late reply, I didn't have access to my mails for a few
> > days.
> >
> > Actually I entirely disagree, activating the error handler should be an
> > exception and as such exception, it shall print it was activated and also
> > the reason why it was activated. Without these information we see quite
> > often in our logs something like:
> >
> > [12165690.357905] mptscsih: ioc1: attempting task abort!
> > (sc=ffff81012a957500) [12165690.357966] sd 3:0:1:0:
> > [12165690.358018]         command: cdb[0]=0x28: 28 00 37 10 e9 4f 00 00
> > 08 00 [12165690.732712] mptbase: ioc1: IOCStatus(0x0048): SCSI Task
> > Terminated [12165690.733699] mptscsih: ioc1: task abort: SUCCESS
> > (sc=ffff81012a957500)
> >
> > But this gives you no chance to see, where it comes from. After adding
> > the additional printks from my patch, we recognized the error handler was
> > activated mostly due to command timeouts. So increasing the timeouts to
> > >90s already solved 2/3rds of our problems. Please also see patch nr. 6,
> > the additional printks did help me to recognize always only one special
> > scsi command fails.
>
> But surely what you're arguing for then, is a printk on command timeout?

I'm arguing that calling the error handler is a rare exception and that the 
admin wants to know what has caused this exception. This is also nothing
you want to enable with scsi logging, since it mostly errors happen after 
weeks when the system is already in production and nobody then has error
logging active.

Another example for the timeouts patch:

sd 6:0:2:2: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
sd 6:0:2:2: [sdk] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
sd 6:0:2:2: Activating scsi error recovery (1)
sd 6:0:2:2: trying to abort command
qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df2 20


So without the printk patch you would see many messages like these:

qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df2 20
qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df2 20
qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df2 20
qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df2 20
qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df2 20

But you wouldn't have an idea why and which command was aborted. Eventually
this will cause a severe failure of qla2xxx driver, but you never would
figure out the underlying reason. Actually, I wouldn't mind to suppress these
driver messages, but the eh activation printks are essential to understand
what is going.

>
> > In my opinion, if a driver needs the error handler for specific actions,
> > we should create another interface for that. Could you please point me to
> > such a non-ACA river?
> > I also only see two calling functions of scsi_eh_scmd_add(), namely
> > scsi_times_out() and scsi_softirq_done() and only for these calls the
> > additinal printks will be done (since scmd is required to do the
> > printks).
>
> Mostly we converted the in-use drivers, but things like the parallel
> port drivers still use this mechanism.

Thanks, going to check these now.


Cheers,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
