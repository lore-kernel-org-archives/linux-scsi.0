From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Fix printing of failed 32-byte commands
Date: Wed, 20 Jan 2010 02:20:43 -0500
Message-ID: <yq1ska1kzsk.fsf@sermon.lab.mkp.net>
References: <yq1636zt1yr.fsf@sermon.lab.mkp.net>
	<4B5588B4.4030608@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:22691 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab0ATHVx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2010 02:21:53 -0500
In-Reply-To: <4B5588B4.4030608@panasas.com> (Boaz Harrosh's message of "Tue,
	19 Jan 2010 12:25:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> I don't like that flag. If cmd->cmnd is invalid after the call to
Boaz> sd_done.  Then I prefer if sd_done could NULL the pointer and any
Boaz> access will BUG, instead of a dangerous use after free, which you
Boaz> never know when it will bite.

Boaz> Then if so scsi_print_command() can just silently ignore any
cmd-> cmnd == NULL cases. (And a fat comment somewhere)

Yeah, that's a better idea.  I considered that flag a wart from the
get-go...


scsi: Fix printing of failed 32-byte commands

Having the large CDB allocation logic in sd.c means that
scsi_io_completion does not have access to the command buffer. That in
turn causes garbage to be printed when a 32-byte command fails. Move the
command printing to sd_done where the command buffer is intact.  Clear
the command buffer pointer after the extended CDB has been freed.

Make scsi_print_command ignore commands with NULL CDB pointers to
inhibit printing of garbled command strings.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index db68e3b..93606bc 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -349,6 +349,9 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	int k;
 
+	if (cmd->cmnd == NULL)
+		return;
+
 	scmd_printk(KERN_INFO, cmd, "CDB: ");
 	print_opcode_name(cmd->cmnd, cmd->cmd_len);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 255da53..5f0f6c7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1218,8 +1218,19 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		sd_dif_complete(SCpnt, good_bytes);
 
 	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
-	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd)
+	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd) {
+
+		/* We have to print a failed command here as the
+		 * extended CDB gets freed before scsi_io_completion()
+		 * is called.
+		 */
+		if (result)
+			scsi_print_command(SCpnt);
+
 		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+		SCpnt->cmnd = NULL;
+		SCpnt->cmd_len = 0;
+	}
 
 	return good_bytes;
 }
