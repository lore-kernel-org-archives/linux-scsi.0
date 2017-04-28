From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] scsi_dh_alua: Do not retry for unmapped device
Date: Fri, 28 Apr 2017 15:06:25 +0200
Message-ID: <20170428130626.32162-3-mwilck@suse.com>
References: <20170428130626.32162-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46146 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755476AbdD1NG6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 09:06:58 -0400
In-Reply-To: <20170428130626.32162-1-mwilck@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

If a device becomes unmapped on the target we should be returning
SCSI_DH_DEV_OFFLINED.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index b90a5dec199f..501855bde633 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -522,7 +522,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	struct alua_port_group *tmp_pg;
 	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
 	unsigned char *desc, *buff;
-	unsigned err, retval;
+	unsigned err = SCSI_DH_OK, retval;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 	unsigned long flags;
@@ -541,7 +541,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		return SCSI_DH_DEV_TEMP_BUSY;
 
  retry:
-	err = 0;
 	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
 
 	if (retval) {
@@ -569,6 +568,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
 			goto retry;
 		}
+		err = SCSI_DH_IO;
 		/*
 		 * Retry on ALUA state transition or if any
 		 * UNIT ATTENTION occurred.
@@ -576,6 +576,9 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		if (sense_hdr.sense_key == NOT_READY &&
 		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
 			err = SCSI_DH_RETRY;
+		if (sense_hdr.sense_key == ILLEGAL_REQUEST &&
+		    sense_hdr.asc == 0x25 && sense_hdr.ascq == 0x00)
+			err = SCSI_DH_DEV_OFFLINED;
 		else if (sense_hdr.sense_key == UNIT_ATTENTION)
 			err = SCSI_DH_RETRY;
 		if (err == SCSI_DH_RETRY &&
@@ -591,7 +594,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
 		kfree(buff);
 		pg->expiry = 0;
-		return SCSI_DH_IO;
+		return err;
 	}
 
 	len = get_unaligned_be32(&buff[0]) + 4;
-- 
2.12.2
