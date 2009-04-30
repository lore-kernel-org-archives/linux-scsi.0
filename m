From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]: fixing gcc 4.4 compiler warning: suggest parentheses
 around operand of =?UTF-8?Q?=E2=80=98!=E2=80=99?=
Date: Thu, 30 Apr 2009 14:46:56 -0700
Message-ID: <20090430144656.714fe853.akpm@linux-foundation.org>
References: <20090430060430.GA6040@localhost>
	<1241127084.3320.14.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbZD3Vt5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2009 17:49:57 -0400
In-Reply-To: <1241127084.3320.14.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sergey.senozhatsky@mail.by, linux-scsi@vger.kernel.org, Kai.Makisara@kolumbus.fi

On Thu, 30 Apr 2009 21:31:24 +0000
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2009-04-30 at 09:04 +0300, Sergey Senozhatsky wrote:
> > Trivial: fixing gcc 4.4 compiler warning:
> > drivers/scsi/st.c: In function =E2=80=98st_int_ioctl=E2=80=99:
> > drivers/scsi/st.c:2967: warning: suggest parentheses around operand=
 of =E2=80=98!=E2=80=99 or change =E2=80=98|=E2=80=99 to =E2=80=98||=E2=
=80=99 or =E2=80=98!=E2=80=99 to =E2=80=98~=E2=80=99
> >=20
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> >=20
> > ---
> >=20
> > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > index eb24efe..2bde8a5 100644
> > --- a/drivers/scsi/st.c
> > +++ b/drivers/scsi/st.c
> > @@ -2964,7 +2964,7 @@ static int st_int_ioctl(struct scsi_tape *STp=
, unsigned int cmd_in, unsigned lon
> >  			    !(STp->use_pf & PF_TESTED)) {
> >  				/* Try the other possible state of Page Format if not
> >  				   already tried */
> > -				STp->use_pf =3D !STp->use_pf | PF_TESTED;
> > +				STp->use_pf =3D (!STp->use_pf) | PF_TESTED;
>=20
> This just doesn't look right.  As I said to the warning reporter, I
> think STp->use_pf |=3D PF_TESTED; is the correct fix, but I need Kai =
to
> check this.

yeah, good point.  The code looks very confused.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
