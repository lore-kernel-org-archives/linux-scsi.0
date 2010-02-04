From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 19/30] hpsa: Retry commands completing with a sense key of
	ABORTED_COMMAND
Date: Thu, 04 Feb 2010 08:43:00 -0600
Message-ID: <20100204144300.10406.47550.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Matt Gates <matthew.gates@hp.com>

hpsa: Retry commands completing with a sense key of ABORTED_COMMAND

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bcc51f9..d07b3d3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1037,8 +1037,15 @@ static void complete_scsi_command(struct CommandList *cp,
 					break;
 				}
 			}
-
-
+			if (sense_key == ABORTED_COMMAND) {
+				/* Aborted command is retryable */
+				dev_warn(&h->pdev->dev, "cp %p "
+					"has check condition: aborted command: "
+					"ASC: 0x%x, ASCQ: 0x%x\n",
+					cp, asc, ascq);
+				cmd->result = DID_SOFT_ERROR << 16;
+				break;
+			}
 			/* Must be some other type of check condition */
 			dev_warn(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "
