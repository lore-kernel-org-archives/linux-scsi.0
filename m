Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB14C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 23:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F94E61401
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 23:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbhD1AAF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 20:00:05 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:59819 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230368AbhD1AAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 20:00:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 7C49AFBD;
        Tue, 27 Apr 2021 19:59:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 27 Apr 2021 19:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=38C5SNIWw5R/8
        F2DG7CEJlysAhNZtMDZjUyDu8wII3E=; b=Y/FcbwSAPjYlyU8x2hQ7QV44HoTh9
        S4R2tZjZgnVnLS/JMwGQAOFVLtdaWWpanjJDJzEobQAFyrV1NjYJGTpEOnZPPDMy
        7dM/TgE8O3r/jHpBGUjA3xZeEcUVUVFeaTA52jaDlt1GRvmFvwleKHwUluCmuAdp
        DgCq5DM6zNOttpfTQKd097/jWQBoTDG+e28j5AnF52+aHL3hfSevN2mUTvnB1Iyf
        xhI5JPglyDQQDNKHRiDrGNJSvh+Lo0hzWYGJutkBoFDMAFuB+WmizrnJveqEyvjT
        aQTzUIExWX9q+dZkA9erpD0AxnQJXODRT9R0XbQxQ0OsZ1ZEEDpcueY4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=38C5SNIWw5R/8F2DG7CEJlysAhNZtMDZjUyDu8wII3E=; b=BI1YKePy
        +gFX0NyU3NOsfhJTOEgYCF739aOpAc+0XdfI2+isaY2DLVjpIBJ/gPNJZLKNcjPH
        tvnPEy9aaWw2BnUjdWfjrqoVq8Hz0fk3nfM3nCihJL/HZEtrvxBA3Tw6ve7Ip0NW
        3ZLTxLWSHEnSIpVDzffpRk/+l4Bvup1i3ql+VLoxLqXJ7qLXtxrrVqcqwqWKTowS
        DAnMb2IW1fl6hzHxnmqi/W+GwWuqIkakF2o8AtnLx5qGDQbEMbnzGzq9/qNSERB3
        UuHavysr6W+1UgKAWCuP/sa7zy8tnb3ezs+Zp4eCVRUxuSZClxD10R1WtpwZjO1l
        c/EqzzvC81X4xQ==
X-ME-Sender: <xms:WKWIYDflVHkHYoEWOD8UNxCy8u0DkpmOaePZ5CBqEFA655SUNKbTAA>
    <xme:WKWIYJMevzdX0rSqaXLlMpwB8AD8dLRA7oWtaKBNzuRLADvu4VZ1y0jenyBqDLFLO
    YGPi11MP5aH04lBMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddvuddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:WKWIYMhuvBKIQnrRQEz_Nr2ZUxy7PfnHYAcq8Bb_aIylbzCgMiknvA>
    <xmx:WKWIYE9HBhuuUlDMBqTFH6pATLZ8kObxjlC9jIA0ClqEglmENofkdA>
    <xmx:WKWIYPsa1aA7DcDwllNYZsodaflymvv8fciiDkk57GH4wFs2aHDzOQ>
    <xmx:WKWIYFVHAyFO0q0FKEX3LKMan-U-wbG3kwmmbYHnEZe6DSltZWcSag>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 27 Apr 2021 19:59:19 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adam Radford <aradford@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, Samuel Holland <samuel@sholland.org>
Subject: [PATCH v5 1/3] scsi: 3w-9xxx: Use flexible array members to avoid struct padding
Date:   Tue, 27 Apr 2021 18:59:13 -0500
Message-Id: <20210427235915.39211-2-samuel@sholland.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210427235915.39211-1-samuel@sholland.org>
References: <20210427235915.39211-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for removing the "#pragma pack(1)" from the driver, fix
all instances where a trailing array member could be replaced by a
flexible array member. Since a flexible array member has zero size, it
introduces no padding, whether or not the struct is packed.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/scsi/3w-9xxx.c | 16 ++++++++++------
 drivers/scsi/3w-9xxx.h |  4 ++--
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index b96e82de4237..36564943591e 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -676,7 +676,9 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	data_buffer_length_adjusted = (driver_command.buffer_length + 511) & ~511;
 
 	/* Now allocate ioctl buf memory */
