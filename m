From: Philipp Reisner <philipp.reisner@linbit.com>
Subject: exporting TCQ functionality to the kernel in SYMBIOS/NCR 53C8XX driver
Date: Wed, 27 Jul 2005 11:33:33 +0200
Message-ID: <200507271133.33723.philipp.reisner@linbit.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tT15CqVC3sgPNck"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aug.linbit.com ([212.69.162.22]:40145 "EHLO mail.linbit.com")
	by vger.kernel.org with ESMTP id S262213AbVG0MJV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2005 08:09:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, linux-scsi@vger.kernel.org

--Boundary-00=_tT15CqVC3sgPNck
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Matthew,

Does this patch makes sense to you ?
Could you consider this for inclusion into mainline ?

best regards,
 Philipp
=2D-=20
: Dipl-Ing Philipp Reisner                      Tel +43-1-8178292-50 :
: LINBIT Information Technologies GmbH          Fax +43-1-8178292-82 :
: Sch=F6nbrunnerstr 244, 1120 Vienna, Austria    http://www.linbit.com :

--Boundary-00=_tT15CqVC3sgPNck
Content-Type: text/x-diff;
  charset="us-ascii";
  name="sym53c8xxx-tcq-support.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sym53c8xxx-tcq-support.diff"

diff -ur linux-2.6.12+kdb/drivers/scsi/sym53c8xx_2/sym_glue.c linux-2.6.12+kdb+sym-patch/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linux-2.6.12+kdb/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-07-27 10:54:47.000000000 +0200
+++ linux-2.6.12+kdb+sym-patch/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-07-27 11:07:47.000000000 +0200
@@ -494,7 +494,14 @@
 	 *  Select tagged/untagged.
 	 */
 	lp = sym_lp(tp, sdev->lun);
-	order = (lp && lp->s.reqtags) ? M_SIMPLE_TAG : 0;
+        if (lp && lp->s.reqtags) {
+		if (cmd->request->flags & REQ_HARDBARRIER)
+			order = M_ORDERED_TAG;
+		else
+			order = M_SIMPLE_TAG;
+	} else {
+		order = 0 ;
+	}
 
 	/*
 	 *  Queue the SCSI IO.
@@ -1926,6 +1933,7 @@
 	.proc_info		= sym53c8xx_proc_info,
 	.proc_name		= NAME53C8XX,
 #endif
+	.ordered_tag            = 1,
 };
 
 static int attach_count;

--Boundary-00=_tT15CqVC3sgPNck--
