Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F6229346F;
	Mon, 31 Aug 2026 02:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141937; cv=none; b=LmjlvMV+xFUdZgyok39mmpPp6lgKWXY82eKK2Wh2lhponvurthkY4MF68EcdnBsL7o+if35ZsisL8PWKssctCPNQVYQmA3Taxc7iGyzD5lkjTLzF30PiY+lkzmZE46pTr/ZXf7Mo7t1Hj/30IVAop+aODKafusLqRMeViM9ELgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141937; c=relaxed/simple;
	bh=ZyOXQptz0p5l+iyHI5XdEOcqmdDKfWxADNxBtffX8qo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeaZH9gNhktKsGTKfpbsVRnE6S4imrTTAXt0lgan3dIkMQuMowAsNs1KqfyZd97OpTQ4/SYeaGGMb2ymlfKDS+xSxVYNOz5ALLlPLet95m0txvoYDr3l5RUvhnkNofxXBWw+0PlcTy1xAcRNX/Zj9muqseO+YjpMC0DjfjFaITs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZ/SqRdc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZ/SqRdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67E51F000E9;
	Mon, 31 Aug 2026 02:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141935;
	bh=2uTKqVtr9TqKiLuWOiaCIa15/bYjH1syNv9wiGf3MbY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=QZ/SqRdcLevZpPHIdAuyuA41B61Ecs5KDRCsl99DxDo/wDMgwNK8f4JL5353DO6Pt
	 p/MqPXDDP3WEAmD0oQKDkF6AhHW/9TMCcK06o963gbuJ7xLDa3DFXdDL61Fi762VVj
	 PCxXef8DTe5gmR1imS0402fmh4MHOZjfaVSekKhZpB4NnlYNpuYRqA5kpkK0NnNp9O
	 EWbiTThQOVT9M7eBRinV0vQShSjmw0X7KEzSocna/kxkzdl48PBH1ZvsTqmz6fC4VD
	 apamOEk1B0eTJE1bi3AdlnHk1sPCG/GlLe8skv9PMvi8CFIIx4vPMBAFKllPXkO5ut
	 TBbThSt1wVHPA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 20/37] scsi: leapraid: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:34 +0900
Message-ID: <20260831020451.585944-21-dlemoal@kernel.org>
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

Refactor the leapraid driver to use the 16-bits sense_code field of
struct scsi_sense_hdr and replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

With this change, the locally defined macros for ASC and ASCQ values are
deleted.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/leapraid/leapraid_func.h |  7 -------
 drivers/scsi/leapraid/leapraid_os.c   | 15 +++++++--------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/leapraid/leapraid_func.h b/drivers/scsi/leapraid/leapraid_func.h
index 4c0b9ca728d8..879d8cd5ec03 100644
--- a/drivers/scsi/leapraid/leapraid_func.h
+++ b/drivers/scsi/leapraid/leapraid_func.h
@@ -113,7 +113,6 @@
 #define DESC_FORMAT_THRESHOLD                   0x72
 #define SENSE_KEY_MASK                          0x0F
 #define SCSI_SENSE_RESPONSE_CODE_MASK           0x7F
-#define ASC_FAILURE_PREDICTION_THRESHOLD_EXCEEDED       0x5D
 #define LEAPRAID_LARGE_DISK_THRESHOLD           0x200000UL
 #define LEAPRAID_LARGE_DISK_HEADS               255
 #define LEAPRAID_LARGE_DISK_SECTORS             63
@@ -126,12 +125,6 @@
 #define LEAPRAID_SCSI_HOST_SHIFT                16
 #define LEAPRAID_SCSI_DRIVER_SHIFT              24
 
-/* SCSI ASC/ASCQ definitions. */
-#define LEAPRAID_SCSI_ASCQ_DEFAULT              0x00
-#define LEAPRAID_SCSI_ASC_POWER_ON_RESET        0x29
-#define LEAPRAID_SCSI_ASC_INVALID_CMD_CODE      0x20
-#define LEAPRAID_SCSI_ASCQ_POWER_ON_RESET       0x07
-
 /* VPD Page 0x89 (ATA Information). */
 #define LEAPRAID_VPD_PAGE_ATA_INFO      0x89
 #define LEAPRAID_VPD_PG89_MAX_LEN       255
diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/leapraid_os.c
index ee3242779dfd..eb8b11439923 100644
--- a/drivers/scsi/leapraid/leapraid_os.c
+++ b/drivers/scsi/leapraid/leapraid_os.c
@@ -382,9 +382,8 @@ static void leapraid_handle_data_underrun(
 	} else if (!xfer_cnt && scmd->cmnd[0] == REPORT_LUNS) {
 		scsiio_rep->scsi_state = LEAPRAID_SCSI_STATE_AUTOSENSE_VALID;
 		scsiio_rep->scsi_status = SAM_STAT_CHECK_CONDITION;
-		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST,
-				 LEAPRAID_SCSI_ASC_INVALID_CMD_CODE,
-				 LEAPRAID_SCSI_ASCQ_DEFAULT);
+		scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
+			       INVALID_COMMAND_OP_CODE);
 	}
 }
 
@@ -515,8 +514,9 @@ static void leapraid_scsiio_done_dispatch(
 					 &sshdr))
 			dev_warn(&adapter->pdev->dev,
 				 "Sense: key=0x%x asc=0x%x ascq=0x%x\n",
-				 sshdr.sense_key, sshdr.asc,
-				 sshdr.ascq);
+				 sshdr.sense_key,
+				 scsi_sense_asc(&sshdr),
+				 scsi_sense_ascq(&sshdr));
 		else
 			dev_warn(&adapter->pdev->dev,
 				 "Sense: Invalid sense data\n");
@@ -810,9 +810,8 @@ static bool leapraid_should_queuecommand(struct leapraid_adapter *adapter,
 	if (sdev_priv->block &&
 	    scsi_get_host_state(scmd->device->host) == SHOST_RECOVERY &&
 	    scmd->cmnd[0] == TEST_UNIT_READY) {
-		scsi_build_sense(scmd, 0, UNIT_ATTENTION,
-				 LEAPRAID_SCSI_ASC_POWER_ON_RESET,
-				 LEAPRAID_SCSI_ASCQ_POWER_ON_RESET);
+		scsi_set_sense(scmd, 0, UNIT_ATTENTION,
+			       I_T_NEXUS_LOSS_OCCURRED);
 		goto scsiio_done;
 	}
 
-- 
2.55.0

