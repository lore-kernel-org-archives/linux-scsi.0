From: Borsenkow Andrej <Andrej.Borsenkow@mow.siemens.ru>
Subject: Re: 2.4.18-pre9, Iomega Jaz, PPA - endless loop in SCSI recovery
	thread
Date: 09 Jun 2002 20:04:09 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <advulo$imt$2@main.gmane.org>
References: <UTC200206082250.g58ModI20444.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <UTC200206082250.g58ModI20444.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Juan Quintela <quintela@mandrakesoft.com>

=F7 =F7=D3=CB, 09.06.2002, =D7 02:50, Andries.Brouwer@cwi.nl =CE=C1=D0=C9=
=D3=C1=CC:
>     From: Borsenkow Andrej <Andrej.Borsenkow@mow.siemens.ru>
>=20
>     It looks like a media went corrupted so one expects some reasonab=
le
>     error message. What happens is I get endless loop in SCSI error r=
ecovery
>     thread. The only way to clear up situation is to reboot
>=20
> That is the normal situation. I have never seen the SCSI error handle=
r
> do anything else but bring down the system. Commenting it out
> really increases the stability of Linux (on my hardware).
>=20

MAINTAINERS:

SCSI SUBSYSTEM
L:      linux-scsi@vger.kernel.org
S:      Unmaintained

Oh, well ...


> Hmm. It is clear what happens.
> You are in scsi_error.c:scsi_send_eh_cmnd() and send a command,
> the return status is NEEDS_RETRY, and the same command is sent again.=
 Etc.
>=20
> Now retrying is evil, and trying more than three times almost always
> stupid, so if you add in this function
>=20
> 	int retry_count =3D 0;
>=20
> and
>=20
>     retry:
> 	if (++retry_count > 3) {
> 		SCpnt->eh_state =3D FAILED;
> 		return;
> 	}
>=20
> that would surely be an improvement locally.
> Globally one wonders: there is a retry count already - why isn't it
> honoured by everybody involved? (But it isnt - it is only used in
> scsi_decide_disposition().)
>

Which actually looks like an oversight ... and comments in unjam_host
loop even indicate this must be used.

Anyway, returning FAILED does not look right here. As long as I
understand what happens, FAILED means hard error (like failing to
communicate with device) while here we have more or less "soft" error.
So I decided to copy relevant bits from scsi_decide_disposition into
scsi_eh_completed_normally which resulted in pretty nice overall error
handling:

Jun  9 19:30:45 localhost kernel: Activating command for device 4 (1)
Jun  9 19:30:45 localhost kernel: Doing sd request, dev =3D 0x804, bloc=
k =3D 944448
Jun  9 19:30:45 localhost kernel: sda : real dev =3D /dev/0, block =3D =
944480
Jun  9 19:30:45 localhost kernel: sda : reading 8/8 512 byte blocks.
Jun  9 19:30:45 localhost kernel: Adding timer for command cfe5a000 at =
6000 (d2a13964)
Jun  9 19:30:45 localhost kernel: scsi_dispatch_cmnd (host =3D 0, chann=
el =3D 0, target =3D 4, command =3D cfe5a058, buffer =3D ca4d4000,=20
Jun  9 19:30:45 localhost kernel: bufflen =3D 4096, done =3D d2813b84)
Jun  9 19:30:45 localhost kernel: queuecommand : routine at d2a38292
Jun  9 19:30:45 localhost kernel: leaving scsi_dispatch_cmnd()
Jun  9 19:30:47 localhost kernel: Clearing timer for command cfe5a000 1
Jun  9 19:30:47 localhost kernel: Command failed cfe5a000 2 active=3D1 =
busy=3D1 failed=3D0
Jun  9 19:30:47 localhost kernel: bh08:04: old sense key None
Jun  9 19:30:47 localhost kernel: Non-extended sense class 0 code 0x0
Jun  9 19:30:47 localhost kernel: Waking error handler thread (-1)
Jun  9 19:30:47 localhost kernel: Error handler waking up
Jun  9 19:30:47 localhost kernel: scsi_unjam_host: Checking to see if w=
e need to request sense
Jun  9 19:30:47 localhost kernel: scsi_unjam_host: Requesting sense for=
 4
