From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 2/2] scsi: aacraid: Off by one NUL terminator
Date: Thu, 27 Jul 2017 16:26:17 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5307D0DC@avsrvexchmbx2.microsemi.net>
References: <20170725195110.uwrzzkzvrbfqv7ld@mwanda>
 <yq1wp6uwp9c.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <yq1wp6uwp9c.fsf@oracle.com>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


>=20
> Dan,
>=20
> > We're putting a NUL terminator one character beyond the end of the
> > struct and that's obviously wrong.  On the other hand, I'm not
> > positive this is the correct fix.  This change was added deliberately
> > and was mentioned in the changlog of commit b836439faf04 ("aacraid:
> > 4KB sector support").  The relevant section is "Also fix up a name
> > truncation problem".  Can someone review this code and figure out the
> > right thing to do?
>=20
> I guess that's a feeble attempt to compensate for the fact it's not a C s=
tring. The
> string coming from the controller firmware appears to be a fixed 16-byte =
length.
> And so is the inquiry buffer that it's being copied to.
>=20
> If the code would just use the inquiry string verbatim instead of removin=
g
> leading spaces and padding it. But there was probably some crappy device =
out
> there that broke something for someone...

Hi Martin, Dan,

The issue is that we are making an inquiry response from container/RAID inf=
o. We could also have included a "pad" byte to terminate the string, as the=
 fib data is 512 bytes. My assumption is that somehow back in the day, some=
one managed to get odd characters into the name.

Terminating the string early would truncate the name ...

-Dave
>=20
> Anyway. Terminating the string is not the right fix.
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
