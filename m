From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym53c8xx driver hangs
Date: Fri, 18 Feb 2005 19:25:31 +0000
Message-ID: <20050218192531.GZ29917@parcelfarce.linux.theplanet.co.uk>
References: <4214BD90.7030002@ludd.luth.se> <20050218051916.GX29917@parcelfarce.linux.theplanet.co.uk> <4215BDFF.6040703@ludd.luth.se> <20050218121556.GY29917@parcelfarce.linux.theplanet.co.uk> <42162052.9030304@ludd.luth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:40685 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261451AbVBRTZh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 14:25:37 -0500
Content-Disposition: inline
In-Reply-To: <42162052.9030304@ludd.luth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roger =?iso-8859-1?Q?H=E5kansson?= <hson@ludd.luth.se>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Fri, Feb 18, 2005 at 06:05:22PM +0100, Roger H=E5kansson wrote:
> Matthew Wilcox wrote:
> >Oh.  I think I'm confused as to which version of sym2 is in which ve=
rsion
> >of Linus' tree.  The same line in my development tree reads:
>=20
> Well, I guess that part of the driver is rewritten a bit, I get a=20
> compile error if I put that in ;)

Oh, er, yes, looking at the diff from 2.6.10 shows I did ...

+       struct sym_trans *goal =3D &tp->tinfo.goal;
+       struct sym_trans *curr =3D &tp->tinfo.curr;

lalalla ;-)

> But yes, it works if I put in:
>=20
> if ((tp->tinfo.goal.options & PPR_OPT_MASK) ||
>     (tp->tinfo.goal.period < 0xa)) {

Excellent.  Then 2.6.11 works for Ultrium tape drives.  Yay!  Tick anot=
her
annoying bug off the list ... just the strange not-working-on-Alpha bug
to investigate, I think.

--=20
"Next the statesmen will invent cheap lies, putting the blame upon=20
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refu=
se
to examine any refutations of them; and thus he will by and by convince=
=20
himself that the war is just, and will thank God for the better sleep=20
he enjoys after this process of grotesque self-deception." -- Mark Twai=
n
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
