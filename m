From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch 08/10] mpt2sas: use scsi_host_alloc_node
Date: Tue, 30 Oct 2012 16:14:42 -0400
Message-ID: <1351628084-29358-11-git-send-email-jmoyer@redhat.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab2J3UPU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Oct 2012 16:15:20 -0400
In-Reply-To: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org


Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index af4e6c4..a4d6b36 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8011,8 +8011,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct MPT2SAS_ADAPTER *ioc;
 	struct Scsi_Host *shost;
 
-	shost = scsi_host_alloc(&scsih_driver_template,
-	    sizeof(struct MPT2SAS_ADAPTER));
+	shost = scsi_host_alloc_node(&scsih_driver_template,
+	    sizeof(struct MPT2SAS_ADAPTER), dev_to_node(&pdev->dev));
 	if (!shost)
 		return -ENODEV;
 
-- 
1.7.1

