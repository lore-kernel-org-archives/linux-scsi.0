Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8A0381B16;
	Thu,  3 Sep 2026 03:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406982; cv=none; b=p+FDxBn+cXJnpP1AAHJcH/Amd8Kw6gklttoT/jDEv39xom7XE9TTsls9kKkTWdsPIDysr5fIob12tqm/K2RF8YwP+thazaJrA2JisNFifpxmIHUMacKOExYlpR5ZI06/Noa/Y09Su6N7rQug04EnNW9xzaCPbSSVzHYeZIpwVi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406982; c=relaxed/simple;
	bh=H31+A0a1h0ple4dfxQMUPgiknPak4lFpsoee9BJaTtA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzZn1WGXeyAU0bXT5HR2IWVPF/G5s1VGXS3hLlxaeysnZ0IkZcuuzg8q11c2OSvjOx8Ji5Sfr2gMZ5DDcWCyYrb8Ip4NTcuPCaK3zfYQGUHCtDXp0+N0Sx81kYTT4VXOUjScTBeJbQEvOLor3anv+IVTpI+0LwOYv1jH9TQinmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DN3kl9Mi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DN3kl9Mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47D71F000E9;
	Thu,  3 Sep 2026 03:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406968;
	bh=L2o+vV5QIcEnfz0SgO204mXEmF7u6l5dqI8aO79lbHM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=DN3kl9MizOmSBHOrVEvMDB36UBK0vygpvTJ+psvldpV0huEOaT44an1jKA5TIfEgo
	 8DAoUF5GQjpOoFgfCxbQEKNZo6MPL1BsUwmNXEKoRngn3Ltx/fhIb8hTdMslw6YYVh
	 ysSTB3JIF5jTCf9PclzaU7bdPi3q4nWHC/+xiZ3U6Foucr6Lpleaz/0ni71muqHJ/1
	 nWJh9Y16E6tnuErMpfO7JBzQ+gN568b1kKxVxAMKVXAyQI4hegEPKOPqXWxBQuoEtD
	 1bL7igWtAFRp6a6ejNWrRap/3ESMqoQOJGXHVmNGCIJB4Cp3dy/mw4Upm2WLwXw4k4
	 O94EoRmA4VcnQ==
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
Subject: [PATCH v2 18/40] scsi: mpi3mr: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:39 +0900
Message-ID: <20260903034201.112211-19-dlemoal@kernel.org>
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

Refactor the mpi3mr driver to use the 16-bits sense_code field of struct
scsi_sense_hdr and replace all hard-coded additional sense codes and
additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c |  3 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 50 +++++++++++++++++----------------
 2 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 681868716ebd..ae4b531f3e37 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -404,7 +404,8 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 				scsi_normalize_sense(sense_buf, sense_count,
 				    &sshdr);
 				mpi3mr_scsisense_trigger(mrioc, sshdr.sense_key,
-				    sshdr.asc, sshdr.ascq);
+						scsi_sense_asc(&sshdr),
+						scsi_sense_ascq(&sshdr));
 			}
 		}
 		mpi3mr_reply_trigger(mrioc, masked_ioc_status, ioc_loginfo);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f80a21ec161b..274af456b9c0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3304,8 +3304,7 @@ static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
  * @desc: Sense type
  * @buf: Sense buffer to populate
  * @key: Sense key
- * @asc: Additional sense code
- * @ascq: Additional sense code qualifier
+ * @code: Additional sense code and its qualifier
  *
  * Maps the given sense information into either descriptor or
  * fixed format sense data.
@@ -3313,20 +3312,20 @@ static void mpi3mr_setup_eedp(struct mpi3mr_ioc *mrioc,
  * Return: Nothing
  */
 static inline void mpi3mr_build_sense_buffer(int desc, u8 *buf, u8 key,
-	u8 asc, u8 ascq)
+					     u16 code)
 {
 	if (desc) {
 		buf[0] = 0x72;	/* descriptor, current */
 		buf[1] = key;
-		buf[2] = asc;
-		buf[3] = ascq;
+		buf[2] = scsi_sense_code_asc(code);
+		buf[3] = scsi_sense_code_ascq(code);
 		buf[7] = 0;
 	} else {
 		buf[0] = 0x70;	/* fixed, current */
 		buf[2] = key;
 		buf[7] = 0xa;
-		buf[12] = asc;
-		buf[13] = ascq;
+		buf[12] = scsi_sense_code_asc(code);
+		buf[13] = scsi_sense_code_ascq(code);
 	}
 }
 
