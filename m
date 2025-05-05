Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E504631F046;
	Mon,  5 May 2025 22:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484336; cv=none; b=tpyY66o/4NlZcDn2C7iWKQFPLQd6fkQJEOMd9IkeZL2GUEBrt2qvk34tXM+JXSiubOVmoe41avKKlT1g58MD4+jWDpZkQ1wy4XL7kvOuVcGcezey3cFujU3HFrbzo84FVvzS1hlrsyAl/8JQhGruMvTD8T8u2Z7p2RW2lTJocs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484336; c=relaxed/simple;
	bh=GW8GjJC3/8EfUS8EwY5ifrWD4fvEkzOHrek+DRc3tvw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oMhi6pvK2tOYqujLXGs9ZX1WsMXRrYb8LzVK8y/aBj9mCr2s4PThZX3Jj7R+PR42DfE1DzVLVFG5ra1w9MXtyC+b2VxyGnrUGtyoBgGh5pB/qG7trYHfXD6Z/nZXT4DsDPzwOjqd1W6hddMXgYQPunJKUWIq+gTmg2G4TNsOK+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMC6aGjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMC6aGjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E16DC4CEE4;
	Mon,  5 May 2025 22:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484335;
	bh=GW8GjJC3/8EfUS8EwY5ifrWD4fvEkzOHrek+DRc3tvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMC6aGjOZUpe8L6nIgq+qLUCHlKyLp5HnFEdpiBVtgkDVgAAmztNJ7fMn7yyCcWjz
	 acoMS9SQChiILf9sJiL+f8c5h5SLwerBbYWzZ1likbxkh2tuqf3xW9Y/1GiI8SCJnf
	 KDgG7dXa4sB1FthuwAj6Qf9pRFRABLqn4IKkk/14XAMkak7mb0UFfafR8B6Yo/XmmL
	 SLtzU1U9ZPKYUUel0zHE817jIhnhaovswjTMJIn4YK4oOSSPqYGC9IgiCmAyCCYjl9
	 u7qHQ/oLNIiVoLYgoRv7apwlK8g/xWbQWP05tZc80nl1rvKFoNdtE9E6umRd6TvtbQ
	 +SKs6jfAzI3og==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	linux@armlinux.org.uk,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	stern@rowland.harvard.edu,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	snovitoll@gmail.com,
	jeff.johnson@oss.qualcomm.com,
	lihongbo22@huawei.com,
	viro@zeniv.linux.org.uk,
	djwong@kernel.org,
	axboe@kernel.dk,
	john.g.garry@oracle.com,
	jani.nikula@intel.com,
	rafael@kernel.org,
	christian.koenig@amd.com,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	megaraidlinux.pdl@broadcom.com,
	target-devel@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 457/642] scsi: usb: Rename the RESERVE and RELEASE constants
Date: Mon,  5 May 2025 18:11:13 -0400
Message-Id: <20250505221419.2672473-457-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 0ea163a18b17f9e0f8350bb348ae69c4a376be66 ]

The names RESERVE and RELEASE are not only used in <scsi/scsi_proto.h> but
also elsewhere in the kernel:

$ git grep -nHE 'define[[:blank:]]*(RESERVE|RELEASE)[[:blank:]]'
drivers/input/joystick/walkera0701.c:13:#define RESERVE 20000
drivers/s390/char/tape_std.h:56:#define RELEASE			0xD4	/* 3420 NOP, 3480 REJECT */
drivers/s390/char/tape_std.h:58:#define RESERVE			0xF4	/* 3420 NOP, 3480 REJECT */

Additionally, while the names of the symbolic constants RESERVE_10 and
RELEASE_10 include the command length, the command length is not included
in the RESERVE and RELEASE names. Address both issues by renaming the
RESERVE and RELEASE constants into RESERVE_6 and RELEASE_6 respectively.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250210205031.2970833-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/message/fusion/mptscsih.c            |  4 ++--
 drivers/scsi/aacraid/aachba.c                |  4 ++--
 drivers/scsi/arm/acornscsi.c                 |  2 +-
 drivers/scsi/ips.c                           |  8 ++++----
 drivers/scsi/megaraid.c                      | 10 +++++-----
 drivers/scsi/megaraid/megaraid_mbox.c        | 10 +++++-----
 drivers/target/target_core_device.c          |  8 ++++----
 drivers/target/target_core_pr.c              |  6 +++---
 drivers/target/target_core_spc.c             | 20 ++++++++++----------
 drivers/usb/gadget/function/f_mass_storage.c |  4 ++--
 drivers/usb/storage/debug.c                  |  4 ++--
 include/scsi/scsi_proto.h                    |  4 ++--
 include/trace/events/scsi.h                  |  4 ++--
 include/trace/events/target.h                |  4 ++--
 14 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index a9604ba3c8058..f0746db92ca61 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2915,14 +2915,14 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 		timeout = 10;
 		break;
 
