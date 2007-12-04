From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Read errors on Flash Drive Transcend TS1GJF2A
Date: Tue, 4 Dec 2007 13:03:12 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0712041254590.13516-100000@iolanthe.rowland.org>
References: <47558FE9.4090400@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53244 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750954AbXLDSDN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 13:03:13 -0500
In-Reply-To: <47558FE9.4090400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, RTE <raszilki@yandex.ru>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 4 Dec 2007, Boaz Harrosh wrote:

> perhaps below hunk should be added to your patch.

It looks like a good idea.

> Was it decided when this data corruption bugfix is
> merged.

I don't know -- I haven't heard anything back from James.

> Also in sr.c. It does the range check but it might
> enjoy the resid handling as well.

I think the range checking in sr.c is completely wrong.  The code
doesn't check carefully to see that the error sector lies within the
range of sectors being accessed; there's a possibility of overflow if
the capacity is larger than 2**31 bytes.  Also this line in particular
makes no sense:

		error_sector &= ~(block_sectors - 1);

Like you said, using the residue value too wouldn't hurt.

Furthermore the check for the Valid bit is done wrongly:

		if (!(SCpnt->sense_buffer[0] & 0x90))

This will never be true because of the earlier test:

        if (driver_byte(result) != 0 &&         /* An error occurred */
            (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */

It probably should test against 0x80 instead of 0x90.

Alan Stern

