From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 6/6] hpsa: Do not zero fields of ioaccel2 command structure
	twice
Date: Fri, 21 Feb 2014 16:25:21 -0600
Message-ID: <20140221222521.31344.93771.stgit@beardog.cce.hp.com>
References: <20140221222153.31344.99129.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:48943 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaBUW0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 17:26:23 -0500
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id D929561386
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 22:26:22 +0000 (UTC)
In-Reply-To: <20140221222153.31344.99129.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Structure was already memset to zero at the top
of hpsa_scsi_ioaccel2_queue_command

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 355ebf3..a32a510 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3570,8 +3570,6 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 	cp->Tag = (c->cmdindex << DIRECT_LOOKUP_SHIFT) |
 				DIRECT_LOOKUP_BIT;
 	memcpy(cp->cdb, cdb, sizeof(cp->cdb));
-	memset(cp->cciss_lun, 0, sizeof(cp->cciss_lun));
-	cp->cmd_priority_task_attr = 0;
 
 	/* fill in sg elements */
 	cp->sg_count = (u8) use_sg;

