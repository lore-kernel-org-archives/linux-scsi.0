Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707764C8F
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 05:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749187770; cv=none; b=lyjfdL0IRy+ib+cYU85YMY+XHMUgamV+X/mFO1QjFCerGmEvC8U7H1IPwcJTUmuksnSHw3o9bGop4yGaAR7FHP4XsTwjl/xYmFUYHchNECH+5ppTLKUDbW8wq8Yvr8VZawSKBDrlJxnX2ZEyPBbyd1M/n93370kjcyQ120f+d4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749187770; c=relaxed/simple;
	bh=k0JMqT/nlcLP5cnzOZDRY+vD7honjl7gbosuRfPAtLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrKGj4n8QW4QKEMBNjjR0po/viTy45uncVgW08JGPkgtK3RrpN74hfp01jqmvfIhZYPzDEF5N/p/70hiXEqFIkq08t32FlqJqcTweXmjUhoN7P2N2uFIy6aw8FYr+xDKjKj+3w0/floi/moSOnHGTGgzQEJTo7lQSJ07/m7oH/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s2kQtbxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2kQtbxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CE3C4CEF1;
	Fri,  6 Jun 2025 05:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749187770;
	bh=k0JMqT/nlcLP5cnzOZDRY+vD7honjl7gbosuRfPAtLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2kQtbxUIc0NBLoLNeafQnmcKLNkO32unio73u6F5igZWqO7LjswuuXiXt5uuoh1v
	 0uoKOZQ4MI3Bo5SmrGMxaEKNi45w7kTveQUFUxJGvFl76tUkHxUggp+aR8jzsEG4wF
	 yajskWXavCpZVpdpuJtARB5f8ZEhDnMFdKcaVUcAORPml2+7MPpY3eu4iqq6nJLTFz
	 1+XYxJt8FA1uKyp1BFmC4aMBDAFYRs7+UW9ocAa7xgUdJ5FrNPElJ19f9qMhCUOTLj
	 zhZXU42CGvF3JbSOGT8Ktemd8nxSVJD1WB0xVzN23Koeb/FyqhCq/Yz+sjo6lE20hF
	 V4X7SLwX+NaLw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 2/2] scsi: mpt3sas: Correctly handle ATA device errors
Date: Fri,  6 Jun 2025 14:27:47 +0900
Message-ID: <20250606052747.742998-3-dlemoal@kernel.org>
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

For SAS HBAs controlled by the mpt3sas driver, NCQ command aborts are
not handled by the HBA SAT and sent back to the host, with an ioc log
information equal to 0x31080000 (IOC_LOGINFO_PREFIX_PL with the PL code
PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR). The function
_scsih_io_done() always forces a retry of commands terminated with the
status MPI2_IOCSTATUS_SCSI_IOC_TERMINATED using the SCSI result
DID_SOFT_ERROR, regardless of the log_info for the command.
This correctly forces the retry of collateral NCQ abort commands, but
with the retry counter for the command being incremented. If a command
to an ATA device is subject to too many retries due to other NCQ
commands failing (e.g. read commands trying to access unreadable
sectors), the collateral NCQ abort commands may be terminated with an
error as they run out of retries. This violates the SAT specifications
and causes hard-to-debug command errors.

Solve this issue by modifying the handling of the
MPI2_IOCSTATUS_SCSI_IOC_TERMINATED status to check if a command is for
an ATA device and if the command loginfo indicates an NCQ collateral
abort. If that is the case, force the command retry using the
SCSI result DID_IMM_RETRY to avoid incrementing the command retry count.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 508861e88d9f..d7d8244dfedc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -195,6 +195,14 @@ struct sense_info {
 #define MPT3SAS_PORT_ENABLE_COMPLETE (0xFFFD)
 #define MPT3SAS_ABRT_TASK_SET (0xFFFE)
 #define MPT3SAS_REMOVE_UNRESPONDING_DEVICES (0xFFFF)
+
+/*
+ * SAS Log info code for a NCQ collateral abort after an NCQ error:
+ * IOC_LOGINFO_PREFIX_PL | PL_LOGINFO_CODE_SATA_NCQ_FAIL_ALL_CMDS_AFTR_ERR
+ * See: drivers/message/fusion/lsi/mpi_log_sas.h
+ */
+#define IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR	0x31080000
+
 /**
  * struct fw_event_work - firmware event struct
  * @list: link list framework
@@ -5814,6 +5822,17 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			goto out;
 		}
+		if (log_info == IOC_LOGINFO_SATA_NCQ_FAIL_AFTER_ERR) {
+			/*
+			 * This is a ATA NCQ command aborted due to another NCQ
+			 * command failure. We must retry this command
+			 * immediately but without incrementing its retry
+			 * counter.
+			 */
+			WARN_ON_ONCE(xfer_cnt != 0);
+			scmd->result = DID_IMM_RETRY << 16;
+			break;
+		}
 		if (log_info == 0x31110630) {
 			if (scmd->retries > 2) {
 				scmd->result = DID_NO_CONNECT << 16;
-- 
2.49.0

