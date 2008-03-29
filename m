From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Fri, 28 Mar 2008 22:09:16 -0500
Message-ID: <1206760156.3662.79.camel@localhost.localdomain>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
	 <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
	 <1206743181.3662.55.camel@localhost.localdomain>
	 <20080328224335.1f14cf6a@core>
	 <1206748313.3662.66.camel@localhost.localdomain>
	 <da824cf30803281749l614c3592t89cce073c9b043c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35693 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759925AbYC2DJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 23:09:20 -0400
In-Reply-To: <da824cf30803281749l614c3592t89cce073c9b043c8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Fri, 2008-03-28 at 17:49 -0700, Grant Grundler wrote:
> On Fri, Mar 28, 2008 at 4:51 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> ...
> >  So basically, most of the cpu_to_le32 in this driver look wrong.  If I
> >  can fix it (or persuade someone else to fix it) can anyone test it on a
> >  BE platform?
> 
> But the code I submitted the patch is also broken for LE platforms.
> (As you pointed out earlier and was my original incentive for
> submitting the patch).

No ... it's correct on a LE platform .. the warning is superfluous we
promote a u8 to a u32 and then complain when it's truncated to a u8
again.

> If most of the usage is wrong anyway, perhaps it's better to
> not pretend the driver can work on a BE platform and just rip
> all the cpu_to_le32() usage out...including the one I submitted
> the patch for. Either way, that change should go in. Right?

Well, not really; the problem is it's not complete ... it only covers up
the real problem by silencing the warning.

If the actual BE pieces of the driver worked, you could make it correct
either by making senselen a u32 and leaving the cpu_to_le32 or adding it
to the point at which we assign it to bufflen.

If you can verify my analysis of the way the driver works, then the
complete fix should be pretty simple: just remove the cpu_to_le32 from
everywhere except the sg list construction.

James


