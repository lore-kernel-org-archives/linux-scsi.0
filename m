From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi/sun3: Split NEXT() for lvalues/rvalues
Date: Mon,  6 Jun 2011 22:52:56 +0200
Message-ID: <1307393576-1318-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:38181 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab1FFUxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2011 16:53:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

Using the current NEXT() macro for both lvalues and rvalues gives:

In file included from drivers/scsi/sun3_scsi.c:623:
drivers/scsi/sun3_NCR5380.c: In function =E2=80=98NCR5380_queue_command=
_lck=E2=80=99:
drivers/scsi/sun3_NCR5380.c:993: warning: assignment discards qualifier=
s from pointer target type
drivers/scsi/sun3_NCR5380.c: In function =E2=80=98NCR5380_main=E2=80=99=
:
drivers/scsi/sun3_NCR5380.c:1147: warning: assignment discards qualifie=
rs from pointer target type
drivers/scsi/sun3_NCR5380.c: In function =E2=80=98NCR5380_information_t=
ransfer=E2=80=99:
drivers/scsi/sun3_NCR5380.c:2277: warning: assignment discards qualifie=
rs from pointer target type
drivers/scsi/sun3_NCR5380.c:2333: warning: assignment discards qualifie=
rs from pointer target type

Change NEXT() to operate on rvalues only(), and introduce SET_NEXT() to
operate on lvalues, as is done in drivers/scsi/atari_NCR5380.c.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/sun3_NCR5380.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 07eaef1..29c8246 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -266,8 +266,9 @@ static struct scsi_host_template *the_template =3D =
NULL;
 	(struct NCR5380_hostdata *)(in)->hostdata
 #define	HOSTDATA(in) ((struct NCR5380_hostdata *)(in)->hostdata)
=20
-#define	NEXT(cmd)	(*(struct scsi_cmnd **)&((cmd)->host_scribble))
-#define	NEXTADDR(cmd)	((struct scsi_cmnd **)&((cmd)->host_scribble))
+#define	NEXT(cmd)		((struct scsi_cmnd *)(cmd)->host_scribble)
+#define	SET_NEXT(cmd, next)	((cmd)->host_scribble =3D (void *)(next))
+#define	NEXTADDR(cmd)		((struct scsi_cmnd **)&((cmd)->host_scribble))
=20
 #define	HOSTNO		instance->host_no
 #define	H_NO(cmd)	(cmd)->device->host->host_no
