Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F612D1E4
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638344; cv=none; b=fHpdNZGqs54xi/eQEI+ix9YyXGK7JuXvFk1ZPdemZeTUdYYtcgXqWeR1DjGkPamQOoyd3x7ilP1lUJ/AgmHQsSOWbO/Dz15CfLo6rG7leVb9AAUHbh689st0wapBD1z+e28721fkRG9OKWqv2kw8w+x0hgCPAcP3HHCo+gHOeyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638344; c=relaxed/simple;
	bh=6Es1z9Z021Z+d2BSbfnWdCwEq2J0mG6QTi9n7uOvsr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+ovGiCic9cIUacFFRkyhd7XxQ6iVSthz/+rcxOt+4HI8rLYAnTuMLTUPJj93nGohkOIm9P3Pg1KtK13iJx5EzRjO6VqIVtsl2Q63qu0SMroyNz2DEXzTHYI1Yxf9S3IRvZQtGgIknRD2lXVQXe0hI1oMLIfZZn3IsjQAXJYM9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e4560664b5so100851b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638342; x=1709243142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=omJq96HpIrT4jxUoJlMDOO+77ZTwDn15R2tbbux00I8=;
        b=FO3tkqvig8PBXWAIgXls5Ufwh6x+Z+i0BHHm+SYSQb6nghoRonPeEbSTSaiXkNMEES
         Eg5lkX7Q5Uz9in3cFa3W40+wS1br+rJAVv5j6ipuD7ucBjjMgLOYmhCakl/TWJ25uhwa
         BWjFt/baKFC/voTFHU79V0LjTSKqKyUPW+kK7sCQLIMI+ScA1ns9cMB8tPH3gioAP7do
         gm30zN2WveSn2RWYlbQ24hjTMZdpsMbnxkusG8tZ3/VjptsmUNvKiliyOw9fDyNjI3Rf
         GT8qfLCZEKTLlXAVbk61N1t3FZg1XFaqWYFvmW+Ex/Xv41OcJLlrHPO3UJFc+nsU3tOu
         LmUg==
X-Gm-Message-State: AOJu0YxeMwt8c+5wIALfbl7qqbiklEjD4iOaB0uX/L9i53hz0sv7wse6
	UQue7Mpi/pg7zOFK+wrrvrvf8gFR53o40fNtOwmZVePvjBSdK7EA
X-Google-Smtp-Source: AGHT+IGLRSnDVvaDmNjdhydC2QgIbkwgi7S0tmq3dauPyNwkZTO945wn2mmXRQiT72Urfd3feOIBpA==
X-Received: by 2002:a05:6a21:360b:b0:1a0:d5b3:8e1 with SMTP id yg11-20020a056a21360b00b001a0d5b308e1mr101253pzb.30.1708638342516;
        Thu, 22 Feb 2024 13:45:42 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:42 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 03/11] scsi: sd: Translate data lifetime information
Date: Thu, 22 Feb 2024 13:44:51 -0800
Message-ID: <20240222214508.1630719-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240222214508.1630719-1-bvanassche@acm.org>
References: <20240222214508.1630719-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently T10 standardized SBC constrained streams. This mechanism allows
to pass data lifetime information to SCSI devices in the group number
field. Add support for translating write hint information into a
permanent stream number in the sd driver.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 104 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |   2 +
 2 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86b819fa04d9..48496e816409 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -47,6 +47,7 @@
 #include <linux/blkpg.h>
 #include <linux/blk-pm.h>
 #include <linux/delay.h>
+#include <linux/rw_hint.h>
 #include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
@@ -1080,12 +1081,35 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 	return BLK_STS_OK;
 }
 
