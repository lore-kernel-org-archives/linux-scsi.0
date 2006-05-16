From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 11:05:56 -0700 (PDT)
Message-ID: <20060516180556.37742.qmail@web31806.mail.mud.yahoo.com>
References: <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:11698 "HELO
	web31806.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750813AbWEPSF4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 14:05:56 -0400
In-Reply-To: <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 2) This scsi_req_abort_cmd() is fundamentally the wrong logic.
> Everything else is communicated back as a result code from the command
> in done().  This should be no different ... A status return of
> DID_FAILED which scsi_decide_disposition() always translates to FAILED
> would seem to do exactly what you want without all the overhead.

You objected to this already, when I first posted the patch,
but I didn't have time to explain:
http://marc.theaimsgroup.com/?l=linux-scsi&m=113833937421677&w=2

Let me now explain, after your twice objecting in the same way to the
patch:

You CANNOT call the done() function on a command (and return DID_FAILED)
because this terminates the nexus established when queuecommand() got called,
and then later try to "recover" the command as you're suggesting here and
in the thread I included the link to above.

That is, when queuecommand() got called, the nexus is now with the driver,
and/or the FW and/or the transport and/or the device, _depending_ on how
far the driver/fw/transport/device got to executing the command.

The only way to _terminate_ the command nexus with the driver is by
calling done(), which means, 

"I (the driver) am completely done with this command, I'm not referencing it,
 nor will you hear about it any more, and I'm giving it back to you, SCSI Core."

This is _basic_ SCSI knowledge.

For this reason, "scsi_req_abort_cmd()" needs to exist.  It causes recovery
of the command to begin, in a universal way, independent of if the timeout
and/or the eh had been differently defined.  As well as, scsi_req_abort_cmd(),
can be called by either SCSI Core or a driver, from any context, without worrying
where the command is.

     Luben

