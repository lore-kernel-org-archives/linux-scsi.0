From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] mpt3sas: a correction in unmap_resources
Date: Wed, 23 Dec 2015 14:21:47 +0100
Message-ID: <1450876907-3913-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524AbbLWNVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Dec 2015 08:21:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@avagotech.com, chaitra.basappa@avagotech.com, mlombard@redhat.com

It might happen that we try to free an already freed pointer.

Tomas

Reported-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index d4f1dcdb83..3b09b3d09f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1827,8 +1827,10 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
 	_base_free_irq(ioc);
 	_base_disable_msix(ioc);
 
-	if (ioc->msix96_vector)
+	if (ioc->msix96_vector) {
 		kfree(ioc->replyPostRegisterIndex);
+		ioc->replyPostRegisterIndex = NULL;
+	}
 
 	if (ioc->chip_phys) {
 		iounmap(ioc->chip);
-- 
2.4.3

