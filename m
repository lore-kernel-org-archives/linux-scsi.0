From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: [RFC] Implementation of SCSI dynamic power
 management
Date: Wed, 9 Jan 2008 10:25:27 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801091022100.4468-100000@iolanthe.rowland.org>
References: <20080108212430.GB5050@ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40717 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752008AbYAIPZ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 10:25:28 -0500
In-Reply-To: <20080108212430.GB5050@ucw.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Oliver Neukum <oliver@neukum.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 8 Jan 2008, Pavel Machek wrote:

> > In fact suspend methods already do take an argument specifying the
> > reason they were called.  It wouldn't be hard to add a couple of extra 
> > PM_EVENT_* values for manual suspend and autosuspend.  The problem is 
> > that resume methods don't take a corresponding argument.
> 
> Well, you could store the value in struct device or something.
> 
> There's other problem: if autosuspend is != NULL, you know device
> supports autosuspend.
> 
> If you call existing suspend(PMSG_AUTOSUSPEND), and driver does not
> support it, it will crash and burn.

That's right.  The problem doesn't arise in SCSI because there only the
sd driver supports suspend at all -- and now it supports autosuspend as
well.  In USB I had to add an extra "supports_autosuspend" bitflag to
the usb_driver structure.

Alan Stern

