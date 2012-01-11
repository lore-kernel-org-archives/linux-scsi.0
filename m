From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/6] drivers/scsi/megaraid.c: fix sparse warnings
Date: Tue, 10 Jan 2012 17:48:14 -0800
Message-ID: <20120110174814.351384c1.akpm@linux-foundation.org>
References: <20120110234230.58C9F20012E@hpza10.eem.corp.google.com>
	<CAHtARFFWhGpFDZ51JsSHQsXs02i4Pu4x4YUfM37JxvYLucH5Dg@mail.gmail.com>
	<1326245138.3264.121.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab2AKBni (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 20:43:38 -0500
In-Reply-To: <1326245138.3264.121.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: adam radford <aradford@gmail.com>, linux-scsi@vger.kernel.org, rdunlap@xenotime.net, megaraidlinux@lsi.com, viro@zeniv.linux.org.uk

On Tue, 10 Jan 2012 20:25:38 -0500 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > Since I have no HP firmware on one of these boards, and I can see that
> > altering the firmware string will alter the behvior of the above code
> > WRT setting/clearing BOARD_64BIT in the adapter->flag field, I have to
> > NACK this patch.  I hope we can live with the sparse warning since I
> > have no way to test this.
> 
> So I think the title of the patch is misleading.

"fix sparse warning" is almost always a bad or wrong patch title.

Sparse warns about "X", and what we're fixing is "X", not the warning.

>  The point is that 
> 
> adapter->product_info.fw_version[] >> 8
> 
> Always produces zero since adapter->product_info.fw_version is a char[].
> It seems that the idea was 
> 
> If you want to supply an update that just making the zero explicit for
> the firmware version (and thus fixes the sparse warning) is fine too ...
> Al just thought that you meant to take the firmware version as BCD
> nybbles.

Yes, it sounds like this is a day-one bug which we can't really fix
now, with an acceptable level of effort or risk.  I agree that replacing
it with literal zero and a decent code comment is appropriate.

