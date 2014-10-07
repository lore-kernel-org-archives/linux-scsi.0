From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/26] fas216: Return DID_ERROR for incomplete data transfer
Date: Tue,  7 Oct 2014 11:03:06 +0200
Message-ID: <1412672605-42868-8-git-send-email-hare@suse.de>
References: <1412672605-42868-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbaJGJDa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 05:03:30 -0400
In-Reply-To: <1412672605-42868-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

fas216 returns DID_BAD_TARGET for an incomplete data
transfer. The midlayer uses DID_BAD_TARGET to signal
a non-existing or not reachable target. So we should
rather be using DID_ERROR here.

Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/fas216.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 71cfb1e..7fc6fd3 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2085,8 +2085,7 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 				SCpnt->result, info->scsi.SCp.ptr,
 				info->scsi.SCp.this_residual);
 			__scsi_print_command(SCpnt->cmnd);
-			SCpnt->result &= ~(255 << 16);
-			SCpnt->result |= DID_BAD_TARGET << 16;
+			set_host_byte(SCpnt, DID_ERROR);
 			goto request_sense;
 		}
 	}
-- 
1.8.5.2

