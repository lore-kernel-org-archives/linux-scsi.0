From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] kernel.h: Add DIV_ROUND_UP_ULL usage
Date: Tue, 26 Jul 2011 09:54:35 -0700
Message-ID: <1311699275.15386.14.camel@Joe-Laptop>
References: <1311664225-20172-1-git-send-email-nab@linux-iscsi.org>
	 <1311666821.26957.13.camel@Joe-Laptop>
	 <1311667641.17766.249.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4303 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab1GZQyi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 12:54:38 -0400
In-Reply-To: <1311667641.17766.249.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Tue, 2011-07-26 at 01:07 -0700, Nicholas A. Bellinger wrote:
> On Tue, 2011-07-26 at 00:53 -0700, Joe Perches wrote:
> > On Tue, 2011-07-26 at 07:10 +0000, Nicholas A. Bellinger wrote:
> > > Add new DIV_ROUND_UP_ULL macro usage for 32-bit architectures requiring
> > > unsigned long long division of sectors * dev_max_sectors.
> > []
> > > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > []
> > > +#define DIV_ROUND_UP_ULL(ll,d) \
> > > +	({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
> > Maybe use uint64_t and a temporary for d?
> > #define DIV_ROUND_UP_ULL(ll, d)				\
> > ({							\
> > 	typeof(d) _d = d;				\
> > 	uint64_t _tmp = (uint64_t)(ll) + _d - 1;	\
> > 	do_div(_tmp, _d);				\
> > 	_tmp;						\
> > })

> Hi Joe,

Hi Nicholas.

> Not sure on this one myself..  Would this case ever be strictly required
> for proper 32-bit operation with unsigned long long division with
> sector_t..?

It's just for correctness.

For 32 bit uses, if ll is a unsigned long and not an
unsigned long long then without the cast the addition
will be done as a 32 bit value.

e.g.:

$ cat t.c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
	unsigned long l = 0xFFFFFFFFUL;
	unsigned long long ull = l + 1;
	unsigned long long ull2 = (unsigned long long)l + 1;

	printf("l: %lu, ull:%llu, ull2: %llu\n", l, ull, ull2);
}
$ gcc t.c
$ ./a.out
l: 4294967295, ull:0, ull2: 4294967296


