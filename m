Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705F32D8385;
	Mon,  7 Sep 2026 02:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749091; cv=none; b=EsaoHdZleNncoWCM4u9gC/dk6z9ikg6jktESefqCjggYGKwhTlpsrFn7mcW/WkxwUKLBo6e0dcgYGXXZS/O7u2xIoIsYHhZgz8D0/3O4VdU79BTSwtkVRoYzL+SXCWGmo2SzqBpOgGIUQAE4NRptp1P971+5ZZegPVd9XNo36KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749091; c=relaxed/simple;
	bh=JisUTP7ezwEBgdazW6wegi5wYqba5Kk1BAyZgnCv43A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f38NUb0vBH+zdKpJgP7g/yXu5bHPFAH3//wYUUgySX9njHw7eiKO8nvVFaN3lwvO8VXuONxusoFLWGkYTzXd4tf5KUFdaOA4upOUtMUSOIEJ3xD88+ittyxeaZAOUDHAxbLK1TmURlYyTkGtk72yTULVmpqn17RmqhJDbRFD+Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kltllkkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kltllkkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AB71F00A3E;
	Mon,  7 Sep 2026 02:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749090;
	bh=orsiKtqpPXuKdHSBEufYlWL8TusHNlkQmAJxHp9f26E=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=kltllkktalCt0DfFwq0uZYCDCaBjCzC/uMuJBMx+4XxoMcxdpQjAqBy/ZrBd86e2v
	 uVoQCr6K30yw0DR5ZcgamOT2uROJe+2km1a19oudWABM87LCahEr0hmsWX2c9uH8sE
	 EvV+6+GojN9A2I2JJttykePwTfdu8OqYalmRAwhjC5/q9oVzYg4Ltmr0eZ/oD+Y9dV
	 g+9LVXV6QYp5TNuaZlD/7ypg+5+9MVXIDmVadlDQNDG/NcsIXzsyuFN6wJc4H/ri5/
	 6nR5DviqKLXINeQrIw/4TBQLnXMAvTbAayNAVMnO3BdmZYRkfN2n2TT66Y7kdgqy3M
	 9NCittKD3R68g==
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
Subject: [PATCH v5 35/40] usb: storage: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:38 +0900
Message-ID: <20260907024343.1046387-36-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the USB mass storage driver to replace all hard-coded additional
sense codes and additional sense code qualifiers with the enum values
defined in include/scsi/scsi_sense.h. This helps with code clarity as the
sense codes being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 34 +++++-----
 drivers/usb/gadget/function/storage_common.h | 71 +++++++++++++++-----
 drivers/usb/storage/transport.c              |  5 +-
 3 files changed, 74 insertions(+), 36 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index a50743caf083..05e138968389 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -1103,9 +1103,9 @@ static int do_request_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 	 * FSG normally uses option a); enable this code to use option b).
 	 */
 #if 0
-	if (curlun && curlun->unit_attention_data != SS_NO_SENSE) {
+	if (curlun && curlun->unit_attention_data != NO_SENSE) {
 		curlun->sense_data = curlun->unit_attention_data;
-		curlun->unit_attention_data = SS_NO_SENSE;
+		curlun->unit_attention_data = NO_SENSE;
 	}
 #endif
 
@@ -1118,18 +1118,18 @@ static int do_request_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 		sd = curlun->sense_data;
 		sdinfo = curlun->sense_data_info;
 		valid = curlun->info_valid << 7;
-		curlun->sense_data = SS_NO_SENSE;
+		curlun->sense_data = NO_SENSE;
 		curlun->sense_data_info = 0;
 		curlun->info_valid = 0;
 	}
 
 	memset(buf, 0, 18);
 	buf[0] = valid | 0x70;			/* Valid, current error */
-	buf[2] = SK(sd);
+	buf[2] = usb_sense_key(sd);
 	put_unaligned_be32(sdinfo, &buf[3]);	/* Sense information */
 	buf[7] = 18 - 8;			/* Additional sense length */
-	buf[12] = ASC(sd);
-	buf[13] = ASCQ(sd);
+	buf[12] = usb_sense_asc(sd);
+	buf[13] = usb_sense_ascq(sd);
 	return 18;
 }
 