-	cpu_addr = dma_alloc_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_Ioctl_Buf_Apache) - 1, &dma_handle, GFP_KERNEL);
+	cpu_addr = dma_alloc_coherent(&tw_dev->tw_pci_dev->dev,
+				      sizeof(TW_Ioctl_Buf_Apache) + data_buffer_length_adjusted,
+				      &dma_handle, GFP_KERNEL);
 	if (!cpu_addr) {
 		retval = TW_IOCTL_ERROR_OS_ENOMEM;
 		goto out2;
@@ -685,7 +687,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	tw_ioctl = (TW_Ioctl_Buf_Apache *)cpu_addr;
 
 	/* Now copy down the entire ioctl */
-	if (copy_from_user(tw_ioctl, argp, driver_command.buffer_length + sizeof(TW_Ioctl_Buf_Apache) - 1))
+	if (copy_from_user(tw_ioctl, argp, sizeof(TW_Ioctl_Buf_Apache) + driver_command.buffer_length))
 		goto out3;
 
 	/* See which ioctl we are doing */
@@ -867,11 +869,13 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	}
 
 	/* Now copy the entire response to userspace */
-	if (copy_to_user(argp, tw_ioctl, sizeof(TW_Ioctl_Buf_Apache) + driver_command.buffer_length - 1) == 0)
+	if (copy_to_user(argp, tw_ioctl, sizeof(TW_Ioctl_Buf_Apache) + driver_command.buffer_length) == 0)
 		retval = 0;
 out3:
 	/* Now free ioctl buf memory */
-	dma_free_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_Ioctl_Buf_Apache) - 1, cpu_addr, dma_handle);
+	dma_free_coherent(&tw_dev->tw_pci_dev->dev,
+			  sizeof(TW_Ioctl_Buf_Apache) + data_buffer_length_adjusted,
+			  cpu_addr, dma_handle);
 out2:
 	mutex_unlock(&tw_dev->ioctl_lock);
 out:
@@ -1392,7 +1396,7 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 		newcommand->request_id__lunl =
 			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id));
 		if (length) {
-			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
+			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
 			newcommand->sg_list[0].length = cpu_to_le32(length);
 		}
 		newcommand->sgl_entries__lunh =
@@ -1407,7 +1411,7 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 				sgl = (TW_SG_Entry *)((u32 *)oldcommand+oldcommand->size - (sizeof(TW_SG_Entry)/4) + pae);
 			else
 				sgl = (TW_SG_Entry *)((u32 *)oldcommand+TW_SGL_OUT(oldcommand->opcode__sgloffset));
-			sgl->address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
+			sgl->address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
 			sgl->length = cpu_to_le32(length);
 
 			oldcommand->size += pae;
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index d3f479324527..f93795164d7d 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -602,7 +602,7 @@ typedef struct TAG_TW_Ioctl_Apache {
 	TW_Ioctl_Driver_Command driver_command;
 	char padding[488];
 	TW_Command_Full firmware_command;
-	char data_buffer[1];
+	char data_buffer[];
 } TW_Ioctl_Buf_Apache;
 
 /* Lock structure for ioctl get/release lock */
@@ -618,7 +618,7 @@ typedef struct {
 	unsigned short	parameter_id;
 	unsigned short	parameter_size_bytes;
 	unsigned short  actual_parameter_size_bytes;
-	unsigned char	data[1];
+	unsigned char	data[];
 } TW_Param_Apache, *PTW_Param_Apache;
 
 /* Response queue */
-- 
2.26.3