Jun  9 19:30:47 localhost kernel: Adding timer for command cfe5a000 at =
1000 (d2a13af8)
Jun  9 19:30:47 localhost kernel: In eh_done cfe5a000 result:0
Jun  9 19:30:47 localhost kernel: send_eh_cmnd: cfe5a000 eh_state:2002
Jun  9 19:30:47 localhost kernel: scsi_send_eh_cmnd: scsi_eh_completed_=
normally 2002
Jun  9 19:30:47 localhost kernel: Sense requested for cfe5a000 - result=
 2
Jun  9 19:30:47 localhost kernel: Info fld=3D0xe6960, Current bh08:04: =
sense key Medium Error
Jun  9 19:30:47 localhost kernel: Additional sense indicates Address ma=
rk not found for data field
Jun  9 19:30:47 localhost kernel: Adding timer for command cfe5a000 at =
6000 (d2a13af8)
Jun  9 19:30:49 localhost kernel: In eh_done cfe5a000 result:2
Jun  9 19:30:49 localhost kernel: send_eh_cmnd: cfe5a000 eh_state:2002
Jun  9 19:30:49 localhost kernel: scsi_send_eh_cmnd: scsi_eh_completed_=
normally 2001
Jun  9 19:30:49 localhost kernel: Adding timer for command cfe5a000 at =
6000 (d2a13af8)
Jun  9 19:30:51 localhost kernel: In eh_done cfe5a000 result:2
Jun  9 19:30:51 localhost kernel: send_eh_cmnd: cfe5a000 eh_state:2002
Jun  9 19:30:51 localhost kernel: scsi_send_eh_cmnd: scsi_eh_completed_=
normally 2001
Jun  9 19:30:51 localhost kernel: Adding timer for command cfe5a000 at =
6000 (d2a13af8)
Jun  9 19:30:53 localhost kernel: In eh_done cfe5a000 result:2
Jun  9 19:30:53 localhost kernel: send_eh_cmnd: cfe5a000 eh_state:2002
Jun  9 19:30:53 localhost kernel: scsi_send_eh_cmnd: scsi_eh_completed_=
normally 2001
Jun  9 19:30:53 localhost kernel: Adding timer for command cfe5a000 at =
6000 (d2a13af8)
Jun  9 19:30:55 localhost kernel: In eh_done cfe5a000 result:2
Jun  9 19:30:55 localhost kernel: send_eh_cmnd: cfe5a000 eh_state:2002
Jun  9 19:30:55 localhost kernel: scsi_send_eh_cmnd: scsi_eh_completed_=
normally 2002
Jun  9 19:30:55 localhost kernel: Total of 0+0 commands on 0 devices re=
quire eh work
Jun  9 19:30:55 localhost kernel: Adding timer for command cfe5a000 at =
100 (d2a13af8)
Jun  9 19:30:55 localhost kernel: Clearing timer for command cfe5a000 1
Jun  9 19:30:55 localhost kernel: scsi_error.c: Waking up host to resta=
rt
Jun  9 19:30:55 localhost kernel: Error handler sleeping
Jun  9 19:30:55 localhost kernel: Command finished 1 0 0x2
Jun  9 19:30:55 localhost kernel: Notifying upper driver of completion =
for device 4 8000002
Jun  9 19:30:55 localhost kernel: sda : rw_intr(0, 8000002 [f0 3])
Jun  9 19:30:55 localhost kernel: scsi0: ERROR on channel 0, id 4, lun =
0, CDB: Read (10) 00 00 0e 69 60 00 00 08 00=20
Jun  9 19:30:55 localhost kernel: Info fld=3D0xe6960, Current sd08:04: =
sense key Medium Error
Jun  9 19:30:55 localhost kernel: Additional sense indicates Address ma=
rk not found for data field
Jun  9 19:30:55 localhost kernel: I/O error: dev 08:04, sector 944448
Jun  9 19:30:55 localhost kernel: Deactivating command for device 4 (ac=
tive=3D0, failed=3D0)
Jun  9 19:30:55 localhost kernel: Open returning 1
Jun  9 19:30:55 localhost kernel: Trying ioctl with scsi command 30
Jun  9 19:30:55 localhost kernel: scsi_do_req (host =3D 0, channel =3D =
0 target =3D 4, buffer =3D00000000, bufflen =3D 0, done =3D d2a0f088, t=
imeout =3D 1000, retries =3D 5)
Jun  9 19:30:55 localhost kernel: command : 1e  00  00  00  00  00 =20
Jun  9 19:30:55 localhost kernel: Activating command for device 4 (1)
Jun  9 19:30:55 localhost kernel: Leaving scsi_init_cmd_from_req()
Jun  9 19:30:55 localhost kernel: Adding timer for command cfe5a000 at =
1000 (d2a13964)
Jun  9 19:30:55 localhost kernel: scsi_dispatch_cmnd (host =3D 0, chann=
el =3D 0, target =3D 4, command =3D cfe5a058, buffer =3D 00000000,=20
Jun  9 19:30:55 localhost kernel: bufflen =3D 0, done =3D d2a0f088)
Jun  9 19:30:55 localhost kernel: queuecommand : routine at d2a38292
Jun  9 19:30:55 localhost kernel: leaving scsi_dispatch_cmnd()
Jun  9 19:30:55 localhost kernel: Leaving scsi_do_req()
Jun  9 19:30:55 localhost kernel: Clearing timer for command cfe5a000 1
Jun  9 19:30:55 localhost kernel: Command finished 1 0 0x0
Jun  9 19:30:55 localhost kernel: Notifying upper driver of completion =
for device 4 0
Jun  9 19:30:55 localhost kernel: Deactivating command for device 4 (ac=
tive=3D0, failed=3D0)
Jun  9 19:30:55 localhost kernel: Ioctl returned  0x0
Jun  9 19:30:55 localhost kernel: IOCTL Releasing command

