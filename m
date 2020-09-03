Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B006FC433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86BF42078E
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:45:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="ncEEIHoq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="En7xihk/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgICDo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:44:57 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46943 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726686AbgICDoy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:44:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 015775C01E6;
        Wed,  2 Sep 2020 23:44:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Sep 2020 23:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=+9t662V001TgRGCCG56jM+Z/YQ
        k7ENVjdwqNyvtMt08=; b=ncEEIHoq2AjQY7yVVJwctMiONp9DMKYtGlsEjV+no+
        Pb1qtMFvd0ckYLBcMugc8VTnpWaOwIvrb4n9yXpJmShC4cSsIQoLx1wNoRHu6M9n
        2ZsNh8frkUr7eKjnpW+9H905itNXn1oTT275l7k5TIaDUCNS6aIi10HUtFYI/KZV
        +nFidQWFExNmaXa1lLfgqQsdqzP9TVHvWQSKVmcejZYBjGat29JrUXRnLRRqPr1k
        ivap7t/WSf3RPmN41remLxip/pz53kpLxzB+SkrHBnGy0pcTYAXqLHScHPxn0tSj
        c8LCsZyWyT98iUKSCgZRVdQnXzMjloa9S3Q96Cf2/Dhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+9t662V001TgRGCCG
        56jM+Z/YQk7ENVjdwqNyvtMt08=; b=En7xihk/JdEQlGCehutY2nWWwnJxqnebU
        KyoT/M+BvwrrGwXhCQeHfx9Lp0MpYeVIjwegS5DA15QjGiPHlztRvBeFMgKJbnU2
        D5sSGGq8bGM0ztDbwDi8rcP7NSFiqytt3831NNTwS0+NH2u1SVJLLn6e417IucYc
        tVzy96Mi6tlDxi/IvTaRy368dWY+MnBBePIiA/eh4PTMBkieLwJqC2E3Byz/8B1J
        9nho/nRy0NIFVpqmqJZ0D8ouEAjonQ30HW8vFjSIZaRGH6+Z/dR21/IjSxiV9SOG
        htCThY06a8Z2ctB+HM1zftqZ2M+itrKgbp2sEWCAvHGLDh8uUoSig==
X-ME-Sender: <xms:s2ZQX0lBpgjvIJpsuzpebcml88UtbpJsdAev4D9DWsW7DxvUWtYHtw>
    <xme:s2ZQXz1-s9KK-bO4a9OebiWW_d87eDNlY3cPocI5k5mD4gM9CG2GrxvDpYxmej1LT
    ot5MK0V6pPrSf1EzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegtddgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgvlhcu
    jfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtffrrg
    htthgvrhhnpeeiteekhfehuddugfeltddufeejjeefgeevheekueffhffhjeekheeiffdt
    vedtveenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghnugdr
    ohhrgh
X-ME-Proxy: <xmx:s2ZQXyrmczd2stHlXkHCcNk6lslNlWqkW-lgOdMqgSw_swAlbdJq9A>
    <xmx:s2ZQXwkovpzyiXvVgn4tE9bCSFeD8VCSCLEv8M717ahmrJEkjBaDNw>
    <xmx:s2ZQXy3mfoc7cTb6rKSBrb8RiiuZYeV63BBTckTU4E934oGLsSxuwQ>
    <xmx:tGZQX-9qfDQoIW9np7-6wyk0AryePHqHxQmPx6jFocUbYvE-D9AGPw>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 751C23060067;
        Wed,  2 Sep 2020 23:44:51 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>
Subject: [PATCH v4 1/3] scsi: 3w-9xxx: Use flexible array members to avoid struct padding
Date:   Wed,  2 Sep 2020 22:44:48 -0500
Message-Id: <20200903034450.5491-1-samuel@sholland.org>
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

Changes since v3:
  - Consistently put sizeof(TW_Ioctl_Buf_Apache) before buffer_length.

---
 drivers/scsi/3w-9xxx.c | 16 ++++++++++------
 drivers/scsi/3w-9xxx.h |  4 ++--
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3337b1e80412..aad9b3b73e15 100644
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

