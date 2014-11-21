From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: fix regression in scsi_send_eh_cmnd()
Date: Fri, 21 Nov 2014 10:44:49 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1411211040110.4139-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54682 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758177AbaKUPou (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 10:44:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?UTF-8?B?0JDQvdC00YDQtdC5INCQ0LvQsNC00YzQtdCy?= <aladjev.andrew@gmail.com>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

Commit ac61d1955934 (scsi: set correct completion code in
scsi_send_eh_cmnd()) introduced a bug.  It changed the stored return
value from a queuecommand call, but it didn't take into account that
the return value was used again later on.  This patch fixes the bug by
changing the later usage.

There is a big comment in the middle of scsi_send_eh_cmnd() which
does a good job of explaining how the routine works.  But it mentions
a "rtn =3D FAILURE" value that doesn't exist in the code.  This patch
adjusts the code to match the comment (I assume the comment is right
and the code is wrong).

This fixes Bugzilla #88341.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 =D0=90=D0=BB=D0=B0=D0=
=B4=D1=8C=D0=B5=D0=B2 <aladjev.andrew@gmail.com>
Tested-by: =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 =D0=90=D0=BB=D0=B0=D0=B4=
=D1=8C=D0=B5=D0=B2 <aladjev.andrew@gmail.com>
=46ixes: ac61d19559349e205dad7b5122b281419aa74a82
CC: Hannes Reinecke <hare@suse.de>
CC: <stable@vger.kernel.org>

---


[as1768]


 drivers/scsi/scsi_error.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 3.18-rc5/drivers/scsi/scsi_error.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- 3.18-rc5.orig/drivers/scsi/scsi_error.c
+++ 3.18-rc5/drivers/scsi/scsi_error.c
@@ -1027,7 +1027,7 @@ retry:
 		}
 		/* signal not to enter either branch of the if () below */
 		timeleft =3D 0;
-		rtn =3D NEEDS_RETRY;
+		rtn =3D FAILED;
 	} else {
 		timeleft =3D wait_for_completion_timeout(&done, timeout);
 		rtn =3D SUCCESS;
@@ -1067,7 +1067,7 @@ retry:
 			rtn =3D FAILED;
 			break;
 		}
-	} else if (!rtn) {
+	} else if (rtn !=3D FAILED) {
 		scsi_abort_eh_cmnd(scmd);
 		rtn =3D FAILED;
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
