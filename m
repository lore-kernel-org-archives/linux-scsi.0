From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: aic94xx driver woes continued
Date: Sat, 29 Mar 2008 15:39:18 -0700 (PDT)
Message-ID: <663394.20251.qm@web31802.mail.mud.yahoo.com>
References: <1206043027.3038.48.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31802.mail.mud.yahoo.com ([68.142.207.65]:35836 "HELO
	web31802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750963AbYC2WjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 18:39:19 -0400
In-Reply-To: <1206043027.3038.48.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

--- On Thu, 3/20/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Thu, 2008-03-20 at 20:15 +0100, Raoul Bhatia [IPAX]
> wrote:
> > James Bottomley wrote:
> > > This is all normal.  Seagate drives are known for
> throwing protocol
> > > errors under stress at certain revs of firmware. 
> That's what
> > > REQ_TASK_ABORT, reason=0x6 is.
> > > 
> > > Your logs indicate that the recovery occurred
> correctly (as in all tasks
> > > were eventually retried), so it doesn't show
> an actual problem.
> > 
> > ok, i already filed a trouble ticket at seagate - lets
> see if they
> > provide a firmware update for the disks. afaik mine is
> "firmware 0002"
> > 
> > >> sometimes even a disk is kicked out of the
> raid configuration.
> > > 
> > > This would be abnormal, if you have a log of
> this, could you post it.  I
> > > assume it was because of I/O errors?
> > 
> > i attached a bigger syslog file (.gz format).
> 
> OK, this looks more definitive, thanks!
> 
> What appears to be happening is that you get a run of
> protocol errors,
> not necessarily all on the same command, but what happens
> every time (by
> current design of the aic94xx driver) is that we halt the
> aic94xx, abort
> all the outstanding commands and resubmit them.  Because
> the disk is
> being hammered, there are rather a lot, so all it takes is
> five protocol
> errors in a few seconds for one unlucky command to get
> aborted five
> times (not necessarily through any fault of its own) and
> run out of
> retries.  This causes it to return to the upper layers with
> DID_ABORT
> and be treated as an I/O error.
> 
> A work around might be to lower the queue depth to say 4 or
> 8 and up the
> retries (this latter can only be done by altering the
> SD_MAX_RETRIES
> parameter in include/scsi/sd.h and recompiling).
> 
> Longer term, I think REQ_TASK_ABORT needs to be handled
> better on the
> fly.  What we should do is abort only the task we've
> been asked to abort
> and return it to the upper layer for a retry without
> invoking the error
> handler ... I can look into this, but it will take a while.

The original driver, from which you forked off, has always supported
this correct (SCSI) behaviour.

   Luben

