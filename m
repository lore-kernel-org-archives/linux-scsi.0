From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] aic94xx: match wait_for_completion_timeout return type
Date: Mon,  9 Mar 2015 03:45:44 -0400
Message-ID: <1425887144-8109-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-scsi@vger.kernel.org

return type of wait_for_completion_timeout is unsigned long not int. As
leftover is used exclusively for wait_for_completion_timeout its type is
simply changed to unsigned long.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

This was only compile tested for x86_64_defconfig +
CONFIG_SCSI_LOWLEVEL=y, CONFIG_SCSI_AIC94XX=m

Patch is against 4.0-rc2 linux-next (localversion-next is -next-20150306)

 drivers/scsi/aic94xx/aic94xx_tmf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index d4c35df..161b536 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -343,7 +343,7 @@ static void asd_tmf_tasklet_complete(struct asd_ascb *ascb,
 static int asd_clear_nexus(struct sas_task *task)
 {
 	int res = TMF_RESP_FUNC_FAILED;
-	int leftover;
+	unsigned long leftover;
 	struct asd_ascb *tascb = task->lldd_task;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	unsigned long flags;
@@ -410,7 +410,7 @@ int asd_abort_task(struct sas_task *task)
 	unsigned long flags;
 	struct asd_ascb *ascb = NULL;
 	struct scb *scb;
-	int leftover;
+	unsigned long leftover;
 	DECLARE_TCS(tcs);
 	DECLARE_COMPLETION_ONSTACK(completion);
 	DECLARE_COMPLETION_ONSTACK(tascb_completion);
-- 
1.7.10.4
