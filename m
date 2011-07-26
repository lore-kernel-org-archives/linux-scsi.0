From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Tue, 26 Jul 2011 00:26:01 -0700
Message-ID: <1311665161.17766.234.camel@haakon2.linux-iscsi.org>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	 <20110725163739.5c19b04d.akpm@linux-foundation.org>
	 <20110725165057.9701f16b.akpm@linux-foundation.org>
	 <1311663071.17766.230.camel@haakon2.linux-iscsi.org>
	 <CA+55aFyNBaf2+=XJDLKNF1S5zMtpx38+Zd8uNd9k4ap4YpZmvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43721 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1GZHfX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 03:35:23 -0400
In-Reply-To: <CA+55aFyNBaf2+=XJDLKNF1S5zMtpx38+Zd8uNd9k4ap4YpZmvw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

On Tue, 2011-07-26 at 00:09 -0700, Linus Torvalds wrote:
> On Mon, Jul 25, 2011 at 11:51 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > How about the following to add a new DIV_ROUND_UP_ULL macro
> 
> Hmm.
> 
> >  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> > +#define DIV_ROUND_UP_ULL(n,d) (                                \
> > +{                                                      \
> > +       unsigned long long _tmp = n, _off;              \
> > +       int _res;                                       \
> > +       /* Round up using asm/div64.h:do_div */         \
> > +       _off = do_div(_tmp, d);                         \
> > +       if (_off != 0)                                  \
> > +               _tmp++;                                 \
> > +       _res = _tmp;                                    \
> > +}                                                      \
> > +)
> 
> That looks buggy. Why the "_res = _tmp" there? All that does is to
> truncate the result to "int", which looks bogus.
> 
> And it just looks unnecessarily complicated. Just a simple
> 
> #define DIV_ROUND_UP_ULL(ll,d) \
>   ({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
> 
> looks like it would work and be simpler. Avoid the conditional, do the
> same "add 'd-1' thing as the regular ROUND_UP().
> 
> Untested. And not much thinking involved.
> 

Fixing this up in lio-core-2.6.git now and pushing out into
target-pending.git/for-next now unless you have any other concerns.

Thank you,

--nab


