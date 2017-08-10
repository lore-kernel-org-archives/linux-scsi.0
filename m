From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] scsi: allow state transition CREATED_BLOCK -> TRANSPORT_OFFLINE
Date: Thu, 10 Aug 2017 09:05:29 +0200
Message-ID: <1502348731-63534-2-git-send-email-hare@suse.de>
References: <1502348731-63534-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41443 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752281AbdHJHFg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 03:05:36 -0400
In-Reply-To: <1502348731-63534-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

scsi_internal_device_unblock_nowait() allows a state transition
SDEV_CREATED_BLOCK -> SDEV_TRANSPORT_OFFLINE/SDEV_OFFLINE,
scsi_device_set_state() does not.
So add the missing state transition to scsi_device_set_state().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 41c19c7..1ae531b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2599,6 +2599,7 @@ void scsi_exit_queue(void)
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_CREATED_BLOCK:
 			break;
 		default:
 			goto illegal;
-- 
1.8.5.6
