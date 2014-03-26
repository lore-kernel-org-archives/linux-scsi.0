From: Joe Handzik <joseph.t.handzik@beardog.cce.hp.com>
Subject: [PATCH] hpsa: Checking for a NULL return from a kzalloc call
Date: Wed, 26 Mar 2014 17:48:11 -0500
Message-ID: <20140326224739.7679.19250.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:24264 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaCZWtF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Mar 2014 18:49:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, scameron@beardog.cce.hp.com

From: Joe Handzik <joseph.t.handzik@hp.com>

Checking for a NULL return from a kzalloc call in hpsa_get_pdisk_of_ioaccel2.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8cf4a0c..2d37257 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2836,6 +2836,8 @@ static int hpsa_get_pdisk_of_ioaccel2(struct ctlr_info *h,
 
 	/* Get the list of physical devices */
 	physicals = kzalloc(reportsize, GFP_KERNEL);
+	if (physicals == NULL)
+		return 0;
 	if (hpsa_scsi_do_report_phys_luns(h, (struct ReportLUNdata *) physicals,
 		reportsize, extended)) {
 		dev_err(&h->pdev->dev,

