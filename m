From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] scsi: aacraid: fix a potential data inconsistency caused by double-fetch
Date: Tue, 25 Dec 2018 15:11:36 -0600
Message-ID: <20181225211136.69702-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"user_srb->count" may be changed by malicious user races. Let's set
"user_srbcmd->count" fetched in the second copy to be the one fetched in
the first copy.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/scsi/aacraid/commctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 25f6600d6c09..eb18117c431a 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -539,6 +539,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		rcode = -EFAULT;
 		goto cleanup;
 	}
+	/* Ensure user_srb->count is not changed */
+	user_srbcmd->count = fibsize;
 
 	flags = user_srbcmd->flags; /* from user in cpu order */
 	switch (flags & (SRB_DataIn | SRB_DataOut)) {
-- 
2.17.2 (Apple Git-113)
