From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH] libiscsi: Use scsi helper to set information descriptor
Date: Sun, 12 Jul 2015 13:38:06 +0300
Message-ID: <1436697486-21161-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:35884 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751093AbbGLKie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jul 2015 06:38:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

In case encountered a PI error, use scsi_set_sense_information
instead of open coding information descriptor format.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/scsi/libiscsi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8053f24..bb5ca7f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -853,12 +853,9 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 				     SAM_STAT_CHECK_CONDITION;
 			scsi_build_sense_buffer(1, sc->sense_buffer,
 						ILLEGAL_REQUEST, 0x10, ascq);
-			sc->sense_buffer[7] = 0xc; /* Additional sense length */
-			sc->sense_buffer[8] = 0;   /* Information desc type */
-			sc->sense_buffer[9] = 0xa; /* Additional desc length */
-			sc->sense_buffer[10] = 0x80; /* Validity bit */
-
-			put_unaligned_be64(sector, &sc->sense_buffer[12]);
+			scsi_set_sense_information(sc->sense_buffer,
+						   SCSI_SENSE_BUFFERSIZE,
+						   sector);
 			goto out;
 		}
 	}
-- 
1.8.4.3

