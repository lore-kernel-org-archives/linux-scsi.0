From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Retry scsi_mode_sense if UNIT ATTENTION occurs
Date: Tue, 29 Jul 2003 17:10:38 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307291705430.6177-100000@ida.rowland.org>
References: <Pine.LNX.4.56.0307292319140.3939@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:20228 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S272129AbTG2VKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 17:10:40 -0400
In-Reply-To: <Pine.LNX.4.56.0307292319140.3939@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 29 Jul 2003, Kai Makisara wrote:

> On Mon, 28 Jul 2003, Alan Stern wrote:
> 
> > Jens:
> >
> > This patch changes the scsi_mode_sense() routine to retry up to a total of
> > 3 times if a command fails with a UNIT ATTENTION sense key value.
> >
> This is dangerous or makes __scsi_mode_sense usable only in special cases.
> Some high-level drivers need to process the UNIT ATTENTION sense data.

I don't know what you're talking about.  __scsi_mode_sense() is called
only from a very few places within sr.c and sd.c, and none of the calling
routines pays any notice to the sense data.

> > Without this change, sr.c does not properly read the capabilities mode
> > page for a just-powered-up cdrom drive -- it gives up upon receiving a
> > Device Reset Occurred code.
> >
> One alternative is to move the retry code upwards to scsi_mode_sense and
> document that it may discard UNIT ATTENTION. Those drivers that can't
> tolerate this can then use __scsi_mode_sense. This would solve the sr
> problem.

But scsi_mode_sense() allocates its own struct scsi_request, whereas the 
callers in sd.c already have one available.

I wouldn't object to documenting in both scsi_mode_sense() and 
__scsi_mode_sense() that UNIT ATTENTION sense data is discarded.

Alan Stern

