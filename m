From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 10/24] hpsa: set irq affinity hints to route MSI-X vectors
	across CPUs
Date: Thu, 29 May 2014 10:53:13 -0500
Message-ID: <20140529155312.8180.51635.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:37816 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753AbaE2Pyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:54:38 -0400
Received: from g5t1626.atlanta.hp.com (g5t1626.atlanta.hp.com [15.192.137.9])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 89DF062139
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:54:16 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Mike Miller <michael.miller@canonical.com>
Reviewed-by: Scott Teel <scott.teel@hp.com>
---
 drivers/scsi/hpsa.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9c44f26..e8090e2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6608,6 +6608,17 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
 			h->ioaccel_cmd_pool, h->ioaccel_cmd_pool_dhandle);
 }
 
+static void hpsa_irq_affinity_hints(struct ctlr_info *h)
+{
+	int i, cpu, rc;
+
+	cpu = cpumask_first(cpu_online_mask);
+	for (i = 0; i < h->msix_vector; i++) {
+		rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
+		cpu = cpumask_next(cpu, cpu_online_mask);
+	}
+}
+
 static int hpsa_request_irq(struct ctlr_info *h,
 	irqreturn_t (*msixhandler)(int, void *),
 	irqreturn_t (*intxhandler)(int, void *))
@@ -6627,6 +6638,7 @@ static int hpsa_request_irq(struct ctlr_info *h,
 			rc = request_irq(h->intr[i], msixhandler,
 					0, h->devname,
 					&h->q[i]);
+		hpsa_irq_affinity_hints(h);
 	} else {
 		/* Use single reply pool */
 		if (h->msix_vector > 0 || h->msi_vector) {
@@ -6678,12 +6690,15 @@ static void free_irqs(struct ctlr_info *h)
 	if (!h->msix_vector || h->intr_mode != PERF_MODE_INT) {
 		/* Single reply queue, only one irq to free */
 		i = h->intr_mode;
+		irq_set_affinity_hint(h->intr[i], NULL);
 		free_irq(h->intr[i], &h->q[i]);
 		return;
 	}
 
-	for (i = 0; i < h->msix_vector; i++)
+	for (i = 0; i < h->msix_vector; i++) {
+		irq_set_affinity_hint(h->intr[i], NULL);
 		free_irq(h->intr[i], &h->q[i]);
+	}
 }
 
 static void hpsa_free_irqs_and_disable_msix(struct ctlr_info *h)

