Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0F8C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 22:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA8EB20829
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 22:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="evmd3WkT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ph5RvOQq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgG3WH4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 18:07:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55349 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727072AbgG3WHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jul 2020 18:07:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 90F705C01AF;
        Thu, 30 Jul 2020 18:07:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 30 Jul 2020 18:07:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=vHWWixzs7knWrmLD1yUPl+Ms30
        6QdTLaTxsMLxt+lQU=; b=evmd3WkThYm1GXm0xd4YM1KrHYUZYyzdbw//msEMhE
        /vgAySq1++JK+g+1gtEekHVJUm3f9TguXvN//ZlsMTMM7Fbw6IIdg9BZADYblFs+
        tlEvK/DT+e4etXa9RoAfiqJLy5l8lIgaqqKAVYTdwHlpetayywd+JbxPtiZ0I94o
        bZGVgUcqMEFXcLv4nxkFYZdjSqSQhih1hMwh6B25LxH2RjFmlOz5g9PLu405XK29
        44dFk6vLvUkiZ6xYydEKl3f9fCN6XIpk9/ZdBihegLiGSuFu7NpLsNwFQdqCynlk
        OydtGtkhWmytyDeYWOdPIdMSlbYNedCn61HBbYfH5Zfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vHWWixzs7knWrmLD1
        yUPl+Ms306QdTLaTxsMLxt+lQU=; b=Ph5RvOQqW0TKIH+nfISKNvDN6+PxPatab
        +RrkEvFIN3HNPrI4Mj+xLfguu7iLGlKIpc/b0rtWEF8jiJ2uATq47++dAMoOV76V
        3cRWWBDpCdwn7pmDkh5QypVk9sYuTILLFPKl5GRwh0dkNbdAYoLfG9pYMcsdOkFm
        9f2rzdz0/eRyavv9v+KuSmLhaFKIWdoMhJp9Nmyaoj76zYvik3zIUHILozrbBb/8
        DgR+evsWP9HNeigxcs7J0cpYuGbQafDRMMhMaua99gue/Jbxo6Rfdmz+kD2I66sk
        kmYZULAlW8Y8BvQBnNWs+Gu1Tl8U+bt7X2KH7r5cPL/N8Ry8GOhnw==
X-ME-Sender: <xms:t0QjX64GSBs1npa-Or-iQFueV4-_UVoKiX60PtLfo5HygYjMehpWjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieejgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghlucfj
    ohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrfgrth
    htvghrnhephfegvdeiueevjeeuhfduhfejveffieevvedtjeelfeetgfdvudefueelffeg
    gfelnecuffhomhgrihhnpehnvgiftghomhhmrghnugdrshhgnecukfhppeejtddrudefhe
    drudegkedrudehudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:t0QjXz5ICahFvjUMP89ky54FqJbT8PAwhmMf-fZGEZ40jL0nIZ_1WA>
    <xmx:t0QjX5fOYzd8gcLA2cRBCkJvVV9ReTVLtwAcx6_LqPQuPchG555OiA>
    <xmx:t0QjX3IMMusKIYog5KYw4SlpbBoTLbUK7QdqrGKqckP35ml5yFYrjw>
    <xmx:uEQjX62_bQjR2oNHMoM9_WMamGp7d9uhsGRgmrh165h04phf-toI-g>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DCCB3280063;
        Thu, 30 Jul 2020 18:07:51 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Samuel Holland <samuel@sholland.org>
Subject: [PATCH v2] scsi: 3w-9xxx: Fix endianness issues found by sparse
Date:   Thu, 30 Jul 2020 17:07:50 -0500
Message-Id: <20200730220750.18158-1-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The main issue observed was at the call to scsi_set_resid, where the
byteswapped parameter would eventually trigger the alignment check at
drivers/scsi/sd.c:2009. At that point, the kernel would continuously
complain about an "Unaligned partial completion", and no further I/O
could occur.

This gets the controller working on big endian powerpc64.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---

Changes since v1:
 - Include changes to use __le?? types in command structures
 - Use an object literal for the intermediate "schedulertime" value
 - Use local "error" variable to avoid repeated byte swapping
 - Create a local "length" variable to avoid very long lines
 - Move byte swapping to TW_REQ_LUN_IN/TW_LUN_OUT to avoid long lines

I verified this patch with `make C=1`, and there were no warnings from
these files.

---
 drivers/scsi/3w-9xxx.c |  56 +++++++++------------
 drivers/scsi/3w-9xxx.h | 112 ++++++++++++++++++++++-------------------
 2 files changed, 85 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..8f56beefa338 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -303,10 +303,10 @@ static int twa_aen_drain_queue(TW_Device_Extension *tw_dev, int no_check_reset)
 
 	/* Initialize sglist */
 	memset(&sglist, 0, sizeof(TW_SG_Entry));
