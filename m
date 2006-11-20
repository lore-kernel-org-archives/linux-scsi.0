From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH RESEND 2/2] SCSI: add scsi_device->retries
Date: Mon, 20 Nov 2006 23:42:21 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0611202332281.6260@kai.makisara.local>
References: <20061119125115.GJ2184@htj.dyndns.org> <20061119125200.GK2184@htj.dyndns.org>
 <Pine.LNX.4.64.0611200001230.4946@kai.makisara.local> <4560E950.9000209@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kolumbus.fi ([193.229.0.46]:47825 "EHLO mail.kolumbus.fi")
	by vger.kernel.org with ESMTP id S966691AbWKTVlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 16:41:11 -0500
In-Reply-To: <4560E950.9000209@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Mon, 20 Nov 2006, Tejun Heo wrote:

> Hello,
> 
> Kai Makisara wrote:
> > > * st uses three retry limits - MAX_RETRIES, MAX_WRITE_RETRIES and
> > >   MAX_READY_RETRIES, which are all zero.  This patch only converts
> > >   MAX_RETRIES to sdev->retries.  Defining WRITE and READY retries in
> > >   terms of sdev->retries would make more sense.
> > >
> > I am neither acking nor naking this now. The patch does not change st
> > behavior but moves part of the retry strategy out of the driver. (Which is
> > also good because it makes one of the retry limits user changeable.)
> > 
> > Combining all retry counts is something that may not be a good thing. Below
> > is justification why st has three different retry limits.
> > 
> > For some devices one number of retries is not perfect for all functions.
> > 
> > The firmware of tape devices usually retries quite thoroughly before
> > returning error. This is why the default zero applies to most cases.
> > 
> > MAX_WRITE_RETRIES is separate from MAX_RETRIES because a plausible strategy
> > might be (maybe not any more) to allow no retries for write but allow
> > retries for reading and repositioning. The writes should fail directly so
> > that the minimum number of marginal errors will be written. The reads can be
> > retried so that even marginal data can be recovered. (Note that this may
> > lead to tape positioning errors and may not be a good strategy in all
> > cases.)
> > 
> > MAX_READY_RETRIES is used for commands that don't move the tape. This is a
> > situation where retrying is probably harmless.
> 
> I see.  Then, how about adding and initializing STp->write_retries and
> STp->ready_retries according to SDp->retries (some reasonable default value,
> say write_retries is always zero while ready_retries is round up of retries *
> 1.1) and export both through sysfs?  That will give lower level primitive
> control as other ULDs do and also allow users to configure each timeout
> separately if necessary.
> 
When I made the timeouts user changeable (using ioctl), I also thought 
about making retries changeable. However, there did not seem to be any 
real need to change the retry limits and I postponed the implementation. 
Now it would be easy to implement with sysfs but it may be still best to 
postpone that until someone asks for that feature.

One possibility would be to transform the different retry limit philosophy 
into a comment in the source and use lowlevel retry limit for all 
commands. The different limits are actually comments also now because I 
don't think anyone changes the defaults. (If anyone does, please tell us!)

If this is done, I will have the suspicion that someone some time changes 
the low-level retry limit to other than zero without knowing what this 
does to tapes.

-- 
Kai
