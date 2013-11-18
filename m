From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: be_iscsi: fix possible memory leak and refactor
 code
Date: Mon, 18 Nov 2013 08:24:24 -0800
Message-ID: <1384791864.2001.19.camel@dabdike.int.hansenpartnership.com>
References: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
	 <1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
	 <CAGG-pURSnEeNvmHhQ-GvrnyuMHPrTRMoCKt3P=bB23OD9Vmkpg@mail.gmail.com>
	 <1384724339.2050.6.camel@dabdike.int.hansenpartnership.com>
	 <CAGG-pUT_h1eNnHDpxRvMPWeN5zi6L2mckHMPsV92Qf3hqtf7EQ@mail.gmail.com>
	 <1384786707.2001.6.camel@dabdike.int.hansenpartnership.com>
	 <CAGG-pURDPHOGuSt7a1G=CpdgvyiUvW0ugKq0K_o7-ThCS39F-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57118 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243Ab3KRQY1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Nov 2013 11:24:27 -0500
In-Reply-To: <CAGG-pURDPHOGuSt7a1G=CpdgvyiUvW0ugKq0K_o7-ThCS39F-A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geyslan =?ISO-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On Mon, 2013-11-18 at 14:18 -0200, Geyslan Greg=F3rio Bem wrote:
> 2013/11/18 James Bottomley <James.Bottomley@hansenpartnership.com>:
> > On Sun, 2013-11-17 at 23:12 -0200, Geyslan Greg=F3rio Bem wrote:
> >> 2013/11/17 James Bottomley <James.Bottomley@hansenpartnership.com>=
:
> >> > On Sun, 2013-11-17 at 19:09 -0200, Geyslan Greg=F3rio Bem wrote:
> >> >> 2013/11/17 James Bottomley <James.Bottomley@hansenpartnership.c=
om>:
> >> >> > On Sun, 2013-11-17 at 15:51 -0300, Geyslan G. Bem wrote:
> >> >> >> This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VLAN=
_ID' and
> >> >> >> 'ISCSI_NET_PARAM_VLAN_PRIORITY' and refactors code 'going ou=
t' when
> >> >> >> necessary.
> >> >> >
> >> >> > You pointlessly renamed a variable, which makes the diff hard=
 to read.
> >> >> > Please don't do that.
> >> >>
> >> >> Ok, I can agree. 'len' means length? What is returned in case o=
f non
> >> >> error?
> >> >
> >> > it returns the length of buf written to or negative error.
> >> >
> >> >> > You missed the fact that the passed in pointer is unmodified =
if
> >> >> > mgmt_get_if_info() returns non zero, so the kfree frees junk =
and would
> >> >> > oops.
> >> >> >
> >> >> > There's no need for a goto; len =3D -EINVAL; does everything =
that's
> >> >> > needed.
> >> >>
> >> >> Well, that is a coverity catch. CID 1128954. Check it.
> >> >
> >> > I didn't say coverity was wrong, I said your patch was (well not=
 wrong,
> >> > just over complex and incomplete).  This is the way to fix both
> >> > problems.
> >> >
> >> > James
> >> >
> >> > ---
> >> >
> >> > diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2=
iscsi/be_iscsi.c
> >> > index ffadbee..9dcbdfa 100644
> >> > --- a/drivers/scsi/be2iscsi/be_iscsi.c
> >> > +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> >> > @@ -541,10 +541,8 @@ static int be2iscsi_get_if_param(struct bei=
scsi_hba *phba,
> >> >                 ip_type =3D BE2_IPV6;
> >>
> >> James, this approach will not prevent the leakage.
> >
> > I don't see why not.  The -EINVAL case goes through the kfree() now=
 too,
> > no?
>=20
> I'm refering to the removal of kfree in your suggestion.

That's the second bug I pointed out via code inspection.  If the
function returns an error (any non zero return) then the pointer isn't
altered, so we return without the free.  It's a standard error pattern.

> >
> >>  We can initialize the if_info with NULL and always kfree it witho=
ut
> >> to care about junk.
> >
> > Why?  Error return means no allocation.
> Setting if_info to NULL allow to kfree without concerns.
>=20
> Eg.:
>=20
> - struct be_cmd_get_if_info_resp *if_info;
> + struct be_cmd_get_if_info_resp *if_info =3D NULL;
>=20
> ...
>=20
> +       if (len)
> +               goto out;
>=20
> ...
>=20
> -               if (if_info->vlan_priority =3D=3D BEISCSI_VLAN_DISABL=
E)
> -                       return -EINVAL;
> +               if (if_info->vlan_priority =3D=3D BEISCSI_VLAN_DISABL=
E) {
> +                       len =3D -EINVAL;
> +                       goto out;
> +               }

What's the point of that?  Just removing the goto out; has the code
going to the same place because of the break below.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
