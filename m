From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 4.14+ merge
 window
Date: Wed, 15 Nov 2017 18:35:51 +0900
Message-ID: <1510738551.19284.3.camel@HansenPartnership.com>
References: <1510677363.4078.16.camel@HansenPartnership.com>
         <CA+55aFx791+T60zeDRH+08eb7TxhYMW7pJBSCi8HezFtSkEHvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56602 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756000AbdKOJgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Nov 2017 04:36:23 -0500
In-Reply-To: <CA+55aFx791+T60zeDRH+08eb7TxhYMW7pJBSCi8HezFtSkEHvw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Hannes Reinecke <hare@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2017-11-14 at 16:33 -0800, Linus Torvalds wrote:
> On Tue, Nov 14, 2017 at 8:36 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > 
> > Hannes Reinecke (14):
> >       scsi: scsi_devinfo: Reformat blacklist flags
> 
> Ugh, that's just really ugly, but it's also wrong.
> 
> Just having long lines would probably have been much preferable, and
> would mean that the commit that explains the bit would show up when
> you grep for the bit.
> 
> Having a small helper macro like
> 
>    #define BLIST_n(x) ((__force __u32 __bitwise)(1 << (n)))
> 
> woiuld also likely have made it more legible.
> 
> But that only takes care of the ugliness and the greppability.
> 
> It's not right for sparse even _with_ those changes.
> 
> Why? Because "__bitwise" actually creates a new type. So what those
> BLIST defines should do is to use a special type something like
> 
>     typedef unsigned int __bitwise blist_flags_t;
> 
> and now you have _one_ type thanks to that typedef, that is different
> from all the other bitwise types. Then you force all the constants
> and the field that implements to have that type, and you have type-
> safety: you can use those constants together, and you can assign the
> result to the blist flags, but you can't mix it with other __bitwise
> types.
> 
> That's why things like this work:
> 
>     typedef __u16 __bitwise __le16;
>     typedef __u16 __bitwise __be16;
> 
> where __le16 and __be16 are actually different types, even though
> their underlying _storage_ is the same (a 16-bit unsigned).
> 
> Anyway, I've pulled, because clearly this only matters for sparse,
> but I would hope that this gets fixed up, ok?

It will, boss; I'll make sure of it.

James
