From: Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.24-rc3
Date: Tue, 8 Jan 2008 14:15:53 +0300
Message-ID: <20080108111549.GA30832@rain>
References: <1195989865.3427.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756463AbYAHLQQ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1195989865.3427.16.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 25, 2007 at 01:24:25PM +0200, James Bottomley wrote:
> This is a bit of a rash of bug fixes.  The qla1280 is actually a bug =
fix
> (in spite of the title---it's actually correcting an existing problem
> with the qla1280 implementation of accessors that broke the current
> driver).
>=20

Recently I build last Linus's git tree, and got:
=E2=80=98req_cnt=E2=80=99 is used uninitialized in this function,
and see bellow
> The patch is available here:
>=20
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.gi=
t
>=20
> The short changelog is:
=2E..
> Jes Sorensen (1):
>       qla1280: convert to use the data buffer accessors
>=20
=2E..
>  scsi/qla1280.c         |  387 +++++++++++++++++++++-----------------=
-----------
=2E..
>  	/* Calculate number of entries and segments required. */
> -	req_cnt =3D 1;
>=20

Initilization of req_cnt was removed, but in this function
there are places like=20
req_cnt +=3D (seg_cnt - 4) / 7;
or
req_cnt++;
This is should be so?

--=20
/Evgeniy

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