@@ -1678,21 +1678,23 @@ static void send_status(struct fsg_common *common)
 	if (curlun) {
 		sd = curlun->sense_data;
 		sdinfo = curlun->sense_data_info;
-	} else if (common->bad_lun_okay)
-		sd = SS_NO_SENSE;
-	else
+	} else if (common->bad_lun_okay) {
+		sd = NO_SENSE;
+	} else {
 		sd = SS_LOGICAL_UNIT_NOT_SUPPORTED;
+	}
 
 	if (common->phase_error) {
 		DBG(common, "sending phase-error status\n");
 		status = US_BULK_STAT_PHASE;
 		sd = SS_INVALID_COMMAND;
-	} else if (sd != SS_NO_SENSE) {
+	} else if (sd != NO_SENSE) {
 		DBG(common, "sending command-failure status\n");
 		status = US_BULK_STAT_FAIL;
 		VDBG(common, "  sense data: SK x%02x, ASC x%02x, ASCQ x%02x;"
 				"  info x%x\n",
-				SK(sd), ASC(sd), ASCQ(sd), sdinfo);
+		     usb_sense_key(sd), usb_sense_asc(sd),
+		     usb_sense_ascq(sd), sdinfo);
 	}
 
 	/* Store and send the Bulk-only CSW */
