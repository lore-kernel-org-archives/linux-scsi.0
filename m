From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: iRiver H100 series and usb-storage issues
Date: 08 Jun 2004 10:10:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086711004.3647.23.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0406081019281.1222-100000@ida.rowland.org><1086
	709937.2105.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:13218 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264917AbUFHQKN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 12:10:13 -0400
In-Reply-To: <1086709937.2105.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, Alan Stern <stern@rowland.harvard.edu>, Philippe Troin <phil@fifi.org>

James B:

> underflow ... meaning ... supposed to be
> "return an error if you transfer fewer than underflow bytes".
> The error's not specified,
> but something like DID_ERROR with SUGGEST_RETRY should be fine.

Incisive, thank you.

> ... Usually HBAs ignore underflow,
> because it simply works correctly ...

Is there an easy way to test whether an HBA implements underflow
correctly?

For example, to inject an underflow into ioctl SG_IO, trivially I ask
for a one block read CDB to fill a two block buffer.

Pat LaVarre

P.S. A possibly relevant glance into the source is:

http://lxr.linux.no/search?v=2.6.5&string=underflow
search: SCSI
http://lxr.linux.no/source/drivers/scsi/sd.c?v=2.6.5#L374
...
static int sd_init_command(struct scsi_cmnd * SCpnt)
...
SCpnt->underflow = this_count << 9;
...


