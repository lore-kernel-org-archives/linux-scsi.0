From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: fix handling of protocol error
Date: Fri, 14 Sep 2012 16:34:25 -0500
Message-ID: <20120914213424.12032.43765.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

If a command status of CMD_PROTOCOL_ERR is received, this
information should be conveyed to the SCSI mid layer, not
dropped on the floor.  CMD_PROTOCOL_ERR may be received
from the Smart Array for any commands destined for an external
RAID controller such as a P2000, or commands destined for tape
drives or CD/DVD-ROM drives, if for instance a cable is
disconnected.  This mostly affects multipath configurations, as
disconnecting a cable on a non-multipath configuration is not
going to do anything good regardless of whether CMD_PROTOCOL_ERR
is handled correctly or not.  Not handling CMD_PROTOCOL_ERR
correctly in a multipath configaration involving external RAID
controllers may cause data corruption, so this is quite a serious
bug.  This bug should not normally cause a problem for direct
attached disk storage.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/hpsa.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 796482b..d3e0377 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1315,6 +1315,7 @@ static void complete_scsi_command(struct CommandList *cp)
 	}
 		break;
 	case CMD_PROTOCOL_ERR:
+		cmd->result = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "cp %p has "
 			"protocol error \n", cp);
 		break;
