Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C1026B4C7
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2025 21:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739309212; cv=none; b=CFPbIDFsOYo2QNjtNiJSUJOkOb6upjwBGOB6iODUBX1nBy327paxVloPIN8lr/MRZi0XYuj9QbysCZMooXEX6WZl6+eQp1VGXOX6oshtu7K9WlvEN1UXv5KteCIvRRoInk0StS0qy07F58FU8delMoOkW6Znh0ExHgX7ZFDCsNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739309212; c=relaxed/simple;
	bh=jTemk7V0etPxO8YIatDkldvK1+JZNyf5x69Znm/uUxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNiSpDCmSzTRTR3ko4SCCbdYaX81IG03igFgB6zwWQarS9l8AtTKzXpKtFhdcSiIeI703n0S9FHgHuGcCBArDh0YieZoNwo5ni1P4LCODIUmHMvZTJKxVrXRZEK1tDRcfPKvonLUY/h+lW7189NFdoyudQx5Y1EjMvFg1vVYKiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=iGk8tieS; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="iGk8tieS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=7h6TC1fkfgKJhiRxslVxeqOvN5c2Fv+OKaFLUg0qP7A=;
	b=iGk8tieSuYmNcuA9a6eZIsUqdyld3dxI49//cPwRxm5iKdm31H6HYSZQmlXhe0c2bvdEPO59sj7AZ
	 UerM9/hZRd397/6dAyZ6eJjGobyHrszHLFl2p9LPkX1U1VcqfDKpI2kgWp2hr8rRnAQbvQbS6+WQuh
	 F2XgkDC8ULw2lzTI+XRCybVzNzIIMUN05SkJEnIZ3/gywO88su3NAcW5ToCaiF3L1fqWtSePbR0P8Y
	 ztdrdVp4BA2q8Xlh+5Kegn273B6jEfhbSYAJ/tFnj7RwL2qyyoUX/BlHCBGqDRy+0JB9kClDx748I8
	 o3ZLTE3D7ls0h3JrEavO5jweGttOwHQ==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id e090c264-e8be-11ef-9d6e-005056bd6ce9;
	Tue, 11 Feb 2025 23:26:39 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v1b 4/7] scsi: scsi_debug: Add read support and update locate for tapes
Date: Tue, 11 Feb 2025 23:26:18 +0200
Message-ID: <20250211212618.38281-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210191232.185207-5-Kai.Makisara@kolumbus.fi>
References: <20250210191232.185207-5-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Support for the READ (6) and SPACE (6) commands for tapes based on the
previous write patch is added. The LOCATE (10) command is updated to use
the written data.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---

v1 -> v1b:
- initialize i to zero in resp_space to fix the bug found by
  The Kernel Test Robot

 drivers/scsi/scsi_debug.c | 240 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 235 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 69cae4c1712a..29a9aea30d22 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -532,7 +532,8 @@ enum sdeb_opcode_index {
 	SDEB_I_READ_BLOCK_LIMITS = 33,
 	SDEB_I_LOCATE = 34,
 	SDEB_I_WRITE_FILEMARKS = 35,
-	SDEB_I_LAST_ELEM_P1 = 36,	/* keep this last (previous + 1) */
+	SDEB_I_SPACE = 36,
+	SDEB_I_LAST_ELEM_P1 = 37,	/* keep this last (previous + 1) */
 };
 
 
