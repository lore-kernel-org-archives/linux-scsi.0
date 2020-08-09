Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F8CC433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BC8F206C0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="oZ03+dYC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mTaQXb3E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHIArd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 20:47:33 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50227 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726250AbgHIArb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 20:47:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4E5D7CA4;
        Sat,  8 Aug 2020 20:47:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 08 Aug 2020 20:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=tVNBLqxnXkBqRSvx4taVgNcu0A
        nLZcVxBn31KJJTrt8=; b=oZ03+dYC/bTPte2jvFhOeUimOPDWCmC5b48HOqi6Gf
        yaWqrQ9HieG1msVO5jaljXSC0yrzvRxdT/ck1aEbOjSmpoSGvcS2cjl1GFNj6fa7
        CT5bSkbpGTNT7twPBaaAsnAX+r5RnhN2kJEx3QLDUlvchAYzBBEFHv4SiPZXmk96
        JtxmfuF18yKs24mi13rXVkKWwrvL5uzWZtEx3HSxUbzfpOvuWZD4gssjTExBSzpV
        RAuq6cyIMQ9utn6A8sbcnkYOil0nrMGPqTAZ0fWWYkjQhrOGP2WL2SJG4W2sIIOm
        g3ycV1M4S8lYTn2QhBheTHD7qWbtsEyawRPP8kbwAI1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tVNBLqxnXkBqRSvx4
        taVgNcu0AnLZcVxBn31KJJTrt8=; b=mTaQXb3E59ATJB8tWFJopq3/QI8OpBmA+
        vQBap52zxbLXV0puXkDTfaFc0ufLsTUjDIxReH3FQIiiSTR+3nb2xWCnqFhS4nFH
        ZuyPjOsmsFJC6zqgLDKRtPk8vIQtIaCt9FFLLf2CMOmF+TQFknusBZG3yoRlNZJs
        4lqfY64TjqfRHD+HKkoNXidkbTQM9rWm7TEhH5uZCSW8Qxr20m+dL12jlgYxXrrN
        Z8QVWnwBv/ZpEfvEeTNmjZPKmhiXXpjV/YUJCMYAHSfPnItS/LlkZ0sNLWxxreuG
        kYIo1urPI1wfo5zXjji9AWcoV49TmGwhkXHFPPlj/s10TCBdrgwrA==
X-ME-Sender: <xms:oUcvX1SjGK9FmucWANai4c8OSODVEQC_WRXbV9tM3kjmdnqpv8au1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeehgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghlucfj
    ohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrfgrth
    htvghrnhepieetkefhheduudfgledtudefjeejfeegveehkeeufffhhfejkeehiefftdev
    tdevnecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdho
    rhhg
X-ME-Proxy: <xmx:oUcvX-weoWGJ0bD_wZnnBwwjavhuHu2lEb5DU-nsfpeMXrYf9xSIrw>
    <xmx:oUcvX62KUnRCYwcZa59XAYlQL1MdqQmsoFIAjKOmuXOt9sJOYYAR2Q>
    <xmx:oUcvX9DlG9JDOuz6DrYiIkdd6QQH05YeLqzleGmj01wze-VUe9b0xQ>
    <xmx:oUcvX_s2-_LQP8s44j-7i4tDrKGrupz7Gtt7u-_JB5Gpg7_feL36MQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id B54D430600A3;
        Sat,  8 Aug 2020 20:47:28 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>
Subject: [PATCH v3 1/3] scsi: 3w-9xxx: Use flexible array members to avoid struct padding
Date:   Sat,  8 Aug 2020 19:47:25 -0500
Message-Id: <20200809004727.53107-1-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for removing the "#pragma pack(1)" from the driver, fix
all instances where a trailing array member could be replaced by a
flexible array member. Since a flexible array member has zero size, it
introduces no padding, whether or not the struct is packed.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/scsi/3w-9xxx.c | 12 ++++++------
 drivers/scsi/3w-9xxx.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..ec7859f071ac 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -676,7 +676,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	data_buffer_length_adjusted = (driver_command.buffer_length + 511) & ~511;
 
 	/* Now allocate ioctl buf memory */
-	cpu_addr = dma_alloc_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_Ioctl_Buf_Apache) - 1, &dma_handle, GFP_KERNEL);
+	cpu_addr = dma_alloc_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted + sizeof(TW_Ioctl_Buf_Apache), &dma_handle, GFP_KERNEL);
 	if (!cpu_addr) {
 		retval = TW_IOCTL_ERROR_OS_ENOMEM;
 		goto out2;
@@ -685,7 +685,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	tw_ioctl = (TW_Ioctl_Buf_Apache *)cpu_addr;
 
 	/* Now copy down the entire ioctl */
-	if (copy_from_user(tw_ioctl, argp, driver_command.buffer_length + sizeof(TW_Ioctl_Buf_Apache) - 1))
+	if (copy_from_user(tw_ioctl, argp, driver_command.buffer_length + sizeof(TW_Ioctl_Buf_Apache)))
 		goto out3;
 
 	/* See which ioctl we are doing */
@@ -867,11 +867,11 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	}
 
 	/* Now copy the entire response to userspace */
-	if (copy_to_user(argp, tw_ioctl, sizeof(TW_Ioctl_Buf_Apache) + driver_command.buffer_length - 1) == 0)
+	if (copy_to_user(argp, tw_ioctl, sizeof(TW_Ioctl_Buf_Apache) + driver_command.buffer_length) == 0)
 		retval = 0;
 out3:
 	/* Now free ioctl buf memory */
-	dma_free_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_Ioctl_Buf_Apache) - 1, cpu_addr, dma_handle);
+	dma_free_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted + sizeof(TW_Ioctl_Buf_Apache), cpu_addr, dma_handle);
 out2:
 	mutex_unlock(&tw_dev->ioctl_lock);
 out:
@@ -1392,7 +1392,7 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 		newcommand->request_id__lunl =
 			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id));
 		if (length) {
-			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
+			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
 			newcommand->sg_list[0].length = cpu_to_le32(length);
 		}
 		newcommand->sgl_entries__lunh =
@@ -1407,7 +1407,7 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 				sgl = (TW_SG_Entry *)((u32 *)oldcommand+oldcommand->size - (sizeof(TW_SG_Entry)/4) + pae);
 			else
 				sgl = (TW_SG_Entry *)((u32 *)oldcommand+TW_SGL_OUT(oldcommand->opcode__sgloffset));
-			sgl->address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
+			sgl->address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
 			sgl->length = cpu_to_le32(length);
 
 			oldcommand->size += pae;
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index d88cd3499bd5..e65dafda2e3e 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -588,7 +588,7 @@ typedef struct TAG_TW_Ioctl_Apache {
 	TW_Ioctl_Driver_Command driver_command;
         char padding[488];
 	TW_Command_Full firmware_command;
-	char data_buffer[1];
+	char data_buffer[];
 } TW_Ioctl_Buf_Apache;
 
 /* Lock structure for ioctl get/release lock */
@@ -604,7 +604,7 @@ typedef struct {
 	unsigned short	parameter_id;
 	unsigned short	parameter_size_bytes;
 	unsigned short  actual_parameter_size_bytes;
-	unsigned char	data[1];
+	unsigned char	data[];
 } TW_Param_Apache, *PTW_Param_Apache;
 
 /* Response queue */
-- 
2.26.2

