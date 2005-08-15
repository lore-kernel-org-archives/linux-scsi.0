From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [-mm PATCH 29/32] drivers/scsi: fix-up schedule_timeout() usage
Date: Mon, 15 Aug 2005 13:42:13 -0700
Message-ID: <20050815204213.GA4746@us.ibm.com>
References: <20050815180514.GC2854@us.ibm.com> <1124138067l.3920l.7l@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:29643 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S964934AbVHOUmV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 16:42:21 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j7FKgGdi208244
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 16:42:16 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7FKgH3q123120
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 14:42:17 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7FKgEwa031995
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 14:42:15 -0600
Content-Disposition: inline
In-Reply-To: <1124138067l.3920l.7l@serve.riede.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: James.Bottomley@SteelEye.com, matthew@wil.cx, markus.lidel@shadowconnect.com, andrew.vasquez@qlogic.com, akpm@osdl.org, linux-scsi@vger.kernel.org

On 15.08.2005 [20:34:27 +0000], Willem Riede wrote:
> On 08/15/2005 02:27:51 PM, Nishanth Aravamudan wrote:
> > Description: Use schedule_timeout_uninterruptible() instead of
> > set_current_state()/schedule_timeout() to reduce kernel size.
> > 
> > Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> > 
> > ---
> > 
> >  drivers/scsi/osst.c           |    9 +++------
> >
> > diff -urpN 2.6.13-rc5-mm1/drivers/scsi/osst.c
> > 2.6.13-rc5-mm1-dev/drivers/scsi/osst.c
> > --- 2.6.13-rc5-mm1/drivers/scsi/osst.c	2005-08-07 10:05:21.000000000
> > -0700
> > +++ 2.6.13-rc5-mm1-dev/drivers/scsi/osst.c	2005-08-12
> > 13:42:13.000000000 -0700
> > @@ -862,8 +862,7 @@ static int osst_recover_wait_frame(struc
> >  				retval = osst_write_error_recovery(STp,
> > aSRpnt, 0);
> >  				break;
> >  			}
> > -			set_current_state(TASK_INTERRUPTIBLE);
> > -			schedule_timeout (HZ / OSST_POLL_PER_SEC);
> > +			schedule_timeout_interruptible(HZ /
> OSST_POLL_PER_SEC);
> 
> Others have suggested using msleep in osst instead of schedule, which I think
> is 
> more appropriate.

That's my fault, you are right, a patch for msleep() usage in OSST
already exists in the latest -KJ patchset and covers all these changes.
I tried to avoid collisions between existing changes in -KJ and these
new ones in -MM, but must have missed this one.

Thanks,
Nish
