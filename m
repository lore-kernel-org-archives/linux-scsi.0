From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 06/17] hpsa: retry driver initiated commands on busy status
Date: Fri, 20 Apr 2012 10:06:46 -0500
Message-ID: <20120420150646.10596.37875.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Matt Bondurant <Matthew.dav.bondurant@hp.com>

In shared SAS configurations we might get a busy status
during driver initiated commands (e.g. during rescan for
devices).  We should retry the command in such cases rather
than giving up.

Signed-off-by: Matt Bondurant <Matthew.dav.bondurant@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fcb9fb2..7355891 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -234,6 +234,15 @@ static int check_for_unit_attention(struct ctlr_info *h,
 	return 1;
 }
 
+static int check_for_busy(struct ctlr_info *h, struct CommandList *c)
+{
+	if (c->err_info->CommandStatus != CMD_TARGET_STATUS ||
+		c->err_info->ScsiStatus != SAM_STAT_BUSY)
+		return 0;
+	dev_warn(&h->pdev->dev, HPSA "device busy");
+	return 1;
+}
+
 static ssize_t host_store_rescan(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -1379,7 +1388,8 @@ static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
 		memset(c->err_info, 0, sizeof(*c->err_info));
 		hpsa_scsi_do_simple_cmd_core(h, c);
 		retry_count++;
-	} while (check_for_unit_attention(h, c) && retry_count <= 3);
+	} while ((check_for_unit_attention(h, c) ||
+			check_for_busy(h, c)) && retry_count <= 3);
 	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
 }
 
