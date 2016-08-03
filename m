From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] mpt3sas: Don't spam logs if logging level is 0
Date: Wed,  3 Aug 2016 15:00:18 +0200
Message-ID: <1470229218-22040-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

In _scsih_io_done() we test if the ioc->logging_level does _not_ have the
MPT_DEBUG_REPLY bit set and if it hasn't we print the debug messages. This
unfortunately is the wrong way around.

Note, the actual bug is older than af0094115 but this commit removed the
CONFIG_SCSI_MPT3SAS_LOGGING Kconfig option which hid the bug.

Fixes: af0094115 'mpt2sas, mpt3sas: Remove SCSI_MPTXSAS_LOGGING entry from Kconfig'
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 4a1cc85..a138690 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4693,7 +4693,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 			    le16_to_cpu(mpi_reply->DevHandle));
 		mpt3sas_trigger_scsi(ioc, data.skey, data.asc, data.ascq);
 
-		if (!(ioc->logging_level & MPT_DEBUG_REPLY) &&
+		if ((ioc->logging_level & MPT_DEBUG_REPLY) &&
 		     ((scmd->sense_buffer[2] == UNIT_ATTENTION) ||
 		     (scmd->sense_buffer[2] == MEDIUM_ERROR) ||
 		     (scmd->sense_buffer[2] == HARDWARE_ERROR)))
-- 
1.8.5.6
