From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 18/41] hpsa: complain if physical or logical aborts are not
	supported
Date: Wed, 15 Jan 2014 16:37:50 -0600
Message-ID: <20140115223750.5061.27747.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:21157 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaAOVhv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:37:51 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 39500d6..3db772f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5048,6 +5048,10 @@ static void hpsa_find_board_params(struct ctlr_info *h)
 
 	/* Find out what task management functions are supported and cache */
 	h->TMFSupportFlags = readl(&(h->cfgtable->TMFSupportFlags));
+	if (!(HPSATMF_PHYS_TASK_ABORT & h->TMFSupportFlags))
+		dev_warn(&h->pdev->dev, "Physical aborts not supported\n");
+	if (!(HPSATMF_LOG_TASK_ABORT & h->TMFSupportFlags))
+		dev_warn(&h->pdev->dev, "Logical aborts not supported\n");
 }
 
 static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)

