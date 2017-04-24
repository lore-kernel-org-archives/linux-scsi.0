From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] mpt: Move scsi_remove_host() out of mptscsih_remove_host()
Date: Mon, 24 Apr 2017 11:22:32 +0200
Message-ID: <1493025752-19963-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41121 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1167840AbdDXJWg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 05:22:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Commit c5ce0ab ("scsi: sas: move scsi_remove_host call...")
moved the call to scsi_remove_host() into sas_remove_host(),
but forgot to modify the mpt drivers.

Fixes: c5ce0ab ("scsi: sas: move scsi_remove_host call into sas_remove_host")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/message/fusion/mptfc.c    |  7 ++++++-
 drivers/message/fusion/mptscsih.c |  2 --
 drivers/message/fusion/mptspi.c   | 10 +++++++++-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 98eafae..d065062 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1329,7 +1329,7 @@
 					WQ_MEM_RECLAIM);
 	if (!ioc->fc_rescan_work_q) {
 		error = -ENOMEM;
-		goto out_mptfc_probe;
+		goto out_mptfc_host;
 	}
 
 	/*
@@ -1351,6 +1351,9 @@
 
 	return 0;
 
+out_mptfc_host:
+	scsi_remove_host(sh);
+
 out_mptfc_probe:
 
 	mptscsih_remove(pdev);
@@ -1530,6 +1533,8 @@ static void mptfc_remove(struct pci_dev *pdev)
 		}
 	}
 
+	scsi_remove_host(ioc->sh);
+
 	mptscsih_remove(pdev);
 }
 
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 08a807d..6ba07c7 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1176,8 +1176,6 @@ static int	mptscsih_get_completion_code(MPT_ADAPTER *ioc,
 	MPT_SCSI_HOST		*hd;
 	int sz1;
 
-	scsi_remove_host(host);
-
 	if((hd = shost_priv(host)) == NULL)
 		return;
 
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 031e088..9a336a1 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1548,11 +1548,19 @@ static void mpt_dv_raid(struct _MPT_SCSI_HOST *hd, int disk)
 	return error;
 }
 
+static void mptspi_remove(struct pci_dev *pdev)
+{
+	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
+
+	scsi_remove_host(ioc->sh);
+	mptscsih_remove(pdev);
+}
+
 static struct pci_driver mptspi_driver = {
 	.name		= "mptspi",
 	.id_table	= mptspi_pci_table,
 	.probe		= mptspi_probe,
-	.remove		= mptscsih_remove,
+	.remove		= mptspi_remove,
 	.shutdown	= mptscsih_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= mptscsih_suspend,
-- 
1.8.5.6
