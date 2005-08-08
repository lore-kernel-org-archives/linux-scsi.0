From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 08 Aug 2005 18:20:21 -0400
Message-ID: <42F7DAA5.7070208@adaptec.com>
References: <Pine.LNX.4.44L0.0508081517000.4454-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:11991 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932284AbVHHWUj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 18:20:39 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508081517000.4454-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>

On 08/08/05 16:41, Alan Stern wrote:
> I still have one related question.  This is a little bit off to one 
> side, but maybe you folks can suggest possible solutions.  The question 
> concerns a deadlock I _was_ able to generate earlier today with a patched
> usb-storage.
> 
> My USB mass-storage test device doesn't respond to TEST UNIT READY, so it
> causes a timeout and kicks the error handler into action.  This happens 
> during device scanning, just prior to reading the partition table.  The 
> error handler goes through various stages of processing, leading up to a 
> bus reset.  I disconnected the USB device just before the bus reset 
> routine was called.

I think that "scanning" is a special process which should involve
the minimum of error handling, by either ignoring errors and trying
to connect to the device anyway, or on the first error, give up
the device.  Which policy would one follow depends on the transport.

If the latter, you need to blacklist the device as not supporting
TUR.  Then on any error, like you pulling the cable during scanning,
the scanning process will give up and all will be well.

	Luben
