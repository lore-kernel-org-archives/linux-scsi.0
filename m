From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1
Date: 06 Jul 2004 09:46:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089125210.1767.128.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC7D9@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:21683 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263923AbUGFOrD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2004 10:47:03 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC7D9@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Fri, 2004-06-25 at 19:55, Mukker, Atul wrote:
> A bug was discovered in the driver unload path, causing kernel panic. The
> new driver will be available in the FTP site soon. The patch with the fix is
> inlined.

OK, I think I'm looking at the latest one now.

The biggest structural issue still seems to be the pending queue.  It
looks to me like the driver could be nicely simplified if you got rid of
it and simply relied on returning SCSI_MLQUEUE_HOST_BUSY from
queeucommand().  You'd still get the queue restart almost from the ISR
like you want.

My other main gripe is things like this:

+	// wait for maximum 1 second for status to post
+	for (i = 0; i < 40000; i++) {
+		if (mbox->numstatus != 0xFF) break;
+		udelay(25); yield();
+	}


which litter the driver.  Use of yield() in drivers is deprecated.   I
suspect what you want is a minimum delay to wait if the relevant bit is
not set 

Something like

if (mbox->numstatus != 0xFF)
	goto out;
udelay(25);
for (i = 0; mbox->numstatus != 0xFF && i < 1000; i++)
	msleep(1);
out:

which will give initially 25us to see if the box becomes ready and then
begin yeilding the CPU.

James


