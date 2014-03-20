From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [LSF/MM TOPIC] atomic block device
Date: Thu, 20 Mar 2014 16:10:50 -0400
Message-ID: <x49ob107hrp.fsf@segfault.boston.devel.redhat.com>
References: <CAA9_cmf7Y1TL8XqR7dYUn=Pv-En2e0X0FM0zdpkiBkUuNBGKfQ@mail.gmail.com>
	<1392487335.2178.5.camel@dabdike.int.hansenpartnership.com>
	<CABBL8E+dQPi=N108+z97F54o=xg7vYk5T1JCBGY+9UetiC6qTg@mail.gmail.com>
	<1392495902.2178.27.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075AbaCTULE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2014 16:11:04 -0400
In-Reply-To: <1392495902.2178.27.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Sat, 15 Feb 2014 12:25:02 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Rudoff <andy@rudoff.com>, Dan Williams <dan.j.williams@intel.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, david@fromorbit.com, Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, Bryan E Veal <bryan.e.veal@intel.com>, Annie Foong <annie.foong@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Lameter <christoph@lameter.com>

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> OK, so what the Database people are currently fretting about is how the
> Linux cache fights with the WAL.  Pretty much all DBs sit on filesystems
> these days, so the first question is are block operations even relevant

Yes, they are relevant so long as there are users.  Not all databases
run on file systems.  More to the point, I think the spec includes them
for completeness.

> and do the (rather scant) file operations fit their need.  The basic
> problem with the file mode is the granularity.  What does a DB do with
> transactions which go over the limits?

s/transactions/atomic multiwrites?  There are a couple of options,
there.  You could either emulate the multiwrite transparently to the
application, or you could fail it.  I think we'd have to support both,
since some applications will not want the less performant fallback.

> It also looks like the NVM file actions need to work over DIO, so the
> question is how.

DIO just means avoid using the page cache (or, I guess you could make it
more generic by saying avoid double buffering).  If the hardware
supports atomic writes, then this is easy.  If it doesn't, then we can
still do the emulation.  DIO already has fallback to buffered, so it's
not like we always honor that flag.

> (And the other problem is that only a few DBs seem to use DIO).

This is the first time I have ever heard anyone state that not using DIO
was a problem.  :-)  Also, I'm not sure what problem you are thinking
of.  Perhaps you are referring to the interactions of the WAL and the
page cache (that you mentioned in the first paragraph).

Cheers,
Jeff
