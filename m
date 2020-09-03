Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF143C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84F942072A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sholland.org header.i=@sholland.org header.b="J8uMl5op";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aW6AIcNH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgICDo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:44:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58309 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbgICDoy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:44:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 015B75C01ED;
        Wed,  2 Sep 2020 23:44:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Sep 2020 23:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=CzDMzrx7Uon4Y
        51DrS7UpU2Heup60DvL4sgkL20Fbjg=; b=J8uMl5opwoW/OmMJ4G60dbmqURcY1
        RChqN5dCqgT8WrbMamabLIIq1LcjGrPyD292o76PvFvllN9+p9ewG+8xkhBhlgkh
        BWvziYapMaSzpNEeYWsUI+TTBJYWJetFV5apu4bAiNqCihaj8RdOjfLI2wcnzT4C
        SRUockgMs+u5pbe9AOWLuRTLGxZ/ugKCMtMhNN8r4IJ8C2cy3ZqiAJ53dIiOH2Hb
        M01zubZPNbLjaNPld8Ni6gSwrw4CHFzBeEBOyTyC5eJqcl4h0PAThiqIzQtvd/8E
        TZOEt6N//FRy7tXrFFa8K6UA+XvtZ//iqOECHmABqt70jn1/x7xmfW4tw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=CzDMzrx7Uon4Y51DrS7UpU2Heup60DvL4sgkL20Fbjg=; b=aW6AIcNH
        xgPVfcBveaxPlh8CcS3lCrH3Sye199wZUcKtA5BziVivX00BEjpab0D/NoIL/OqL
        VSu0xTn7PjbNd1YCsBca03LXgKYUivPd7DIth5iuOzYxzzfgeNuZwCkU0bZ2RWNL
        jLeLGfTtvU6GEXvANXVsOVbVmEAfTidY6ak294Bkl36k078ki9z+xNmD+z52AmJc
        caOMk9NgGerom7CtYLotfHpzUY4iQmQqgOx5ddaLDfODtF5dsTyEsnWibDnqONQm
        wxKHZizDcjh0MJ41brraloJoHKRl1dJUUggSqFyl+sEIc3LMG4+jrmu5DwgJofhi
        uQ/nH02NNKv7wQ==
X-ME-Sender: <xms:tGZQX6z6XD7v6H-Rx1aoEloMCiHPjdpLXQEzFYAbjTVexdKbmRwNrw>
    <xme:tGZQX2RfU52C9uIIMZEKj2uF87HoxHKc2cW1XABVLe-ftgIFmPIbiHkH92hQaEs9j
    gFmoTd-pHPgq58wVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegtddgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:tGZQX8XNw4MYfvF0GlL8ozDqJgiGqW321FKWh_C1fBWPKlC3Zqamew>
    <xmx:tGZQXwgHvdF4wM2O6k-LEqDbwLK7HkAiT2v3NuOgxZa0eKSQkuRRqg>
    <xmx:tGZQX8DycMmUDldtdGBE9xeqMTYpcKDP3uxcZRF4aufHB7Nzh74GOQ>
    <xmx:tGZQX75JPP5irkQWFztHg-SGDBb1LjbLVbmto_r3f_khHA8u9sU-uw>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id D011B30600A3;
        Wed,  2 Sep 2020 23:44:51 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>
Subject: [PATCH v4 2/3] scsi: 3w-9xxx: Reduce scope of structure packing
Date:   Wed,  2 Sep 2020 22:44:49 -0500
Message-Id: <20200903034450.5491-2-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200903034450.5491-1-samuel@sholland.org>
References: <20200903034450.5491-1-samuel@sholland.org>
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

Changes since v3: None.

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

