From: michaelc@cs.wisc.edu
Subject: [PATCH 5/5] libiscsi: fix senselen calculation
Date: Sun, 17 Dec 2006 12:10:28 -0600
Message-ID: <11663790332500-git-send-email-michaelc@cs.wisc.edu>
References: <1166379028772-git-send-email-michaelc@cs.wisc.edu> <11663790303684-git-send-email-michaelc@cs.wisc.edu> <11663790313961-git-send-email-michaelc@cs.wisc.edu> <1166379031350-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbWLQSKm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Dec 2006 13:10:42 -0500
In-Reply-To: <1166379031350-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Yanling Qi, noted that when the sense data length of
a check-condition is greater than 0x7f (127), senselen = (data[0] << 8)
| data[1] will become negative. It causes different kinds of panics from
GPF, spin_lock deadlock to spin_lock recursion.

We were also swapping this value on big endien machines.

This patch fixes both issues by using be16_to_cpu().
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5d88621..c58ae3b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -260,7 +260,7 @@ static int iscsi_scsi_cmd_rsp(struct isc
 	}
 
 	if (rhdr->cmd_status == SAM_STAT_CHECK_CONDITION) {
-		int senselen;
+		uint16_t senselen;
 
 		if (datalen < 2) {
 invalid_datalen:
@@ -270,12 +270,12 @@ invalid_datalen:
 			goto out;
 		}
 
-		senselen = (data[0] << 8) | data[1];
+		senselen = be16_to_cpu(*(uint16_t *)data);
 		if (datalen < senselen)
 			goto invalid_datalen;
 
 		memcpy(sc->sense_buffer, data + 2,
-		       min(senselen, SCSI_SENSE_BUFFERSIZE));
+		       min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
 		debug_scsi("copied %d bytes of sense\n",
 			   min(senselen, SCSI_SENSE_BUFFERSIZE));
 	}
-- 
1.4.1.1