-	case RESERVE:
+	case RESERVE_6:
 		cmdLen = 6;
 		dir = MPI_SCSIIO_CONTROL_READ;
 		CDB[0] = cmd;
 		timeout = 10;
 		break;
 
-	case RELEASE:
+	case RELEASE_6:
 		cmdLen = 6;
 		dir = MPI_SCSIIO_CONTROL_READ;
 		CDB[0] = cmd;
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index abf6a82b74af3..0be719f383770 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3221,8 +3221,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			break;
 		}
 		fallthrough;
-	case RESERVE:
-	case RELEASE:
+	case RESERVE_6:
+	case RELEASE_6:
 	case REZERO_UNIT:
 	case REASSIGN_BLOCKS:
 	case SEEK_10:
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index e50a3dbf9de3e..ef21b85cf0146 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -591,7 +591,7 @@ datadir_t acornscsi_datadirection(int command)
     case CHANGE_DEFINITION:	case COMPARE:		case COPY:
     case COPY_VERIFY:		case LOG_SELECT:	case MODE_SELECT:
     case MODE_SELECT_10:	case SEND_DIAGNOSTIC:	case WRITE_BUFFER:
-    case FORMAT_UNIT:		case REASSIGN_BLOCKS:	case RESERVE:
+    case FORMAT_UNIT:		case REASSIGN_BLOCKS:	case RESERVE_6:
     case SEARCH_EQUAL:		case SEARCH_HIGH:	case SEARCH_LOW:
     case WRITE_6:		case WRITE_10:		case WRITE_VERIFY:
     case UPDATE_BLOCK:		case WRITE_LONG:	case WRITE_SAME:
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index cce6c6b409ad5..94adb6ac02a4e 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3631,8 +3631,8 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 
 			break;
 
-		case RESERVE:
-		case RELEASE:
+		case RESERVE_6:
+		case RELEASE_6:
 			scb->scsi_cmd->result = DID_OK << 16;
 			break;
 
@@ -3899,8 +3899,8 @@ ips_chkstatus(ips_ha_t * ha, IPS_STATUS * pstatus)
 			case WRITE_6:
 			case READ_10:
 			case WRITE_10:
-			case RESERVE:
-			case RELEASE:
+			case RESERVE_6:
+			case RELEASE_6:
 				break;
 
 			case MODE_SENSE:
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index adab151663dd8..2006094af4189 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -855,8 +855,8 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			return scb;
 
 #if MEGA_HAVE_CLUSTERING