-	sglist[0].length = TW_SECTOR_SIZE;
-	sglist[0].address = tw_dev->generic_buffer_phys[request_id];
+	sglist[0].length = cpu_to_le32(TW_SECTOR_SIZE);
+	sglist[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
 
-	if (sglist[0].address & TW_ALIGNMENT_9000_SGL) {
+	if (tw_dev->generic_buffer_phys[request_id] & TW_ALIGNMENT_9000_SGL) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1, "Found unaligned address during AEN drain");
 		goto out;
 	}
@@ -440,8 +440,8 @@ static int twa_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
 
 	/* Initialize sglist */
 	memset(&sglist, 0, sizeof(TW_SG_Entry));
-	sglist[0].length = TW_SECTOR_SIZE;
-	sglist[0].address = tw_dev->generic_buffer_phys[request_id];
+	sglist[0].length = cpu_to_le32(TW_SECTOR_SIZE);
+	sglist[0].address = TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
 
 	/* Mark internal command */
 	tw_dev->srb[request_id] = NULL;
@@ -501,9 +501,8 @@ static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
            Sunday 12:00AM */
 	local_time = (ktime_get_real_seconds() - (sys_tz.tz_minuteswest * 60));
 	div_u64_rem(local_time - (3 * 86400), 604800, &schedulertime);
-	schedulertime = cpu_to_le32(schedulertime % 604800);
 
-	memcpy(param->data, &schedulertime, sizeof(u32));
+	memcpy(param->data, &(__le32){cpu_to_le32(schedulertime)}, sizeof(__le32));
 
 	/* Mark internal command */
 	tw_dev->srb[request_id] = NULL;
@@ -1000,19 +999,13 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
 		if (print_host)
 			printk(KERN_WARNING "3w-9xxx: scsi%d: ERROR: (0x%02X:0x%04X): %s:%s.\n",
 			       tw_dev->host->host_no,
-			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
-			       full_command_packet->header.status_block.error,
-			       error_str[0] == '\0' ?
-			       twa_string_lookup(twa_error_table,
-						 full_command_packet->header.status_block.error) : error_str,
+			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR, error,
+			       error_str[0] ? error_str : twa_string_lookup(twa_error_table, error),
 			       full_command_packet->header.err_specific_desc);
 		else
 			printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s:%s.\n",
-			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
-			       full_command_packet->header.status_block.error,
-			       error_str[0] == '\0' ?
-			       twa_string_lookup(twa_error_table,
-						 full_command_packet->header.status_block.error) : error_str,
+			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR, error,
+			       error_str[0] ? error_str : twa_string_lookup(twa_error_table, error),
 			       full_command_packet->header.err_specific_desc);
 	}
 
@@ -1129,12 +1122,11 @@ static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
 	tw_initconnect->opcode__reserved = TW_OPRES_IN(0, TW_OP_INIT_CONNECTION);
 	tw_initconnect->request_id = request_id;
 	tw_initconnect->message_credits = cpu_to_le16(message_credits);
-	tw_initconnect->features = set_features;
 
 	/* Turn on 64-bit sgl support if we need to */
-	tw_initconnect->features |= sizeof(dma_addr_t) > 4 ? 1 : 0;
+	set_features |= sizeof(dma_addr_t) > 4 ? 1 : 0;
 
-	tw_initconnect->features = cpu_to_le32(tw_initconnect->features);
+	tw_initconnect->features = cpu_to_le32(set_features);
 
 	if (set_features & TW_EXTENDED_INIT_CONNECT) {
 		tw_initconnect->size = TW_INIT_COMMAND_PACKET_SIZE_EXTENDED;
@@ -1347,8 +1339,10 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 
 				/* Report residual bytes for single sgl */
 				if ((scsi_sg_count(cmd) <= 1) && (full_command_packet->command.newcommand.status == 0)) {
-					if (full_command_packet->command.newcommand.sg_list[0].length < scsi_bufflen(tw_dev->srb[request_id]))
-						scsi_set_resid(cmd, scsi_bufflen(cmd) - full_command_packet->command.newcommand.sg_list[0].length);
+					u32 length = le32_to_cpu(full_command_packet->command.newcommand.sg_list[0].length);
+
+					if (length < scsi_bufflen(cmd))
+						scsi_set_resid(cmd, scsi_bufflen(cmd) - length);
 				}
 
 				/* Now complete the io */
@@ -1390,13 +1384,13 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 	if (TW_OP_OUT(full_command_packet->command.newcommand.opcode__reserved) == TW_OP_EXECUTE_SCSI) {
 		newcommand = &full_command_packet->command.newcommand;
 		newcommand->request_id__lunl =
-			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id));
+			TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id);
 		if (length) {
 			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
 			newcommand->sg_list[0].length = cpu_to_le32(length);
 		}
 		newcommand->sgl_entries__lunh =
