From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH REPOST] mpt2sas: fix a compile issue
Date: Mon, 02 May 2011 15:08:34 +0200
Message-ID: <4DBEACD2.5040602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556Ab1EBNIh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2011 09:08:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>

This is a repost - the original mail was ack-ed by Kashyap Desai - http://www.spinics.net/lists/linux-scsi/msg50271.html

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
 


--


