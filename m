From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Mon, 5 May 2003 01:46:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505084617.GG8416@beaverton.ibm.com>
References: <3EB11AD3.2070503@torque.net> <3EB22F09.7060906@torque.net> <20030502095536.76dba4dd.rddunlap@osdl.org> <3EB385F3.6010708@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:52207 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262102AbTEEIb7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 04:31:59 -0400
Content-Disposition: inline
In-Reply-To: <3EB385F3.6010708@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

Douglas Gilbert [dougg@torque.net] wrote:
> The issued command is a MODE SENSE (10 byte) for page 0x2a
> and just the first 2 bytes (i.e. tell me the length you
> will return). There must have been 10 of the exact same
> commands executed successfully prior to this point.
> 
> "hdd: lost interrupt" seems to indicate a timeout (ide-scsi
> sets its timeouts to max(10, whatever_app_wants) seconds).
> Then it re-enters the ide-scsi driver in the
> idescsi_pc_intr() routine and things look corrupted. It tries
> to finish off a DMA transfer but that 2 byte data_in request
> was not set up as DMA. It is all downhill from there.
> 
> Naturally I don't see any errors on my box. However I can
> shorten the timeout so it will go off on a READ command.
> The timeout log looks quite different from yours and
> my driver continues in a healthy state.
> 
> ide-scsi: hdd: que 11417, cmd = [ 28 0 0 0 0 0 0 0 1 0 ]
> hdd: irq timeout: status=0xd0 { Busy }
> hdd: ATAPI reset complete
> hdd: irq timeout: status=0xc0 { Busy }
> hdd: ATAPI reset complete
> hdd: irq timeout: status=0xc0 { Busy }
> ide-scsi: hdd: I/O error for 11417
> 
> 
> Does anyone have any suggestions for further testing?
> 

It might be interesting if timeouts are happening to see what the error
handler is doing. If SCSI_LOGGING is config'd. Then 

echo scsi log error 4 > /proc/scsi/scsi

should not be too verbose.


> I have cleaned up the logging messages a little but
> that does not justify releasing a new version yet.
> 
> 
> An additional observation concerning Randy's capture:
> the failed command (MODE SENSE) has serial number 91.
> After ide-scsi thinks it has cleared the timeout and
> the DMA transfer it issues a TEST UNIT READY which
> also get 91 as a serial number. This looks like a
> bug in the mid level.
> 

Well ++serial_number and scsi_pid++ are not very safe, but is the TUR
coming from the error handler as it will have the same serial number
that the timed out command had. Alan Stern was asking about this in
another thread a few days ago.

-andmike
--
Michael Anderson
andmike@us.ibm.com

