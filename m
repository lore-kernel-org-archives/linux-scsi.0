Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14372C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354103AbiBKWd1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354097AbiBKWd0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:26 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21DFD52
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:24 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id a39so17827163pfx.7
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W/uCFQynT+oZB9gVA55CGf3bsDwxJbtZ1xwg7R0D9DM=;
        b=KdsPgHYm2Ce9tCsf5rtNhegSSjE/CM1pe3mhhDXeueSthKv6pzgs72rTis8TSkdAK6
         qaXb8ddWdmEcttgF1gz62onP2bJle1PI2jAAhsGazwDywWYqFAi9wdeqZp5LRqJUFtVE
         3VByLnJa+eNvNlMujOE3K3s9DpyWcdR5zsxJUXfbIayW3F7px2D/yjL9eaivsH65Pd2F
         81Bwz1f4Nbdg4GSoa5ldtjAfCiR3aga8nvQSOsvSCykBf0ywwnBUdfpqbyvqifZzKLR7
         OSG1BMTST+D+yJ2CVP8fe76r04L4obzD5Gkk+UIH+nSAJzXCAz+k2jaaFmzsmEjdbdVv
         pCIQ==
X-Gm-Message-State: AOAM533P+yGJ6ZEHDoCfj/VkkTaSXcSYKC6KG0uJYLJyPFWZ0fZhYwTR
        HR3J0euJJQSdmres3CsqiGk=
X-Google-Smtp-Source: ABdhPJxPS1s7WwUOUg4BjViy0XgYNNwSL4L0A84fToomv/1gctcJc6O12y7QBFb8Mztt2TiBybkOLg==
X-Received: by 2002:a05:6a00:1789:: with SMTP id s9mr3628911pfg.71.1644618804142;
        Fri, 11 Feb 2022 14:33:24 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Finn Thain <fthain@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 09/48] scsi: NCR5380: Move the SCSI pointer to private command data
