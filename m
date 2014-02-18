From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 11/35] hpsa: complain if physical or logical aborts are not
	supported
Date: Tue, 18 Feb 2014 13:55:59 -0600
Message-ID: <20140218195559.15787.36792.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57035 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaBRT50 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:57:26 -0500
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id E96E83E5
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:57:17 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 31ce73f..7c6db2f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5041,6 +5041,10 @@ static void hpsa_find_board_params(struct ctlr_info *h)
 
 	/* Find out what task management functions are supported and cache */
 	h->TMFSupportFlags = readl(&(h->cfgtable->TMFSupportFlags));
+	if (!(HPSATMF_PHYS_TASK_ABORT & h->TMFSupportFlags))
+		dev_warn(&h->pdev->dev, "Physical aborts not supported\n");
+	if (!(HPSATMF_LOG_TASK_ABORT & h->TMFSupportFlags))
+		dev_warn(&h->pdev->dev, "Logical aborts not supported\n");
 }
 
 static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)

