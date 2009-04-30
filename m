From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Subject: [PATCH]: fixing gcc 4.4 =?utf-8?Q?compiler?=
	=?utf-8?Q?_warning=3A_suggest_parentheses_around_operand_of_=E2=80=98!?=
	=?utf-8?B?4oCZ?=
Date: Thu, 30 Apr 2009 09:04:30 +0300
Message-ID: <20090430060430.GA6040@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.98.175.89] ([212.98.175.89]:57881 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753344AbZD3StW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2009 14:49:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org

Trivial: fixing gcc 4.4 compiler warning:
drivers/scsi/st.c: In function =E2=80=98st_int_ioctl=E2=80=99:
drivers/scsi/st.c:2967: warning: suggest parentheses around operand of =
=E2=80=98!=E2=80=99 or change =E2=80=98|=E2=80=99 to =E2=80=98||=E2=80=99=
 or =E2=80=98!=E2=80=99 to =E2=80=98~=E2=80=99

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>

---

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index eb24efe..2bde8a5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2964,7 +2964,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 			    !(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
-				STp->use_pf =3D !STp->use_pf | PF_TESTED;
+				STp->use_pf =3D (!STp->use_pf) | PF_TESTED;
 				st_release_request(SRpnt);
 				SRpnt =3D NULL;
 				return st_int_ioctl(STp, cmd_in, arg);

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
