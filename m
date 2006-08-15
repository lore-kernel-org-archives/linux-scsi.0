From: akpm@osdl.org
Subject: [patch 16/24] megaraid gcc 4.1 warning fix
Date: Mon, 14 Aug 2006 23:09:29 -0700
Message-ID: <200608150609.k7F69Tf7013250@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19094 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965191AbWHOGKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:10:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, dwalker@mvista.com, Neela.Kolli@engenio.com, alan@lxorguk.ukuu.org.uk

=46rom: Daniel Walker <dwalker@mvista.com>

drivers/scsi/megaraid.c: In function =E2=80=98megadev_ioctl=E2=80=99:
drivers/scsi/megaraid.c:3665: warning: ignoring return value of =E2=80=98=
copy_to_user=E2=80=99, declared with attribute warn_unused_result

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <Neela.Kolli@engenio.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/megaraid.c~megaraid-gcc-41-warning-fix drivers/s=
csi/megaraid.c
--- a/drivers/scsi/megaraid.c~megaraid-gcc-41-warning-fix
+++ a/drivers/scsi/megaraid.c
@@ -3656,8 +3656,9 @@ megadev_ioctl(struct inode *inode, struc
 			 * Send the request sense data also, irrespective of
 			 * whether the user has asked for it or not.
 			 */
-			copy_to_user(upthru->reqsensearea,
-					pthru->reqsensearea, 14);
+			if (copy_to_user(upthru->reqsensearea,
+					pthru->reqsensearea, 14))
+				rval =3D (-EFAULT);
=20
 freemem_and_return:
 			if( pthru->dataxferlen ) {
_
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
