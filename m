From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] mpt2sas:  move the scsi_host_put to the right place
Date: Fri, 20 Apr 2012 17:35:45 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E89B22F@inbmail02.lsi.com>
References: <4F8D6F20.4040301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:48656 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab2DTMFv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Apr 2012 08:05:51 -0400
In-Reply-To: <4F8D6F20.4040301@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This patch seem to be fine. Please consider this patch as Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

Regards,
Nagalakshmi


-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Tuesday, April 17, 2012 6:55 PM
To: 'linux-scsi@vger.kernel.org'
Cc: Nandigama, Nagalakshmi
Subject: [PATCH] mpt2sas: move the scsi_host_put to the right place

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
 


