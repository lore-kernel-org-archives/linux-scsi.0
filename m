From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: BLIST flag for non-lockable devices
Date: Mon, 28 Jun 2004 11:54:16 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406281150180.1598-100000@ida.rowland.org>
References: <20040627231007.GA12853@marcet.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:12292 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265044AbUF1PyS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 11:54:18 -0400
In-Reply-To: <20040627231007.GA12853@marcet.info>
List-Id: linux-scsi@vger.kernel.org
To: Javier Marcet <javier@marcet.info>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wheeler <matt@yurisko.net>, Mike Anderson <andmike@us.ibm.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 28 Jun 2004, Javier Marcet wrote:

> For me, as you probably guessed, this is fine. It works very well with
> my iRiver.

Good.

> Yet I wonder why the INQUIRY_36 flag? Isn't it the default? Or you just
> try to skip the try & failure over longer inquiries since you already
> know these devices' length?

It's true that using a 36-byte INQUIRY command is the default.  However
the BLIST_INQUIRY_36 flag means more than that: It means also that there 
should _not_ be an INQUIRY command longer than 36 bytes, even if the 
device says it has extra data available.

I've been adding this flag to all the blacklist entries for USB devices,
just for safety.  With most of them it's not needed.  But I have seen an
example of a device which said that it had 37 bytes of INQUIRY data and
then crashed when it received a command asking for all 37 bytes.

Alan Stern