@@ -1798,7 +1800,7 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 	curlun = common->curlun;
 	if (curlun) {
 		if (common->cmnd[0] != REQUEST_SENSE) {
-			curlun->sense_data = SS_NO_SENSE;
+			curlun->sense_data = NO_SENSE;
 			curlun->sense_data_info = 0;
 			curlun->info_valid = 0;
 		}
@@ -1820,11 +1822,11 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 	 * If a unit attention condition exists, only INQUIRY and
 	 * REQUEST SENSE commands are allowed; anything else must fail.
 	 */
-	if (curlun && curlun->unit_attention_data != SS_NO_SENSE &&
+	if (curlun && curlun->unit_attention_data != NO_SENSE &&
 	    common->cmnd[0] != INQUIRY &&
 	    common->cmnd[0] != REQUEST_SENSE) {
 		curlun->sense_data = curlun->unit_attention_data;
-		curlun->unit_attention_data = SS_NO_SENSE;
+		curlun->unit_attention_data = NO_SENSE;
 		return -EINVAL;
 	}
 
@@ -2501,8 +2503,8 @@ static void handle_exception(struct fsg_common *common)
 			if (!curlun)
 				continue;
 			curlun->prevent_medium_removal = 0;
-			curlun->sense_data = SS_NO_SENSE;
-			curlun->unit_attention_data = SS_NO_SENSE;
+			curlun->sense_data = NO_SENSE;
+			curlun->unit_attention_data = NO_SENSE;
 			curlun->sense_data_info = 0;
 			curlun->info_valid = 0;
 		}
diff --git a/drivers/usb/gadget/function/storage_common.h b/drivers/usb/gadget/function/storage_common.h
index 11ac785d5eee..e73a30cc553f 100644
--- a/drivers/usb/gadget/function/storage_common.h
+++ b/drivers/usb/gadget/function/storage_common.h
@@ -70,24 +70,59 @@ do {									\
 #define MAX_COMMAND_SIZE	16
 
 /* SCSI Sense Key/Additional Sense Code/ASC Qualifier values */
-#define SS_NO_SENSE				0
-#define SS_COMMUNICATION_FAILURE		0x040800
-#define SS_INVALID_COMMAND			0x052000
-#define SS_INVALID_FIELD_IN_CDB			0x052400
-#define SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE	0x052100
-#define SS_LOGICAL_UNIT_NOT_SUPPORTED		0x052500
-#define SS_MEDIUM_NOT_PRESENT			0x023a00
-#define SS_MEDIUM_REMOVAL_PREVENTED		0x055302
-#define SS_NOT_READY_TO_READY_TRANSITION	0x062800
-#define SS_RESET_OCCURRED			0x062900
-#define SS_SAVING_PARAMETERS_NOT_SUPPORTED	0x053900
-#define SS_UNRECOVERED_READ_ERROR		0x031100
-#define SS_WRITE_ERROR				0x030c02
-#define SS_WRITE_PROTECTED			0x072700
-
-#define SK(x)		((u8) ((x) >> 16))	/* Sense Key byte, etc. */
-#define ASC(x)		((u8) ((x) >> 8))
-#define ASCQ(x)		((u8) (x))
+static inline u32 usb_sense_kc(u8 sense_key, u16 sense_code)
+{
+	return ((u32)sense_key << 16) | (u32)sense_code;
+}
+
+static inline u8 usb_sense_key(u32 kc)
+{
+	return kc >> 16;
+}
+
+static inline u16 usb_sense_code(u32 kc)
+{
+	return kc & 0xFFFF;
+}
+
+static inline u8 usb_sense_asc(u32 kc)
+{
+	return scsi_sense_code_asc(usb_sense_code(kc));
+}
+
+static inline u8 usb_sense_ascq(u32 kc)
+{
+	return scsi_sense_code_ascq(usb_sense_code(kc));
+}
+
+#define SS_COMMUNICATION_FAILURE		\
+	usb_sense_kc(HARDWARE_ERROR, LU_COMMUNICATION_FAILURE)
+#define SS_INVALID_COMMAND			\
+	usb_sense_kc(ILLEGAL_REQUEST, INVALID_COMMAND_OP_CODE)
+#define SS_INVALID_FIELD_IN_CDB			\
+	usb_sense_kc(ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB)
+#define SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE	\
+	usb_sense_kc(ILLEGAL_REQUEST, LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE)
+#define SS_LOGICAL_UNIT_NOT_SUPPORTED		\
+	usb_sense_kc(ILLEGAL_REQUEST, LU_NOT_SUPPORTED)
+#define SS_MEDIUM_NOT_PRESENT			\
+	usb_sense_kc(NOT_READY, MEDIUM_NOT_PRESENT)
+#define SS_MEDIUM_REMOVAL_PREVENTED		\
+	usb_sense_kc(ILLEGAL_REQUEST, MEDIUM_REMOVAL_PREVENTED)
+#define SS_NOT_READY_TO_READY_TRANSITION	\
+	usb_sense_kc(UNIT_ATTENTION,		\
+		     NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED)
+#define SS_RESET_OCCURRED			\
+	usb_sense_kc(UNIT_ATTENTION,		\
+		     POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED)
+#define SS_SAVING_PARAMETERS_NOT_SUPPORTED	\
+	usb_sense_kc(ILLEGAL_REQUEST, SAVING_PARAMETERS_NOT_SUPPORTED)
+#define SS_UNRECOVERED_READ_ERROR		\
+	usb_sense_kc(MEDIUM_ERROR, UNRECOVERED_READ_ERROR)
+#define SS_WRITE_ERROR				\
+	usb_sense_kc(MEDIUM_ERROR, WRITE_ERROR_AUTO_REALLOCATION_FAILED)
+#define SS_WRITE_PROTECTED			\
+	usb_sense_kc(DATA_PROTECT, WRITE_PROTECTED)
 
 /*
  * Vendor (8 chars), product (16 chars), release (4 hexadecimal digits) and NUL
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 8e9359501d88..8de3015bce05 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -803,7 +803,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			     temp_result);
 		usb_stor_dbg(us, "-- code: 0x%x, key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
 			     sshdr.response_code, sshdr.sense_key,
-			     sshdr.asc, sshdr.ascq);
+			     scsi_sense_asc(&sshdr), scsi_sense_ascq(&sshdr));
 #ifdef CONFIG_USB_STORAGE_DEBUG
 		usb_stor_show_sense(us, &sshdr);
 #endif
@@ -820,7 +820,8 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		 * everything worked or that there was an unspecified
 		 * problem.  We have to decide which.
 		 */
-		if (sshdr.sense_key == 0 && sshdr.asc == 0 && sshdr.ascq == 0 &&
+		if (sshdr.sense_key == NO_SENSE &&
+		    sshdr.sense_code == NO_ADDITIONAL_SENSE_INFORMATION &&
 		    fm_ili == 0) {
 			/*
 			 * If things are really okay, then let's show that.
-- 
2.55.0

