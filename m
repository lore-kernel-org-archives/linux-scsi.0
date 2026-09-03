Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E10380FF4;
	Thu,  3 Sep 2026 03:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406977; cv=none; b=XqyCOPx/uq9KATnM2swx7vXC9IVCnAEGMRPp1KB11A6gHjFihzads30jgz9oiVSULbYAP2XQFALfsFwEVxJLDMPqqw9YLCL2V1U+2p/I9q7pUEmn7bY783WvElgHTgU4CoD04ErCV08ejqB3jJHqBKPLLTYNZTsS90yJjbwB+cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406977; c=relaxed/simple;
	bh=ZyOXQptz0p5l+iyHI5XdEOcqmdDKfWxADNxBtffX8qo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDLs703bSVllhxMjaqzthXkNxwNQ02agEhYV6PoiMdK2l4KAt/8IHQanb89mdswhwOHE+k46VfwceJlKYGAP+qwaplEapIQrN89HA9e8ixYrQ9LO+wma1IGdy1ikkL6chPycib8xvOfdKjywLxjnLxZKFPM3jJ61FBLG7YF7LNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnAzGFsU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnAzGFsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506EF1F00ACA;
	Thu,  3 Sep 2026 03:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406971;
	bh=2uTKqVtr9TqKiLuWOiaCIa15/bYjH1syNv9wiGf3MbY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=BnAzGFsUMxSyEJyEcyZn1L/Sjrl2YYRKiM9eEwR0eVXPKdrX0SQenQ1SqdTshfapW
	 LFjp/7IyyBkDEkW80/AlDL4AVWl68KLh8956F5ASQ43Y9wqAcX9lRlEQwjHYkWc1Iw
	 VMKTqOrr9PPAK788RPKFLndQYz4vK1MD6neEsUVU8IpyIGOPdnZGur6MslLl6R+5U9
	 Rk+8ikOmYfiWa4JjJ+C4vDKzJ+jGjE0xQLgTJgNfFGDtPS11Nzty0GNcjjrdlPsgci
	 aLQT7HZ4kv4b/3yjiSfY6Oa4RY6J7rkrEg22U7LeVvkrtjYpthNTnkEAQVpaRS92Io
	 jmNjrdeEgzZYA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 20/40] scsi: leapraid: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:41 +0900
Message-ID: <20260903034201.112211-21-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
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

