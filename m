Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413B64C8F
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 05:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749187769; cv=none; b=souGdER86vu8Be4QFMIhVBRGOfcc3+BdN5Wjrhs5/Era5XzNn6+187MPfD+76g1j2Exrw6eEDrgoqEwfKovWuthq4izs7e7hBBcoDV+UlZKsqneUS9UhH7troAR8N0dNhZe33EG9boNzPZOh/Bl5ItXlLHsXqLYh9gkLMLToJ3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749187769; c=relaxed/simple;
	bh=0DJyDFnQu+oiGLeYg+wuio4g7xnAAE/jyQEuQ8LHk9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5lKepITHG3UBnFQ2xLVNwGAn0TKIRPW0HSbCIg5jkPytlXNTcEyDuc95KDQK7vAGsH/UcsbwkK2q9CgaN4khAEeROxQNjz1S8NqJ1Cz3IjkVLuvZ2d8CELlRTh1bMDkLd9ETfkSh47GxAFlnqFi6kd9UcwRX1hz+k46K9uDuGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X9pFzcyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9pFzcyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8604C4CEEF;
	Fri,  6 Jun 2025 05:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749187768;
	bh=0DJyDFnQu+oiGLeYg+wuio4g7xnAAE/jyQEuQ8LHk9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9pFzcydZAMkTPVV2F3o8DKAQEt0Ndx7eUn9/U9l9tbjDyhqoJ1JjY4gX0otRea5U
	 vNaa99z1LkOxJZ52mpDXmu81YNW1faFwjxtwwgHwiQ3oUAywaJF2kxHpsTrLj6NXbU
	 azFiMqRncjUWjGbPRMotShgxVgLsz9K1Wgybm3mgiDfldfQo19kFL1nQHp5PXXksX6
	 q6mmW7/nIXslSeZe8oG0xXGIr2xmOq7dHWznmO5fdNvQ+26vJk/9KzCaPrkXYosteY
	 7UrwI3g5iPf4eGjscFr+aiWrBKlJwguCwh409bNpVFOkxl2MkBF3KwFA/HYB2u2AoN
	 aHak3fOS+Yk9A==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 1/2] scsi: mpi3mr: Correctly handle ATA device errors
Date: Fri,  6 Jun 2025 14:27:46 +0900
Message-ID: <20250606052747.742998-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250606052747.742998-1-dlemoal@kernel.org>
References: <20250606052747.742998-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the ATA error model, an NCQ command failure always triggers an
abort (termination) of all NCQ commands queued on the device. In such
case, the SAT or the host must handle the failed command according to
the command sense data and immediately retry all other NCQ commands that
were aborted due to the failed NCQ command.

For SAS HBAs controlled by the mpi3mr driver, NCQ command aborts are not
handled by the HBA SAT and sent back to the host, with an ioc log
information equal to 0x31080000 (IOC_LOGINFO_PREFIX_PL with the PL code
PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR). The function
mpi3mr_process_op_reply_desc() always forces a retry of commands
terminated with the status MPI3_IOCSTATUS_SCSI_IOC_TERMINATED using the
SCSI result DID_SOFT_ERROR, regardless of the ioc_loginfo for the
command. This correctly forces the retry of collateral NCQ abort
commands, but with the retry counter for the command being incremented.
If a command to an ATA device is subject to too many retries due to
other NCQ commands failing (e.g. read commands trying to access
unreadable sectors), the collateral NCQ abort commands may be terminated
with an error as they run out of retries. This violates the SAT
specifications and causes hard-to-debug command errors.

Solve this issue by modifying the handling of the
MPI3_IOCSTATUS_SCSI_IOC_TERMINATED status to check if a command is for
an ATA device and if the command ioc_loginfo indicates an NCQ collateral
abort. If that is the case, force the command retry using the
SCSI result DID_IMM_RETRY to avoid incrementing the command retry count.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ce444efd859e..87983ea4e06e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -49,6 +49,13 @@ static void mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
 
 #define MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH	(0xFFFE)
 
+/*
+ * SAS Log info code for a NCQ collateral abort after an NCQ error:
+ * IOC_LOGINFO_PREFIX_PL | PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR
+ * See: drivers/message/fusion/lsi/mpi_log_sas.h
+ */
+#define IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR	0x31080000
+
 /**
  * mpi3mr_host_tag_for_scmd - Get host tag for a scmd
  * @mrioc: Adapter instance reference
@@ -3430,7 +3437,18 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		scmd->result = DID_NO_CONNECT << 16;
 		break;
 	case MPI3_IOCSTATUS_SCSI_IOC_TERMINATED:
-		scmd->result = DID_SOFT_ERROR << 16;
+		if (ioc_loginfo == IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR) {
+			/*
+			 * This is a ATA NCQ command aborted due to another NCQ
+			 * command failure. We must retry this command
+			 * immediately but without incrementing its retry
+			 * counter.
+			 */
+			WARN_ON_ONCE(xfer_count != 0);
+			scmd->result = DID_IMM_RETRY << 16;
+		} else {
+			scmd->result = DID_SOFT_ERROR << 16;
+		}
 		break;
 	case MPI3_IOCSTATUS_SCSI_TASK_TERMINATED:
 	case MPI3_IOCSTATUS_SCSI_EXT_TERMINATED:
-- 
2.49.0

