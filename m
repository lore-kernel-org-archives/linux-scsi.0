From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 13/17] qla1280: Fix bidi command support
Date: Fri, 23 Jan 2015 13:13:06 +0100
Message-ID: <54C23AD2.9030709@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0093.outbound.protection.outlook.com ([65.55.169.93]:5443
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753527AbbAWM1W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:27:22 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Michael Reed <mdr@sgi.com>

The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Michael Reed <mdr@sgi.com>
---
 drivers/scsi/qla1280.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index c68a66e..ede9563 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -468,13 +468,14 @@ static struct qla_driver_setup driver_setup;
 static inline uint16_t
 qla1280_data_direction(struct scsi_cmnd *cmnd)
 {
+	if (scsi_bidi_cmnd(cmnd))
+		return BIT_5 | BIT_6;
+
 	switch(cmnd->sc_data_direction) {
 	case DMA_FROM_DEVICE:
 		return BIT_5;
 	case DMA_TO_DEVICE:
 		return BIT_6;
-	case DMA_BIDIRECTIONAL:
-		return BIT_5 | BIT_6;
 	/*
 	 * We could BUG() on default here if one of the four cases aren't
 	 * met, but then again if we receive something like that from the
-- 
2.1.2

