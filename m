From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [2.4.25] scsi29160 card-aic7xxx, HP Ultrium 230 tape read/write
 failure
Date: Tue, 24 Feb 2004 17:34:06 -0300 (BRT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58L.0402241729080.23951@logos.cnet>
References: <20040224154208.1602.qmail@web41203.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intra.cyclades.com ([64.186.161.6]:53390 "EHLO
	intra.cyclades.com") by vger.kernel.org with ESMTP id S262406AbUBXThR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 14:37:17 -0500
In-Reply-To: <20040224154208.1602.qmail@web41203.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Jin Suh <jinssuh@yahoo.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org



On Tue, 24 Feb 2004, Jin Suh wrote:

> Hello,
>
> I recently upgraded my kernel to 2.4.25. I have a strange error using 2.4.25
> with Ultrium 230 tape drive. I wrote 4gb data unto the tape and read back to
> verify md5sum value. It died when it read around 1.3gb data from tape saying
> following:
>
> (scsi0:A:3:0): parity error detected in Data-in phase. SEQADDR(0x84)
> SCSIRATE(0x98)
> (scsi0:A:3:0): Unexpected busfree in Message-out phase
> SEQADDR == 0x16b
> st0: Error 70000 (sugg. bt 0x0, driver bt 0x0, host bt 0x7).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> ........
>
> When I tried to read it again using:
> dd if=/dev/st0 bs=1024 conv=noerror,sync | md5sum
>
> I got the following:
> st0: Error 10000 (sugg. bt 0x0, driver bt 0x0, host bt 0x1).
> dd: opening '/dev/st0': Input/Output error
>
> I tested the same thing unto the HP Exabyte and HP SuperStore DAT24. Both
> worked without problems. But it happened on the HP Ultrium 230 tape drive.
> Everything used to work fine with 2.4.20 kernel before. Is there any patch for
> 2.4.25? Do you have any idea?

Hi Jin,

CCing linux-scsi to get more input.

I dont have much clues unfortunately -- reading the SCSI error messages it
looks like a parity error.

Can you try 2.4.20 again? Find out where this problem started.

It might be a physical drive problem too which was not failing when you
ran 2.4.20.
