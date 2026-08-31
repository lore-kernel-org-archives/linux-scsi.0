Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CF8356761;
	Mon, 31 Aug 2026 02:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141932; cv=none; b=fqgHkwYsKlLKYhwrK/PCWojl8nZ34/z45Lu9PyzaR7pFEsH/3UXlTnJJCSGH9FMgdb9QNyFMSwk8BkXd3RtUDohbzsz9XznlbpCBmuhvy/M7TzSXEo42/ndp/7K5XW4K5URKztLCdonZHa3StdZjUWASFfifY+B9PUlE1p6E8JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141932; c=relaxed/simple;
	bh=2SggC+ZVuOsQ7XYce6B55mmWU6M7mDvHN8RGclSGMmM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyPpjZ6zZHLjS+pgvtSLrLHre/MHNMXixc15Kvs52U8HZgpolPYc8tF6ZDoQuc69AzeU3WnMeeETsJABnX33BBbEnG5Jus3PjjvhYUHwjxWSiRpK/nAlPzUM4aJN/v2MXJEuV+XIYAHWvgPYuMafJQzSFlmv5lEgRKDpKixiHvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1CmdhVZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1CmdhVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B6D1F00A3E;
	Mon, 31 Aug 2026 02:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141931;
	bh=XRIHjC99X3BvhlsCWuYonNooUNHHjj6FPKdt9T3x+3E=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=P1CmdhVZPZZU+swfa2P+fxb7Yf0FNZ1u8YHLxtP7wlmBxA0u7kXqcY+slzXp2Bu3e
	 IavF0bC+dDM/ApnebknHjxO1kv1KCC2LtRgAMq50nXp2EKjjGxVvvvWbu7L01y3J5x
	 +Kl6h4+cNTNzBYw7z/cPEBn6WW8HX41c5ID5EJuMLa8vFs+VNMrr4KoyMkjJ1yNSij
	 pJornF48LwP247Yokm1Kyhs5LMksVpMry0kMzOINtOphmXe1YxH8NMbIQOuWPrH5e9
	 keCOH+WHw82t8kuqsud5iQakgXYZcoEEKDaBRNRwJ0cR/SfN8FO9+g+z2LGJjaciXy
	 uXIRcVujfibug==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 17/37] scsi: mpt3sas: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:31 +0900
Message-ID: <20260831020451.585944-18-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831020451.585944-1-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the mpt3sas driver to replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 69 +++++++++++++++-------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0e12009a87f6..085d4672db85 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5401,23 +5401,23 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 static void
 _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 {
-	u8 ascq;
+	u16 sense_code;
 
 	switch (ioc_status) {
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
-		ascq = 0x01;
+		sense_code = LOGICAL_BLOCK_GUARD_CHECK_FAILED;
 		break;
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
-		ascq = 0x02;
+		sense_code = LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED;
 		break;
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
-		ascq = 0x03;
+		sense_code = LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED;
 		break;
 	default:
-		ascq = 0x00;
+		sense_code = ID_CRC_OR_ECC_ERROR;
 		break;
 	}
-	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x10, ascq);
+	scsi_set_sense(scmd, 0, ILLEGAL_REQUEST, sense_code);
 	set_host_byte(scmd, DID_ABORT);
 }
 
@@ -5474,7 +5474,8 @@ static enum scsi_qc_status scsih_qcmd(struct Scsi_Host *shost,
 	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE || sas_device_priv_data->block) {
 		if (scsi_get_host_state(scmd->device->host) == SHOST_RECOVERY &&
 		    scmd->cmnd[0] == TEST_UNIT_READY) {
-			scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
+			scsi_set_sense(scmd, 0, UNIT_ATTENTION,
+				       I_T_NEXUS_LOSS_OCCURRED);
 			scsi_done(scmd);
 			return 0;
 		}
@@ -5986,7 +5987,7 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	event_data = (Mpi2EventDataSasDeviceStatusChange_t *)
 	    event_reply->EventData;
 	event_data->ReasonCode = MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA;
-	event_data->ASC = 0x5D;
+	event_data->ASC = ASC_FAILURE_PREDICTION_THRESHOLD_EXCEEDED;
 	event_data->DevHandle = cpu_to_le16(handle);
 	event_data->SASAddress = cpu_to_le64(sas_target_priv_data->sas_address);
 	mpt3sas_ctl_add_to_event_log(ioc, event_reply);
@@ -6109,8 +6110,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		    le32_to_cpu(mpi_reply->SenseCount));
 		memcpy(scmd->sense_buffer, sense_data, sz);
 		_scsih_normalize_sense(scmd->sense_buffer, &data);
