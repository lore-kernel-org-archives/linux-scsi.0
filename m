From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH v3 3/5] st: get rid of scsi_tapes array
Date: Sun, 1 Jul 2012 11:57:48 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1207011147110.3650@kai.makisara.local>
References: <4FBACC66.80208@suse.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-1340321357-1341133077=:3650"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FBACC66.80208@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jeffm@suse.com
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-1340321357-1341133077=:3650
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 21 May 2012, Lee Duncan wrote:

> From: Jeff Mahoney <jeffm@suse.com>
>=20
> st currently allocates an array to store pointers to all of the
> scsi_tape objects. It's used to discover available indexes to use as th=
e
> base for the minor number selection and later to look up scsi_tape
> devices for character devices.
>=20
> We switch to using an IDR for minor selection and a pointer from
> st_modedef back to scsi_tape for the lookups.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/st.c |  172 ++++++++++++++++++++-------------------------=
--------
>  drivers/scsi/st.h |    2 +
>  2 files changed, 65 insertions(+), 109 deletions(-)
>=20
... patch removed

I have finally had time to review and test this patch set. I am sorry thi=
s=20
has taken so long.

I have found one change of behaviour and a theoretical problem:
The new code does not re-use the tape numbers when freed and re-scanned.=20
The current code does re-use the freed numbers. Are there any reasons for=
=20
this changed behaviour? (The theoretical problem is that the new code=20
frees the tape structure but leaves the pointer in the idr tree.)

The patch at the end of this message (applies after the whole series) is=20
an attempt to implement re-use of tape numbers. I am not completely sure=20
that the change is correctly placed but it seems to work.

Another minor thing is that the documentation should be updated :-)

The patch at the end also updates the version code. I am not sure if the=20
version code is useful, but it should be either updated or removed.

Otherwise no problems found. I am ready to ack the patch set after the=20
re-use thing has been resolved (one way or another).

Thanks,
Kai

-----------------------------8<------------------------------------------=
--
--- linux-3.5-rc4/drivers/scsi/st.c.orig	2012-07-01 09:32:21.826666580 +0=
300
+++ linux-3.5-rc4/drivers/scsi/st.c	2012-07-01 11:43:49.154332920 +0300
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs=
 support
  */
=20
-static const char *verstr =3D "20101219";
+static const char *verstr =3D "20120701";
=20
 #include <linux/module.h>
=20
@@ -4273,6 +4273,9 @@ static void scsi_tape_release(struct kre
=20
 	disk->private_data =3D NULL;
 	put_disk(disk);
+	spin_lock(&st_index_lock);
+	idr_remove(&st_index_idr, tpnt->index);
+	spin_unlock(&st_index_lock);
 	kfree(tpnt);
 	return;
 }
--- linux-3.5-rc4/Documentation/scsi/st.txt.orig	2012-07-01 11:42:34.7066=
07154 +0300
+++ linux-3.5-rc4/Documentation/scsi/st.txt	2012-07-01 11:41:27.542857135=
 +0300
@@ -2,7 +2,7 @@ This file contains brief information abo
 The driver is currently maintained by Kai M=C3=A4kisara (email
 Kai.Makisara@kolumbus.fi)
=20
-Last modified: Sun Aug 29 18:25:47 2010 by kai.makisara
+Last modified: Sun Jul  1 11:41:27 2012 by kai.makisara
=20
=20
 BASICS
@@ -112,10 +112,8 @@ attempted).
=20
 MINOR NUMBERS
=20
-The tape driver currently supports 128 drives by default. This number
-can be increased by editing st.h and recompiling the driver if
-necessary. The upper limit is 2^17 drives if 4 modes for each drive
-are used.
+The upper limit is 2^17 drives if 4 modes for each drive are used. The
+tape driver currently supports drives up to this limit.
=20
 The minor numbers consist of the following bit fields:
=20

---1463811327-1340321357-1341133077=:3650--
