From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [V2 PATCH 02/11] aacraid: IOCTL pass-through command fix
Date: Thu, 26 Mar 2015 10:41:23 -0400
Message-ID: <1427380892-1978-3-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37807 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbbCZOrF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:47:05 -0400
In-Reply-To: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com, Mahesh.Rajashekhara@pmcs.com

The Linux aacriad driver fails to detect the case of SG list count=0 on IOCTL pass-through command and cause intermittent fault.
The result is the Linux aacriad driver send down IOCTL pass-through command with one not initialized SG list to firmware when receiving SG list count =0 on pass-through command.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/commctrl.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index fbcd48d..54195a1 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -689,7 +689,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			kfree (usg);
 		}
 		srbcmd->count = cpu_to_le32(byte_count);
-		psg->count = cpu_to_le32(sg_indx+1);
+		if (user_srbcmd->sg.count)
+			psg->count = cpu_to_le32(sg_indx+1);
+		else
+			psg->count = 0;
 		status = aac_fib_send(ScsiPortCommand64, srbfib, actual_fibsize, FsaNormal, 1, 1,NULL,NULL);
 	} else {
 		struct user_sgmap* upsg = &user_srbcmd->sg;
@@ -775,7 +778,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			}
 		}
 		srbcmd->count = cpu_to_le32(byte_count);
-		psg->count = cpu_to_le32(sg_indx+1);
+		if (user_srbcmd->sg.count)
+			psg->count = cpu_to_le32(sg_indx+1);
+		else
+			psg->count = 0;
 		status = aac_fib_send(ScsiPortCommand, srbfib, actual_fibsize, FsaNormal, 1, 1, NULL, NULL);
 	}
 	if (status == -ERESTARTSYS) {
-- 
1.7.7.3

