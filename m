From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 2/5] scsi_error thread exits in TASK_INTERRUPTIBLE
	state.
Date: Fri, 28 Oct 2005 18:28:22 -0400
Message-ID: <1130538502.6169.21.camel@localhost.localdomain>
References: <200510282207.j9SM7WuB022257@shell0.pdx.osdl.net>
	 <1130538105.3328.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:34218 "EHLO
	ms-smtp-03.nyroc.rr.com") by vger.kernel.org with ESMTP
	id S1751911AbVJ1W2c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 18:28:32 -0400
In-Reply-To: <1130538105.3328.21.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org

On Fri, 2005-10-28 at 17:21 -0500, James Bottomley wrote:
> On Fri, 2005-10-28 at 15:07 -0700, akpm@osdl.org wrote:
> > From: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Found in the -rt patch set.  The scsi_error thread likely will be in the
> > TASK_INTERRUPTIBLE state upon exit.  This patch fixes this bug.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > Cc: James Bottomley <James.Bottomley@steeleye.com>
> > Signed-off-by: Andrew Morton <akpm@osdl.org>
> > ---
> > 
> >  drivers/scsi/scsi_error.c |    1 +
> >  1 files changed, 1 insertion(+)
> > 
> > diff -puN drivers/scsi/scsi_error.c~scsi_error-thread-exits-in-task_interruptible-state drivers/scsi/scsi_error.c
> > --- 25/drivers/scsi/scsi_error.c~scsi_error-thread-exits-in-task_interruptible-state	Fri Oct 28 15:06:03 2005
> > +++ 25-akpm/drivers/scsi/scsi_error.c	Fri Oct 28 15:06:03 2005
> > @@ -1644,6 +1644,7 @@ int scsi_error_handler(void *data)
> >  		scsi_restart_operations(shost);
> >  		set_current_state(TASK_INTERRUPTIBLE);
> >  	}
> > +	__set_current_state(TASK_RUNNING);
> ^^^^^^^^^^^^^^^^^^^^^
> >  	__set_current_state(TASK_RUNNING);
> ^^^^^^^^^^^^^^^^^^^^^
> 
> Mismerge, I think (of a patch which is already present)

Yeah, I noticed that Linus pulled it into the 2.6.14 release, since it
was a small minor fix. So this can be dropped.

-- Steve


