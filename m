From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/19] hpsa: choose number of reply queues more intelligently.
Date: Thu, 08 May 2014 14:28:04 -0500
Message-ID: <20140508192804.13481.93792.stgit@beardog.cce.hp.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:53418 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbaEHT3u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:29:50 -0400
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 186F163063
	for <linux-scsi@vger.kernel.org>; Thu,  8 May 2014 19:29:30 +0000 (UTC)
In-Reply-To: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

No sense having 8 or 16 reply queues if you only have 4 cpus,
and likewise no sense limiting to 8 reply queues if you have
many more cpus.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |    2 ++
 drivers/scsi/hpsa_cmd.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b1ecfd8..b903e86 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6157,6 +6157,8 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
 		dev_info(&h->pdev->dev, "MSIX\n");
 		h->msix_vector = MAX_REPLY_QUEUES;
+		if (h->msix_vector > num_online_cpus())
+			h->msix_vector = num_online_cpus();
 		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
 				      h->msix_vector);
 		if (err > 0) {
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 9737ac2..55215d3 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -615,7 +615,7 @@ struct TransTable_struct {
 	u32            RepQCount;
 	u32            RepQCtrAddrLow32;
 	u32            RepQCtrAddrHigh32;
-#define MAX_REPLY_QUEUES 8
+#define MAX_REPLY_QUEUES 64
 	struct vals32  RepQAddr[MAX_REPLY_QUEUES];
 };
 

