From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 06/17] eata: Remove dead code
Date: Fri, 23 Jan 2015 13:08:51 +0100
Message-ID: <54C239D3.7090209@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0092.outbound.protection.outlook.com ([157.56.111.92]:31904
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753314AbbAWMI5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:08:57 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dario Ballabio <ballabio_dario@emc.com>

The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL.
Hence remove the code that tests for this value.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Dario Ballabio <ballabio_dario@emc.com>
---
 drivers/scsi/eata.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 227dd2c..c1fa5ba 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1726,9 +1726,8 @@ static void scsi_to_dev_dir(unsigned int i, struct hostdata *ha)
 		return;
 	}
 
-	if (SCpnt->sc_data_direction != DMA_BIDIRECTIONAL)
-		panic("%s: qcomm, invalid SCpnt->sc_data_direction.\n",
-				ha->board_name);
+	panic("%s: qcomm, invalid SCpnt->sc_data_direction %d.\n",
+	      ha->board_name, SCpnt->sc_data_direction);
 
 	for (k = 0; k < ARRAY_SIZE(data_out_cmds); k++)
 		if (SCpnt->cmnd[0] == data_out_cmds[k]) {
-- 
2.1.2

