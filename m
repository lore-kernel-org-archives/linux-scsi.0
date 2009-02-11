From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH -stable resend] fix USB_STORAGE_CYPRESS_ATACB
Date: Wed, 11 Feb 2009 09:54:31 +0200
Message-ID: <49928437.6020807@panasas.com>
References: <495913A6.9070007@free.fr> <20081229192431.GZ1469@one-eyed-alien.net> <495A475D.7060608@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <495A475D.7060608-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, matthieu castet <castet.matthieu-GANU6spQydw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

James hi.

I'm resending a forgotten patch. See here:
http://lkml.indiana.edu/hypermail/linux/kernel/0812.3/01127.html

I'll need Matthew Dharm ACK or who ever maintains cypress_atacb

---
=46rom: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] fix USB_STORAGE_CYPRESS_ATACB

commit 64a87b24: [SCSI] Let scsi_cmnd->cmnd use request->cmd buffer
changed the scsi_eh_prep_cmnd logic by making it clear
the ->cmnd buffer. But the sat to cypress atacb translation supposed
the ->cmnd buffer wasn't modified.

This patch makes it set the ->cmnd buffer after scsi_eh_prep_cmnd call.
The problem and a fix was reported by Matthieu CASTET <castet.matthieu@=
free.fr>

It also removes all the hackery fiddling of scsi_cmnd and scsi_eh_save =
by
requesting from scsi_eh_prep_cmnd to prepare a read into ->sense_buffer=
,
which is much more suitable a buffer for HW transfers, then after the c=
ommand
execution the regs read is copied into regs buffer before actual prepar=
ation
of sense_buffer.

Also fix an alien comment character to my utf-8 editor.

Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Matthieu CASTET <castet.matthieu-GANU6spQydw@public.gmane.org>
CC: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
 drivers/usb/storage/cypress_atacb.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/=
cypress_atacb.c
index 898e67d..9466a99 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -133,19 +133,18 @@ void cypress_atacb_passthrough(struct scsi_cmnd *=
srb, struct us_data *us)
=20
 		/* build the command for
 		 * reading the ATA registers */
-		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, 0);
-		srb->sdb.length =3D sizeof(regs);
-		sg_init_one(&ses.sense_sgl, regs, srb->sdb.length);
-		srb->sdb.table.sgl =3D &ses.sense_sgl;
-		srb->sc_data_direction =3D DMA_FROM_DEVICE;
-		srb->sdb.table.nents =3D 1;
+		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, sizeof(regs));
+
 		/* we use the same command as before, but we set
 		 * the read taskfile bit, for not executing atacb command,
 		 * but reading register selected in srb->cmnd[4]
 		 */
+		srb->cmd_len =3D 16;
+		srb->cmnd =3D ses.cmnd;
 		srb->cmnd[2] =3D 1;
=20
 		usb_stor_transparent_scsi_command(srb, us);
+		memcpy(regs, srb->sense_buffer, sizeof(regs));
 		tmp_result =3D srb->result;
 		scsi_eh_restore_cmnd(srb, &ses);
 		/* we fail to get registers, report invalid command */
@@ -162,8 +161,8 @@ void cypress_atacb_passthrough(struct scsi_cmnd *sr=
b, struct us_data *us)
=20
 		/* XXX we should generate sk, asc, ascq from status and error
 		 * regs
-		 * (see 11.1 Error translation =EF=BF=BD ATA device error to SCSI er=
ror map)
-		 * and ata_to_sense_error from libata.
+		 * (see 11.1 Error translation ATA device error to SCSI error
+		 *  map, and ata_to_sense_error from libata.)
 		 */
=20
 		/* Sense data is current and format is descriptor. */
--=20
1.6.0.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
