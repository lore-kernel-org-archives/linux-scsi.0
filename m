From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [regression] CD-DA delay needed after insertion
Date: Sun, 15 Jun 2008 15:46:04 +0300
Message-ID: <48550F0C.8030907@panasas.com>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758142AbYFOMqn@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Geert Uytterhoeven wrote:
> We've found another regression in 2.6.25 w.r.t. CD media change on PS=
3.
>=20
> It can easily be reproduced by:
>=20
>   1. Inserting an audio CD
>   2. Running the following command as soon as the blue CD/DVD/BD driv=
e LED
>      stops blinking and is lit continuously:
>      =20
> 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
>=20
> On 2.6.25 (and current mainline), you have to wait ca. 10 seconds aft=
er
> insertion, or it will fail.
> On 2.6.24 and older, it just works immediately.
>=20
> It does not matter whether
> http://git.kernel.org/?p=3Dlinux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixe=
s-2.6.git;a=3Dcommitdiff_plain;h=3Dd1daeabf0da5bfa1943272ce508e2ba78573=
0bf0
> is applied or not.
>=20
> We haven't bisected it yet.
>=20
> With kind regards,
>=20
> Geert Uytterhoeven
> Software Architect
>=20
> Sony Techsoft Centre
> The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem=
 =C2=B7 Belgium
>=20
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@sonycom.com
> Internet: http://www.sony-europe.com/
>=20
> Sony Technology and Software Centre Europe
> A division of Sony Service Centre (Europe) N.V.
> Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 =
Belgium
> VAT BE 0413.825.160 =C2=B7 RPR Brussels
> Fortis 293-0376800-10 GEBA-BE-BB

James hi.

It looks like the same problem as before. Any BLOCK_PC command will=20
eat the UNIT_ATTENTION notification. Which is what I was afraid of.=20
I was thinking of something like below.

Totally untested, never even booted. It is just to demonstrate the conc=
ept.
Please tell me if it is at all desirable and I'll spend some time to se=
e
if it runs, and test it.

Boaz
---
=46rom 8cd166b76100a2830f0f973df866f5509398f6cc Mon Sep 17 00:00:00 200=
1
=46rom: Boaz Harrosh <bharrosh@panasas.com>
Date: Tue, 10 Jun 2008 20:09:43 +0300
Subject: [PATCH] scsi: Proccess UNIT_ATTENTION on any type command

Let scsi_check_sense() report UNIT_ATTENTION media
changes for any type of command. Currently only FS
commands are reported.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |    4 ++++
 drivers/scsi/scsi_lib.c   |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 006a959..7039d11 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -370,6 +370,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd=
)
 		if (scmd->device->allow_restart &&
 		    (sshdr.asc =3D=3D 0x04) && (sshdr.ascq =3D=3D 0x02))
 			return FAILED;
+
+		/* Detected disc change.*/
+		if (scmd->device->removable)
+			scmd->device->changed =3D 1;
 		return SUCCESS;
=20
 		/* these three are not supported */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 033c58a..efd3e09 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -903,11 +903,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, un=
signed int good_bytes)
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			if (cmd->device->removable) {
+			if (cmd->device->changed) {
 				/* Detected disc change.  Set a bit
 				 * and quietly refuse further access.
 				 */
-				cmd->device->changed =3D 1;
 				scsi_end_request(cmd, -EIO, this_count, 1);
 				return;
 			} else {
--=20
1.5.6.rc1.5.gadf6
