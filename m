From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 2/8] snic: LUN goes offline due to scsi cmd timeouts
Date: Thu, 17 Mar 2016 00:51:11 -0700
Message-ID: <1458201077-10211-2-git-send-email-nmusini@cisco.com>
References: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-6.cisco.com ([173.37.142.93]:27530 "EHLO
	alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbcCQH5g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2016 03:57:36 -0400
In-Reply-To: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

- LUN goes offline, if there are atleast two scsi command timeouts
  Completing the IO with scsi_done() fixes the issue.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic_scsi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index e423eaa..5a709eb 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1465,11 +1465,19 @@ snic_abort_finish(struct snic *snic, struct scsi_cmnd *sc)
 	case SNIC_STAT_IO_SUCCESS:
 	case SNIC_STAT_IO_NOT_FOUND:
 		ret = SUCCESS;
+		/*
+		 * If abort path doesn't call scsi_done(),
+		 * the # IO timeouts == 2, will cause the LUN offline.
+		 * Call scsi_done to complete the IO.
+		 */
+		sc->result = (DID_ERROR << 16);
+		sc->scsi_done(sc);
 		break;
 
 	default:
 		/* Firmware completed abort with error */
 		ret = FAILED;
+		rqi = NULL;
 		break;
 	}
 
@@ -1842,6 +1850,9 @@ snic_dr_clean_single_req(struct snic *snic,
 
 	snic_release_req_buf(snic, rqi, sc);
 
+	sc->result = (DID_ERROR << 16);
+	sc->scsi_done(sc);
+
 	ret = 0;
 
 	return ret;
@@ -2396,6 +2407,13 @@ snic_cmpl_pending_tmreq(struct snic *snic, struct scsi_cmnd *sc)
 		      "Completing Pending TM Req sc %p, state %s flags 0x%llx\n",
 		      sc, snic_io_status_to_str(CMD_STATE(sc)), CMD_FLAGS(sc));
 
+	/*
+	 * CASE : FW didn't post itmf completion due to PCIe Errors.
+	 * Marking the abort status as Success to call scsi completion
+	 * in snic_abort_finish()
+	 */
+	CMD_ABTS_STATUS(sc) = SNIC_STAT_IO_SUCCESS;
+
 	rqi = (struct snic_req_info *) CMD_SP(sc);
 	if (!rqi)
 		return;
-- 
1.8.5.4

