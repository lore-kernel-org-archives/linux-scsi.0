From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 8 Aug 2005 17:49:34 -0700 (PDT)
Message-ID: <20050809004934.95766.qmail@web51605.mail.yahoo.com>
References: <Pine.LNX.4.44L0.0508081829070.4470-100000@iolanthe.rowland.org>
Reply-To: luben_tuikov@adaptec.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web51605.mail.yahoo.com ([206.190.38.210]:64441 "HELO
	web51605.mail.yahoo.com") by vger.kernel.org with SMTP
	id S932393AbVHIAtg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 20:49:36 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508081829070.4470-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>

--- Alan Stern <stern@rowland.harvard.edu> wrote:
> > I think that "scanning" is a special process which should involve
> > the minimum of error handling, by either ignoring errors and trying
> > to connect to the device anyway, or on the first error, give up
> > the device.  Which policy would one follow depends on the transport.
> 
> No, that's not feasible.  We can't just ignore errors, and we do have to 
> cope with them.  Scanning is a particular vulnerable time, since it 
> involves sending commands that don't occur most of the time during normal 
> operation.

Your reasoning is correct, but your conclusion is not.

Exactly, scanning is a "particularly vulnerable time" and this is why
we do not want the full I_T nexus error recovery.  At scanning time
we're just "probing" here and there.
 
> > If the latter, you need to blacklist the device as not supporting
> > TUR.  Then on any error, like you pulling the cable during scanning,
> > the scanning process will give up and all will be well.
> 
> You can't blacklist devices you don't know about.  The kernel should work 
> regardless.

Hmm, I thought there was a black listing somewhere in scsi, maybe
/proc/scsi/device_info?

So then you do scheme #1 as I described: ignore as much as possible and try
to establish an I_T nexus and _then_ try to poke around with the device.

      Luben

