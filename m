From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB disk-type
	storag edevices?
Date: 10 Mar 2004 11:53:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078944795.5156.210.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0403081046190.1187-100000@ida.rowland.org>
	 <200 40308201328.GA13708@apps.cwi.nl>
	 <20040309174353.A15780@beaverton.ibm.com>
	 <20040310091312.GA25632@apps.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:29108 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262767AbUCJSz1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 13:55:27 -0500
In-Reply-To: <20040310091312.GA25632@apps.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <Andries.Brouwer@cwi.nl>
Cc: Patrick Mansfield <patmans@us.ibm.com>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

> > res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);

I see the structure of this code arbitrarily requires H = C.  That
structure makes sense only when H = D <= C.  Why we guess D <= C when C
is 4, I do not understand.

> * First attempt: ask for all pages (0x3F), ...

I hear Windows starts with page x08, not x3F.

> all pages (0x3F), but only 4 bytes.

SCSI Pass-Through Mode Sense Command May Crash the Computer
http://support.microsoft.com/?kbid=813908

suggests Talk-like-Windows excludes 4 bytes, by saying -i 4 -y "1A
xx:xx:xx 04 00" crashes the Win 2K kernel for much Atapi, just as -y "12
00:00:00 00 00" crashes some lk for much Usb.

> some devices hang if we ask for more than is available.

Also some hosts hang when D < H.

Offline recently I received an as yet unconfirmed report that 2.4.25
ioctl CDROM_SEND_PACKET fails (but does not hang) when D < H.

> ... my devices ... work...

Yes, here we choose among evils.

If Windows doesn't discover PDT x00/0E writability except by trying to
write blocks, then any other technique we invent will fail to
interoperate broadly.

Pat LaVarre