@@ -541,7 +542,7 @@ static const unsigned char opcode_ind_arr[256] = {
 	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
 	    0, SDEB_I_READ_BLOCK_LIMITS, 0, 0,
 	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
-	SDEB_I_WRITE_FILEMARKS, 0, SDEB_I_INQUIRY, 0, 0,
+	SDEB_I_WRITE_FILEMARKS, SDEB_I_SPACE, SDEB_I_INQUIRY, 0, 0,
 	    SDEB_I_MODE_SELECT, SDEB_I_RESERVE, SDEB_I_RELEASE,
 	0, 0, SDEB_I_MODE_SENSE, SDEB_I_START_STOP, 0, SDEB_I_SEND_DIAG,
 	    SDEB_I_ALLOW_REMOVAL, 0,
@@ -625,6 +626,7 @@ static int resp_rwp_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_read_blklimits(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_locate(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_filemarks(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_space(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_rewind(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 static int sdebug_do_add_host(bool mk_new_store);
@@ -872,10 +874,12 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	{0, 0x05, 0, F_D_IN, resp_read_blklimits, NULL,    /* READ BLOCK LIMITS (6) */
 	    {6,  0, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0x2b, 0, F_D_UNKN, resp_locate, NULL,    /* LOCATE (10) */
-	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
+	    {10,  0x07, 0, 0xff, 0xff, 0xff, 0xff, 0, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },
 	{0, 0x10, 0, F_D_IN, resp_write_filemarks, NULL,    /* WRITE FILEMARKS (6) */
 	    {6,  0x01, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+	{0, 0x11, 0, F_D_IN, resp_space, NULL,    /* SPACE (6) */
+	    {6,  0x07, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 /* sentinel */
 	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
@@ -3309,6 +3313,9 @@ static int resp_locate(struct scsi_cmnd *scp,
 		struct sdebug_dev_info *devip)
 {
 	unsigned char *cmd = scp->cmnd;
+	unsigned int i, pos;
+	struct tape_block *blp;
+	int partition;
 
 	if ((cmd[1] & 0x02) != 0) {
 		if (cmd[8] >= devip->tape_nbr_partitions) {
@@ -3317,8 +3324,19 @@ static int resp_locate(struct scsi_cmnd *scp,
 		}
 		devip->tape_partition = cmd[8];
 	}
-	devip->tape_location[devip->tape_partition] =
-		get_unaligned_be32(cmd + 3);
+	pos = get_unaligned_be32(cmd + 3);
+	partition = devip->tape_partition;
+
+	for (i = 0, blp = devip->tape_blocks[partition];
+	     i < pos && i < devip->tape_eop[partition]; i++, blp++)
+		if (IS_TAPE_BLOCK_EOD(blp->fl_size))
+			break;
+	if (i < pos) {
+		devip->tape_location[partition] = i;
+		mk_sense_buffer(scp, BLANK_CHECK, 0x05, 0);
+		return check_condition_result;
+	}
+	devip->tape_location[partition] = pos;
 
 	return 0;
 }
@@ -3353,6 +3371,123 @@ static int resp_write_filemarks(struct scsi_cmnd *scp,
 	return 0;
 }
 
+static int resp_space(struct scsi_cmnd *scp,
+		struct sdebug_dev_info *devip)
+{
+	unsigned char *cmd = scp->cmnd, code;
+	int i = 0, pos, count;
+	struct tape_block *blp;
+	int partition = devip->tape_partition;
+
+	count = get_unaligned_be24(cmd + 2);
+	if ((count & 0x800000) != 0) /* extend negative to 32-bit count */
+		count |= 0xff000000;
+	code = cmd[1] & 0x0f;
+
+	pos = devip->tape_location[partition];
+	if (code == 0) { /* blocks */
+		if (count < 0) {
+			count = (-count);
+			pos -= 1;
+			for (i = 0, blp = devip->tape_blocks[partition] + pos; i < count;
+			     i++) {
+				if (pos < 0)
+					goto is_bop;
+				else if (IS_TAPE_BLOCK_FM(blp->fl_size))
+					goto is_fm;
+				if (i > 0) {
+					pos--;
+					blp--;
+				}
+			}
+		} else if (count > 0) {
+			for (i = 0, blp = devip->tape_blocks[partition] + pos; i < count;
+			     i++, pos++, blp++) {
+				if (IS_TAPE_BLOCK_EOD(blp->fl_size))
+					goto is_eod;
+				if (IS_TAPE_BLOCK_FM(blp->fl_size)) {
+					pos += 1;
+					goto is_fm;
+				}
+				if (pos >= devip->tape_eop[partition])
+					goto is_eop;
+			}
+		}
+	} else if (code == 1) { /* filemarks */
+		if (count < 0) {
+			count = (-count);
+			if (pos == 0)
+				goto is_bop;
+			else {
+				for (i = 0, blp = devip->tape_blocks[partition] + pos;
+				     i < count && pos >= 0; i++, pos--, blp--) {
+					for (pos--, blp-- ; !IS_TAPE_BLOCK_FM(blp->fl_size) &&
+						     pos >= 0; pos--, blp--)
+						; /* empty */
+					if (pos < 0)
+						goto is_bop;
+				}
+			}
+			pos += 1;
+		} else if (count > 0) {
+			for (i = 0, blp = devip->tape_blocks[partition] + pos;
+			     i < count; i++, pos++, blp++) {
+				for ( ; !IS_TAPE_BLOCK_FM(blp->fl_size) &&
+					      !IS_TAPE_BLOCK_EOD(blp->fl_size) &&
+					      pos < devip->tape_eop[partition];
+				      pos++, blp++)
+					; /* empty */
+				if (IS_TAPE_BLOCK_EOD(blp->fl_size))
+					goto is_eod;
+				if (pos >= devip->tape_eop[partition])
+					goto is_eop;
+			}
+		}
+	} else if (code == 3) { /* EOD */
+		for (blp = devip->tape_blocks[partition] + pos;
+		     !IS_TAPE_BLOCK_EOD(blp->fl_size) && pos < devip->tape_eop[partition];
+		     pos++, blp++)
+			; /* empty */
+		if (pos >= devip->tape_eop[partition])
+			goto is_eop;
+	} else {
+		/* sequential filemarks not supported */
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 8, -1);
+		return check_condition_result;
+	}
+	devip->tape_location[partition] = pos;
+	return 0;
+
+is_fm:
+	devip->tape_location[partition] = pos;
+	mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
+			FILEMARK_DETECTED_ASCQ, count - i,
+			SENSE_FLAG_FILEMARK);
+	return check_condition_result;
+
+is_eod:
+	devip->tape_location[partition] = pos;
+	mk_sense_info_tape(scp, BLANK_CHECK, NO_ADDITIONAL_SENSE,
+			EOD_DETECTED_ASCQ, count - i,
+			0);
+	return check_condition_result;
+
+is_bop:
+	devip->tape_location[partition] = 0;
+	mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
+			BEGINNING_OF_P_M_DETECTED_ASCQ, count - i,
+			SENSE_FLAG_EOM);
+	devip->tape_location[partition] = 0;
+	return check_condition_result;
+
+is_eop:
+	devip->tape_location[partition] = devip->tape_eop[partition] - 1;
+	mk_sense_info_tape(scp, MEDIUM_ERROR, NO_ADDITIONAL_SENSE,
+			EOP_EOM_DETECTED_ASCQ, (unsigned int)i,
+			SENSE_FLAG_EOM);
+	return check_condition_result;
+}
+
 static int resp_rewind(struct scsi_cmnd *scp,
 		struct sdebug_dev_info *devip)
 {
@@ -4121,6 +4256,98 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 	return ret;
 }
 
+static int resp_read_tape(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	u32 i, num, transfer, size;
+	u8 *cmd = scp->cmnd;
+	struct scsi_data_buffer *sdb = &scp->sdb;
+	int partition = devip->tape_partition;
+	u32 pos = devip->tape_location[partition];
+	struct tape_block *blp;
+	bool fixed, sili;
+
+	if (cmd[0] != READ_6) { /* Only Read(6) supported */
+		mk_sense_invalid_opcode(scp);
+		return illegal_condition_result;
+	}
+	fixed = (cmd[1] & 0x1) != 0;
+	sili = (cmd[1] & 0x2) != 0;
+	if (fixed && sili) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 1);
+		return check_condition_result;
+	}
+
+	transfer = get_unaligned_be24(cmd + 2);
+	if (fixed) {
+		num = transfer;
+		size = devip->tape_blksize;
+	} else {
+		if (transfer < TAPE_MIN_BLKSIZE ||
+			transfer > TAPE_MAX_BLKSIZE) {
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
+			return check_condition_result;
+		}
+		num = 1;
+		size = transfer;
+	}
+
+	for (i = 0, blp = devip->tape_blocks[partition] + pos;
+	     i < num && pos < devip->tape_eop[partition];
+	     i++, pos++, blp++) {
+		devip->tape_location[partition] = pos + 1;
+		if (IS_TAPE_BLOCK_FM(blp->fl_size)) {
+			mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
+					FILEMARK_DETECTED_ASCQ, fixed ? num - i : size,
+					SENSE_FLAG_FILEMARK);
+			scsi_set_resid(scp, (num - i) * size);
+			return check_condition_result;
+		}
+		/* Assume no REW */
+		if (IS_TAPE_BLOCK_EOD(blp->fl_size)) {
+			mk_sense_info_tape(scp, BLANK_CHECK, NO_ADDITIONAL_SENSE,
+					EOD_DETECTED_ASCQ, fixed ? num - i : size,
+					0);
+			devip->tape_location[partition] = pos;
+			scsi_set_resid(scp, (num - i) * size);
+			return check_condition_result;
+		}
+		sg_zero_buffer(sdb->table.sgl, sdb->table.nents,
+			size, i * size);
+		sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
+			&(blp->data), 4, i * size, false);
+		if (fixed) {
+			if (blp->fl_size != devip->tape_blksize) {
+				scsi_set_resid(scp, (num - i) * size);
+				mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
+						0, num - i,
+						SENSE_FLAG_ILI);
+				return check_condition_result;
+			}
+		} else {
+			if (blp->fl_size != size) {
+				if (blp->fl_size < size)
+					scsi_set_resid(scp, size - blp->fl_size);
+				if (!sili) {
+					mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
+							0, size - blp->fl_size,
+							SENSE_FLAG_ILI);
+					return check_condition_result;
+				}
+			}
+		}
+	}
+	if (pos >= devip->tape_eop[partition]) {
+		mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
+				EOP_EOM_DETECTED_ASCQ, fixed ? num - i : size,
+				SENSE_FLAG_EOM);
+		devip->tape_location[partition] = pos - 1;
+		return check_condition_result;
+	}
+	devip->tape_location[partition] = pos;
+
+	return 0;
+}
+
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	bool check_prot;
@@ -4132,6 +4359,9 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u8 *cmd = scp->cmnd;
 	bool meta_data_locked = false;
 
+	if (sdebug_ptype == TYPE_TAPE)
+		return resp_read_tape(scp, devip);
+
 	switch (cmd[0]) {
 	case READ_16:
 		ei_lba = 0;
-- 
2.43.0

