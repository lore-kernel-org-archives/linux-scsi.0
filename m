From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix qla1280 compiles
Date: Fri, 26 Sep 2003 17:45:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030926154512.GA24181@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:15238 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262375AbTIZPpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 11:45:23 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jes@trained-monkey.org, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Duh!  The scsi_cmnd.flags removal broke qla1280.

It checked for the flags beeing 0, which it always was for a long
time.  It looks a bit fishy thus, so if someone wants to audit
srb.flags audit please do so.


--- 1.48/drivers/scsi/qla1280.c	Sat Sep 20 13:16:01 2003
+++ edited/drivers/scsi/qla1280.c	Fri Sep 26 15:03:44 2003
@@ -1220,9 +1220,7 @@
 	sp = (struct srb *)CMD_SP(cmd);
 	sp->cmd = cmd;
 	cmd->scsi_done = fn;
-	if (cmd->flags == 0) {	/* new command */
-		sp->flags = 0;
-	}
+	sp->flags = 0;
 
 	qla1280_print_scsi_cmd(5, cmd);
 
