From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Mon, 7 Jul 2014 11:54:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1407071147130.871-100000@iolanthe.rowland.org>
References: <CANudz+uUuhLdfkVSseXXHW6ugm126Q4Taau+s7wavAP=Z9=4XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51951 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751162AbaGGPye (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 11:54:34 -0400
In-Reply-To: <CANudz+uUuhLdfkVSseXXHW6ugm126Q4Taau+s7wavAP=Z9=4XA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: loody <miloody@gmail.com>
Cc: "Bryn M. Reeves" <bmr@redhat.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 7 Jul 2014, loody wrote:

> hi Bryn:
> 
> 2014-07-07 17:20 GMT+08:00 Bryn M. Reeves <bmr@redhat.com>:
> > On Sun, Jul 06, 2014 at 01:18:03AM +0800, loody wrote:
> >> hi all:
> >>     we met a USB Hard Disk that will go to suspend if host stop
> >> sending scsi command over 5mins.
> >>     To save the IO, kernel will keep the file in page cache as much as
> >> he can and under this circumstances, the scsi command may disappear
> >> for a while longer enough to cause the device suspend.
> >>
> >>     is there any kernel config or module parameter can do the dummy
> >> read or scsi command periodically?
> >
> > No but you could set up a simple cron job to call an sg3_utils command.
> >
> > E.g. issue an sg_read for one sector to the device every 4m:
> >
> >   */4 * * * * sg_read count=1 if=/dev/<disk>
> Since my target platform arm embedded system,
> does that mean I should include sg_read in my Busybox
> or
> cross-compile sg_read from sg3_utils?

An alternative is to write a positive value, such as 240000, to 

	/sys/block/sdX/events_poll_msecs

where X is replaced with the proper drive letter.  (240000 ms = 240 s = 
4 m.)  I'm not sure this will work, but it's worth a try.

Alan Stern

