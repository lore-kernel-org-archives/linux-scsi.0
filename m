From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/3] hpsa: fix a race in cmd_free/scsi_done
Date: Thu, 01 Aug 2013 15:14:00 +0200
Message-ID: <51FA5F18.4070300@redhat.com>
References: <51FA5E7A.9050000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab3HANPF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 09:15:05 -0400
In-Reply-To: <51FA5E7A.9050000@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com

From: Tomas Henzl <thenzl@redhat.com>

When the driver calls scsi_done and after that frees it's internal
preallocated memory it can happen that a new job is enqueud before
the memory is freed. The allocation fails and the message
"cmd_alloc returned NULL" is shown.
Patch below fixes it by moving cmd->scsi_done after cmd_free.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d7df01e..48fa81e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1180,8 +1180,8 @@ static void complete_scsi_command(struct CommandList *cp)
 	scsi_set_resid(cmd, ei->ResidualCnt);
 
 	if (ei->CommandStatus == 0) {
-		cmd->scsi_done(cmd);
 		cmd_free(h, cp);
+		cmd->scsi_done(cmd);
 		return;
 	}
 
@@ -1353,8 +1353,8 @@ static void complete_scsi_command(struct CommandList *cp)
 		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
 				cp, ei->CommandStatus);
 	}
-	cmd->scsi_done(cmd);
 	cmd_free(h, cp);
+	cmd->scsi_done(cmd);
 }
 
 static void hpsa_pci_unmap(struct pci_dev *pdev,
-- 
1.8.3.1

