From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Fri, 28 Mar 2008 18:51:53 -0500
Message-ID: <1206748313.3662.66.camel@localhost.localdomain>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
	 <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
	 <1206743181.3662.55.camel@localhost.localdomain>
	 <20080328224335.1f14cf6a@core>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43936 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbYC1Xv5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 19:51:57 -0400
In-Reply-To: <20080328224335.1f14cf6a@core>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Grundler <grundler@google.com>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp


On Fri, 2008-03-28 at 22:43 +0000, Alan Cox wrote:
> > Alan, has this driver ever worked on a BE platform?
> 
> Not afaik.

It looks to me like the SCSI piece is entirely driven by the state model
in tulip_scsi, which seems to drive the phases by I/O instructions which
are endian safe, so the only issue I can see is the actual SG entries
themselves, which begin as an outl of the pointer to the SG table, but
which must be pulled into the card by DMA.

So basically, most of the cpu_to_le32 in this driver look wrong.  If I
can fix it (or persuade someone else to fix it) can anyone test it on a
BE platform?

James