Date:   Fri, 11 Feb 2022 14:32:08 -0800
Message-Id: <20220211223247.14369-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the SCSI pointer into the NCR5380 private command data instead of
using the SCSI pointer from struct scsi_cmnd. This patch prepares for
removal of the SCSI pointer from struct scsi_cmnd. The NCR5380 drivers
have been identified as follows:
$ git grep -l '#include.*NCR5380.h'
drivers/scsi/arm/cumana_1.c
drivers/scsi/arm/oak.c
drivers/scsi/atari_scsi.c
drivers/scsi/dmx3191d.c
drivers/scsi/g_NCR5380.c
drivers/scsi/mac_scsi.c
drivers/scsi/sun3_scsi.c

Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.c    | 89 ++++++++++++++++++++++++---------------
 drivers/scsi/NCR5380.h    |  1 +
 drivers/scsi/atari_scsi.c |  7 ++-
 drivers/scsi/g_NCR5380.c  |  6 ++-
 drivers/scsi/mac_scsi.c   |  7 ++-
 drivers/scsi/sun3_scsi.c  |  4 +-
 6 files changed, 72 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 6fa5e363945a..974b15cf8415 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -145,40 +145,47 @@ static void bus_reset_cleanup(struct Scsi_Host *);
 
 static inline void initialize_SCp(struct scsi_cmnd *cmd)
 {
+	struct scsi_pointer *scsi_pointer =
+		&NCR5380_cmd_priv(cmd)->scsi_pointer;
+
 	/*
 	 * Initialize the Scsi Pointer field so that all of the commands in the
 	 * various queues are valid.
 	 */
 
 	if (scsi_bufflen(cmd)) {
-		cmd->SCp.buffer = scsi_sglist(cmd);
-		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
-		cmd->SCp.this_residual = cmd->SCp.buffer->length;
+		scsi_pointer->buffer = scsi_sglist(cmd);
+		scsi_pointer->ptr = sg_virt(scsi_pointer->buffer);
+		scsi_pointer->this_residual = scsi_pointer->buffer->length;
 	} else {
-		cmd->SCp.buffer = NULL;
-		cmd->SCp.ptr = NULL;
-		cmd->SCp.this_residual = 0;
+		scsi_pointer->buffer = NULL;
+		scsi_pointer->ptr = NULL;
+		scsi_pointer->this_residual = 0;
 	}
 
-	cmd->SCp.Status = 0;
-	cmd->SCp.Message = 0;
+	scsi_pointer->Status = 0;
+	scsi_pointer->Message = 0;
 }
 
 static inline void advance_sg_buffer(struct scsi_cmnd *cmd)
 {
-	struct scatterlist *s = cmd->SCp.buffer;
-
-	if (!cmd->SCp.this_residual && s && !sg_is_last(s)) {
-		cmd->SCp.buffer = sg_next(s);
-		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
-		cmd->SCp.this_residual = cmd->SCp.buffer->length;
+	struct scsi_pointer *scsi_pointer =
+		&NCR5380_cmd_priv(cmd)->scsi_pointer;
+	struct scatterlist *s = scsi_pointer->buffer;
+
+	if (!scsi_pointer->this_residual && s && !sg_is_last(s)) {
+		scsi_pointer->buffer = sg_next(s);
+		scsi_pointer->ptr = sg_virt(scsi_pointer->buffer);
+		scsi_pointer->this_residual = scsi_pointer->buffer->length;
 	}
 }
 
 static inline void set_resid_from_SCp(struct scsi_cmnd *cmd)
 {
-	int resid = cmd->SCp.this_residual;
-	struct scatterlist *s = cmd->SCp.buffer;
+	struct scsi_pointer *scsi_pointer =
+		&NCR5380_cmd_priv(cmd)->scsi_pointer;
+	int resid = scsi_pointer->this_residual;
+	struct scatterlist *s = scsi_pointer->buffer;
 
 	if (s)
 		while (!sg_is_last(s)) {
@@ -757,6 +764,7 @@ static void NCR5380_main(struct work_struct *work)
 static void NCR5380_dma_complete(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	struct scsi_pointer *scsi_pointer;
 	int transferred;
 	unsigned char **data;
 	int *count;
@@ -764,7 +772,10 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 	unsigned char p;
 
 	if (hostdata->read_overruns) {
-		p = hostdata->connected->SCp.phase;
+		struct scsi_pointer *scsi_pointer =
+			&NCR5380_cmd_priv(hostdata->connected)->scsi_pointer;
+
+		p = scsi_pointer->phase;
 		if (p & SR_IO) {
 			udelay(10);
 			if ((NCR5380_read(BUS_AND_STATUS_REG) &
@@ -801,8 +812,9 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 	transferred = hostdata->dma_len - NCR5380_dma_residual(hostdata);
 	hostdata->dma_len = 0;
 
-	data = (unsigned char **)&hostdata->connected->SCp.ptr;
-	count = &hostdata->connected->SCp.this_residual;
+	scsi_pointer = &NCR5380_cmd_priv(hostdata->connected)->scsi_pointer;
+	data = (unsigned char **)&scsi_pointer->ptr;
+	count = &scsi_pointer->this_residual;
 	*data += transferred;
 	*count -= transferred;
 
@@ -1487,6 +1499,8 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 				unsigned char **data)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	struct scsi_pointer *scsi_pointer =
+		&NCR5380_cmd_priv(hostdata->connected)->scsi_pointer;
 	int c = *count;
 	unsigned char p = *phase;
 	unsigned char *d = *data;
@@ -1498,7 +1512,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 		return -1;
 	}
 
-	hostdata->connected->SCp.phase = p;
+	scsi_pointer->phase = p;
 
 	if (p & SR_IO) {
 		if (hostdata->read_overruns)
@@ -1691,6 +1705,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 
 	while ((cmd = hostdata->connected)) {
 		struct NCR5380_cmd *ncmd = NCR5380_cmd_priv(cmd);
+		struct scsi_pointer *scsi_pointer = &ncmd->scsi_pointer;
 
 		tmp = NCR5380_read(STATUS_REG);
 		/* We only have a valid SCSI phase when REQ is asserted */
@@ -1712,10 +1727,10 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				if (count > 0) {
 					if (cmd->sc_data_direction == DMA_TO_DEVICE)
 						sun3scsi_dma_send_setup(hostdata,
-						                        cmd->SCp.ptr, count);
+						                        scsi_pointer->ptr, count);
 					else
 						sun3scsi_dma_recv_setup(hostdata,
-						                        cmd->SCp.ptr, count);
+						                        scsi_pointer->ptr, count);
 					sun3_dma_setup_done = cmd;
 				}
 #ifdef SUN3_SCSI_VME
@@ -1758,8 +1773,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				advance_sg_buffer(cmd);
 				dsprintk(NDEBUG_INFORMATION, instance,
 					"this residual %d, sg ents %d\n",
-					cmd->SCp.this_residual,
-					sg_nents(cmd->SCp.buffer));
+					scsi_pointer->this_residual,
+					sg_nents(scsi_pointer->buffer));
 
 				/*
 				 * The preferred transfer method is going to be
@@ -1778,7 +1793,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				if (transfersize > 0) {
 					len = transfersize;
 					if (NCR5380_transfer_dma(instance, &phase,
-					    &len, (unsigned char **)&cmd->SCp.ptr)) {
+					    &len, (unsigned char **)&scsi_pointer->ptr)) {
 						/*
 						 * If the watchdog timer fires, all future
 						 * accesses to this device will use the
@@ -1794,13 +1809,13 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					/* Transfer a small chunk so that the
 					 * irq mode lock is not held too long.
 					 */
-					transfersize = min(cmd->SCp.this_residual,
+					transfersize = min(scsi_pointer->this_residual,
 							   NCR5380_PIO_CHUNK_SIZE);
 					len = transfersize;
 					NCR5380_transfer_pio(instance, &phase, &len,
-					                     (unsigned char **)&cmd->SCp.ptr,
+					                     (unsigned char **)&scsi_pointer->ptr,
 							     0);
-					cmd->SCp.this_residual -= transfersize - len;
+					scsi_pointer->this_residual -= transfersize - len;
 				}
 #ifdef CONFIG_SUN3
 				if (sun3_dma_setup_done == cmd)
@@ -1811,7 +1826,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				len = 1;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
-				cmd->SCp.Message = tmp;
+				scsi_pointer->Message = tmp;
 
 				switch (tmp) {
 				case ABORT:
@@ -1828,15 +1843,15 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					hostdata->connected = NULL;
 					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 
-					set_status_byte(cmd, cmd->SCp.Status);
+					set_status_byte(cmd, scsi_pointer->Status);
 
 					set_resid_from_SCp(cmd);
 
 					if (cmd->cmnd[0] == REQUEST_SENSE)
 						complete_cmd(instance, cmd);
 					else {
-						if (cmd->SCp.Status == SAM_STAT_CHECK_CONDITION ||
-						    cmd->SCp.Status == SAM_STAT_COMMAND_TERMINATED) {
+						if (scsi_pointer->Status == SAM_STAT_CHECK_CONDITION ||
+						    scsi_pointer->Status == SAM_STAT_COMMAND_TERMINATED) {
 							dsprintk(NDEBUG_QUEUES, instance, "autosense: adding cmd %p to tail of autosense queue\n",
 							         cmd);
 							list_add_tail(&ncmd->list,
@@ -2000,7 +2015,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				len = 1;
 				data = &tmp;
 				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
-				cmd->SCp.Status = tmp;
+				scsi_pointer->Status = tmp;
 				break;
 			default:
 				shost_printk(KERN_ERR, instance, "unknown phase\n");
@@ -2151,6 +2166,8 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 #ifdef CONFIG_SUN3
 	if (sun3_dma_setup_done != tmp) {
+		struct scsi_pointer *scsi_pointer =
+			&NCR5380_cmd_priv(tmp)->scsi_pointer;
 		int count;
 
 		advance_sg_buffer(tmp);
@@ -2160,10 +2177,12 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		if (count > 0) {
 			if (tmp->sc_data_direction == DMA_TO_DEVICE)
 				sun3scsi_dma_send_setup(hostdata,
-				                        tmp->SCp.ptr, count);
+				                        scsi_pointer->ptr,
+							count);
 			else
 				sun3scsi_dma_recv_setup(hostdata,
-				                        tmp->SCp.ptr, count);
+				                        scsi_pointer->ptr,
+							count);
 			sun3_dma_setup_done = tmp;
 		}
 	}
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 88a1bb41b72e..a4291e7c24dd 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -227,6 +227,7 @@ struct NCR5380_hostdata {
 };
 
 struct NCR5380_cmd {
+	struct scsi_pointer scsi_pointer;
 	struct list_head list;
 };
 
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index e9d0d99abc86..17e6a6262abf 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -538,7 +538,9 @@ static int falcon_classify_cmd(struct scsi_cmnd *cmd)
 static int atari_scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                    struct scsi_cmnd *cmd)
 {
-	int wanted_len = cmd->SCp.this_residual;
+	struct scsi_pointer *scsi_pointer =
+		&NCR5380_cmd_priv(cmd)->scsi_pointer;
+	int wanted_len = scsi_pointer->this_residual;
 	int possible_len, limit;
 
 	if (wanted_len < DMA_MIN_SIZE)
@@ -610,7 +612,8 @@ static int atari_scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 	}
 
 	/* Last step: apply the hard limit on DMA transfers */
-	limit = (atari_dma_buffer && !STRAM_ADDR(virt_to_phys(cmd->SCp.ptr))) ?
+	limit = (atari_dma_buffer &&
+		 !STRAM_ADDR(virt_to_phys(scsi_pointer->ptr))) ?
 		    STRAM_BUFFER_SIZE : 255*512;
 	if (possible_len > limit)
 		possible_len = limit;
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 5923f86a384e..f887ed2e0a8e 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -663,7 +663,9 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
 static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                         struct scsi_cmnd *cmd)
 {
-	int transfersize = cmd->SCp.this_residual;
+	struct scsi_pointer *scsi_pointer =
+		&NCR5380_cmd_priv(cmd)->scsi_pointer;
+	int transfersize = scsi_pointer->this_residual;
 
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
 		return 0;
@@ -675,7 +677,7 @@ static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 	/* Limit PDMA send to 512 B to avoid random corruption on DTC3181E */
 	if (hostdata->board == BOARD_DTC3181E &&
 	    cmd->sc_data_direction == DMA_TO_DEVICE)
-		transfersize = min(cmd->SCp.this_residual, 512);
+		transfersize = min(scsi_pointer->this_residual, 512);
 
 	return min(transfersize, DMA_MAX_SIZE);
 }
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 71d493a0bb43..d44ad35621fb 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -404,11 +404,14 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 static int macscsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                 struct scsi_cmnd *cmd)
 {
+	struct scsi_pointer *scsi_pointer =
+		&NCR5380_cmd_priv(cmd)->scsi_pointer;
+
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA ||
-	    cmd->SCp.this_residual < setup_use_pdma)
+	    scsi_pointer->this_residual < setup_use_pdma)
 		return 0;
 
-	return cmd->SCp.this_residual;
+	return scsi_pointer->this_residual;
 }
 
 static int macscsi_dma_residual(struct NCR5380_hostdata *hostdata)
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 82a253270c3b..3a584a1b7944 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -334,7 +334,9 @@ static int sun3scsi_dma_residual(struct NCR5380_hostdata *hostdata)
 static int sun3scsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                  struct scsi_cmnd *cmd)
 {
-	int wanted_len = cmd->SCp.this_residual;
+	struct scsi_pointer *scsi_pointer =
+		&NCR5380_cmd_priv(cmd)->scsi_pointer;
+	int wanted_len = scsi_pointer->this_residual;
 
 	if (wanted_len < DMA_MIN_SIZE || blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)))
 		return 0;
