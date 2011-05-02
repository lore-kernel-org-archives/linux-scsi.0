From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH repost] mpt2sas: fix failure path
Date: Mon, 02 May 2011 15:00:50 +0200
Message-ID: <4DBEAB02.7050000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757562Ab1EBNA4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2011 09:00:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>

host allocated with scsi_host_alloc should be freed when
init fails

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16e99b6..1cb48ab 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6985,6 +6985,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	list_del(&ioc->list);
 	scsi_remove_host(shost);
  out_add_shost_fail:
+	scsi_host_put(shost);
 	return -ENODEV;
 }
 


