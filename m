From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 13:38:14 -0500
Message-ID: <1147804694.3505.76.camel@mulgrave.il.steeleye.com>
References: <20060516180556.37742.qmail@web31806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41955 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751470AbWEPSiS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 14:38:18 -0400
In-Reply-To: <20060516180556.37742.qmail@web31806.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2006-05-16 at 11:05 -0700, Luben Tuikov wrote:
> Let me now explain, after your twice objecting in the same way to the
> patch:
> 
> You CANNOT call the done() function on a command (and return DID_FAILED)
> because this terminates the nexus established when queuecommand() got called,
> and then later try to "recover" the command as you're suggesting here and
> in the thread I included the link to above.
> 
> That is, when queuecommand() got called, the nexus is now with the driver,
> and/or the FW and/or the transport and/or the device, _depending_ on how
> far the driver/fw/transport/device got to executing the command.
> 
> The only way to _terminate_ the command nexus with the driver is by
> calling done(), which means, 
> 
> "I (the driver) am completely done with this command, I'm not referencing it,
>  nor will you hear about it any more, and I'm giving it back to you, SCSI Core."
> 
> This is _basic_ SCSI knowledge.
> 
> For this reason, "scsi_req_abort_cmd()" needs to exist.  It causes recovery
> of the command to begin, in a universal way, independent of if the timeout
> and/or the eh had been differently defined.  As well as, scsi_req_abort_cmd(),
> can be called by either SCSI Core or a driver, from any context, without worrying
> where the command is.

The only current proposed user of this is libata-eh.  If you look,
you'll see the caller is from ata_qc_complete() which is only called
*after* the nexus is terminated.

James


