From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: 13 Jun 2004 13:06:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087153573.3172.24.camel@patibmrh9>
References: <1086710016.3647.4.camel@patibmrh9><40C8FB79.1050706@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:42701 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265247AbUFMTG0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2004 15:06:26 -0400
In-Reply-To: <40C8FB79.1050706@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

> The underlying serial protocols used by sATA and SAS do
> seem to be in units of "dwords" (i.e. 4 byte quantities).
> I have noticed several SCSI standards changing the maximum
> allocation length of a one byte field (e.g. in an INQUIRY
> and MODE SENSE(6) ) from 255 to 252. The intent seems to be
> to have lengths that are multiples of 4.

Aye, analogously, I remember noticing that t10.org op x7F claims to max
out CDB length at x104 rather than the x107 that that additional length
could express.

> > 			int vn = 0;
> > 			if (0 <= ioctl(fd, SG_GET_VERSION_NUM, &vn)) {
> > 				if (vn < 30000) {
> > 					perror("ioctl SG_GET_VERSION_NUM");
> > 					continue;
> > 				}
> 
> Note: I have started to drop this SG_GET_VERSION_NUM ioctl()
> check. It is still needed in the special case where the sg
> driver is working asynchronously (i.e. sending commands with
> write() and receiving the response with read() ).

Help?

I thought the purpose of ioctl SG_GET_VERSION_NUM was to avoid sending
ioctl SG_IO on a Linux so old that ioctl SG_IO meant something
different.

Is that wrong?  Can I expect Linux to behave reasonably whenever I
assault it with a root-privileged ioctl SG_IO, no matter what the ioctl
SG_GET_VERSION_NUM results are?

> > 	sih->dxferp = static_data;
> > 	sih->dxfer_len = 0x24;
> > 	sih->dxfer_direction = SG_DXFER_NONE;
> > 	sih->dxfer_direction = SG_DXFER_TO_DEV;
> > 	sih->dxfer_direction = SG_DXFER_FROM_DEV;
> 
> The three above lines look a bit strange :-)

Help?  Why strange?

These three lines exist because I can easily reorder them to change
quickly among the three main options of expecting data in, data out, or
no data.  Commenting out the two lines that have no effect would
actually make that edit more difficult.

Maybe your ":-)" means you understood that?

> Perhaps you could sent me the "strace" of this failure so
> I can have a closer look at what is going on.

I will try to remember to strace next time I report a failing ioctl.

I will believe the progress of this thread has obsoleted that specific
request unless you say different.

> > Can ioctl SG_IO fetch the offset 7 Additional Length field of op x03
> > "REQUEST SENSE" data?
> > 
> > Naively I thought yes of course, I know that works with /dev/scd$n.
> > 
> > But then I tried a /dev/hd$v ide-floppy.  No joy.  perror tells me ioctl
> > SG_IO fails via "Invalid argument", ...
> 
> My method with the SG_IO ioctl was to yield errnos
> if the SCSI command could not be sent (or was rejected
> at the point of transmission). So if there is an errno
> there will be no sense buffer (or any other valid
> response data).

This much I did understand correctly from the doc.

I did eventually write:

	ii = ioctl(fd, SG_IO, sih);
	if (ii < 0) {
		perror("ioctl SG_IO");
		... die ...
	} else {
		fwrite(sih->dxferp, sih->dxfer_len, 1, stdout);
		if ((sih->info & SG_INFO_OK_MASK) != SG_INFO_OK) {
			... die ...
		} else if (sih->resid != 0) {
			... die ...
		}
		...
	}

The case that falls thru without "die"ing is my guess of when SG_IO
actually has reported complete success.

Pat LaVarre


