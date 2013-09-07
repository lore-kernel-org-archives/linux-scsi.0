From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] scsi: sr: use block layer runtime PM
Date: Sat, 7 Sep 2013 11:22:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309071117110.31321-100000@netrider.rowland.org>
References: <522B40C3.2080605@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:52205 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751385Ab3IGPWu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Sep 2013 11:22:50 -0400
In-Reply-To: <522B40C3.2080605@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 7 Sep 2013, Aaron Lu wrote:

> >>> Note that due to ODD will be polled every 2 seconds,
> >>
> >> Since the device will be polled every 2 seconds
> >>
> >>>  for suspend to
> >>> actually happen, the autosuspend_delay can not be set to more than 2
> >>> seconds or the polling interval has to be increased.
> >>
> >> Is this true?  What about event driven devices?  Supposing a distro has
> >> a different interval.
> >>
> >> How about
> >>
> >> If your Distribution polls the device, the autosuspend interval cannot
> >> be set to longer than the polling interval otherwise the device will
> >> never suspend.
> > 
> > The default polling done by the kernel uses 2-second intervals.  Of 
> > course, distributions and users can change this or disable it entirely.
> 
> What about:
> Note that due to the device will be polled by kernel at a constant
> interval specified at /sys/module/block/parameters/events_dfl_poll_msecs,
> the default value is 2 seconds, the autosuspend delay cannot be set to
> longer than the polling interval otherwise the device will never suspend.

Well, I wouldn't say "cannot" -- people can set the delay to whatever
they want.  Just: If the autosuspend delay is set longer than the
polling interval then the device will never suspend.

Also, the actual polling interval is controlled by
/sys/block/sdX/events_poll_msec.  The file you mentioned merely
contains the default polling interval used for new devices.

Alan Stern

