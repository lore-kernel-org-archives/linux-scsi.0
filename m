From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: 2.6.5-rc1 SCSI + st regressions (was: Linux 2.6.5-rc1)
Date: Wed, 17 Mar 2004 19:45:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040318014525.GE20793@hexapodia.org>
References: <Pine.LNX.4.58.0403152154070.19853@ppc970.osdl.org> <20040316211203.GA3679@merlin.emma.line.org> <20040316211700.GA25059@parcelfarce.linux.theplanet.co.uk> <20040316215659.GA3861@merlin.emma.line.org> <Pine.LNX.4.58.0403172145420.1093@kai.makisara.local> <20040317213201.GB5722@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pirx.hexapodia.org ([65.103.12.242]:56751 "EHLO
	pirx.hexapodia.org") by vger.kernel.org with ESMTP id S262283AbUCRBp0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 20:45:26 -0500
Content-Disposition: inline
In-Reply-To: <20040317213201.GB5722@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>

On Wed, Mar 17, 2004 at 10:32:01PM +0100, Matthias Andree wrote:
> On Wed, 17 Mar 2004, Kai Makisara wrote:
> > # ChangeSet
> > #   2004/03/12 16:22:36-08:00 greg@kroah.com=20
> > #   remove cdev_set_name completely as it is not needed.
> >=20
> > (and editing drivers/char/tty_io.c to get the kernel to compile) so=
lved=20
> > the problem for me. st.c is using the name put into kobj.name in ma=
king=20
> > the class file names. I will make a patch that removes this depende=
ncy.
>=20
> I had backed out that ChangeSet here as I was suspecting it (about th=
e
> only one "new enough" to cause these problems) but bumped into tty_io=
=2Ec
> compile failures and didn't have time to investigate.
>=20
> > While looking at this problem, I noticed that the naming changes al=
ready=20
> > committed to BK had disappeared. Looking at st.c history revealed t=
hat the=20
> > following change had been committed (sorry for wrapping) by greg@kr=
oah.com=20
> > 46 hours ago:
>=20
> This is how the change tree looks like in BitKeeper's histtool,
> the top line is the date in MM-DD format:
>=20
> 02-22  02-24   03-03     03-13        03-13           03-15
> kai  -> axb=F8 -> kai ------------------------------->  greg
> 1.78    1.79\   1.80                                  1.81
>              \                                   /
>               `----------corbet-------greg------'
>                          1.79.1.1     1.79.1.2
>=20
> ...
>=20
> Logs:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D st.c 1.1..1.81 =3D=3D=3D=3D=3D=3D=3D=3D
> D 1.81 04/03/15 15:02:26-08:00 greg@kroah.com 104 101 0/5/4363
> P drivers/scsi/st.c
> C merge
> ------------------------------------------------
> D 1.79.1.2 04/03/12 08:22:11-08:00 greg@kroah.com[greg] 103 102 0/1/4=
350
> P drivers/scsi/st.c
> C remove cdev_set_name completely as it is not needed.
> ------------------------------------------------
> D 1.79.1.1 04/03/13 00:47:18-08:00 corbet@lwn.net[greg] 102 100 2/3/4=
349
> P drivers/scsi/st.c
> C cdev 2/2: hide cdev->kobj
> ------------------------------------------------
> D 1.80 04/02/26 05:24:19-06:00 Kai.Makisara@kolumbus.fi[jejb] 101 100=
 28/12/4340
> P drivers/scsi/st.c
> C SCSI tape sysfs name fixes
> ------------------------------------------------
> D 1.79 04/02/23 06:23:46-08:00 axboe@suse.de[torvalds] 100 99 1/1/435=
1
> P drivers/scsi/st.c
> C fix SCSI non-sector bio backed IO
>=20
> > The change comment was "merge" and it resulted in st.c version 1.81=
=2E (I am=20
> > not using Bitkeeper but trying to extract information from bkbits.n=
et.)
>=20
> BitKeeper doesn't have more info and this doesn't look like an auto-g=
enerated
> comment of BitKeeper's, but seems to have been entered manually. Blam=
e Greg?

That's a pretty nasty merge, so it's not real suprising that Greg didn'=
t
get it completely right.

Nice ASCII art, BTW.  If you can reduce it to an algorithm I bet Larry
would like to hire you to add it to BK. :)

-andy
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
