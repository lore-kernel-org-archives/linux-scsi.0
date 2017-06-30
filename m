From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/7] aacraid: enable sending of TMFs from aac_hba_send()
Date: Fri, 30 Jun 2017 19:18:10 +0200
Message-ID: <1498843092-76285-6-git-send-email-hare@suse.de>
References: <1498843092-76285-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59991 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752016AbdF3RTs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 13:19:48 -0400
In-Reply-To: <1498843092-76285-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

aac_hba_send() will return FAILED for any non-SCSI command requests,
failing any TMFs. This patch updates the check to allow TMFs.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 1c617cc..348f0ea 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -770,7 +770,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 		/* bit1 of request_id must be 0 */
 		hbacmd->request_id =
 			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2) + 1);
-	} else
+	} else if (command != HBA_IU_TYPE_SCSI_TM_REQ)
 		return -EINVAL;
 
 
-- 
1.8.5.6
