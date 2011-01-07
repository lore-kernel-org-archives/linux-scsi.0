From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/3] hpsa: Fix problem that CMD_UNABORTABLE command status was
	treated as unknown
Date: Fri, 07 Jan 2011 10:55:48 -0600
Message-ID: <20110107165548.14259.50339.stgit@beardog.cce.hp.com>
References: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <StephenM.Cameron>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c6c13b0..5828bcb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1152,6 +1152,10 @@ static void complete_scsi_command(struct CommandList *cp,
 		cmd->result = DID_TIME_OUT << 16;
 		dev_warn(&h->pdev->dev, "cp %p timedout\n", cp);
 		break;
+	case CMD_UNABORTABLE:
+		cmd->result = DID_ERROR << 16;
+		dev_warn(&h->pdev->dev, "Command unabortable\n");
+		break;
 	default:
 		cmd->result = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
@@ -1317,6 +1321,9 @@ static void hpsa_scsi_interpret_error(struct CommandList *cp)
 	case CMD_TIMEOUT:
 		dev_warn(d, "cp %p timed out\n", cp);
 		break;
+	case CMD_UNABORTABLE:
+		dev_warn(d, "Command unabortable\n");
+		break;
 	default:
 		dev_warn(d, "cp %p returned unknown status %x\n", cp,
 				ei->CommandStatus);