@@ -962,7 +963,7 @@ static int NCR5380_queue_command_lck(struct scsi_cm=
nd *cmd,
      * in a queue=20
      */
=20
-    NEXT(cmd) =3D NULL;
+    SET_NEXT(cmd, NULL);
     cmd->scsi_done =3D done;
=20
     cmd->result =3D 0;
@@ -990,14 +991,14 @@ static int NCR5380_queue_command_lck(struct scsi_=
cmnd *cmd,
      */
     if (!(hostdata->issue_queue) || (cmd->cmnd[0] =3D=3D REQUEST_SENSE=
)) {
 	LIST(cmd, hostdata->issue_queue);
-	NEXT(cmd) =3D hostdata->issue_queue;
+	SET_NEXT(cmd, hostdata->issue_queue);
 	hostdata->issue_queue =3D cmd;
     } else {
 	for (tmp =3D (struct scsi_cmnd *)hostdata->issue_queue;
 	     NEXT(tmp); tmp =3D NEXT(tmp))
 	    ;
 	LIST(cmd, tmp);
-	NEXT(tmp) =3D cmd;
+	SET_NEXT(tmp, cmd);
     }
=20
     local_irq_restore(flags);
@@ -1105,12 +1106,12 @@ static void NCR5380_main (struct work_struct *b=
l)
 		    local_irq_disable();
 		    if (prev) {
 		        REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
-			NEXT(prev) =3D NEXT(tmp);
+			SET_NEXT(prev, NEXT(tmp));
 		    } else {
 		        REMOVE(-1, hostdata->issue_queue, tmp, NEXT(tmp));
 			hostdata->issue_queue =3D NEXT(tmp);
 		    }
-		    NEXT(tmp) =3D NULL;
+		    SET_NEXT(tmp, NULL);
 		   =20
 		    /* reenable interrupts after finding one */
 		    local_irq_restore(flags);
@@ -1144,7 +1145,7 @@ static void NCR5380_main (struct work_struct *bl)
 		    } else {
 			local_irq_disable();
 			LIST(tmp, hostdata->issue_queue);
-			NEXT(tmp) =3D hostdata->issue_queue;
+			SET_NEXT(tmp, hostdata->issue_queue);
 			hostdata->issue_queue =3D tmp;
 #ifdef SUPPORT_TAGS
 			cmd_free_tag( tmp );
@@ -2274,7 +2275,7 @@ static void NCR5380_information_transfer (struct =
Scsi_Host *instance)
=20
 			local_irq_save(flags);
 			LIST(cmd,hostdata->issue_queue);
-			NEXT(cmd) =3D hostdata->issue_queue;
+			SET_NEXT(cmd, hostdata->issue_queue);
 		        hostdata->issue_queue =3D (struct scsi_cmnd *) cmd;
 		        local_irq_restore(flags);
 			QU_PRINTK("scsi%d: REQUEST SENSE added to head of "
@@ -2330,7 +2331,7 @@ static void NCR5380_information_transfer (struct =
Scsi_Host *instance)
 		    local_irq_save(flags);
 		    cmd->device->disconnect =3D 1;
 		    LIST(cmd,hostdata->disconnected_queue);
-		    NEXT(cmd) =3D hostdata->disconnected_queue;
+		    SET_NEXT(cmd, hostdata->disconnected_queue);
 		    hostdata->connected =3D NULL;
 		    hostdata->disconnected_queue =3D cmd;
 		    local_irq_restore(flags);
@@ -2589,12 +2590,12 @@ static void NCR5380_reselect (struct Scsi_Host =
*instance)
 	    ) {
 	    if (prev) {
 		REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
-		NEXT(prev) =3D NEXT(tmp);
+		SET_NEXT(prev, NEXT(tmp));
 	    } else {
 		REMOVE(-1, hostdata->disconnected_queue, tmp, NEXT(tmp));
 		hostdata->disconnected_queue =3D NEXT(tmp);
 	    }
-	    NEXT(tmp) =3D NULL;
+	    SET_NEXT(tmp, NULL);
 	    break;
 	}
     }
@@ -2762,7 +2763,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 	if (cmd =3D=3D tmp) {
 	    REMOVE(5, *prev, tmp, NEXT(tmp));
 	    (*prev) =3D NEXT(tmp);
-	    NEXT(tmp) =3D NULL;
+	    SET_NEXT(tmp, NULL);
 	    tmp->result =3D DID_ABORT << 16;
 	    local_irq_restore(flags);
 	    ABRT_PRINTK("scsi%d: abort removed command from issue queue.\n",
@@ -2835,7 +2836,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 		    if (cmd =3D=3D tmp) {
 		    REMOVE(5, *prev, tmp, NEXT(tmp));
 		    *prev =3D NEXT(tmp);
-		    NEXT(tmp) =3D NULL;
+		    SET_NEXT(tmp, NULL);
 		    tmp->result =3D DID_ABORT << 16;
 		    /* We must unlock the tag/LUN immediately here, since the
 		     * target goes to BUS FREE and doesn't send us another
@@ -2943,7 +2944,7 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cm=
d)
=20
     for (i =3D 0; (cmd =3D disconnected_queue); ++i) {
 	disconnected_queue =3D NEXT(cmd);
-	NEXT(cmd) =3D NULL;
+	SET_NEXT(cmd, NULL);
 	cmd->result =3D (cmd->result & 0xffff) | (DID_RESET << 16);
 	cmd->scsi_done( cmd );
     }
--=20
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
