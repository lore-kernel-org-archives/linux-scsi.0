From: Roman Zippel <zippel@linux-m68k.org>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Tue, 2 Dec 2003 14:57:15 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0312021422450.26104@serv>
References: <Pine.LNX.4.10.10312011925380.17836-100000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scrub.xs4all.nl ([194.109.195.176]:18702 "EHLO scrub.xs4all.nl")
	by vger.kernel.org with ESMTP id S262114AbTLBN5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2003 08:57:33 -0500
In-Reply-To: <Pine.LNX.4.10.10312011925380.17836-100000@master.linux-ide.org>
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: Naveen Burmi <naveenb@cisco.com>, hch@infradead.org, linux-scsi@vger.kernel.org

Hi,

On Mon, 1 Dec 2003, Andre Hedrick wrote:

> If a "memcpy" is held and the original content changes with the top level
> caller not marking the request dirty, BOOM you just commited crap to
> platter.

This is irrelevant for this discussion, it's the responsibility of the
caller to ensure data integrity, when it's modifying the data while it's
written. The iSCSI driver is only responsible for the checksum generation.

> If you are not zero-copy to the network stack, you will never catch the
> changes between calculation of the CRC32C and pumping to the wire.
>
> iSCSI(MC)
>
> BLOCK->SCSI->iSCSI->MEMCPY->CRC32C->TCP->WIRE
>                               ^^^^^^^^^^^^^^
>                               BOOM memory buffers change

If the driver uses a private buffer, there is nobody who can change it
(otherwise it's simply a bug).

> iSCSI(MC) passes CRC32C
>
> iSCSI(ZC) fails CRC32C, and retries the failed PDU.
>
> It should be clear that any TARGET, INITIATOR, or PAIR doing iSCSI(MC)
> will roast your data.
>
> Now iSCSI(ZC) requires ERL >= 1 w/ Sync-and-Steering.

Wrong, the iSCSI standard allows to escalate the error handling to the
SCSI layer. It's a different problem whether our SCSI layer can deal with
it or not.
There are multiple valid ways to recover from a digest error, there is not
just one true way as you suggest.

> Real iSCSI does ERL >= 2, but then again > 2 means new async-connections.

ERL0 is also "real iSCSI".

bye, Roman
