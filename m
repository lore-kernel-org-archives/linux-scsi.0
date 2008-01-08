From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: [RFC] Implementation of SCSI dynamic power management
Date: Tue, 8 Jan 2008 21:24:30 +0000
Message-ID: <20080108212430.GB5050@ucw.cz>
References: <200801072131.05755.oliver@neukum.org> <Pine.LNX.4.44L0.0801071632180.6739-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2800 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752104AbYAHV56 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jan 2008 16:57:58 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801071632180.6739-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>


> > > When all the devices under a host are suspended, the LLD is informed 
> > > (via a new "autosuspend" method in the host template) so that it can
> > 
> > That is most certainly a mistake.
> 
> Why?
> 
> > Is there a good reason to not modify
> > to extend suspend() to take an extra argument for the reason it is called?
> 
> In fact suspend methods already do take an argument specifying the
> reason they were called.  It wouldn't be hard to add a couple of extra 
> PM_EVENT_* values for manual suspend and autosuspend.  The problem is 
> that resume methods don't take a corresponding argument.

Well, you could store the value in struct device or something.

There's other problem: if autosuspend is != NULL, you know device
supports autosuspend.

If you call existing suspend(PMSG_AUTOSUSPEND), and driver does not
support it, it will crash and burn.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
