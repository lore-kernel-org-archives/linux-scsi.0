From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 4/6] sg: check for valid direction before starting the request
Date: Fri,  7 Apr 2017 09:34:15 +0200
Message-ID: <1491550457-78302-5-git-send-email-hare@suse.de>
References: <1491550457-78302-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753235AbdDGHeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 03:34:23 -0400
In-Reply-To: <1491550457-78302-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <"james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, DougGilberdgilbert"@interlog.com>, Johannes Thumshirn <jth@kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>

From: Johannes Thumshirn <jthumshirn@suse.de>

Check for a valid direction before starting the request, otherwise we risk
running into an assertion in the scsi midlayer checking for vaild requests.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Link: http://www.spinics.net/lists/linux-scsi/msg104400.html
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sg.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ddc1808..5f12273 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -663,18 +663,14 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	 * is a non-zero input_size, so emit a warning.
 	 */
 	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV) {
-		static char cmd[TASK_COMM_LEN];
-		if (strcmp(current->comm, cmd)) {
-			printk_ratelimited(KERN_WARNING
-					   "sg_write: data in/out %d/%d bytes "
-					   "for SCSI command 0x%x-- guessing "
-					   "data in;\n   program %s not setting "
-					   "count and/or reply_len properly\n",
-					   old_hdr.reply_len - (int)SZ_SG_HEADER,
-					   input_size, (unsigned int) cmnd[0],
-					   current->comm);
-			strcpy(cmd, current->comm);
-		}
+		printk_ratelimited(KERN_WARNING
+				   "sg_write: data in/out %d/%d bytes "
+				   "for SCSI command 0x%x-- guessing "
+				   "data in;\n   program %s not setting "
+				   "count and/or reply_len properly\n",
+				   old_hdr.reply_len - (int)SZ_SG_HEADER,
+				   input_size, (unsigned int) cmnd[0],
+				   current->comm);
 	}
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
@@ -753,6 +749,29 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	return count;
 }
 
+static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
+{
+	switch (hp->dxfer_direction) {
+	case SG_DXFER_NONE:
+		if (hp->dxferp || hp->dxfer_len > 0)
+			return false;
+		return true;
+	case SG_DXFER_TO_DEV:
+	case SG_DXFER_FROM_DEV:
+	case SG_DXFER_TO_FROM_DEV:
+		if (!hp->dxferp || hp->dxfer_len == 0)
+			return false;
+		return true;
+	case SG_DXFER_UNKNOWN:
+		if ((!hp->dxferp && hp->dxfer_len) ||
+		    (hp->dxferp && hp->dxfer_len == 0))
+			return false;
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
@@ -773,6 +792,9 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
+	if (!sg_is_valid_dxfer(hp))
+		return -EINVAL;
+
 	k = sg_start_req(srp, cmnd);
 	if (k) {
 		SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sfp->parentdp,
-- 
1.8.5.6
