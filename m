From: akpm@linux-foundation.org
Subject: [patch 15/17] mpt fusion: shut up uninitialized variable  warnings
Date: Tue, 02 Oct 2007 14:38:11 -0700
Message-ID: <200710022138.l92LcB8Z023600@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42528 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754224AbXJBViV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:38:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, satyam@infradead.org, eric.moore@lsi.com


drivers/message/fusion/mptctl.c: In function =E2=80=98mptctl_mpt_comman=
d=E2=80=99:
drivers/message/fusion/mptctl.c:1764: warning: =E2=80=98bufIn.len=E2=80=
=99 may be used uninitialized in this function
drivers/message/fusion/mptctl.c:1765: warning: =E2=80=98bufOut.len=E2=80=
=99 may be used uninitialized in this function

come because gcc gets confused by some "goto" statements in above funct=
ion.
 The warnings have been verified to be bogus, however, the function doe=
s
initialize these later (after the offending goto's) in the function any=
way.
 So let's move those initializations to top of function, thereby also
shutting up these warnings.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Eric Moore <eric.moore@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptctl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/message/fusion/mptctl.c~mpt-fusion-shut-up-uninitiali=
zed-variable drivers/message/fusion/mptctl.c
--- a/drivers/message/fusion/mptctl.c~mpt-fusion-shut-up-uninitialized-=
variable
+++ a/drivers/message/fusion/mptctl.c
@@ -1774,7 +1774,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	ulong 		timeout;
 	struct scsi_device *sdev;
=20
+	/* bufIn and bufOut are used for user to kernel space transfers
+	 */
 	bufIn.kptr =3D bufOut.kptr =3D NULL;
+	bufIn.len =3D bufOut.len =3D 0;
=20
 	if (((iocnum =3D mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc =3D=3D NULL)) {
@@ -2108,11 +2111,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	psge =3D (char *) (((int *) mf) + karg.dataSgeOffset);
 	flagsLength =3D 0;
=20
-	/* bufIn and bufOut are used for user to kernel space transfers
-	 */
-	bufIn.kptr =3D bufOut.kptr =3D NULL;
-	bufIn.len =3D bufOut.len =3D 0;
-
 	if (karg.dataOutSize > 0)
 		sgSize ++;
=20
_
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
