From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Sun, 7 Dec 2003 01:37:49 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0312070034550.26104@serv>
References: <Pine.LNX.4.10.10312061111220.18839-100000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scrub.xs4all.nl ([194.109.195.176]:27401 "EHLO scrub.xs4all.nl")
	by vger.kernel.org with ESMTP id S265292AbTLGBDu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Dec 2003 20:03:50 -0500
In-Reply-To: <Pine.LNX.4.10.10312061111220.18839-100000@master.linux-ide.org>
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, naveenb@cisco.com, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

On Sat, 6 Dec 2003, Andre Hedrick wrote:

> James:
>
> Thank you for explaining to Roman and company the obvious nature of
> BLOCK on top of SCSI.  This is only a point of proof that I was correct in
> my statements earlier.

In case you missed it, but James was not the only one stating that the
send data is not static and so far it's rather unclear what you're trying
to proof here.

> iSCSI(MC) will corrupt randomly.
>
> iSCSI(ZC) will fail data digests and invoke the retry.

Again, how should the data in a local buffer become corrupted? Where is
that "random corruption" which you don't have to deal with zero copy as
well?

> Same example with iSCSI(ERL = 1), the original 19 good PDU's are buffered
> and an in-connection recovery is executed for the one failed.
>
> Translation:
>
> iSCSI(ERL = 0) 20 * (m + 1), m = I(all postive integers)
>
> iSCSI(ERL = 1) 20 + n, n = I(all postive integers)
>
> m == the number of entire commands retired.
> n == the number of PDU's retried.
>
> For ease, make m == n = 1;
>
> iSCSI(ERL = 0) == 40 PDU's
>
> iSCSI(ERL = 1) == 21 PDU's
>
> The only case where they are equal is if all PDU's in iSCSI(ERL = 1) had
> to be retried.

Andre, maybe you can scare little girls with this, but otherwise this
highly unimpressive, how about you come up with some real data?
It's easily possible to limit the transfer size and so to reduce the
amount of the data which has to be transfered again, which protocol is
used to request a retry of the transfer, is not that important. It would
be a lot more interesting if you could actually show a real perfomance
difference with some real numbers.
Of course ERL1 allows to solve this problem more elegant, but so far you
failed to show any proof that ERL0 is not usable.

> The goal of the exercise is to show that both Roman's and Cisco's
> iSCSI(ERL = 0) initaitors are not in a data integrity class acceptable for
> anyone.

iSCSI works quite fine also without an additional checksum and if one
knows the ip transport is reliable, one can easily live without it.

bye, Roman
