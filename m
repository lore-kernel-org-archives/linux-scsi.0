From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Fri, 28 Mar 2008 17:26:21 -0500
Message-ID: <1206743181.3662.55.camel@localhost.localdomain>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
	 <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38923 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbYC1W00 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 18:26:26 -0400
In-Reply-To: <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Fri, 2008-03-28 at 14:55 -0700, Grant Grundler wrote:
> On Fri, Mar 28, 2008 at 2:48 PM,  <akpm@linux-foundation.org> wrote:
> > From: Andrew Morton <akpm@linux-foundation.org>
> >
> >  powerpc:
> >
> >  drivers/scsi/initio.c: In function 'initio_build_scb':
> >  drivers/scsi/initio.c:2585: warning: large integer implicitly truncated to unsigned type
> 
> I posted a fix for this yesterday and Alan Cox ACKed it.
> 
> It's here:
>     http://marc.info/?l=linux-scsi&m=120668352622659&w=2

Actually, I have to say that neither of these looks to be correct.
Andrew's is obviously wrong because (u8)cpu_to_le32(xxx) always returns
zero on a BE platform if xxx is an 8 bit quantity.

However, the driver clearly does a cblk->bufflen (a __le32 quantity) =
cblk->senselen, which looks obviously wrong on a BE platform as well.
Plus there's another hunk around here:

		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
			++sg;
		}

here total_len is a le32 quantity

		cblk->buflen = (scsi_bufflen(cmnd) > total_len) ?

here we compare against a CPU native quantity

			total_len : scsi_bufflen(cmnd);

And here we set either to a le32 or cpu native quantity depending on the
result of the comparison.


Alan, has this driver ever worked on a BE platform?

James


