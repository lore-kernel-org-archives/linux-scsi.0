From: Mike Maslenkin <mihailm@parallels.com>
Subject: [PATCH 1/1] scsi_transport_spi: fix for unbalanced reference counting
Date: Sat, 28 Apr 2012 05:32:14 +0400
Message-ID: <1335576734-12805-1-git-send-email-mihailm@parallels.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:19730 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab2D0VdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2012 17:33:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Mike Maslenkin <mihailm@parallels.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Check the domain validation flag on the given device before referencing
scsi_device instance.

Signed-off-by: Mike Maslenkin <mihailm@parallels.com>
CC: James E.J. Bottomley <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_transport_spi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index a2715c3..3cc09b9 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1010,10 +1010,10 @@ spi_dv_device(struct scsi_device *sdev)
 	u8 *buffer;
 	const int len = SPI_MAX_ECHO_BUFFER_SIZE*2;
 
-	if (unlikely(scsi_device_get(sdev)))
+	if (unlikely(spi_dv_in_progress(starget)))
 		return;
 
-	if (unlikely(spi_dv_in_progress(starget)))
+	if (unlikely(scsi_device_get(sdev)))
 		return;
 	spi_dv_in_progress(starget) = 1;
 
-- 
1.6.6.1

