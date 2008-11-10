From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/18 ver2] libosd: OSDv1 Headers
Date: Mon, 10 Nov 2008 10:47:07 +0200
Message-ID: <4917F50B.3000905@panasas.com>
References: <491073BB.4000900@panasas.com> <1225817046-5946-1-git-send-email-bharrosh@panasas.com> <4916F934.4090205@panasas.com> <20081109174509.GB5350@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:6424 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753643AbYKJIq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 03:46:58 -0500
In-Reply-To: <20081109174509.GB5350@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, open-osd development <osd-dev@open-osd.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>

J=C3=B6rn Engel wrote:
> On Sun, 9 November 2008 16:52:36 +0200, Boaz Harrosh wrote:
>> +struct osdv1_cdb {
>> +	struct osd_cdb_head h;
>> +	u8 caps[OSDv1_CAP_LEN];
>> +	struct osd_security_parameters sec_params;
>> +} __packed;
>=20
> __packed can result in slow code being generated.  But removing the
> attribute can lead to bugs on other architectures.  F.e. the size of
> the structure below is different for i386 and x86_64.
>=20
> struct foo {
> 	u64 bar;
> 	u32 baz;
> };
>=20
> My personal solution is to use this little macro and then just follow
> every structure defition with a size check.
>=20
> #define SIZE_CHECK(type, size)					\
> static inline void check_##type(void)				\
> {								\
> 	BUILD_BUG_ON(sizeof(struct type) !=3D (size));		\
> }
> ...
> struct foo {
> 	u64 bar;
> 	u32 baz;
> };
>=20
> SIZE_CHECK(foo, 12);
>=20
> The above would not compile on x86_64 and clearly indicate a missing
> __packed.  In other cases the attribute can be removed.
>=20
> J=C3=B6rn
>=20

Hi J=C3=B6rn
Thank you for your comments

I do have a size check that governs the complete structure it is the fi=
rst
code in osd_initiator.c at build_test(). It will catch any discrepancie=
s
from the protocol.

I have done some experimentation with __packed both on 32 and 64 bit x8=
6.
When it does nothing like the above foo in 32bit, then there is no code
difference with it or with out it, but on 64bit I must have it otherwis=
e
the structure grows.

These are all, on-the-wire structures. I must have __packed, otherwise
I'm at the compiler mercy and that's bad.

If the assembly - size and offsets - of foo is exactly the same with or
without the __packed, but the generated code is different then clearly =
this
is a compiler bug. I've herd of this myth before, and at least with my
gcc 4.1.2 there is no such bug. Either the structure gets packed, or th=
ere is
no difference. All the places I have __packed in the code are absolutel=
y must
be so, stated by the protocol.

Boaz
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
