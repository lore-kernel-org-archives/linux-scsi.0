From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: printk the cdb's that interest me
Date: Tue, 23 Sep 2003 09:52:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030923095248.A9896@beaverton.ibm.com>
References: <1064331642.10473.23.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:4090 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262094AbTIWQxZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 12:53:25 -0400
Content-Disposition: inline
In-Reply-To: <1064331642.10473.23.camel@patehci2>; from p.lavarre@ieee.org on Tue, Sep 23, 2003 at 09:40:42AM -0600
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 23, 2003 at 09:40:42AM -0600, Pat LaVarre wrote:
> 
> Can I somehow easily trace only all the scsi cdb's that fail?
> 
> How about a patch to trace only the cdb's that fail between the sk asc =
> x 6 28 GoneReady of disc insertion and the sk asc = x 2 3A DiskAbsent?
> 
> I'm guessing I have to reach down into usb-storage, ide-cd, ide-scsi
> etc. to find a line of code thru which all cdb's pass.  I see
> CONFIG_USB_STORAGE_DEBUG=y gives me all cdb's and so much more besides
> that often I run with =n.  I want only cdb's that interest me to
> distract me from my other printk.

I have never found the SCSI_LOG_ stuff to be very useful when trying to
track all cdb's, the output is not well formatted, and is inconsistent.
The split of upper/middle/lower (UL/ML/LL) in the logging is not very
useful.

All scsi core cdb's are sent via the host->queuecommand, there are only
two callers of it (in 2.6).

Ignoring the non-auto sense request and TUR in scsi_error.c, all the scsi
core cdb's sent to the LLDD go out via scsi_dispatch_cmd, and come back
via scsi_softirq.

cdb logging should dump the host/chan/id/lun and at least the opcode: on
send in scsi_dispatch_cmd or before shost->queuecommand is called; and on
completion in scsi_decide_disposition, or in scsi_softirq, and maybe in
scsi_error.c in two places. Plus the result + possible sense data on
completion.

You could then add debug code to turn on/off the cdb logging for certain
conditions, like your sense key/asc.

Of course cdb's that do not make it to the LLDD would not be logged.

> lost page write due to I/O error on sr1
> SCSI error : <2 0 0 0> return code = 0x10000
> end_request: I/O error, dev sr1, sector 54044096
> Buffer I/O error on device sr1, logical block 6755512
> 
> 1) I think I get these for less than all interesting errors.
> 
> In particular, I think I don't see not-retried unit attentions reported
> this way, even though unit attentions change such things as the
> 2.6.0-test4 /proc/sys/dev/cdrom/info
> 
> 2) I have no confident idea of what the cdb was, and zero idea of what
> the auto-sensed sk asc ascq info was.

It got a DID_NO_CONNECT (host busy 0x01), so there should be no sense
data. Or do you mean what was the sense data was for an IO before the
failed one?

-- Patrick Mansfield
