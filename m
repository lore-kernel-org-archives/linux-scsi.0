From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 29/31] scsi: snic: Remove code that zeroes driver-private command data
Date: Tue, 23 May 2017 17:34:18 -0700
Message-ID: <20170524003420.5381-30-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Since the SCSI core zeroes driver-private command data, remove
that code from the snic driver.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Narsimhulu Musini <nmusini@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
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
