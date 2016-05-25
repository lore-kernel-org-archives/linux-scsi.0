From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: sd: ZBC Update Read/Write Commands to SCSI spec
Date: Wed, 25 May 2016 10:02:36 -0500
Message-ID: <1464188556.3020.4.camel@petroskoutoupis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:61609 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbcEYPCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2016 11:02:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, linux-scsi@vger.kernel.org
Cc: petros@petroskoutoupis.com

This patch is based on:
git.kernel.org:/pub/scm/linux/kernel/git/hare/scsi-devel branch zbc.v6

According to the Zoned Block Commands (ZBC) Revision 5 SCSI specificati=
on,
a Host Managed and Host Aware device is limited to support at a minimum=
 the
READ (16) and WRITE (16) read/write CDBs. This means that a drive manuf=
acturer
is not obligated to support anything else. We shouldn't assume that we =
can
send other read/write commands and should instead limit sd to only the
mandatory list highlighted in the specification.

Note, I did not place the a check for zoned devices in the DIF-enabled
conditional above, under the assumption that if the media supports Type=
-2
then it should also support the 32-byte commands. Thoughts?

Signed-off-by: Petros Koutoupis <petros@petroskoutoupis.com>

--- scsi-devel/drivers/scsi/sd.c.orig	2016-05-12 23:21:04.314000000 -05=
00
+++ scsi-devel/drivers/scsi/sd.c	2016-05-25 08:55:21.715506056 -0500
@@ -1159,7 +1159,8 @@ static int sd_setup_read_write_cmnd(stru
=C2=A0		SCpnt->cmnd[29] =3D (unsigned char) (this_count >> 16) & 0xff;
=C2=A0		SCpnt->cmnd[30] =3D (unsigned char) (this_count >> 8) & 0xff;
=C2=A0		SCpnt->cmnd[31] =3D (unsigned char) this_count & 0xff;
-	} else if (sdp->use_16_for_rw || (this_count > 0xffff)) {
+	} else if (sdp->use_16_for_rw || (this_count > 0xffff) ||
+		=C2=A0=C2=A0=C2=A0sdkp->zoned =3D=3D 1 || sdp->type =3D=3D TYPE_ZBC)=
 {
=C2=A0		SCpnt->cmnd[0] +=3D READ_16 - READ_6;
=C2=A0		SCpnt->cmnd[1] =3D protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 :=
 0);
=C2=A0		SCpnt->cmnd[2] =3D sizeof(block) > 4 ? (unsigned char) (block >=
> 56) & 0xff : 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
