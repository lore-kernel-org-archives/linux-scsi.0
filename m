From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: [example PATCH - not for applying] exclude
 certain commands
Date: Sun, 27 Apr 2003 10:04:31 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304270949150.20515-100000@netrider.rowland.org>
References: <20030426183957.C8697@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:28426 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S264622AbTD0NwQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 09:52:16 -0400
In-Reply-To: <20030426183957.C8697@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net

On Sat, 26 Apr 2003, Matthew Dharm wrote:

> This is a common misconception.  usb-storage does not need to know, in
> advance, exactly how many bytes will transfer.  It does, however, need to
> know exactly how many bytes are being requested for transfer.
> 
> There's a subtle difference there.  usb-storage can handle the case of
> underrun or overrun properly.  But there are USB<->[SCSI|ATA|whatever]
> bridges which can't handle a discrepancy between expected transfer length
> and actual transfer length when no error was detected.

I wonder about this a little, for overruns.  It's certainly true that we
detect an error and report problems when a transfer is larger than
expected (unless the expected length is exactly a multiple of the USB
packet size).  But it gets reported as DID_ERROR, indicating a possibly
transient communications problem.

This is just what Andries saw.  The MODE-SENSE commands wanted 4 bytes but
the devices insisted on sending more.  These waere reported as errors
rather than command failures (CHECK-CONDITION and so on), so the
error-handler kicked in and the same commands were retried to no avail.
That's no way to handle a systematic problem.

It would have worked better if instead we treated -EOVERFLOW as a failure, 
not an error.  Or if we had known that the device wouldn't work properly 
with a 4-byte MODE-SENSE(6) transfer.  We could have returned sense data 
that would tell the SCSI layer to try a different form of the command.

What I'm not sure about is the practicality of trying to handle things
this way.  Under what conditions is it correct to treat -EOVERFLOW during
the data phase as a failure instead of an error?  And do we want to try
and track the little foibles of many different sorts of devices so that we
can reject commands they don't handle properly?  Yes, we already do this
to some extent, but how far do we want to carry it through?

Alan Stern

