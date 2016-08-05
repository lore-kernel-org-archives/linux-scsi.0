From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [PATCH] mpt3sas: Don't spam logs if logging level is 0
Date: Fri, 5 Aug 2016 12:18:43 +0530
Message-ID: <a3b55ef3291030b37cffda26a4470b70@mail.gmail.com>
References: <1470229218-22040-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34572 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030399AbcHEGtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2016 02:49:18 -0400
Received: by mail-qk0-f178.google.com with SMTP id p186so129255688qkd.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2016 23:48:44 -0700 (PDT)
In-Reply-To: <1470229218-22040-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>

Hi,
 Please consider this patch as Acked-by: Chaitra P B
<chaitra.basappa@broadcom.com>

Thanks,
 Chaitra

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Johannes Thumshirn
Sent: Wednesday, August 03, 2016 6:30 PM
To: Martin K . Petersen; James Bottomley
Cc: Linux SCSI Mailinglist; Linux Kernel Mailinglist; Sreekanth Reddy;
Johannes Thumshirn
Subject: [PATCH] mpt3sas: Don't spam logs if logging level is 0

In _scsih_io_done() we test if the ioc->logging_level does _not_ have the
MPT_DEBUG_REPLY bit set and if it hasn't we print the debug messages. This
unfortunately is the wrong way around.

Note, the actual bug is older than af0094115 but this commit removed the
CONFIG_SCSI_MPT3SAS_LOGGING Kconfig option which hid the bug.

Fixes: af0094115 'mpt2sas, mpt3sas: Remove SCSI_MPTXSAS_LOGGING entry from
Kconfig'
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 4a1cc85..a138690 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4693,7 +4693,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16
smid, u8 msix_index, u32 reply)
 			    le16_to_cpu(mpi_reply->DevHandle));
 		mpt3sas_trigger_scsi(ioc, data.skey, data.asc, data.ascq);

-		if (!(ioc->logging_level & MPT_DEBUG_REPLY) &&
+		if ((ioc->logging_level & MPT_DEBUG_REPLY) &&
 		     ((scmd->sense_buffer[2] == UNIT_ATTENTION) ||
 		     (scmd->sense_buffer[2] == MEDIUM_ERROR) ||
 		     (scmd->sense_buffer[2] == HARDWARE_ERROR)))
--
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
