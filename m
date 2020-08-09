Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EF3C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C2A4206E9
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 00:47:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="Iir0dFwP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lrcf5fgM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgHIArd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 20:47:33 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:34409 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgHIArb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 20:47:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 53FB2CA9;
        Sat,  8 Aug 2020 20:47:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 08 Aug 2020 20:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=Mn8s8HELX6iUo
        XJ3vp/fngCnCG9DaoUlYlPOAfNoKMc=; b=Iir0dFwP4K6hGE5VWd03eLZetfF7L
        +DOhq+R0XnskLvp4kagVktY9jZGJv7lAyQe6Fi+V1G2+UXpgwOPqbirqBvkkeC4G
        qBeEBTFV9GrELDWDT/TB7pHpvPxIDZznlPvwnlFps2lx8X8/2S/6GRcrOsxXInEk
        VAmqDXybdaGdJYqWliLyo8Y0ADZm1GVZUYpHg7yFXqUZqJILkn1Er1sujUL1uh6E
        Du+wbg20TJ0FH4okndHsoF0if3ybKFZV9YnSQcYMtqcMjrmJ6VgIyE9u9J2UosiA
        oLFTiSrk4oiC4g80AHvP+Kx2e7AyFKO6nI31d7Q8M6k1+lm4IcvZfrXug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Mn8s8HELX6iUoXJ3vp/fngCnCG9DaoUlYlPOAfNoKMc=; b=lrcf5fgM
        EIXWvgsieGC5cGvHKr3TX96UYrfgtX6VcaR91fy5Ly7EpGOoC6ahUjfpBThMtTHN
        dsWeA8jv5RrXWxCpnGpnZzSSR9EK5WazhoQDmiVnt10Lt7HItAWJvW0yYp0G+CEN
        a/fUgbc25f5uBR30QD7MbymkyFt4VxJ0qK4iBi/oMtbTuEdj5FboABQjXK9wBr4G
        TXB8IKWRcf26l85RgCCJqEG7lEJJdOUKx51tZEScelraBk4mU0lR2yKMTMtQmOM6
        SJ1yvbhaVJsb4cdF6gjpimRb+H8mbOEk5vPxmjW+Vmx7jMhoWzTd3+oqQGwU3xPK
        LNChQZ1oSS3xPw==
X-ME-Sender: <xms:oUcvXyNnjcoHJ-8xEY3U1cCJPY-HTSjVmvC7Jpap_464g5oniwFFOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeehgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:oUcvXw94GP_HZdavlnw5bQAz1rELv_fvCJeIaxmjrkprF_sk3RjW-Q>
    <xmx:oUcvX5TwfEDtbKaMI260w9ONcciYYsxJkR7LRHrjiAkkJbA983LQ4w>
    <xmx:oUcvXyvTqhr5ySnmHo-EL_ynmBvSioQ1JCCwPX_n9blMXlr_TSzi8Q>
    <xmx:oUcvX6625zYFx9FCZGivq3IFXX3SiXFjFI44he6BOvvHahNimOHT9A>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1824130600A9;
        Sat,  8 Aug 2020 20:47:29 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>
Subject: [PATCH v3 2/3] scsi: 3w-9xxx: Reduce scope of structure packing
Date:   Sat,  8 Aug 2020 19:47:26 -0500
Message-Id: <20200809004727.53107-2-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200809004727.53107-1-samuel@sholland.org>
References: <20200809004727.53107-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
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
index e65dafda2e3e..36b865eca67d 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -471,13 +471,17 @@ printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s.\n",a,b,c); \
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
@@ -496,12 +500,12 @@ typedef struct TW_Command {
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
@@ -531,7 +535,7 @@ typedef struct TAG_TW_Command_Apache_Header {
 	unsigned char err_specific_desc[98];
 	struct {
 		unsigned char size_header;
-		unsigned short reserved;
+		unsigned char reserved[2];
 		unsigned char size_sense;
 	} header_desc;
 } TW_Command_Apache_Header;
@@ -631,8 +635,6 @@ typedef struct TAG_TW_Compatibility_Info
 	unsigned short fw_on_ctlr_build;
 } TW_Compatibility_Info;
 
-#pragma pack()
-
 typedef struct TAG_TW_Device_Extension {
 	u32                     __iomem *base_addr;
 	unsigned long	       	*generic_buffer_virt[TW_Q_LENGTH];
-- 
2.26.2

