From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] st: clear ILI if Medium Error
Date: Mon, 18 Apr 2016 08:06:06 -0400 (EDT)
Message-ID: <1916314668.30408094.1460981166841.JavaMail.zimbra@redhat.com>
References: <alpine.LSU.2.20.1604180843100.1620@xnv.znxvfnen.cevingr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:60177 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbcDRMGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2016 08:06:19 -0400
In-Reply-To: <alpine.LSU.2.20.1604180843100.1620@xnv.znxvfnen.cevingr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, mlombard@redhat.com

Looks good
Reviewed-by Laurence Oberman <loberman@redhat.com>

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Kai Makisara" <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org
Cc: mlombard@redhat.com
Sent: Monday, April 18, 2016 1:47:18 AM
Subject: [PATCH] st: clear ILI if Medium Error

Some drives set the ILI flag together with MEDIUM ERROR
sense code. Clear the ILI flag in this case so that the
medium error will be handled. The problem was reported by
Maurizio Lombardi.

Signed-off-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>
---
 drivers/scsi/st.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/st.c	2016-04-17 21:22:15.671897001 +0300
+++ b/drivers/scsi/st.c	2016-04-17 22:25:39.234321293 +0300
@@ -1974,9 +1974,12 @@ static long read_tape(struct scsi_tape *
 					transfer =3D (int)cmdstatp->uremainder64;
 				else
 					transfer =3D 0;
-				if (STp->block_size =3D=3D 0 &&
-				    cmdstatp->sense_hdr.sense_key =3D=3D MEDIUM_ERROR)
-					transfer =3D bytes;
+				if (cmdstatp->sense_hdr.sense_key =3D=3D MEDIUM_ERROR) {
+					if (STp->block_size =3D=3D 0)
+						transfer =3D bytes;
+					/* Some drives set ILI with MEDIUM ERROR */
+					cmdstatp->flags &=3D ~SENSE_ILI;
+				}
=20
 				if (cmdstatp->flags & SENSE_ILI) {	/* ILI */
 					if (STp->block_size =3D=3D 0 &&
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
