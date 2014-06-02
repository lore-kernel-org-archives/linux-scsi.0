From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Mon, 2 Jun 2014 13:05:38 -0700
Message-ID: <CA+55aFy+VTFqBi5aQLdB7=04wWmf+gvZzQ1vdrSEuscN7k3xGw@mail.gmail.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
	<1399340492-2136-7-git-send-email-jkallickal@emulex.com>
	<536AB13E.6080906@cs.wisc.edu>
	<0eb11761-3b46-44d0-b35a-16d121fe1df4@CMEXHTCAS2.ad.emulex.com>
	<20140602064601.GA6630@infradead.org>
	<1401736926.12939.13.camel@dabdike.int.hansenpartnership.com>
	<20140602193349.GA11555@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:52420 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaFBUFj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:05:39 -0400
Received: by mail-vc0-f173.google.com with SMTP id ik5so2759714vcb.18
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 13:05:38 -0700 (PDT)
In-Reply-To: <20140602193349.GA11555@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "MinhDuc.Tran@Emulex.Com" <MinhDuc.Tran@emulex.com>, "jayamohank@gmail.com" <jayamohank@gmail.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Sony.John-N@Emulex.Com" <Sony.John-N@emulex.com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@emulex.com>

On Mon, Jun 2, 2014 at 12:33 PM, hch@infradead.org <hch@infradead.org> wrote:
>
> Linus has been very unappy about rebasing close to or in the merge
> window, and other subsystems generally revert patches that late in the
> cycle as well.  I'd prefer to stick to that model, but if you and Linus
> prefer the rebase now I can do it as well of course.

I would indeed prefer to avoid rebases, _unless_ the tree is a real
mess without it.

Now, what constitues "real mess" can vary. It can be just really ugly
history, and part of that can be "it doesn't build or work at all
partway through". If it causes major build or boot failures the code
is *not* worth merging as-is, because that ends up being really
painful for bisection etc. But for it to matter for bisection, it has
to be a _major_ failure that actually matters to real people. So I'm
not talking about odd "make randomconfig" failures, but painful build
failures that actually hit reasonable configurations, and boot
failures that hit relevant hardware configurations.

Even in the absense of major build/working problems, "real mess" can
be about just horrible history with tons of stupid merges that just
makes it much harder to figure out what was going on.

So it's a judgment thing in the end, not a black-and-white "never
rebase". I don't know how core that revert is.

            Linus