-			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), length ? 1 : 0));
+			TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), length ? 1 : 0);
 	} else {
 		oldcommand = &full_command_packet->command.oldcommand;
 		oldcommand->request_id = request_id;
@@ -1837,10 +1831,10 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 	if (srb) {
 		command_packet->unit = srb->device->id;
 		command_packet->request_id__lunl =
-			cpu_to_le16(TW_REQ_LUN_IN(srb->device->lun, request_id));
+			TW_REQ_LUN_IN(srb->device->lun, request_id);
 	} else {
 		command_packet->request_id__lunl =
-			cpu_to_le16(TW_REQ_LUN_IN(0, request_id));
+			TW_REQ_LUN_IN(0, request_id);
 		command_packet->unit = 0;
 	}
 
@@ -1872,19 +1866,19 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 					}
 				}
 			}
-			command_packet->sgl_entries__lunh = cpu_to_le16(TW_REQ_LUN_IN((srb->device->lun >> 4), scsi_sg_count(tw_dev->srb[request_id])));
+			command_packet->sgl_entries__lunh = TW_REQ_LUN_IN((srb->device->lun >> 4), scsi_sg_count(tw_dev->srb[request_id]));
 		}
 	} else {
 		/* Internal cdb post */
 		for (i = 0; i < use_sg; i++) {
-			command_packet->sg_list[i].address = TW_CPU_TO_SGL(sglistarg[i].address);
-			command_packet->sg_list[i].length = cpu_to_le32(sglistarg[i].length);
+			command_packet->sg_list[i].address = sglistarg[i].address;
+			command_packet->sg_list[i].length = sglistarg[i].length;
 			if (command_packet->sg_list[i].address & TW_CPU_TO_SGL(TW_ALIGNMENT_9000_SGL)) {
 				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2f, "Found unaligned sgl address during internal post");
 				goto out;
 			}
 		}
