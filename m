From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] first round of SCSI updates for the 4.14+ merge window
Date: Tue, 14 Nov 2017 16:33:15 -0800
Message-ID: <CA+55aFx791+T60zeDRH+08eb7TxhYMW7pJBSCi8HezFtSkEHvw@mail.gmail.com>
References: <1510677363.4078.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:47814 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdKOAdQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2017 19:33:16 -0500
In-Reply-To: <1510677363.4078.16.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, Nov 14, 2017 at 8:36 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Hannes Reinecke (14):
>       scsi: scsi_devinfo: Reformat blacklist flags

Ugh, that's just really ugly, but it's also wrong.

Just having long lines would probably have been much preferable, and
would mean that the commit that explains the bit would show up when
you grep for the bit.

Having a small helper macro like

   #define BLIST_n(x) ((__force __u32 __bitwise)(1 << (n)))

woiuld also likely have made it more legible.

But that only takes care of the ugliness and the greppability.

It's not right for sparse even _with_ those changes.

Why? Because "__bitwise" actually creates a new type. So what those
BLIST defines should do is to use a special type something like

    typedef unsigned int __bitwise blist_flags_t;

and now you have _one_ type thanks to that typedef, that is different
from all the other bitwise types. Then you force all the constants and
the field that implements to have that type, and you have type-safety:
you can use those constants together, and you can assign the result to
the blist flags, but you can't mix it with other __bitwise types.

That's why things like this work:

    typedef __u16 __bitwise __le16;
    typedef __u16 __bitwise __be16;

where __le16 and __be16 are actually different types, even though
their underlying _storage_ is the same (a 16-bit unsigned).

Anyway, I've pulled, because clearly this only matters for sparse, but
I would hope that this gets fixed up, ok?

             Linus
