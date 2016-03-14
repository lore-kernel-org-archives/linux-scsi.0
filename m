From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/3] aacraid: add missing curly braces
Date: Mon, 14 Mar 2016 15:29:43 +0100
Message-ID: <1457965789-3373916-2-git-send-email-arnd@arndb.de>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Johannes Thumshirn <jthumshirn@suse.de>, Tomas Henzl <thenzl@redhat.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>, Fengguang Wu <fengguang.wu@intel.com>
List-Id: linux-scsi@vger.kernel.org

gcc-6 warns about obviously wrong indentation for newly added
code in aac_slave_configure():

drivers/scsi/aacraid/linit.c: In function 'aac_slave_configure':
drivers/scsi/aacraid/linit.c:458:3: warning: statement is indented as if it were guarded by... [-Wmisleading-indentation]
   sdev->tagged_supported = 1;
   ^~~~
drivers/scsi/aacraid/linit.c:455:4: note: ...this 'else' clause, but it is not

gcc is correct, and evidently this was meant to be within the curly
braces that should have been there to start with. This patch adds
them, which avoids the warning and makes it clear what was intended
here.

Nothing changes in behavior because in the 'if' block, the
sdev->tagged_supported flag is known to be set already.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 6bf3b630d0a7 ("aacraid: SCSI blk tag support")
---
 drivers/scsi/aacraid/linit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 21a67ed047e8..ff6caab8cc8b 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -452,10 +452,11 @@ static int aac_slave_configure(struct scsi_device *sdev)
 		else if (depth < 2)
 			depth = 2;
 		scsi_change_queue_depth(sdev, depth);
-	} else
+	} else {
 		scsi_change_queue_depth(sdev, 1);
 
 		sdev->tagged_supported = 1;
+	}
 
 	return 0;
 }
-- 
2.7.0