=20
> Where did we get this NEEDS_RETRY in the first place?
> Well, scsi_check_sense() will return NEEDS_RETRY for MEDIUM_ERROR.
> (Bad: the hardware also did retry many times already; it is usually v=
ery
> counterproductive to keep on hitting the same bad spot on the media.)
>

I do not dare to touch it. Whoever wrote the code must have some reason=
s
behind. Still, the obvious patch the shuts at least this code path
follows.=20

-andrej

> There are also other code paths that will loop, but this one
> looks most likely here.
>=20
> Andries
>=20

--- linux-2.4.18-18mdk/drivers/scsi/scsi_error.c.scsi-eh-timeout	Thu Ma=
y 30 16:22:37 2002
+++ linux-2.4.18-18mdk/drivers/scsi/scsi_error.c	Sun Jun  9 19:18:11 20=
02
@@ -1100,6 +1100,8 @@
  */
 STATIC int scsi_eh_completed_normally(Scsi_Cmnd * SCpnt)
 {
+	int rtn;
+
 	/*
 	 * First check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
@@ -1113,14 +1115,18 @@
 			 * otherwise we just flag it as success.
 			 */
 			SCpnt->flags &=3D ~IS_RESETTING;
-			return NEEDS_RETRY;
+			goto maybe_retry;
 		}
 		/*
 		 * Rats.  We are already in the error handler, so we now get to try
 		 * and figure out what to do next.  If the sense is valid, we have
 		 * a pretty good idea of what to do.  If not, we mark it as failed.
 		 */
-		return scsi_check_sense(SCpnt);
+		rtn =3D scsi_check_sense(SCpnt);
+		if (rtn =3D=3D NEEDS_RETRY) {
+			goto maybe_retry;
+		}
+		return rtn;
 	}
 	if (host_byte(SCpnt->result) !=3D DID_OK) {
 		return FAILED;
@@ -1139,7 +1145,11 @@
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case CHECK_CONDITION:
-		return scsi_check_sense(SCpnt);
+		rtn =3D scsi_check_sense(SCpnt);
+		if (rtn =3D=3D NEEDS_RETRY) {
+			goto maybe_retry;
+		}
+		return rtn;
 	case CONDITION_GOOD:
 	case INTERMEDIATE_GOOD:
 	case INTERMEDIATE_C_GOOD:
@@ -1154,6 +1164,17 @@
 		return FAILED;
 	}
 	return FAILED;
+
+      maybe_retry:
+
+	if ((++SCpnt->retries) < SCpnt->allowed) {
+		return NEEDS_RETRY;
+	} else {
+                /*
+                 * No more retries - report this one back to upper lev=
el.
+                 */
+		return SUCCESS;
+	}
 }
=20
 /*
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
