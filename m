From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Mon, 22 Aug 2005 15:09:42 -0700
Message-ID: <20050822150942.4f0c46df.akpm@osdl.org>
References: <20050822003325.33507.qmail@web51613.mail.yahoo.com>
	<1124680540.5068.37.camel@mulgrave>
	<20050821205214.2a75b3cf.akpm@osdl.org>
	<1124720938.5211.13.camel@mulgrave>
	<1124747615.5211.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:40074 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751055AbVHVWQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 18:16:52 -0400
In-Reply-To: <1124747615.5211.34.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: luben_tuikov@adaptec.com, jim.houston@ccur.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davej@redhat.com, jgarzik@pobox.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> Of course, if we're going to go to all this trouble, the next question
>  that arises naturally is why not just reuse the radix-tree code to
>  implement idr anyway ... ?

Yes, we could probably have gone that way.  radix-tree would need some
enhancements for the find-next-above thing.

radix-tree has some features (tags, gang-lookup, gang-lookup-by-tag) which
idr doesn't.  Fitting them all into the one storage API would be nice, I
guess.  radix-tree does potentially use more memory, although that'll only
be significant for collections which are both large and sparse.

Still, people can use either facility at present.  The person who does any
such consolidation would do the kernel-wide migration at the same time.
