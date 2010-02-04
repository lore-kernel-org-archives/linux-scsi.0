From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 20/30] hpsa: Don't return DID_NO_CONNECT when a device is
	merely not ready
Date: Thu, 04 Feb 2010 08:43:05 -0600
Message-ID: <20100204144305.10406.63403.stgit@beardog.cce.hp.com>
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

hpsa: Don't return DID_NO_CONNECT when a device is merely not ready

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d07b3d3..320d686 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1029,7 +1029,6 @@ static void complete_scsi_command(struct CommandList *cp,
 				 * required
 				 */
 				if ((asc == 0x04) && (ascq == 0x03)) {
-					cmd->result = DID_NO_CONNECT << 16;
 					dev_warn(&h->pdev->dev, "cp %p "
 						"has check condition: unit "
 						"not ready, manual "
