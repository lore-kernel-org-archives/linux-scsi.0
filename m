From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Linux-usb-users] Read errors on Flash Drive Transcend TS1GJF2A
Date: Wed, 05 Dec 2007 11:04:17 +0200
Message-ID: <47566991.6080200@panasas.com>
References: <Pine.LNX.4.44L0.0712041254590.13516-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56689 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXLEJEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 04:04:32 -0500
In-Reply-To: <Pine.LNX.4.44L0.0712041254590.13516-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, RTE <raszilki@yandex.ru>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Dec 04 2007 at 20:03 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 4 Dec 2007, Boaz Harrosh wrote:
> 
>> perhaps below hunk should be added to your patch.
> 
> It looks like a good idea.
> 
>> Was it decided when this data corruption bugfix is
>> merged.
> 
> I don't know -- I haven't heard anything back from James.
> 
>> Also in sr.c. It does the range check but it might
>> enjoy the resid handling as well.
> 
> I think the range checking in sr.c is completely wrong.  The code
> doesn't check carefully to see that the error sector lies within the
> range of sectors being accessed; there's a possibility of overflow if
> the capacity is larger than 2**31 bytes.  Also this line in particular
> makes no sense:
> 
> 		error_sector &= ~(block_sectors - 1);
> 
> Like you said, using the residue value too wouldn't hurt.
> 
> Furthermore the check for the Valid bit is done wrongly:
> 
> 		if (!(SCpnt->sense_buffer[0] & 0x90))
> 
> This will never be true because of the earlier test:
> 
>         if (driver_byte(result) != 0 &&         /* An error occurred */
>             (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
> 
> It probably should test against 0x80 instead of 0x90.
> 
> Alan Stern
> 
Hi Alen

Yes, I have not inspected sr.c very carefully, you are absolutely right.
Could you submit a unified patch for sd, sr and scsi.c I have hit this 
bug 2 in my error injection tests. I was doing sg_chaining tests and now
with the possibly very large requests the problem gets worse. At the time,
I could not identify the exact problem, thanks

Boaz
