Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881D3C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 23:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0FF61410
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 23:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239552AbhD1AAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 20:00:07 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:38867 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239535AbhD1AAG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 20:00:06 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 23A21FA3;
        Tue, 27 Apr 2021 19:59:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 27 Apr 2021 19:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=rdB4VZECAetI/
        k4OxmuScrxfAJ5N9y5MQdFQlFzSYFw=; b=GC0TBarNXQ0TUXzvL0o0m984Xv0ZX
        YULS9KnidiFbDrLjIEbQ95HgRamDxuNIg1YARdvQ6h4UsyNrzqSJQ8FFIM49EaaL
        fTkFjI0CNhTD4BWfJs9/VucD7uXS2Jo7j4EWUMYGMqM9sGun1vyb25nIulwKx5Ga
        9Cv1XtyBWzSJufU9jcxRunsAaEYp5MsqTBMVpETRAkG+3jkeWTVlx5xJRQBfD4Lk
        NSbOMsUyfiaXbBkxrmpV/56jjTOcrvxtFAP61YXU5TGc0SU2oCjMMrzVBX8QI/la
        d909ypdaCLQnbYnOltJxMNlmQbs+SPSovNDWxZ6HMAHfoAf8oSkiA46jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=rdB4VZECAetI/k4OxmuScrxfAJ5N9y5MQdFQlFzSYFw=; b=hnfgQnlR
        YSZ5IQT6OuB3IawVi25aOe+rdRYl50ovub5q9eYt4QZ1xPR2rGPWNctUYTGOWeGX
        vddufpMXaln9rq+2C7J24ki75dhzHXkz1OhrfxFQjBjAaqa4SW5dYVH2QQsOMlyf
        8GY5ZOZOsI984FL0YJfcZtcHFCaM5kk9KfVMcQn7yZFMoauMW6kis8n38iHes+4r
        76vIeS4zCo0TpjIMHuUsnIE2O2dQS7tvOvpC9hm2ixXMxFbpYjFAgVMXhjSXtJ/W
        qTFlpUuelZfdNGkzqeRSOf9aD/sdumGHzt5r6fuISHeCBmjKPq8jxMXccGSLHgOS
        0xoIBhmoXTZqaQ==
X-ME-Sender: <xms:WaWIYMHDFOg2XUP2gQ0i5UfbhfcvUZEgvw9eQD6L7kr6qG9eM1YcrQ>
    <xme:WaWIYFXbmJQEBD-H4xgPkc9I05WGiaszlKVN9s5oEUCTlufUnhQXIuQbYancmKsLD
    cTBXBeyhyijWgb1Kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddvuddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:WaWIYGIZ4HmFqPn2S2nWPFDcMuNU4ZauRGeTDqnJeuQh7nnX9V9e_w>
    <xmx:WaWIYOFGdOJ0mMm16bJ3sN37lEzUms0NkxZDo5ByR6i2rw-rgb_zrA>
    <xmx:WaWIYCUY4JSZFhPY7gQLoSEVUYVJWvXfODLapWjETDH0_TCfOdT-dA>
    <xmx:WaWIYEfSp4TwmJL65ZU3i5YzwD6ahJsaoemNf_04yr3Gy9zGpfYKFA>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 27 Apr 2021 19:59:21 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adam Radford <aradford@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, Samuel Holland <samuel@sholland.org>
Subject: [PATCH v5 2/3] scsi: 3w-9xxx: Reduce scope of structure packing
Date:   Tue, 27 Apr 2021 18:59:14 -0500
Message-Id: <20210427235915.39211-3-samuel@sholland.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210427235915.39211-1-samuel@sholland.org>
References: <20210427235915.39211-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, all command packet structs used by this driver are packed.
However, only one (TW_SG_Entry) actually needs to be packed, because it
uses 64-bit addresses at 32-bit alignment. To improve the quality of
generated code, stop packing all of the other command packet structs.
This requires adjusting the type of one misaligned "reserved" member.

After this change, pahole reports that only one type had its layout
change: the tw_compat_info member of TW_Device_Extension is now
naturally aligned.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/scsi/3w-9xxx.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index f93795164d7d..b9c99a2f3b65 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -485,13 +485,17 @@ printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s.\n",a,b,c); \
 #define TW_PADDING_LENGTH (sizeof(dma_addr_t) > 4 ? 8 : 0)
 #define TW_CPU_TO_SGL(x) (sizeof(dma_addr_t) > 4 ? cpu_to_le64(x) : cpu_to_le32(x))
 
-#pragma pack(1)
+#if IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT)
+typedef u64 twa_addr_t;
+#else
+typedef u32 twa_addr_t;
+#endif
 
 /* Scatter Gather List Entry */
 typedef struct TAG_TW_SG_Entry {
-	dma_addr_t address;
+	twa_addr_t address;
 	u32 length;
-} TW_SG_Entry;
+} __packed TW_SG_Entry;
 
 /* Command Packet */
 typedef struct TW_Command {
@@ -510,12 +514,12 @@ typedef struct TW_Command {
 		struct {
 			u32 lba;
 			TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
-			dma_addr_t padding;
+			twa_addr_t padding;
 		} io;
 		struct {
 			TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
 			u32 padding;
-			dma_addr_t padding2;
+			twa_addr_t padding2;
 		} param;
 	} byte8_offset;
 } TW_Command;
@@ -545,7 +549,7 @@ typedef struct TAG_TW_Command_Apache_Header {
 	unsigned char err_specific_desc[98];
 	struct {
 		unsigned char size_header;
-		unsigned short reserved;
+		unsigned char reserved[2];
 		unsigned char size_sense;
 	} header_desc;
 } TW_Command_Apache_Header;
@@ -645,8 +649,6 @@ typedef struct TAG_TW_Compatibility_Info
 	unsigned short fw_on_ctlr_build;
 } TW_Compatibility_Info;
 
-#pragma pack()
-
 typedef struct TAG_TW_Device_Extension {
 	u32			__iomem *base_addr;
 	unsigned long		*generic_buffer_virt[TW_Q_LENGTH];
-- 
2.26.3

