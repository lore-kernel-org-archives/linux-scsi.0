From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] [SCSI] aacraid: prevent ZERO_SIZE_PTR dereference
Date: Tue, 29 Oct 2013 13:17:10 -0700
Message-ID: <CA+55aFzur_Y1vn0EUk7=C9UEunKqvtWceQ4O0UkX9x5agLuAew@mail.gmail.com>
References: <20131025144452.GA28451@ngolde.de>
	<20131029191007.GD21820@longonot.mountain>
	<CA+55aFzTJpx+J3hH+FjsxCmajTjD_nLzHSzbvX02JwDQ1e2U4g@mail.gmail.com>
	<20131029200649.GE20521@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54462 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3J2URL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2013 16:17:11 -0400
Received: by mail-vc0-f176.google.com with SMTP id ia6so277866vcb.35
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2013 13:17:10 -0700 (PDT)
In-Reply-To: <20131029200649.GE20521@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "security@kernel.org" <security@kernel.org>

On Tue, Oct 29, 2013 at 1:06 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> You and James are right.  It should be checking against the sizeof().
> I will send a v2 tomorrow.  Sorry about that.

Looking some more at this, I have to say that I absolutely detest
those aacraid structures. And I'm not sure that sizeof() is
necessarily the right thing for the minimum size.

The "struct user_aac_srb" includes a

        struct  user_sgmap      sg;

which has a count in it. But the actual "struct  user_sgmap" structure
is defined with a

        struct user_sgentry     sg[1];

in it, so the sizeof() of that structure basically gives the size of
an entry that has _one_ sgentry.

And it's not entirely clear that you absolutely have to have a minimum
of one sgentry. So I could imagine that there would be a zero-entry
case that doesn't have any scatter-gather entries at all (ie just the
status parts). So the "sizeof()" might actually end up giving a
minimum size that is too large *if* it is possible to not have those
scatter-gather entries at all?

Hmm? Somebody who knows this code, please speak up..

                Linus
