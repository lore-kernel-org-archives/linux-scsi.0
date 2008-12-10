From: Tejun Heo <htejun@gmail.com>
Subject: Re: libata / scsi separation
Date: Thu, 11 Dec 2008 00:33:48 +0900
Message-ID: <493FE15C.4060907@gmail.com>
References: <493B022B.3050406@ru.mvista.com> <20081206230227.07b00e2f@lxorguk.ukuu.org.uk> <493B0867.5020700@ru.mvista.com> <1228662298.3501.19.camel@localhost.localdomain> <20081209222113.GU25548@parisc-linux.org> <493F2151.6010702@gmail.com> <da824cf30812091829g180b3e45i843e356364bc2f9f@mail.gmail.com> <493F2DA9.7040008@gmail.com> <da824cf30812091923j241f915dmbcb27245c0d0491b@mail.gmail.com> <493F3B33.8010607@gmail.com> <20081210152445.GW25548@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:33826 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYLJPdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 10:33:55 -0500
Received: by ti-out-0910.google.com with SMTP id b6so360334tic.23
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 07:33:53 -0800 (PST)
In-Reply-To: <20081210152445.GW25548@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@google.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello, Matthew.

Matthew Wilcox wrote:
> I think what Tejun means is add a new command, say READ_SG which would
> transfer a page of LBA ranges (see how TRIM works for details), then the
> drive would do a single transfer which contained the data from all those
> ranges.

Yes, I did.

> This would work, but (ignoring the political / standardisation efforts
> required to make this happen), this is just a cop-out.  When networking
> people were first faced with gigabit, they tried the same thing (oooh,
> 9000 byte packets, oooh, TCP Offload, etc), all in the name of passing
> larger amounts of data to the card in a single transaction so they
> didn't have to fix their per-transaction overheads.
> 
> Users weren't interested.  They wanted to keep sending 1500 byte packets
> (because most equipment couldn't handle jumbo frames) and they wanted
> netfilter and SACK and all the other goodies that the Linux networking
> stack offered and the card's TCP stack didn't.
> 
> We should stop denying that users actually want to do 4k IOs and just
> get on with fixing the storage stack to cope with lots of them.

And yeap we definitely should try to do that too but I don't think
RW_SG would be as useless as jumbo frames (much less compatibility
problem and no loss of functionality), and the actual hardware
overhead of issuing separate commands for each 4k segment is way
higher than anything we do along the block and low level driver layers
in terms of IO access, host bus and ATA (or SAS) bus overhead.

Thanks.

-- 
tejun
