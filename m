From: michaelc@cs.wisc.edu
Subject: [PATCH 5/7] use get_unaligned
Date: Wed, 28 Feb 2007 17:32:19 -0600
Message-ID: <11727055441132-git-send-email-michaelc@cs.wisc.edu>
References: <1172705541949-git-send-email-michaelc@cs.wisc.edu> <11727055423762-git-send-email-michaelc@cs.wisc.edu> <11727055433394-git-send-email-michaelc@cs.wisc.edu> <1172705543740-git-send-email-michaelc@cs.wisc.edu> <1172705544330-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbXB1Xcg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 18:32:36 -0500
In-Reply-To: <1172705544330-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Dave Miller meantioned that the data buffer in a past
sense fixup patch was not gauranteed to be aligned
properly for ia64. This patch has libiscsi use get_unalinged
to make sure. There are a couple more places in the
digest handling we may need to do this, but we are in the middle
of fixing that code for big endien systems so just the sense
access is fixed here.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6913466..e226433 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -25,6 +25,7 @@ #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/kfifo.h>
 #include <linux/delay.h>
+#include <asm/unaligned.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -269,14 +270,14 @@ invalid_datalen:
 			goto out;
 		}
 
-		senselen = be16_to_cpu(*(__be16 *)data);
+		senselen = be16_to_cpu(get_unaligned((__be16 *) data));
 		if (datalen < senselen)
 			goto invalid_datalen;
 
 		memcpy(sc->sense_buffer, data + 2,
 		       min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
 		debug_scsi("copied %d bytes of sense\n",
-			   min(senselen, SCSI_SENSE_BUFFERSIZE));
+			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
 	}
 
 	if (sc->sc_data_direction == DMA_TO_DEVICE)
-- 
1.4.1.1

