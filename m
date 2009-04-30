From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Subject: Re: [PATCH]: fixing gcc 4.4 =?utf-8?Q?comp?=
	=?utf-8?Q?iler_warning=3A_suggest_parentheses_around_operand_of_=E2=80=98?=
	=?utf-8?B?IeKAmQ==?=
Date: Fri, 1 May 2009 00:59:06 +0300
Message-ID: <20090430215906.GA5214@mydomain.tld>
References: <20090430060430.GA6040@localhost> <1241127084.3320.14.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.98.175.89] ([212.98.175.89]:56064 "EHLO mydomain.tld"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755533AbZD3WAF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2009 18:00:05 -0400
Content-Disposition: inline
In-Reply-To: <1241127084.3320.14.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>

On (30/04/09 21:31), James Bottomley wrote:
> To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel=
=2Eorg,
> 	Kai Makisara <Kai.Makisara@kolumbus.fi>
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Subject: Re: [PATCH]: fixing gcc 4.4 compiler warning: suggest parent=
heses
> 	around operand of =E2=80=98!=E2=80=99
>=20
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
>=20
> James
>=20

Hello James.
It's not clear to me why STp->use_pf |=3D PF_TESTED; is correct fix=20
(since STp->use_pf =3D (!STp->use_pf) | PF_TESTED; is not equals to STp=
->use_pf |=3D PF_TESTED;).

Would you provide some explanations?

Thanks.

Sergey.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
