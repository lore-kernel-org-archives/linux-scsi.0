From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 18/30] hpsa: Return DID_RESET for commands which complete with
	status of UNSOLICITED ABORT
Date: Thu, 04 Feb 2010 08:42:55 -0600
Message-ID: <20100204144255.10406.57450.stgit@beardog.cce.hp.com>
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

hpsa: Return DID_RESET for commands which complete with status of UNSOLICITED ABORT.
The commands should be retried, and this will make that happen, instead of resulting
in an i/o error.

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cc9e92a..bcc51f9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1128,7 +1128,7 @@ static void complete_scsi_command(struct CommandList *cp,
 		dev_warn(&h->pdev->dev, "cp %p reports abort failed\n", cp);
 		break;
 	case CMD_UNSOLICITED_ABORT:
-		cmd->result = DID_ABORT << 16;
+		cmd->result = DID_RESET << 16;
 		dev_warn(&h->pdev->dev, "cp %p aborted do to an unsolicited "
 			"abort\n", cp);
 		break;
