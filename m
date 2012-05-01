From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/17] hpsa: do not give up retry of driver cmds after only 3
	retries
Date: Tue, 01 May 2012 11:42:40 -0500
Message-ID: <20120501164240.11705.10308.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Instead of giving up after 3 immediate retries of driver initiated
commands, back off the rate of retries and retry a bunch more times.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5015ac4..cb9d619 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1380,17 +1380,24 @@ static void hpsa_scsi_do_simple_cmd_core_if_no_lockup(struct ctlr_info *h,
 	}
 }
 
+#define MAX_DRIVER_CMD_RETRIES 25
 static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
 	struct CommandList *c, int data_direction)
 {
-	int retry_count = 0;
+	int backoff_time = 10, retry_count = 0;
 
 	do {
 		memset(c->err_info, 0, sizeof(*c->err_info));
 		hpsa_scsi_do_simple_cmd_core(h, c);
 		retry_count++;
+		if (retry_count > 3) {
+			msleep(backoff_time);
+			if (backoff_time < 1000)
+				backoff_time *= 2;
+		}
 	} while ((check_for_unit_attention(h, c) ||
-			check_for_busy(h, c)) && retry_count <= 3);
+			check_for_busy(h, c)) &&
+			retry_count <= MAX_DRIVER_CMD_RETRIES);
 	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
 }
 
