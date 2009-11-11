From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 17/17] hpsa: fix typo that causes scsi status to be lost
Date: Wed, 11 Nov 2009 10:51:50 -0600
Message-ID: <20091111165150.17754.50167.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758279AbZKKQu3@vger.kernel.org>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

hpsa: fix typo that causes scsi status to be lost

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5097995..06eeefd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -987,7 +987,7 @@ static void complete_scsi_command(struct CommandList *cp,
 
 
 			/* Must be some other type of check condition */
-			cmd->result |= (ei->ScsiStatus < 1);
+			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "
 					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
@@ -1010,7 +1010,7 @@ static void complete_scsi_command(struct CommandList *cp,
 		 */
 		if (ei->ScsiStatus) {
 
-			cmd->result |= (ei->ScsiStatus < 1);
+			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has status 0x%x "
 				"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 				"Returning result: 0x%x\n",