-		command_packet->sgl_entries__lunh = cpu_to_le16(TW_REQ_LUN_IN(0, use_sg));
+		command_packet->sgl_entries__lunh = TW_REQ_LUN_IN(0, use_sg);
 	}
 
 	if (srb) {
@@ -2109,7 +2103,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 				     TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
 	       (char *)twa_get_param(tw_dev, 1, TW_VERSION_TABLE,
 				     TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
-	       le32_to_cpu(*(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
+	       le32_to_cpu(*(__le32 *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
 				     TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH)));
 
 	/* Try to enable MSI */
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index d88cd3499bd5..d258bc8fe9b0 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -434,8 +434,8 @@ static twa_message_type twa_error_table[] = {
 #define TW_RESID_OUT(x) ((x >> 4) & 0xff)
 
 /* request_id: 12, lun: 4 */
-#define TW_REQ_LUN_IN(lun, request_id) (((lun << 12) & 0xf000) | (request_id & 0xfff))
-#define TW_LUN_OUT(lun) ((lun >> 12) & 0xf)
+#define TW_REQ_LUN_IN(lun, request_id) cpu_to_le16(((lun << 12) & 0xf000) | (request_id & 0xfff))
+#define TW_LUN_OUT(lun) ((le16_to_cpu(lun) >> 12) & 0xf)
 
 /* Macros */
 #define TW_CONTROL_REG_ADDR(x) (x->base_addr)
@@ -469,70 +469,78 @@ printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s.\n",a,b,c); \
 #define TW_APACHE_MAX_SGL_LENGTH (sizeof(dma_addr_t) > 4 ? 72 : 109)
 #define TW_ESCALADE_MAX_SGL_LENGTH (sizeof(dma_addr_t) > 4 ? 41 : 62)
 #define TW_PADDING_LENGTH (sizeof(dma_addr_t) > 4 ? 8 : 0)
-#define TW_CPU_TO_SGL(x) (sizeof(dma_addr_t) > 4 ? cpu_to_le64(x) : cpu_to_le32(x))
+#if IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT)
+#define TW_CPU_TO_SGL(x) cpu_to_le64(x)
+#else
+#define TW_CPU_TO_SGL(x) cpu_to_le32(x)
+#endif
 
 #pragma pack(1)
 
 /* Scatter Gather List Entry */
 typedef struct TAG_TW_SG_Entry {
-	dma_addr_t address;
-	u32 length;
+#if IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT)
+	__le64	address;
+#else
+	__le32	address;
+#endif
+	__le32	length;
 } TW_SG_Entry;
 
 /* Command Packet */
 typedef struct TW_Command {
-	unsigned char opcode__sgloffset;
-	unsigned char size;
-	unsigned char request_id;
-	unsigned char unit__hostid;
+	u8	opcode__sgloffset;
+	u8	size;
+	u8	request_id;
+	u8	unit__hostid;
 	/* Second DWORD */
-	unsigned char status;
-	unsigned char flags;
+	u8	status;
+	u8	flags;
 	union {
-		unsigned short block_count;
-		unsigned short parameter_count;
+		__le16	block_count;
+		__le16	parameter_count;
 	} byte6_offset;
 	union {
 		struct {
-			u32 lba;
-			TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
-			dma_addr_t padding;
+			__le32		lba;
+			TW_SG_Entry	sgl[TW_ESCALADE_MAX_SGL_LENGTH];
+			dma_addr_t	padding;
 		} io;
 		struct {
-			TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
-			u32 padding;
-			dma_addr_t padding2;
+			TW_SG_Entry	sgl[TW_ESCALADE_MAX_SGL_LENGTH];
+			__le32		padding;
+			dma_addr_t	padding2;
 		} param;
 	} byte8_offset;
 } TW_Command;
 
 /* Command Packet for 9000+ controllers */
 typedef struct TAG_TW_Command_Apache {
-	unsigned char opcode__reserved;
-	unsigned char unit;
-	unsigned short request_id__lunl;
-	unsigned char status;
-	unsigned char sgl_offset;
-	unsigned short sgl_entries__lunh;
-	unsigned char cdb[16];
+	u8	opcode__reserved;
+	u8	unit;
+	__le16	request_id__lunl;
+	u8	status;
+	u8	sgl_offset;
+	__le16	sgl_entries__lunh;
+	u8	cdb[16];
 	TW_SG_Entry sg_list[TW_APACHE_MAX_SGL_LENGTH];
-	unsigned char padding[TW_PADDING_LENGTH];
+	u8	padding[TW_PADDING_LENGTH];
 } TW_Command_Apache;
 
 /* New command packet header */
 typedef struct TAG_TW_Command_Apache_Header {
 	unsigned char sense_data[TW_SENSE_DATA_LENGTH];
 	struct {
-		char reserved[4];
-		unsigned short error;
-		unsigned char padding;
-		unsigned char severity__reserved;
+		u8	reserved[4];
+		__le16	error;
+		u8	padding;
+		u8	severity__reserved;
 	} status_block;
 	unsigned char err_specific_desc[98];
 	struct {
-		unsigned char size_header;
-		unsigned short reserved;
-		unsigned char size_sense;
+		u8	size_header;
+		__le16	reserved;
+		u8	size_sense;
 	} header_desc;
 } TW_Command_Apache_Header;
 
@@ -547,19 +555,19 @@ typedef struct TAG_TW_Command_Full {
 
 /* Initconnection structure */
 typedef struct TAG_TW_Initconnect {
-	unsigned char opcode__reserved;
-	unsigned char size;
-	unsigned char request_id;
-	unsigned char res2;
-	unsigned char status;
-	unsigned char flags;
-	unsigned short message_credits;
-	u32 features;
-	unsigned short fw_srl;
-	unsigned short fw_arch_id;
-	unsigned short fw_branch;
-	unsigned short fw_build;
-	u32 result;
+	u8	opcode__reserved;
+	u8	size;
+	u8	request_id;
+	u8	res2;
+	u8	status;
+	u8	flags;
+	__le16	message_credits;
+	__le32	features;
+	__le16	fw_srl;
+	__le16	fw_arch_id;
+	__le16	fw_branch;
+	__le16	fw_build;
+	__le32	result;
 } TW_Initconnect;
 
 /* Event info structure */
@@ -600,11 +608,11 @@ typedef struct TAG_TW_Lock {
 
 /* GetParam descriptor */
 typedef struct {
-	unsigned short	table_id;
-	unsigned short	parameter_id;
-	unsigned short	parameter_size_bytes;
-	unsigned short  actual_parameter_size_bytes;
-	unsigned char	data[1];
+	__le16	table_id;
+	__le16	parameter_id;
+	__le16	parameter_size_bytes;
+	__le16  actual_parameter_size_bytes;
+	u8	data[1];
 } TW_Param_Apache, *PTW_Param_Apache;
 
 /* Response queue */
-- 
2.26.2

