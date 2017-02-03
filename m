From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] sg: check for valid direction before starting the request
Date: Fri,  3 Feb 2017 09:54:50 +0100
Message-ID: <1486112091-68470-4-git-send-email-hare@suse.de>
References: <1486112091-68470-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38417 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752256AbdBCIyz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 03:54:55 -0500
In-Reply-To: <1486112091-68470-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

From: Johannes Thumshirn <jthumshirn@suse.de>

Check for a valid direction before starting the request, otherwise we risk
running into an assertion in the scsi midlayer checking for vaild requests.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Link: http://www.spinics.net/lists/linux-scsi/msg104400.html
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sg.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c29962c..3599551 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -752,6 +752,20 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	return count;
 }
 
+static bool sg_is_valid_direction(int dxfer_direction)
+{
+	switch (dxfer_direction) {
+	case SG_DXFER_NONE:
+	case SG_DXFER_TO_DEV:
+	case SG_DXFER_FROM_DEV:
+	case SG_DXFER_TO_FROM_DEV:
+	case SG_DXFER_UNKNOWN:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int
 sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		unsigned char *cmnd, int timeout, int blocking)
@@ -772,6 +786,11 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
+	if (!sg_is_valid_direction(hp->dxfer_direction))
+		return -EINVAL;
+	if (hp->dxferp == NULL && hp->dxfer_len > 0)
+		return -EINVAL;
+
 	k = sg_start_req(srp, cmnd);
 	if (k) {
 		SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sfp->parentdp,
-- 
1.8.5.6
