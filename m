From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 10/12] snic: Remove code that zeroes driver-private command data
Date: Fri, 2 Jun 2017 14:22:01 -0700
Message-ID: <20170602212203.30401-11-bart.vanassche@sandisk.com>
References: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1337 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdFBVWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 17:22:20 -0400
In-Reply-To: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Sesidhar Baddela <sebaddel@cisco.com>, Johannes Thumshirn <jthumshirn@suse.de>

Since the SCSI core zeroes driver-private command data, remove
that code from the snic driver.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Narsimhulu Musini <nmusini@cisco.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
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
