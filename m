From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 02/19] Checking for a NULL return from a kzalloc call in
	hpsa_get_pdisk_of_ioaccel2.
Date: Thu, 08 May 2014 14:27:29 -0500
Message-ID: <20140508192729.13481.30794.stgit@beardog.cce.hp.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:47641 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053AbaEHT2Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:28:24 -0400
In-Reply-To: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Joe Handzik <joseph.t.handzik@hp.com>

Signed-off-by: Scott Teel <scott.teel@hp.com>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/hpsa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fda6cf1..ef66905 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2848,6 +2848,8 @@ static int hpsa_get_pdisk_of_ioaccel2(struct ctlr_info *h,
 
 	/* Get the list of physical devices */
 	physicals = kzalloc(reportsize, GFP_KERNEL);
+	if (physicals == NULL)
+		return 0;
 	if (hpsa_scsi_do_report_phys_luns(h, (struct ReportLUNdata *) physicals,
 		reportsize, extended)) {
 		dev_err(&h->pdev->dev,

