From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: 2.6.5-rc1 SCSI + st regressions (was: Linux 2.6.5-rc1)
Date: Wed, 17 Mar 2004 22:32:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040317213201.GB5722@merlin.emma.line.org>
References: <Pine.LNX.4.58.0403152154070.19853@ppc970.osdl.org> <20040316211203.GA3679@merlin.emma.line.org> <20040316211700.GA25059@parcelfarce.linux.theplanet.co.uk> <20040316215659.GA3861@merlin.emma.line.org> <Pine.LNX.4.58.0403172145420.1093@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:25556 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S262076AbUCQVcJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 16:32:09 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0403172145420.1093@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Matthias Andree <ma+lscsi@dt.e-technik.uni-dortmund.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>

On Wed, 17 Mar 2004, Kai Makisara wrote:

> # ChangeSet
> #   2004/03/12 16:22:36-08:00 greg@kroah.com=20
> #   remove cdev_set_name completely as it is not needed.
>=20
> (and editing drivers/char/tty_io.c to get the kernel to compile) solv=
ed=20
> the problem for me. st.c is using the name put into kobj.name in maki=
ng=20
> the class file names. I will make a patch that removes this dependenc=
y.

I had backed out that ChangeSet here as I was suspecting it (about the
only one "new enough" to cause these problems) but bumped into tty_io.c
compile failures and didn't have time to investigate.

> While looking at this problem, I noticed that the naming changes alre=
ady=20
> committed to BK had disappeared. Looking at st.c history revealed tha=
t the=20
> following change had been committed (sorry for wrapping) by greg@kroa=
h.com=20
> 46 hours ago:

This is how the change tree looks like in BitKeeper's histtool,
the top line is the date in MM-DD format:

02-22  02-24   03-03     03-13        03-13           03-15
kai  -> axb=F8 -> kai ------------------------------->  greg
1.78    1.79\   1.80                                  1.81
             \                                   /
              `----------corbet-------greg------'
                         1.79.1.1     1.79.1.2

=2E..

Logs:

=3D=3D=3D=3D=3D=3D=3D=3D st.c 1.1..1.81 =3D=3D=3D=3D=3D=3D=3D=3D
D 1.81 04/03/15 15:02:26-08:00 greg@kroah.com 104 101 0/5/4363
P drivers/scsi/st.c
C merge
------------------------------------------------
D 1.79.1.2 04/03/12 08:22:11-08:00 greg@kroah.com[greg] 103 102 0/1/435=
0
P drivers/scsi/st.c
C remove cdev_set_name completely as it is not needed.
------------------------------------------------
D 1.79.1.1 04/03/13 00:47:18-08:00 corbet@lwn.net[greg] 102 100 2/3/434=
9
P drivers/scsi/st.c
C cdev 2/2: hide cdev->kobj
------------------------------------------------
D 1.80 04/02/26 05:24:19-06:00 Kai.Makisara@kolumbus.fi[jejb] 101 100 2=
8/12/4340
P drivers/scsi/st.c
C SCSI tape sysfs name fixes
------------------------------------------------
D 1.79 04/02/23 06:23:46-08:00 axboe@suse.de[torvalds] 100 99 1/1/4351
P drivers/scsi/st.c
C fix SCSI non-sector bio backed IO

> The change comment was "merge" and it resulted in st.c version 1.81. =
(I am=20
> not using Bitkeeper but trying to extract information from bkbits.net=
=2E)

BitKeeper doesn't have more info and this doesn't look like an auto-gen=
erated
comment of BitKeeper's, but seems to have been entered manually. Blame =
Greg?

--=20
Matthias Andree

Encrypt your mail: my GnuPG key ID is 0x052E7D95
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
