Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60A8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 03:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CC3061176
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 03:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350182AbhIIDmf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 23:42:35 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:45377 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhIIDmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 23:42:35 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.west.internal (Postfix) with ESMTP id 64D1F2B00A33;
        Wed,  8 Sep 2021 23:41:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 08 Sep 2021 23:41:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:date:from:message-id:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0iHpfybu+k8g/sNOBSyHwGQalkKV65EYj9rHzeXx+ow=; b=BCvo56Sx
        UrJ3W8KC+mKIdDhUxQ/z1PZT5RlCmQM5D6w24P5nouSYC9rH6oRYUJVfhE3X9uML
        +8tS0mZyuE0WRdG4g/Fm6w3aVmcXSxPw73DJtpOo7C70rPocQnoTPDbJwq5itSfy
        tfHTogjNSboyIvHM8OA93LPZNv4dLizPJqkVr9lKAOE28k29T9GUmwXUs+3Zdnyx
        p5Mt53lNGo0Qcy/uRQLVVrT1q47b/bR5D0EG0uN4dkJgw+DNLCZQGS8ai19wcvZY
        ZT3md1sjZkYLR8uc7xz+ID4yUE1MO2MyhKjcFCS52Fq/L85Ndtg4gt6XyntMo2ZL
        Popbx7iMQuo7SQ==
X-ME-Sender: <xms:Y4I5YW42G_b0zOzTbXuFP6r1O8-nJG3jJcHzdF3N81EqQjrhcjTxMg>
    <xme:Y4I5Yf4c2xXUIlk42mKG9Cm32HOwBizi_JKo_xK7Gj-_ZavyAKfKD65Ajl_oa9QV6
    IA2jus4PINaoqKtNHw>
X-ME-Received: <xmr:Y4I5YVfk3x-qPpDGvNNELQVvWGApuO9UhCEWhLxjoDPnFYa4Mx-RZCD9MnxzQOyupMyFLtGhEiyZb85O2SAcLzyInD3-wQe8ce54ZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefkedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gohfhorhgsihguuggvnhfjughrucdlhedttddmnecujfgurhepvffkhffuffestddtredt
    tddtnecuhfhrohhmpefhihhnnhcuvfhhrghinhcuoehfthhhrghinheslhhinhhugidqmh
    eikehkrdhorhhgqeenucfhohhrsghiugguvghnjfgurhepvffkhffuffestddtredttddt
    pdfvkffhufffsedttdertddttdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:Y4I5YTLPkfALfKhX0Rk-ASVbGSkS7UOj0SxtJ4RGBF5MHExBWba-Kw>
    <xmx:Y4I5YaLolwgVxEFW0OsO0uAWLwp5G9g__G1Xg9CCaNlyKY3X38g7cA>
    <xmx:Y4I5YUw17pUAQOYgAT0WdA4OG0THUUPjMS5ot_D7AIg66DgCbSgpQg>
    <xmx:ZYI5YW14cxST_-o05vSgzdo80uRdZe-m86Ar3pL3V-ngbUUHUfqhjUv324s>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Sep 2021 23:41:22 -0400 (EDT)
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ali Akcaagac" <aliakc@web.de>,
        "Jamie Lenehan" <lenehan@twibble.org>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <c9168d8e5595bdaa3a18d596f781b55e052af3fc.1631158421.git.fthain@linux-m68k.org>
From:   Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH] MAINTAINERS: Remove obsolete e-mail addresses
Date:   Thu, 09 Sep 2021 13:33:41 +1000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These e-mail addresses bounced.

Signed-off-by: Finn Thain <fthain@linux-m68k.org>
---
 MAINTAINERS | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d7b4f32875a9..690539b2705c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5138,10 +5138,8 @@ S:	Maintained
 F:	drivers/scsi/am53c974.c
 
 DC395x SCSI driver
-M:	Oliver Neukum <oliver@neukum.org>
 M:	Ali Akcaagac <aliakc@web.de>
 M:	Jamie Lenehan <lenehan@twibble.org>
-L:	dc395x@twibble.org
 S:	Maintained
 W:	http://twibble.org/dist/dc395x/
 W:	http://lists.twibble.org/mailman/listinfo/dc395x/
 
-- 
2.26.3

