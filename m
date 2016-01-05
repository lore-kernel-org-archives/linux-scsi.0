From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: mvsas: fix indenting on return error code
Date: Tue,  5 Jan 2016 11:56:40 +0000
Message-ID: <1451995000-9210-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40008 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbcAEL4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2016 06:56:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The return code and error return is incorrectly indented which
may cause some confusion as it appears at first sight to be associated
with a device not ready error (with missing { } braces) rather than
a DEV_IS_GONE() failure.

The incorrect indenting was introduced by commit
0b15fb1fdfd403726542cb6111bc916b7a9f7fad ("[SCSI] mvsas: add support
for Task collector mode and fixed relative bugs")

No functional change, just a minor code reformatting clean up.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mvsas/mv_sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 9c78074..e712fe7 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -737,8 +737,8 @@ static int mvs_task_prep(struct sas_task *task, struct mvs_info *mvi, int is_tmf
 			mv_dprintk("device %016llx not ready.\n",
 				SAS_ADDR(dev->sas_addr));
 
-			rc = SAS_PHY_DOWN;
-			return rc;
+		rc = SAS_PHY_DOWN;
+		return rc;
 	}
 	tei.port = dev->port->lldd_port;
 	if (tei.port && !tei.port->port_attached && !tmf) {
-- 
2.6.4