-		/* failure prediction threshold exceeded */
-		if (data.asc == 0x5D)
+		if (data.asc == ASC_FAILURE_PREDICTION_THRESHOLD_EXCEEDED)
 			_scsih_smart_predicted_fault(ioc,
 			    le16_to_cpu(mpi_reply->DevHandle));
 		mpt3sas_trigger_scsi(ioc, data.skey, data.asc, data.ascq);
@@ -6199,8 +6199,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
 			mpi_reply->SCSIState = MPI2_SCSI_STATE_AUTOSENSE_VALID;
 			mpi_reply->SCSIStatus = SAM_STAT_CHECK_CONDITION;
-			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST,
-					 0x20, 0);
+			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+				       INVALID_COMMAND_OP_CODE);
 		}
 		break;
 
@@ -7691,38 +7691,41 @@ _scsih_determine_disposition(struct MPT3SAS_ADAPTER *ioc,
 
 	if (check_sense) {
 		_scsih_normalize_sense(transfer_packet->sense, &sense_info);
-		if (sense_info.skey == UNIT_ATTENTION)
+		if (sense_info.skey == UNIT_ATTENTION) {
 			rc = DEVICE_RETRY_UA;
-		else if (sense_info.skey == NOT_READY) {
-			/* medium isn't present */
-			if (sense_info.asc == 0x3a)
+		} else if (sense_info.skey == NOT_READY) {
+			if (sense_info.asc == ASC_MEDIUM_NOT_PRESENT) {
 				rc = DEVICE_READY;
-			/* LOGICAL UNIT NOT READY */
-			else if (sense_info.asc == 0x04) {
-				if (sense_info.ascq == 0x03 ||
-				   sense_info.ascq == 0x0b ||
-				   sense_info.ascq == 0x0c) {
+			} else if (sense_info.asc == ASC_LU_NOT_READY) {
+				u16 scode = scsi_sense_code(sense_info.asc,
+							    sense_info.ascq);
+
+				if (scode ==
+				    LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED ||
+				    scode ==
+				    LU_NOT_ACCESSIBLE_TARGET_PORT_IN_STANDBY_STATE ||
+				    scode ==
+				    LU_NOT_ACCESSIBLE_TARGET_PORT_IN_UNAVAILABLE_STATE)
 					rc = DEVICE_ERROR;
-				} else
+				else
 					rc = DEVICE_START_UNIT;
-			}
-			/* LOGICAL UNIT HAS NOT SELF-CONFIGURED YET */
-			else if (sense_info.asc == 0x3e && !sense_info.ascq)
+			} else if (sense_info.asc ==
+				   ASC_LU_HAS_NOT_SELF_CONFIGURED_YET &&
+				   !sense_info.ascq) {
 				rc = DEVICE_START_UNIT;
+			}
 		} else if (sense_info.skey == ILLEGAL_REQUEST &&
-		    transfer_packet->cdb[0] == REPORT_LUNS) {
+			   transfer_packet->cdb[0] == REPORT_LUNS) {
 			rc = DEVICE_READY;
 		} else if (sense_info.skey == MEDIUM_ERROR) {
-
-			/* medium is corrupt, lets add the device so
-			 * users can collect some info as needed
+			/*
+			 * medium is corrupt, lets add the device so users can
+			 * collect some info as needed
 			 */
-
-			if (sense_info.asc == 0x31)
+			if (sense_info.asc == ASC_MEDIUM_FORMAT_CORRUPTED)
 				rc = DEVICE_READY;
 		} else if (sense_info.skey == HARDWARE_ERROR) {
-			/* Defect List Error, still add the device */
-			if (sense_info.asc == 0x19)
+			if (sense_info.asc == ASC_DEFECT_LIST_ERROR)
 				rc = DEVICE_READY;
 		}
 	}
-- 
2.55.0