@@ -3343,25 +3342,25 @@ static inline void mpi3mr_build_sense_buffer(int desc, u8 *buf, u8 key,
 static void mpi3mr_map_eedp_error(struct scsi_cmnd *scmd,
 	u16 ioc_status)
 {
-	u8 ascq = 0;
+	u16 sense_code;
 
 	switch (ioc_status) {
 	case MPI3_IOCSTATUS_EEDP_GUARD_ERROR:
-		ascq = 0x01;
+		sense_code = LOGICAL_BLOCK_GUARD_CHECK_FAILED;
 		break;
 	case MPI3_IOCSTATUS_EEDP_APP_TAG_ERROR:
-		ascq = 0x02;
+		sense_code = LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED;
 		break;
 	case MPI3_IOCSTATUS_EEDP_REF_TAG_ERROR:
-		ascq = 0x03;
+		sense_code = LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED;
 		break;
 	default:
-		ascq = 0x00;
+		sense_code = ID_CRC_OR_ECC_ERROR;
 		break;
 	}
 
 	mpi3mr_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
-	    0x10, ascq);
+				  sense_code);
 	scmd->result = (DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
 }
 
@@ -3446,7 +3445,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		if (sense_buf) {
 			scsi_normalize_sense(sense_buf, sense_count, &sshdr);
 			mpi3mr_scsisense_trigger(mrioc, sshdr.sense_key,
-			    sshdr.asc, sshdr.ascq);
+						 scsi_sense_asc(&sshdr),
+						 scsi_sense_ascq(&sshdr));
 		}
 		mpi3mr_reply_trigger(mrioc, ioc_status, ioc_loginfo);
 		break;
@@ -3633,7 +3633,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 			ioc_info(mrioc,
 			    "%s :sense_count 0x%x, sense_key 0x%x ASC 0x%x, ASCQ 0x%x\n",
 			    __func__, sense_count, sshdr.sense_key,
-			    sshdr.asc, sshdr.ascq);
+			    scsi_sense_asc(&sshdr),
+			    scsi_sense_ascq(&sshdr));
 		}
 	}
 out_success:
@@ -5040,8 +5041,8 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 		    __func__, param_len);
 		scsi_print_command(scmd);
 		scmd->result = SAM_STAT_CHECK_CONDITION;
-		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
-		    0x1A, 0);
+		scsi_set_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
+				      PARAMETER_LIST_LENGTH_ERROR);
 		scsi_done(scmd);
 		return true;
 	}
@@ -5051,8 +5052,8 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 		    __func__, param_len, scsi_bufflen(scmd));
 		scsi_print_command(scmd);
 		scmd->result = SAM_STAT_CHECK_CONDITION;
-		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
-		    0x1A, 0);
+		scsi_set_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
+				      PARAMETER_LIST_LENGTH_ERROR);
 		scsi_done(scmd);
 		return true;
 	}
@@ -5060,8 +5061,8 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 	if (!buf) {
 		scsi_print_command(scmd);
 		scmd->result = SAM_STAT_CHECK_CONDITION;
-		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
-		    0x55, 0x03);
+		scsi_set_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
+				      INSUFFICIENT_RESOURCES);
 		scsi_done(scmd);
 		return true;
 	}
@@ -5074,8 +5075,8 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 		    __func__, desc_len);
 		scsi_print_command(scmd);
 		scmd->result = SAM_STAT_CHECK_CONDITION;
-		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
-		    0x26, 0);
+		scsi_set_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
+				      INVALID_FIELD_IN_PARAMETER_LIST);
 		scsi_done(scmd);
 		kfree(buf);
 		return true;
@@ -5175,7 +5176,8 @@ static enum scsi_qc_status mpi3mr_qcmd(struct Scsi_Host *shost,
 	if (scsi_get_host_state(scmd->device->host) == SHOST_RECOVERY &&
 		scmd->cmnd[0] == TEST_UNIT_READY &&
 		(stgt_priv_data->dev_removed || (dev_handle == MPI3MR_INVALID_DEV_HANDLE))) {
-		scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
+		scsi_set_sense(scmd, 0, UNIT_ATTENTION,
+			       I_T_NEXUS_LOSS_OCCURRED);
 		scsi_done(scmd);
 		goto out;
 	}
-- 
2.55.0

