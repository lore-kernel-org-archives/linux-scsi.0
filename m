From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: libata / scsi separation
Date: Wed, 10 Dec 2008 08:24:45 -0700
Message-ID: <20081210152445.GW25548@parisc-linux.org>
References: <493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk> <493B0867.5020700@ru.mvista.com> <1228662298.3501.19.camel@localhost.localdomain> <20081209222113.GU25548@parisc-linux.org> <493F2151.6010702@gmail.com> <da824cf30812091829g180b3e45i843e356364bc2f9f@mail.gmail.com> <493F2DA9.7040008@gmail.com> <da824cf30812091923j241f915dmbcb27245c0d0491b@mail.gmail.com> <493F3B33.8010607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53327 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYLJPZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 10:25:03 -0500
Content-Disposition: inline
In-Reply-To: <493F3B33.8010607@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Grant Grundler <grundler@google.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Dec 10, 2008 at 12:44:51PM +0900, Tejun Heo wrote:
> >> and thus have SG on the host bus side in mode cases
> >> but never on the device side.
> > 
> > SG == scatter-gather? I'm not sure why that is specific to rotating media.
> > Or is this referring to "SCSI-generic" pass through?
> 
> I was talking about scatter-gather.  All the IO commands are about one
> continuous extent of data on the device and the whole stack from the
> bio is built that way and the overhead of libata is minute compared to
> the whole thing including emitting single command and receiving
> completion for each 4k transfer.

I think what Tejun means is add a new command, say READ_SG which would
transfer a page of LBA ranges (see how TRIM works for details), then the
drive would do a single transfer which contained the data from all those
ranges.

This would work, but (ignoring the political / standardisation efforts
required to make this happen), this is just a cop-out.  When networking
people were first faced with gigabit, they tried the same thing (oooh,
9000 byte packets, oooh, TCP Offload, etc), all in the name of passing
larger amounts of data to the card in a single transaction so they
didn't have to fix their per-transaction overheads.

Users weren't interested.  They wanted to keep sending 1500 byte packets
(because most equipment couldn't handle jumbo frames) and they wanted
netfilter and SACK and all the other goodies that the Linux networking
stack offered and the card's TCP stack didn't.

We should stop denying that users actually want to do 4k IOs and just
get on with fixing the storage stack to cope with lots of them.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
