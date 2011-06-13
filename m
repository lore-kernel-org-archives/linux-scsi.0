From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/8] scsi/sun3: Provide a dummy NCR5380_exit()
Date: Mon, 13 Jun 2011 20:39:19 +0200
Message-ID: <1307990362-22768-6-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:35126 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1FMSjj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2011 14:39:39 -0400
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Sam Creasey <sammy@sammy.net>

and call it from sun3scsi_release(), cfr. the other NCR5380 drivers.

This fixes:

drivers/scsi/NCR5380.h:303: warning: =E2=80=98NCR5380_exit=E2=80=99 dec=
lared =E2=80=98static=E2=80=99 but never defined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
 drivers/scsi/sun3_NCR5380.c  |    5 +++++
 drivers/scsi/sun3_scsi.c     |    1 +
 drivers/scsi/sun3_scsi_vme.c |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 0d04c3a..2ba1cb7 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -890,6 +890,11 @@ static int __init NCR5380_init(struct Scsi_Host *i=
nstance, int flags)
     return 0;
 }
=20
+static void NCR5380_exit(struct Scsi_Host *instance)
+{
+	/* Empty, as we didn't schedule any delayed work */
+}
+
 /*=20
  * Function : int NCR5380_queue_command (struct scsi_cmnd *cmd,
  *	void (*done)(struct scsi_cmnd *))
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2ad6b91..2cc83ef 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -314,6 +314,7 @@ int sun3scsi_release (struct Scsi_Host *shpnt)
=20
 	iounmap((void *)sun3_scsi_regp);
=20
+	NCR5380_exit(shpnt);
 	return 0;
 }
=20
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.=
c
index cd6d779..c0252db 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -283,6 +283,7 @@ int sun3scsi_release (struct Scsi_Host *shpnt)
=20
 	iounmap((void *)sun3_scsi_regp);
=20
+	NCR5380_exit(shpnt);
 	return 0;
 }
=20
--=20
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
