From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/5]  libsas: export sas_find_local_phy function
Date: Sat, 23 Feb 2008 23:35:44 -0600
Message-ID: <1203831344.3139.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33663 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbYBXFfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 00:35:48 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 1871F898C
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:35:46 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fiZzQXQ2nnW1 for <linux-scsi@vger.kernel.org>;
	Sat, 23 Feb 2008 23:35:45 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id BFFB08989
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:35:44 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is needed by the to be added I_T reset function in aic94xx.  It
needs to know the local phy so it can send a link or hard reset along
the path.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |    5 +++--
 include/scsi/libsas.h               |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 704ea06..f3706f4 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -434,7 +434,7 @@ static int sas_recover_I_T(struct domain_device *dev)
 }
 
 /* Find the sas_phy that's attached to this device */
-static struct sas_phy *find_local_sas_phy(struct domain_device *dev)
+struct sas_phy *sas_find_local_phy(struct domain_device *dev)
 {
 	struct domain_device *pdev = dev->parent;
 	struct ex_phy *exphy = NULL;
@@ -456,6 +456,7 @@ static struct sas_phy *find_local_sas_phy(struct domain_device *dev)
 	BUG_ON(!exphy);
 	return exphy->phy;
 }
+EXPORT_SYMBOL_GPL(sas_find_local_phy);
 
 /* Attempt to send a LUN reset message to a device */
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
@@ -482,7 +483,7 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
 int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
-	struct sas_phy *phy = find_local_sas_phy(dev);
+	struct sas_phy *phy = sas_find_local_phy(dev);
 	int res;
 
 	res = sas_phy_reset(phy, 1);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3ffd6b5..39e1cac 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -675,5 +675,6 @@ extern int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 extern void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 				  struct ssp_response_iu *iu);
+struct sas_phy *sas_find_local_phy(struct domain_device *dev);
 
 #endif /* _SASLIB_H_ */
-- 
1.5.4.1



