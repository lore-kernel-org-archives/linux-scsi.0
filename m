From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 14/52] atp870u: Remove ugly gotos #2
Date: Tue, 17 Nov 2015 19:23:50 +0100
Message-ID: <1447784668-23713-15-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56571 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbbKQSh4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:56 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   68 +++++++++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 886e54b..999bf74 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -617,7 +617,7 @@ static DEF_SCSI_QCMD(atp870u_queuecommand)
  */
 static void send_s870(struct atp_unit *dev,unsigned char c)
 {
-	struct scsi_cmnd *workreq;
+	struct scsi_cmnd *workreq = NULL;
 	unsigned int i;//,k;
 	unsigned char  j, target_id;
 	unsigned char *prd;
@@ -638,50 +638,42 @@ static void send_s870(struct atp_unit *dev,unsigned char c)
 	if ((dev->last_cmd[c] != 0xff) && ((dev->last_cmd[c] & 0x40) != 0)) {
 		dev->last_cmd[c] &= 0x0f;
 		workreq = dev->id[c][dev->last_cmd[c]].curr_req;
-		if (workreq != NULL) {	/* check NULL pointer */
-		   goto cmd_subp;
-		}
-		dev->last_cmd[c] = 0xff;	
-		if (dev->quhd[c] == dev->quend[c]) {
-		   	dev->in_snd[c] = 0;
-		   	return ;
+		if (!workreq) {
+			dev->last_cmd[c] = 0xff;
+			if (dev->quhd[c] == dev->quend[c]) {
+				dev->in_snd[c] = 0;
+				return;
+			}
 		}
 	}
-	if ((dev->last_cmd[c] != 0xff) && (dev->working[c] != 0)) {
-	     	dev->in_snd[c] = 0;
-	     	return ;
-	}
-	dev->working[c]++;
-	j = dev->quhd[c];
-	dev->quhd[c]++;
-	if (dev->quhd[c] >= qcnt) {
-		dev->quhd[c] = 0;
-	}
-	workreq = dev->quereq[c][dev->quhd[c]];
-	if (dev->id[c][scmd_id(workreq)].curr_req == NULL) {
+	if (!workreq) {
+		if ((dev->last_cmd[c] != 0xff) && (dev->working[c] != 0)) {
+			dev->in_snd[c] = 0;
+			return;
+		}
+		dev->working[c]++;
+		j = dev->quhd[c];
+		dev->quhd[c]++;
+		if (dev->quhd[c] >= qcnt)
+			dev->quhd[c] = 0;
+		workreq = dev->quereq[c][dev->quhd[c]];
+		if (dev->id[c][scmd_id(workreq)].curr_req != NULL) {
+			dev->quhd[c] = j;
+			dev->working[c]--;
+			dev->in_snd[c] = 0;
+			return;
+		}
 		dev->id[c][scmd_id(workreq)].curr_req = workreq;
 		dev->last_cmd[c] = scmd_id(workreq);
-		goto cmd_subp;
-	}	
-	dev->quhd[c] = j;
-	dev->working[c]--;
-	dev->in_snd[c] = 0;
-	return;
-cmd_subp:
-	if ((inb(dev->ioport[c] + 0x1f) & 0xb0) != 0) {
-		goto abortsnd;
-	}
-	if (inb(dev->ioport[c] + 0x1c) == 0) {
-		goto oktosend;
 	}
-abortsnd:
+	if ((inb(dev->ioport[c] + 0x1f) & 0xb0) != 0 || inb(dev->ioport[c] + 0x1c) != 0) {
 #ifdef ED_DBGP
-	printk("Abort to Send\n");
+		printk("Abort to Send\n");
 #endif
-	dev->last_cmd[c] |= 0x40;
-	dev->in_snd[c] = 0;
-	return;
-oktosend:
+		dev->last_cmd[c] |= 0x40;
+		dev->in_snd[c] = 0;
+		return;
+	}
 #ifdef ED_DBGP
 	printk("OK to Send\n");
 	scmd_printk(KERN_DEBUG, workreq, "CDB");
-- 
Ondrej Zary

