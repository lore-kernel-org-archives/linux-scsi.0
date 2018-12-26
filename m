From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] scsi: aacraid: add a check for aac_fib_send
Date: Tue, 25 Dec 2018 23:51:03 -0600
Message-ID: <20181226055103.74893-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

aac_fib_send could fail, so add a check to its return value: If it
fails, issue an error message.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/scsi/aacraid/dpcsup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index ddc69738375f..0fbdc0dbf9d8 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -271,6 +271,8 @@ static void aac_aif_callback(void *context, struct fib * fibptr)
 		FsaNormal,
 		0, 1,
 		(fib_callback)aac_aif_callback, fibctx);
+	if (status)
+		pr_err("failure in aac_fib_send: %d\n", status);
 }
 
 
-- 
2.17.2 (Apple Git-113)
