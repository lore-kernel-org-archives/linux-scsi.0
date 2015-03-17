From: Achim Leubner <Achim.Leubner@pmcs.com>
Subject: RE: [PATCH 2/7] aacraid: IOCTL pass-through command fix
Date: Tue, 17 Mar 2015 15:26:02 +0000
Message-ID: <307F48E420013C4E85C75C93E532197AB8092024@BBYEXM01.pmc-sierra.internal>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1425458313-1956-3-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:55935 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932335AbbCQPyE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2015 11:54:04 -0400
In-Reply-To: <1425458313-1956-3-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Reviewed-by: Achim Leubner <Achim.Leubner@pmcs.com>

-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Wednesday, March 4, 2015 9:38 AM
To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth Pandurangan; Rich Bono; Mahesh Rajashekhara
Subject: [PATCH 2/7] aacraid: IOCTL pass-through command fix

The Linux aacriad driver fails to detect the case of SG list count=0 on IOCTL pass-through command and cause intermittent fault.
The result is the Linux aacriad driver send down IOCTL pass-through command with one not initialized SG list to firmware when receiving SG list count =0 on pass-through command.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/commctrl.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c index fbcd48d..54195a1 100644
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
 		struct user_sgmap* upsg = &user_srbcmd->sg; @@ -775,7 +778,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
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

