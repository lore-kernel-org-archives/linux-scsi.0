From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH v2] BLOCK: fix bio.bi_rw handling
Date: Thu, 12 Aug 2010 18:24:39 +0200
Message-ID: <4C642047.6030108@gmail.com>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz> <1281616266-4709-3-git-send-email-jslaby@suse.cz> <20100812160809.GC28689@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab0HLQYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2010 12:24:43 -0400
In-Reply-To: <20100812160809.GC28689@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jiri Slaby <jslaby@suse.cz>, akpm@linux-foundation.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On 08/12/2010 06:08 PM, Christoph Hellwig wrote:
> On Thu, Aug 12, 2010 at 02:31:06PM +0200, Jiri Slaby wrote:
>> Return of the bi_rw tests is no longer bool after commit 74450be1. B=
ut
>> results of such tests are stored in bools. This doesn't fit in there
>> for some compilers (gcc 4.5 here), so either use !! magic to get rea=
l
>> bools or use ulong where the result is assigned somewhere.
>=20
> I'd have to look at my copy of the C standard if it's guaranteed,

=A76.5.3.3 of ANSI C99, par 5:
The result of the logical negation operator ! is 0 if the value of its
operand compares unequal to 0, 1 if the value of its operand compares
equal to 0. The result has type int. The expression !E is equivalent to
(0=3D=3DE).

On =3D=3D (=A76.5.9 par 3):
The =3D=3D (equal to) and !=3D (not equal to) operators are analogous t=
o the
relational operators except for their lower precedence. Each of the
operators yields 1 if the specified relation is true and 0 if it is
false. The result has type int. For any pair of operands, exactly one o=
f
the relations is true.

On bool =3D> _Bool (=A76.2.5 par 2)
An object declared as type _Bool is large enough to store the values 0
and 1.

So it should be safe :).

BTW just of curiosity, sizeof(bool) is 1 here (8 bits).

regards,
--=20
js
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
