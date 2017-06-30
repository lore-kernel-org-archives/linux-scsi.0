From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/7] aacraid: add fib flag to mark scsi command callback
Date: Fri, 30 Jun 2017 19:18:11 +0200
Message-ID: <1498843092-76285-7-git-send-email-hare@suse.de>
References: <1498843092-76285-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59989 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751878AbdF3RTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 13:19:43 -0400
In-Reply-To: <1498843092-76285-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

To correctly identify which fib has a scsi command callback this
patch implements a flag FIB_CONTEXT_FLAG_SCSI_CMD.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h | 1 +
 drivers/scsi/aacraid/commsup.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index d31a9bc..6981299 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1723,6 +1723,7 @@ struct aac_dev
 #define FIB_CONTEXT_FLAG_FASTRESP		(0x00000008)
 #define FIB_CONTEXT_FLAG_NATIVE_HBA		(0x00000010)
 #define FIB_CONTEXT_FLAG_NATIVE_HBA_TMF	(0x00000020)
+#define FIB_CONTEXT_FLAG_SCSI_CMD	(0x00000040)
 
 /*
  *	Define the command values
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 348f0ea..dfe8e70 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -770,6 +770,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		/* bit1 of request_id must be 0 */
 		hbacmd->request_id =
 			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
+		fibptr->flags |= FIB_CONTEXT_FLAG_SCSI_CMD;
 	} else if (command != HBA_IU_TYPE_SCSI_TM_REQ)
 		return -EINVAL;
 
-- 
1.8.5.6
