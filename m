From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] [SCSI] osst: remove double conversion of timeout
Date: Thu,  7 Jan 2016 21:10:33 +0100
Message-ID: <1452197433-26086-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-scsi@vger.kernel.org

If the time is actually in jiffies already it seems cleaner to call
schedule_timeout_interruptible() than to call msleep and covert the
timeout. In this case it will actually optimize the code a bit as 
it does not need to call jiffies_to_msecs here.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

problem was found by coccinelle spatch

patch was compile tested with: x86_64_defconfig +
CONFIG_CHR_DEV_OSST=m

patch is against linux-next (localversion-next is -next-20160107)

 drivers/scsi/osst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 5033223..d8e5aa9 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -760,7 +760,7 @@ static int osst_wait_ready(struct osst_tape * STp, struct osst_request ** aSRpnt
 #endif
 
 	if (initial_delay > 0)
-		msleep(jiffies_to_msecs(initial_delay));
+		schedule_timeout_uninterruptible(initial_delay);
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = TEST_UNIT_READY;
-- 
2.1.4
