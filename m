From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: iRiver H100 series and usb-storage issues
Date: 07 Jun 2004 16:27:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086647263.3137.134.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0406071616200.666-100000@ida.rowland.org><87y8m
	zukwk.fsf@ceramic.fifi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:30114 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265099AbUFGW1x
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jun 2004 18:27:53 -0400
In-Reply-To: <87y8mzukwk.fsf@ceramic.fifi.org>
List-Id: linux-scsi@vger.kernel.org
To: Philippe Troin <phil@fifi.org>
Cc: linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>

Philippe T:

> I was pointing out I am mostly clueless
> w.r.t. USB.  ... what about:
> 
>   usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
>   usb-storage: usb_stor_bulk_msg() returned 0 xferred 0/512
>   usb-storage: Bulk data transfer result 0x1
>   usb-storage: Attempting to get CSW...
>                ^^^^^^^^^^^^^^^^^^^^^^^^
>   usb-storage: clearing endpoint halt for pipe 0xc0011e80
>   usb-storage: usb_stor_clear_halt: result=0
>   usb-storage: Attempting to get CSW (2nd try)...
>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   usb-storage: Bulk status result = 0
>   usb-storage: Bulk status Sig 0x53425355 T 0x945 R 512 Stat 0x0
>   usb-storage: -- unexpectedly short transfer
>   usb-storage: Issuing auto-REQUEST_SENSE

Knowing only SCSI over USB, not Linux or USB, I'd guess ...

This is a completely ordinary trace of two popular design choices made
by this SCSI over USB device.  First, this device chose to copy less
than the expected count of bytes in.  Second, this device chose to
STALL, rather than copying the bytes in and trusting the host to notice
nonzero dCSWDataResidue.

What's ironic here is that the Linux USB layer understands entirely that
the STALL redundantly with the "CSW" "R 512" means "unexpectedly short
transfer" ... but we're told the layers above don't get it, all the
same.

The op x03 "REQUEST SENSE" here is inappropriate - it is unsolicited -
the "CSW" "Stat" was not x01 AutoSenseMe, it was x00 Passed, expressed
here as "Stat 0x0".

I'm thinking usb-storage has to remove that inappropriate "REQUEST
SENSE", else usb-storage cannot be passing correct status back up?

usb-storage cannot correctly say that it autosensed SK ASC ASCQ zero,
because usb-storage only fetched unsolicited sense, not auto sense. 
usb-storage cannot say it saw a failure without sense, because
usb-storage did think it auto sensed.

Yes?

But after all that, maybe sd still will ignore the error and miscompare?

Pat LaVarre


