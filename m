From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/5] scsi: Correctly handle thin provisioning write error
Date: Thu, 26 Nov 2009 12:00:41 -0500
Message-ID: <1259254843-8326-4-git-send-email-martin.petersen@oracle.com>
References: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:20565 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760861AbZKZRDE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2009 12:03:04 -0500
In-Reply-To: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

A thin provisioned device may temporarily be out of sufficient
allocation units to fulfill a write request.  In that case it will
return a space allocation in progress error.  Wait a bit and retry the
write.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5987da8..dd12183 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -859,6 +859,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				case 0x07: /* operation in progress */
 				case 0x08: /* Long write in progress */
 				case 0x09: /* self test in progress */
+				case 0x14: /* space allocation in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;
 				default:
-- 
1.6.0.6

