From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: iRiver H100 series and usb-storage issues
Date: Tue, 8 Jun 2004 10:24:55 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406081019281.1222-100000@ida.rowland.org>
References: <1086647263.3137.134.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5636 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265211AbUFHOYz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 10:24:55 -0400
In-Reply-To: <1086647263.3137.134.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: Philippe Troin <phil@fifi.org>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, James Bottomley <James.Bottomley@steeleye.com>

On 7 Jun 2004, Pat LaVarre wrote:

> What's ironic here is that the Linux USB layer understands entirely that
> the STALL redundantly with the "CSW" "R 512" means "unexpectedly short
> transfer" ... but we're told the layers above don't get it, all the
> same.
> 
> The op x03 "REQUEST SENSE" here is inappropriate - it is unsolicited -
> the "CSW" "Stat" was not x01 AutoSenseMe, it was x00 Passed, expressed
> here as "Stat 0x0".
> 
> I'm thinking usb-storage has to remove that inappropriate "REQUEST
> SENSE", else usb-storage cannot be passing correct status back up?
> 
> usb-storage cannot correctly say that it autosensed SK ASC ASCQ zero,
> because usb-storage only fetched unsolicited sense, not auto sense. 
> usb-storage cannot say it saw a failure without sense, because
> usb-storage did think it auto sensed.
> 
> Yes?

The log you saw was from an older version of the kernel.  The current
version does not autosense in this situation.  Or when it does (data-out
transfer with CB transport) and the result is SK = ASC = ASCQ = 0, then it
clears the sense buffer to pretend that it didn't autosense.

> But after all that, maybe sd still will ignore the error and miscompare?

sd doesn't receive any error indication other than positive residue, and 
it ignores the residue.

Alan Stern

