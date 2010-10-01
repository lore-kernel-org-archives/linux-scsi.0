From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] qla2xxx: Drop srb reference before waiting for completion
Date: Fri, 01 Oct 2010 14:18:44 +0200
Message-ID: <20101001121844.4ABF3353A8@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49346 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab0JAMSp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2010 08:18:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 8D036945D6
	for <linux-scsi@vger.kernel.org>; Fri,  1 Oct 2010 14:18:44 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


This patch fixes a regression introduced by commit
083a469db4ecf3b286a96b5b722c37fc1affe0be

qla2xxx_eh_wait_on_command() is waiting for an srb to
complete, which will never happen as the routine took
a reference to the srb previously and will only drop it
after this function. So every command abort will fail.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1e4bff6..0af7549 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -883,6 +883,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+	if (got_ref)
+		qla2x00_sp_compl(ha, sp);
+
 	/* Wait for the command to be returned. */
 	if (wait) {
 		if (qla2x00_eh_wait_on_command(cmd) != QLA_SUCCESS) {
@@ -893,9 +896,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		}
 	}
 
-	if (got_ref)
-		qla2x00_sp_compl(ha, sp);
-
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): Abort command issued -- %d %lx %x.\n",
 	    vha->host_no, id, lun, wait, serial, ret);
