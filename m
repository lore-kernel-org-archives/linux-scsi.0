From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/2] megaraid_sas: Remove the shutdown_controller call
Date: Wed, 24 Aug 2011 17:35:29 +0200
Message-ID: <1314200130-28890-2-git-send-email-thenzl@redhat.com>
References: <1314200130-28890-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab1HXPfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 11:35:55 -0400
In-Reply-To: <1314200130-28890-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: steve.masters@lsi.com, michael.benz@lsi.com, aradford@gmail.com, bo.yang@lsi.com, Tomas Henzl <thenzl@redhat.com>

Remove the call to megasas_shutdown_controller in the megasas_shutdown.
It's unclear why it should be needed, flushing the cache and disabling ints 
seems to be enough, because the system is likely going to be switched off
or restarted anyway. The main reason for removing this is a errant message
sent sometimes to the driver when the card is shut down.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a58f84a..14c33f6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4532,7 +4532,6 @@ static void megasas_shutdown(struct pci_dev *pdev)
 	struct megasas_instance *instance = pci_get_drvdata(pdev);
 	instance->unload = 1;
 	megasas_flush_cache(instance);
-	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 	instance->instancet->disable_intr(instance->reg_set);
 	free_irq(instance->msi_flag ? instance->msixentry.vector :
 		 instance->pdev->irq, instance);
-- 
1.7.6

