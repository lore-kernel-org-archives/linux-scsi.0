From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 10/12] snic: Remove code that zeroes driver-private command data
Date: Thu, 1 Jun 2017 16:27:09 -0700
Message-ID: <20170601232711.29062-11-bart.vanassche@sandisk.com>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64778 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbdFAX1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 19:27:23 -0400
In-Reply-To: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Johannes Thumshirn <jthumshirn@suse.de>

Since the SCSI core zeroes driver-private command data, remove
that code from the snic driver.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Narsimhulu Musini <nmusini@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/snic/snic_scsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index da979a73baa0..05c3a7282d4a 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -359,8 +359,6 @@ snic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	SNIC_SCSI_DBG(shost, "sc %p Tag %d (sc %0x) lun %lld in snic_qcmd\n",
 		      sc, snic_cmd_tag(sc), sc->cmnd[0], sc->device->lun);
 
-	memset(scsi_cmd_priv(sc), 0, sizeof(struct snic_internal_io_state));
-
 	ret = snic_issue_scsi_req(snic, tgt, sc);
 	if (ret) {
 		SNIC_HOST_ERR(shost, "Failed to Q, Scsi Req w/ err %d.\n", ret);
-- 
2.12.2