+/**
+ * sd_group_number() - Compute the GROUP NUMBER field
+ * @cmd: SCSI command for which to compute the value of the six-bit GROUP NUMBER
+ *	field.
+ *
+ * From SBC-5 r05 (https://www.t10.org/cgi-bin/ac.pl?t=f&f=sbc5r05.pdf):
+ * 0: no relative lifetime.
+ * 1: shortest relative lifetime.
+ * 2: second shortest relative lifetime.
+ * 3 - 0x3d: intermediate relative lifetimes.
+ * 0x3e: second longest relative lifetime.
+ * 0x3f: longest relative lifetime.
+ */
+static u8 sd_group_number(struct scsi_cmnd *cmd)
+{
+	const struct request *rq = scsi_cmd_to_rq(cmd);
+	struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
+
+	return min3((u32)rq->write_hint, (u32)sdkp->permanent_stream_count,
+		    0x3fu);
+}
+
 static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
 				       unsigned char flags, unsigned int dld)
 {
 	cmd->cmd_len = SD_EXT_CDB_SIZE;
 	cmd->cmnd[0]  = VARIABLE_LENGTH_CMD;
+	cmd->cmnd[6]  = sd_group_number(cmd);
 	cmd->cmnd[7]  = 0x18; /* Additional CDB len */
 	cmd->cmnd[9]  = write ? WRITE_32 : READ_32;
 	cmd->cmnd[10] = flags;
@@ -1104,7 +1128,7 @@ static blk_status_t sd_setup_rw16_cmnd(struct scsi_cmnd *cmd, bool write,
 	cmd->cmd_len  = 16;
 	cmd->cmnd[0]  = write ? WRITE_16 : READ_16;
 	cmd->cmnd[1]  = flags | ((dld >> 2) & 0x01);
-	cmd->cmnd[14] = (dld & 0x03) << 6;
+	cmd->cmnd[14] = ((dld & 0x03) << 6) | sd_group_number(cmd);
 	cmd->cmnd[15] = 0;
 	put_unaligned_be64(lba, &cmd->cmnd[2]);
 	put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
@@ -1119,7 +1143,7 @@ static blk_status_t sd_setup_rw10_cmnd(struct scsi_cmnd *cmd, bool write,
 	cmd->cmd_len = 10;
 	cmd->cmnd[0] = write ? WRITE_10 : READ_10;
 	cmd->cmnd[1] = flags;
-	cmd->cmnd[6] = 0;
+	cmd->cmnd[6] = sd_group_number(cmd);
 	cmd->cmnd[9] = 0;
 	put_unaligned_be32(lba, &cmd->cmnd[2]);
 	put_unaligned_be16(nr_blocks, &cmd->cmnd[7]);
@@ -3001,6 +3025,81 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	sdkp->DPOFUA = 0;
 }
 
+static bool sd_is_perm_stream(struct scsi_disk *sdkp, unsigned int stream_id)
+{
+	u8 cdb[16] = { SERVICE_ACTION_IN_16, SAI_GET_STREAM_STATUS };
+	struct {
+		struct scsi_stream_status_header h;
+		struct scsi_stream_status s;
+	} buf;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
+	int res;
+
+	put_unaligned_be16(stream_id, &cdb[4]);
+	put_unaligned_be32(sizeof(buf), &cdb[10]);
+
+	res = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, &buf, sizeof(buf),
+			       SD_TIMEOUT, sdkp->max_retries, &exec_args);
+	if (res < 0)
+		return false;
+	if (scsi_status_is_check_condition(res) && scsi_sense_valid(&sshdr))
+		sd_print_sense_hdr(sdkp, &sshdr);
+	if (res)
+		return false;
+	if (get_unaligned_be32(&buf.h.len) < sizeof(struct scsi_stream_status))
+		return false;
+	return buf.h.stream_status[0].perm;
+}
+
+static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	struct scsi_device *sdp = sdkp->device;
+	const struct scsi_io_group_descriptor *desc, *start, *end;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_mode_data data;
+	int res;
+
+	if (!sdkp->rscs)
+		return;
+
+	res = scsi_mode_sense(sdp, /*dbd=*/0x8, /*modepage=*/0x0a,
+			      /*subpage=*/0x05, buffer, SD_BUF_SIZE, SD_TIMEOUT,
+			      sdkp->max_retries, &data, &sshdr);
+	if (res < 0)
+		return;
+	start = (void *)buffer + data.header_length + 16;
+	end = (void *)buffer + ALIGN_DOWN(data.header_length + data.length,
+					  sizeof(*end));
+	/*
+	 * From "SBC-5 Constrained Streams with Data Lifetimes": Device severs
+	 * should assign the lowest numbered stream identifiers to permanent
+	 * streams.
+	 */
+	for (desc = start; desc < end; desc++)
+		if (!desc->st_enble || !sd_is_perm_stream(sdkp, desc - start))
+			break;
+	sdkp->permanent_stream_count = desc - start;
+	if (sdkp->permanent_stream_count < 2) {
+		sd_printk(KERN_INFO, sdkp,
+			  "Unexpected: RSCS has been set and the permanent stream count is %u\n",
+			  sdkp->permanent_stream_count);
+		return;
+	}
+
+	sd_printk(KERN_INFO, sdkp, "permanent stream count = %d\n",
+		  sdkp->permanent_stream_count);
+	/*
+	 * Use WRITE(10) instead of WRITE(6) if data lifetime information is
+	 * present because the WRITE(6) command does not have a GROUP NUMBER
+	 * field.
+	 */
+	sdp->use_10_for_rw = true;
+}
+
 /*
  * The ATO bit indicates whether the DIF application tag is available
  * for use by the operating system.
@@ -3481,6 +3580,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
+		sd_read_io_hints(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
 		sd_read_write_same(sdkp, buffer);
 		sd_read_security(sdkp, buffer);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f1120de03d51..5c4285a582b2 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -125,6 +125,8 @@ struct scsi_disk {
 	unsigned int	physical_block_size;
 	unsigned int	max_medium_access_timeouts;
 	unsigned int	medium_access_timed_out;
+			/* number of permanent streams */
+	u16		permanent_stream_count;
 	u8		media_present;
 	u8		write_prot;
 	u8		protection_type;/* Data Integrity Field */
