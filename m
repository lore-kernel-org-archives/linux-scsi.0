Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3768C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 02:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2DAE20692
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 02:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfLICwM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Dec 2019 21:52:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43428 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfLICwM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Dec 2019 21:52:12 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ie99d-0001ex-3y; Mon, 09 Dec 2019 02:52:09 +0000
Date:   Mon, 9 Dec 2019 02:52:09 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Arthur Marsh <arthur.marsh@internode.on.net>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: refcount_t: underflow; use-after-free with CIFS umount after
 scsi-misc commit ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
Message-ID: <20191209025209.GA4203@ZenIV.linux.org.uk>
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net>
 <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net>
 <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Dec 08, 2019 at 06:23:02PM -0800, Linus Torvalds wrote:
> On Sun, Dec 8, 2019 at 5:49 PM Arthur Marsh
> <arthur.marsh@internode.on.net> wrote:
> >
> > This still happens with 5.5.0-rc1:
> 
> Does it happen 100% of the time?
> 
> Your bisection result looks pretty nonsensical - not that it's
> impossible (anything is possible), but it really doesn't look very
> likely. Which makes me think maybe it's slightly timing-sensitive or
> something?
> 
> Would you mind trying to re-do the bisection, and for each kernel try
> the mount thing at least a few times before you decide a kernel is
> good?
> 
> Bisection is very powerful, but if _any_ of the kernels you marked
> good weren't really good (they just happened to not trigger the
> problem), bisection ends up giving completely the wrong answer. And
> with that bisection commit, there's not even a hint of what could have
> gone wrong.

FWIW, the thing that is IME absolutely incompatible with bisection
is CONFIG_GCC_PLUGIN_RANDSTRUCT.  It can affect frequencies badly
enough, even in the cases when the bug isn't directly dependent
upon that thing.

I suspect that nonsense bisects spewed by CI bots lately (bisect on
x86 oops ending up at commit limited to arch/parisc, etc.) are at
least partially due to that kind of garbage...
