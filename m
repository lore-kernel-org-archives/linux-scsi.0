From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH]: fixing gcc 4.4 compiler warning: suggest parentheses
	around operand of =?UTF-8?Q?=E2=80=98!=E2=80=99?=
Date: Thu, 30 Apr 2009 21:31:24 +0000
Message-ID: <1241127084.3320.14.camel@mulgrave.int.hansenpartnership.com>
References: <20090430060430.GA6040@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41434 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbZD3VbZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2009 17:31:25 -0400
In-Reply-To: <20090430060430.GA6040@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>

On Thu, 2009-04-30 at 09:04 +0300, Sergey Senozhatsky wrote:
> Trivial: fixing gcc 4.4 compiler warning:
> drivers/scsi/st.c: In function =E2=80=98st_int_ioctl=E2=80=99:
> drivers/scsi/st.c:2967: warning: suggest parentheses around operand o=
f =E2=80=98!=E2=80=99 or change =E2=80=98|=E2=80=99 to =E2=80=98||=E2=80=
=99 or =E2=80=98!=E2=80=99 to =E2=80=98~=E2=80=99
>=20
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
>=20
> ---
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index eb24efe..2bde8a5 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -2964,7 +2964,7 @@ static int st_int_ioctl(struct scsi_tape *STp, =
unsigned int cmd_in, unsigned lon
>  			    !(STp->use_pf & PF_TESTED)) {
>  				/* Try the other possible state of Page Format if not
>  				   already tried */
> -				STp->use_pf =3D !STp->use_pf | PF_TESTED;
> +				STp->use_pf =3D (!STp->use_pf) | PF_TESTED;

This just doesn't look right.  As I said to the warning reporter, I
think STp->use_pf |=3D PF_TESTED; is the correct fix, but I need Kai to
check this.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
