From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] mpt2sas:  move the scsi_host_put to the right place
Date: Tue, 17 Apr 2012 15:24:48 +0200
Message-ID: <4F8D6F20.4040301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab2DQNYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Apr 2012 09:24:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

When scsi_add_host fails the scsi_host_put should be called.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index d953a57..0a256a3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8061,8 +8061,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  out_thread_fail:
 	list_del(&ioc->list);
 	scsi_remove_host(shost);
-	scsi_host_put(shost);
  out_add_shost_fail:
+	scsi_host_put(shost);
 	return -ENODEV;
 }
 


