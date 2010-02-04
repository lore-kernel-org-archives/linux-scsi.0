From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/30] hpsa: use sizeof() not an inline constant in memset.
Date: Thu, 04 Feb 2010 08:42:04 -0600
Message-ID: <20100204144204.10406.68867.stgit@beardog.cce.hp.com>
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

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: use sizeof() not an inline constant in memset.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8389cce..add2ed5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1363,9 +1363,8 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 		dev_err(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
 		return -1;
 	}
-
-	memset(&scsi3addr[0], 0, 8); /* address the controller */
-
+	/* address the controller */
+	memset(scsi3addr, 0, sizeof(scsi3addr));
 	fill_cmd(c, logical ? HPSA_REPORT_LOG : HPSA_REPORT_PHYS, h,
 		buf, bufsize, 0, scsi3addr, TYPE_CMD);
 	if (extended_response)
