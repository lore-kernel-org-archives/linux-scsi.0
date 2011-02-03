From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] mpt2sas: fix a compile issue
Date: Thu, 03 Feb 2011 15:41:25 +0100
Message-ID: <4D4ABE95.5090105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab1BCOl3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2011 09:41:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Without CONFIG_SCSI_MPT2SAS_LOGGING defined the 
variable mpi_reply isn't defined. 

This patch moves the #endif below the expression where
the mpi_reply is used.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index eda347c..40b57c6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2741,13 +2741,14 @@ _scsih_sas_control_complete(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	Mpi2SasIoUnitControlReply_t *mpi_reply =
 	    mpt2sas_base_get_reply_virt_addr(ioc, reply);
-#endif
+
 	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
 	    "sc_complete:handle(0x%04x), (open) "
 	    "smid(%d), ioc_status(0x%04x), loginfo(0x%08x)\n",
 	    ioc->name, le16_to_cpu(mpi_reply->DevHandle), smid,
 	    le16_to_cpu(mpi_reply->IOCStatus),
 	    le32_to_cpu(mpi_reply->IOCLogInfo)));
+#endif
 	return 1;
 }
 


