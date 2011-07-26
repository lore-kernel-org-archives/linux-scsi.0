From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Tue, 26 Jul 2011 00:09:40 -0700
Message-ID: <CA+55aFyNBaf2+=XJDLKNF1S5zMtpx38+Zd8uNd9k4ap4YpZmvw@mail.gmail.com>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
 <20110725163739.5c19b04d.akpm@linux-foundation.org> <20110725165057.9701f16b.akpm@linux-foundation.org>
 <1311663071.17766.230.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754196Ab1GZHKf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 03:10:35 -0400
In-Reply-To: <1311663071.17766.230.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

On Mon, Jul 25, 2011 at 11:51 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> How about the following to add a new DIV_ROUND_UP_ULL macro

Hmm.

> =A0#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> +#define DIV_ROUND_UP_ULL(n,d) ( =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0\
> +{ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 unsigned long long _tmp =3D n, _off; =A0 =A0 =A0 =A0 =A0=
 =A0 =A0\
> + =A0 =A0 =A0 int _res; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 /* Round up using asm/div64.h:do_div */ =A0 =A0 =A0 =A0=
 \
> + =A0 =A0 =A0 _off =3D do_div(_tmp, d); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 if (_off !=3D 0) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 _tmp++; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 _res =3D _tmp; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> +} =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> +)

That looks buggy. Why the "_res =3D _tmp" there? All that does is to
truncate the result to "int", which looks bogus.

And it just looks unnecessarily complicated. Just a simple

#define DIV_ROUND_UP_ULL(ll,d) \
  ({ unsigned long long _tmp =3D (ll)+(d)-1; do_div(_tmp, d); _tmp; })

looks like it would work and be simpler. Avoid the conditional, do the
same "add 'd-1' thing as the regular ROUND_UP().

Untested. And not much thinking involved.

                     Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
