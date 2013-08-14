From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Wed, 14 Aug 2013 15:44:31 -0400
Message-ID: <yq1eh9wgiqo.fsf@sermon.lab.mkp.net>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com>
	<yq1zjskgn1x.fsf@sermon.lab.mkp.net>
	<D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46466 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760426Ab3HNTol (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2013 15:44:41 -0400
In-Reply-To: <D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com> (Ben
	Collins's message of "Wed, 14 Aug 2013 15:30:44 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <ben.c@servergy.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, aradford@gmail.com

>>>>> "Ben" == Ben Collins <ben.c@servergy.com> writes:

Ben> You're the man. Forward ported this to 3.11-rc code base. Worked
Ben> like a charm.

Heh, you just beat me to it :)

Formatting differences aside there were a few glitches, however. I
outlined them below...

Btw. the reason I did cpu_to_le16(0) etc. was mostly to annotate the
endian-sensitive parameters in case somebody changes them in the future.

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 7bf9c5c..154e9e1 100644
@@ -1170,7 +1170,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	 * Construct SGL
 	 */
 	if (instance->flag_ieee == 1) {
-		flags |= MFI_FRAME_SGL64;
+		flags |= MFI_FRAME_SGL64 | MFI_FRAME_IEEE;
 		pthru->sge_count = megasas_make_sgl_skinny(instance, scp,
 						      &pthru->sgl);
 	} else if (IS_DMA64) {
@@ -1328,8 +1328,10 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	 * Sense info specific
 	 */
 	ldio->sense_len = SCSI_SENSE_BUFFERSIZE;
-	ldio->sense_buf_phys_addr_hi = 0;
-	ldio->sense_buf_phys_addr_lo = cmd->sense_phys_addr;
+	ldio->sense_buf_phys_addr_hi =
+		cpu_to_le32(upper_32_bits(cmd->sense_phys_addr));
+	ldio->sense_buf_phys_addr_lo =
+		cpu_to_le32(lower_32_bits(cmd->sense_phys_addr));
 
 	/*
 	 * Compute the total number of frames this command consumes. FW uses
@@ -3944,14 +3945,15 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 	dcmd->sge_count = 1;
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
 	dcmd->timeout = cpu_to_le16(0);
-	dcmd->pad_0 = cpu_to_le16(0);
+	dcmd->pad_0 = 0;
 	instance->last_seq_num = seq_num;
 	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct megasas_evt_detail));
 	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_EVENT_WAIT);
-	dcmd->mbox.w[0] = seq_num;
-	dcmd->mbox.w[1] = curr_aen.word;
+	dcmd->mbox.w[0] = cpu_to_le32(seq_num);
+	dcmd->mbox.w[1] = cpu_to_le32(curr_aen.word);
 	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(instance->evt_detail_h);
-	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct megasas_evt_detail));
+	dcmd->sgl.sge32[0].length =
+		cpu_to_le32(sizeof(struct megasas_evt_detail));
 
 	if (instance->aen_cmd != NULL) {
 		megasas_return_cmd(instance, cmd);
@@ -5358,9 +5360,9 @@ megasas_aen_polling(struct work_struct *work)
 	}
 	instance->ev = NULL;
 	host = instance->host;
-	if (le32_to_cpu(instance->evt_detail)) {
+	if (instance->evt_detail) {
 
-		switch (instance->evt_detail->code) {
+		switch (le32_to_cpu(instance->evt_detail->code)) {
 		case MR_EVT_PD_INSERTED:
 			if (megasas_get_pd_list(instance) == 0) {
 			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {

