From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Patch to clear both bulk pipes
Date: Tue, 11 Jan 2005 13:47:42 -0800
Message-ID: <20050111134742.11b843c7@lembas.zaitcev.lan>
References: <20050111111019.7230bf4d@lembas.zaitcev.lan>
	<Pine.LNX.4.44L0.0501111541370.639-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38839 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262895AbVAKVrs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 16:47:48 -0500
In-Reply-To: <Pine.LNX.4.44L0.0501111541370.639-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, zaitcev@redhat.com

On Tue, 11 Jan 2005 16:08:20 -0500 (EST), Alan Stern <stern@rowland.harvard.edu> wrote:

> > Also, I captured a few traces with usbmon which show that the usb-storage
> > itself does absolutely nothing different in succeeding and failing case,
> > including any timing. However, the inquiry data transfer is the first
> > bulk transfer performed after the start of probing. No other transfers
> > ever fail.
> 
> I'm not sure what you mean here.  Surely usb-storage doesn't issue a 
> device reset in the succeeding case? []

All the events leading up to the failure are exactly the same in failing
and succeeding cases. So, your "device takes its sweet time" theory is
incorrect.

Of course, once the failure happens, the traces differ. Sorry, I should
have been more specific.

>[...]
> This looks like behavior I've seen on my CDRW drive.  It takes a long time 
> to respond to a SCSI command when it's first plugged in.  So the INQUIRY 
> times out and the device gets reset, then the SCSI error handler runs.

It may look like, but this time the device was NOT plugged in.

As I mentioned previously, I have investigated this behaviour while working
with ub. You can wait until you blue in the face, the device simply won't
respond until pipes are cleared and TOGGLES ARE RESET.

> > usb-storage: Command TEST_UNIT_READY (6 bytes)
> > usb-storage: Bulk Status S 0x53425355 T 0x8920 R 0 Stat 0x1
> > usb-storage: -- transport indicates command failure
> > usb-storage: Issuing auto-REQUEST_SENSE
> > usb-storage: -- Result from auto-sense is 0
> > usb-storage: -- code: 0x70, key: 0x2, ASC: 0x4, ASCQ: 0x1
> > usb-storage: Not Ready: Logical unit is in process of becoming ready
> 
> Same as before.  And once again, the error handler thinks something is 
> wrong when in fact everything is all right.
>[...]
> So usb-storage is doing everything right.  It's the SCSI error handler
> that needs to be fixed.

The recovery has to be fixed, I agree. This is something for James to
consider. And if we fix it, the recovery may be able to paper over the
problem successfully. But the original problem happens way before the
recovery.

-- Pete
