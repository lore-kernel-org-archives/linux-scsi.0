Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D13C433E3
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 19:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E37AF20714
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 19:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="F0Lhu1J/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="E85XbM4h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgGZTOc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 15:14:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48969 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbgGZTOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 15:14:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 085F45C00C8;
        Sun, 26 Jul 2020 15:14:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 26 Jul 2020 15:14:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=VOhMjOAiZA1wifu6qUjLj1Le2c
        cLjZ8L6RqmU8fJDw4=; b=F0Lhu1J/QbtriID4mC5qTKcyyLqhBTxa+SMyVU2C+g
        W4Yl7lD0AKEVPeYeamxZMkbUpPxMNKnUl1uKVYiu1wEgSVG9aydZuskRZvxJHNX/
        gezzDYpSxiPnZkq4sLmPrWy7FRP6d3h7kXqKM13U1OxnKX73ItrFFyI7eO/TTzpn
        AV8Vfk3wjp6G8f6H91/IwWwWccLPLkq+SdNOZ258H9VMJ1/HT9+6Qe7bQTvuzO5d
        Ad5RXuEXJb4wOM1Ed/vm80plKRzO3wQvMd9zlgUQq4Mch7xJ2t7V6XSTULl7BfPO
        uqOi3VrbFhVEYyYn+j4takQMw+PydYXrlP4qpfVSYCBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VOhMjOAiZA1wifu6q
        UjLj1Le2ccLjZ8L6RqmU8fJDw4=; b=E85XbM4hy7pnLnb+ygSQs7Z89WIIohXwQ
        AIebVeU04AZMTSxjr5JvcJUShBWF2r/vE59fU/0cS36IUZWGod+zXWZQEWVDC58A
        4gvo23QDp7wicexRQHZ3Dzroky3J0LTX4Rke3WzEdqEozQfYygqp20x9A7Avi7JO
        kAKnNB3pyZfzNPHLGIJv2WK+dJZxkkf1DF3pnYznLHjI6A8F0Fi8MH1/uNVnzGZw
        xT7ewl1444EPCh6V/b+a1HGLelP5k4F1mzG+P9BCyJVf2CXxFAqrM7bDelUd61BH
        MBdz2B62KdPlWnp8UwKTMCMLZOdcMhSUdzDfvCYIwFEhmsQ9VDpTg==
X-ME-Sender: <xms:FdYdXyAylV8-bVmXT4FrpTjuuTt_owNwiPG3THGs845xUrZcFvHF3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrheejgddufeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgvlhcu
    jfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtffrrg
    htthgvrhhnpefhgedvieeuveejuefhudfhjeevffeiveevtdejleeftefgvddufeeuleff
    gefgleenucffohhmrghinhepnhgvfigtohhmmhgrnhgurdhsghenucfkphepjedtrddufe
    ehrddugeekrdduhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:FdYdX8gzBfte9AJlglhs1gvwvQuVzRn8Z3qaMSOHPfruGS51X4vDrw>
    <xmx:FdYdX1kUfbGPccHr-a0jhuXlrHrPjJjQxYwlO6orKUCR931FIi4D-g>
    <xmx:FdYdXwwMeSeSpzE2RIqXETdnCT3b0YWuasdEKsWTv9jDRCz2_z4nGw>
    <xmx:FtYdXyd1ELv4eSLURyzwHdLuf13dJW-J5Ret4G0fV3g19Cao0sCbeQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6AA2930600A9;
        Sun, 26 Jul 2020 15:14:29 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>
Subject: [PATCH] scsi: 3w-9xxx: Fix endianness issues found by sparse
Date:   Sun, 26 Jul 2020 14:14:28 -0500
Message-Id: <20200726191428.26767-1-samuel@sholland.org>
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
 drivers/scsi/3w-9xxx.c | 35 +++++++++++++++++------------------
 drivers/scsi/3w-9xxx.h |  6 +++++-
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..95e25fda1f90 100644
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
@@ -501,7 +501,7 @@ static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
            Sunday 12:00AM */
 	local_time = (ktime_get_real_seconds() - (sys_tz.tz_minuteswest * 60));
 	div_u64_rem(local_time - (3 * 86400), 604800, &schedulertime);
-	schedulertime = cpu_to_le32(schedulertime % 604800);
+	cpu_to_le32p(&schedulertime);
 
 	memcpy(param->data, &schedulertime, sizeof(u32));
 
@@ -1004,7 +1004,7 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
 			       full_command_packet->header.status_block.error,
 			       error_str[0] == '\0' ?
 			       twa_string_lookup(twa_error_table,
-						 full_command_packet->header.status_block.error) : error_str,
+						 le16_to_cpu(full_command_packet->header.status_block.error)) : error_str,
 			       full_command_packet->header.err_specific_desc);
 		else
 			printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s:%s.\n",
@@ -1012,7 +1012,7 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
 			       full_command_packet->header.status_block.error,
 			       error_str[0] == '\0' ?
 			       twa_string_lookup(twa_error_table,
-						 full_command_packet->header.status_block.error) : error_str,
+						 le16_to_cpu(full_command_packet->header.status_block.error)) : error_str,
 			       full_command_packet->header.err_specific_desc);
 	}
 
@@ -1129,12 +1129,11 @@ static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
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
@@ -1347,8 +1346,8 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 
 				/* Report residual bytes for single sgl */
 				if ((scsi_sg_count(cmd) <= 1) && (full_command_packet->command.newcommand.status == 0)) {
-					if (full_command_packet->command.newcommand.sg_list[0].length < scsi_bufflen(tw_dev->srb[request_id]))
-						scsi_set_resid(cmd, scsi_bufflen(cmd) - full_command_packet->command.newcommand.sg_list[0].length);
+					if (le32_to_cpu(full_command_packet->command.newcommand.sg_list[0].length) < scsi_bufflen(tw_dev->srb[request_id]))
+						scsi_set_resid(cmd, scsi_bufflen(cmd) - le32_to_cpu(full_command_packet->command.newcommand.sg_list[0].length));
 				}
 
 				/* Now complete the io */
@@ -1390,13 +1389,13 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 	if (TW_OP_OUT(full_command_packet->command.newcommand.opcode__reserved) == TW_OP_EXECUTE_SCSI) {
 		newcommand = &full_command_packet->command.newcommand;
 		newcommand->request_id__lunl =
-			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id));
+			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(le16_to_cpu(newcommand->request_id__lunl)), request_id));
 		if (length) {
 			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
 			newcommand->sg_list[0].length = cpu_to_le32(length);
 		}
 		newcommand->sgl_entries__lunh =
-			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), length ? 1 : 0));
+			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(le16_to_cpu(newcommand->sgl_entries__lunh)), length ? 1 : 0));
 	} else {
 		oldcommand = &full_command_packet->command.oldcommand;
 		oldcommand->request_id = request_id;
@@ -1877,8 +1876,8 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
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
@@ -2109,7 +2108,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 				     TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
 	       (char *)twa_get_param(tw_dev, 1, TW_VERSION_TABLE,
 				     TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
-	       le32_to_cpu(*(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
+	       le32_to_cpu(*(__le32 *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
 				     TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH)));
 
 	/* Try to enable MSI */
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index d88cd3499bd5..1e0430eb3b40 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -469,7 +469,11 @@ printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s.\n",a,b,c); \
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
 
-- 
2.26.2