-		case RESERVE:
-		case RELEASE:
+		case RESERVE_6:
+		case RELEASE_6:
 
 			/*
 			 * Do we support clustering and is the support enabled
@@ -875,7 +875,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 			}
 
 			scb->raw_mbox[0] = MEGA_CLUSTER_CMD;
-			scb->raw_mbox[2] = ( *cmd->cmnd == RESERVE ) ?
+			scb->raw_mbox[2] = *cmd->cmnd == RESERVE_6 ?
 				MEGA_RESERVE_LD : MEGA_RELEASE_LD;
 
 			scb->raw_mbox[3] = ldrv_num;
@@ -1618,8 +1618,8 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 			 * failed or the input parameter is invalid
 			 */
 			if( status == 1 &&
-				(cmd->cmnd[0] == RESERVE ||
-					 cmd->cmnd[0] == RELEASE) ) {
+			    (cmd->cmnd[0] == RESERVE_6 ||
+			     cmd->cmnd[0] == RELEASE_6) ) {
 
 				cmd->result |= (DID_ERROR << 16) |
 					SAM_STAT_RESERVATION_CONFLICT;
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 60cc3372991fd..3ba837b3093f8 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1725,8 +1725,8 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 
 			return scb;
 
-		case RESERVE:
-		case RELEASE:
+		case RESERVE_6:
+		case RELEASE_6:
 			/*
 			 * Do we support clustering and is the support enabled
 			 */
@@ -1748,7 +1748,7 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			scb->dev_channel	= 0xFF;
 			scb->dev_target		= target;
 			ccb->raw_mbox[0]	= CLUSTER_CMD;
-			ccb->raw_mbox[2]	=  (scp->cmnd[0] == RESERVE) ?
+			ccb->raw_mbox[2]	= scp->cmnd[0] == RESERVE_6 ?
 						RESERVE_LD : RELEASE_LD;
 
 			ccb->raw_mbox[3]	= target;
@@ -2334,8 +2334,8 @@ megaraid_mbox_dpc(unsigned long devp)
 			 * Error code returned is 1 if Reserve or Release
 			 * failed or the input parameter is invalid
 			 */
-			if (status == 1 && (scp->cmnd[0] == RESERVE ||
-					 scp->cmnd[0] == RELEASE)) {
+			if (status == 1 && (scp->cmnd[0] == RESERVE_6 ||
+					    scp->cmnd[0] == RELEASE_6)) {
 
 				scp->result = DID_ERROR << 16 |
 					SAM_STAT_RESERVATION_CONFLICT;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index d1ae3df069a4f..cc2da086f96e2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1078,8 +1078,8 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	if (!dev->dev_attrib.emulate_pr &&
 	    ((cdb[0] == PERSISTENT_RESERVE_IN) ||
 	     (cdb[0] == PERSISTENT_RESERVE_OUT) ||
-	     (cdb[0] == RELEASE || cdb[0] == RELEASE_10) ||
-	     (cdb[0] == RESERVE || cdb[0] == RESERVE_10))) {
+	     (cdb[0] == RELEASE_6 || cdb[0] == RELEASE_10) ||
+	     (cdb[0] == RESERVE_6 || cdb[0] == RESERVE_10))) {
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -1101,7 +1101,7 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 			return target_cmd_size_check(cmd, size);
 		}
 
-		if (cdb[0] == RELEASE || cdb[0] == RELEASE_10) {
+		if (cdb[0] == RELEASE_6 || cdb[0] == RELEASE_10) {
 			cmd->execute_cmd = target_scsi2_reservation_release;
 			if (cdb[0] == RELEASE_10)
 				size = get_unaligned_be16(&cdb[7]);
@@ -1109,7 +1109,7 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 				size = cmd->data_length;
 			return target_cmd_size_check(cmd, size);
 		}
-		if (cdb[0] == RESERVE || cdb[0] == RESERVE_10) {
+		if (cdb[0] == RESERVE_6 || cdb[0] == RESERVE_10) {
 			cmd->execute_cmd = target_scsi2_reservation_reserve;
 			if (cdb[0] == RESERVE_10)
 				size = get_unaligned_be16(&cdb[7]);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 4f4ad6af416c8..34cf2c399b399 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -91,7 +91,7 @@ target_scsi2_reservation_check(struct se_cmd *cmd)
 
 	switch (cmd->t_task_cdb[0]) {
 	case INQUIRY:
-	case RELEASE:
+	case RELEASE_6:
 	case RELEASE_10:
 		return 0;
 	default:
@@ -418,12 +418,12 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 			return -EINVAL;
 		}
 		break;
-	case RELEASE:
+	case RELEASE_6:
 	case RELEASE_10:
 		/* Handled by CRH=1 in target_scsi2_reservation_release() */
 		ret = 0;
 		break;
-	case RESERVE:
+	case RESERVE_6:
 	case RESERVE_10:
 		/* Handled by CRH=1 in target_scsi2_reservation_reserve() */
 		ret = 0;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 61c065702350e..785a97536212b 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1674,9 +1674,9 @@ static bool tcm_is_pr_enabled(struct target_opcode_descriptor *descr,
 		return true;
 
 	switch (descr->opcode) {
-	case RESERVE:
+	case RESERVE_6:
 	case RESERVE_10:
-	case RELEASE:
+	case RELEASE_6:
 	case RELEASE_10:
 		/*
 		 * The pr_ops which are used by the backend modules don't
@@ -1828,9 +1828,9 @@ static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
 
 static struct target_opcode_descriptor tcm_opcode_release = {
 	.support = SCSI_SUPPORT_FULL,
-	.opcode = RELEASE,
+	.opcode = RELEASE_6,
 	.cdb_size = 6,
-	.usage_bits = {RELEASE, 0x00, 0x00, 0x00,
+	.usage_bits = {RELEASE_6, 0x00, 0x00, 0x00,
 		       0x00, SCSI_CONTROL_MASK},
 	.enabled = tcm_is_pr_enabled,
 };
@@ -1847,9 +1847,9 @@ static struct target_opcode_descriptor tcm_opcode_release10 = {
 
 static struct target_opcode_descriptor tcm_opcode_reserve = {
 	.support = SCSI_SUPPORT_FULL,
-	.opcode = RESERVE,
+	.opcode = RESERVE_6,
 	.cdb_size = 6,
-	.usage_bits = {RESERVE, 0x00, 0x00, 0x00,
+	.usage_bits = {RESERVE_6, 0x00, 0x00, 0x00,
 		       0x00, SCSI_CONTROL_MASK},
 	.enabled = tcm_is_pr_enabled,
 };
@@ -2267,9 +2267,9 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 	unsigned char *cdb = cmd->t_task_cdb;
 
 	switch (cdb[0]) {
-	case RESERVE:
+	case RESERVE_6:
 	case RESERVE_10:
-	case RELEASE:
+	case RELEASE_6:
 	case RELEASE_10:
 		if (!dev->dev_attrib.emulate_pr)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
@@ -2313,7 +2313,7 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		*size = get_unaligned_be32(&cdb[5]);
 		cmd->execute_cmd = target_scsi3_emulate_pr_out;
 		break;
-	case RELEASE:
+	case RELEASE_6:
 	case RELEASE_10:
 		if (cdb[0] == RELEASE_10)
 			*size = get_unaligned_be16(&cdb[7]);
@@ -2322,7 +2322,7 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 
 		cmd->execute_cmd = target_scsi2_reservation_release;
 		break;
-	case RESERVE:
+	case RESERVE_6:
 	case RESERVE_10:
 		/*
 		 * The SPC-2 RESERVE does not contain a size in the SCSI CDB.
diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 2eae8fc2e0db7..94d478b6bcd3d 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2142,8 +2142,8 @@ static int do_scsi_command(struct fsg_common *common)
 	 * of Posix locks.
 	 */
 	case FORMAT_UNIT:
-	case RELEASE:
-	case RESERVE:
+	case RELEASE_6:
+	case RESERVE_6:
 	case SEND_DIAGNOSTIC:
 
 	default:
diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index 576be66ad9627..dda610f689b73 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -58,8 +58,8 @@ void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb)
 	case INQUIRY: what = "INQUIRY"; break;
 	case RECOVER_BUFFERED_DATA: what = "RECOVER_BUFFERED_DATA"; break;
 	case MODE_SELECT: what = "MODE_SELECT"; break;
-	case RESERVE: what = "RESERVE"; break;
-	case RELEASE: what = "RELEASE"; break;
+	case RESERVE_6: what = "RESERVE"; break;
+	case RELEASE_6: what = "RELEASE"; break;
 	case COPY: what = "COPY"; break;
 	case ERASE: what = "ERASE"; break;
 	case MODE_SENSE: what = "MODE_SENSE"; break;
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 70e1262b2e202..aeca37816506d 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -33,8 +33,8 @@
 #define INQUIRY               0x12
 #define RECOVER_BUFFERED_DATA 0x14
 #define MODE_SELECT           0x15
-#define RESERVE               0x16
-#define RELEASE               0x17
+#define RESERVE_6             0x16
+#define RELEASE_6             0x17
 #define COPY                  0x18
 #define ERASE                 0x19
 #define MODE_SENSE            0x1a
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 05f1945ed204e..bf6cc98d91228 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -29,8 +29,8 @@
 		scsi_opcode_name(INQUIRY),			\
 		scsi_opcode_name(RECOVER_BUFFERED_DATA),	\
 		scsi_opcode_name(MODE_SELECT),			\
-		scsi_opcode_name(RESERVE),			\
-		scsi_opcode_name(RELEASE),			\
+		scsi_opcode_name(RESERVE_6),			\
+		scsi_opcode_name(RELEASE_6),			\
 		scsi_opcode_name(COPY),				\
 		scsi_opcode_name(ERASE),			\
 		scsi_opcode_name(MODE_SENSE),			\
diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index a13cbf2b34050..7e2e20ba26f1c 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -31,8 +31,8 @@
 		scsi_opcode_name(INQUIRY),			\
 		scsi_opcode_name(RECOVER_BUFFERED_DATA),	\
 		scsi_opcode_name(MODE_SELECT),			\
-		scsi_opcode_name(RESERVE),			\
-		scsi_opcode_name(RELEASE),			\
+		scsi_opcode_name(RESERVE_6),			\
+		scsi_opcode_name(RELEASE_6),			\
 		scsi_opcode_name(COPY),				\
 		scsi_opcode_name(ERASE),			\
 		scsi_opcode_name(MODE_SENSE),			\
-- 
2.39.5

