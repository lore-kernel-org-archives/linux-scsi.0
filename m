Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B500DC77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 13:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjDQNFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 09:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjDQNEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 09:04:37 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682CC1258B;
        Mon, 17 Apr 2023 06:01:35 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 7BC6E2B06780;
        Mon, 17 Apr 2023 08:59:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 17 Apr 2023 08:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1681736370; x=
        1681736970; bh=HzfCDp89CrHADm8uM7DAlH9ew8Q9RFNHbSn77EFsrrs=; b=D
        8UgMpeWU7PyWGFFGtFvKdDr1GKnPYSg/y0uTVCHzyeBPRo4QGm+7qfeNCJtDUmyz
        4pjjpVcToS23VBFGlTPq7p8k+leVETUhwYHchFTsSR36YIWsmi3xq0HaXZq4pHO/
        wwpVXzeoYYgF1kz1e7yPQcDJSjRdYJ92kjLU2/AuiTKAx1eU2viVdqryoiIYaVWE
        NJhkaI8Vvi4DrX3b6dXQWr4Wv1H0VdNkKaqMt19mXhtthZ9LP5HJsGlEEwf8Vjnh
        JtP0Hxq0Lx6SNgv41fjdgWrvSXJvj3xKA8AZjD5tlAyctIWGoCs8QGe+FVulx09K
        VaC4YBrmcBbUj1flDtvgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1681736370; x=1681736970; bh=HzfCDp89CrHADm8uM7DAlH9ew8Q9RFNHbSn
        77EFsrrs=; b=WzCifZArPgtaQRkd9zNLlrmpObUhMH1oZRs8Hxlx4UQktSnrQty
        Gyn8zEu9QGnpDh1gv3fyh5a5rGCE+alMfQeF22a/sCs1f75t4aJED40OUYYEhJkL
        pVa0FAUbFfmqHH4yWneHEwrSj4T9gs6r+RsdsfsBVBnaOrFvSiK3r7bcNcrG5CyF
        YR2jOQvMUdRbyscyxfQTo5opoEefpVWbJ2z1q9mMrL3EzxBgZ467jvbl1orryj8q
        uwBvxi6kOTLfohvhDDOTh56ylhi4fX5JnT/bFbzqbU7LAgyv6FOxHFG1JHAQhRlI
        Rix2J4S1ln/Tj6WNuFuEgXfpTdT/nCg8BAw==
X-ME-Sender: <xms:sUI9ZD4o68wtgtQ2xMq_l-SLH7bX_WBa2pxcPak01Vc5HgiSDbEruA>
    <xme:sUI9ZI7yZascfyYQSnaHCXMzhHZwlEqmvYWQMDaoA4UR5k2TVo4Wq2ydF1zHDCSgH
    uVwrTyFfBmKhQkpw04>
X-ME-Received: <xmr:sUI9ZKcynEiFnMiknAlKUUm9ss4Kdspvg0yXkM6eH4qSU7-2_PeAiE_Dx_FtyRtuBIGStDzj6wYW8qsDgxkz6IJiCzZkHZIdNKN-nkLU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefuhhhinhdkihgthhhirhhoucfmrgifrghsrghkihcuoehs
    hhhinhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpe
    fggfegffejgeefueetgeeukedvhfeludfhhefftdeitdfhteelieefiefhueekgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhinhhitg
    hhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:sUI9ZEIH2wi1r-y8NPysLYa8g4B80rci5CMVG9oaL6BCRmTQqvKtNw>
    <xmx:sUI9ZHIn47bJtVrZi5x2gVsjMp75inS602vkY98SVrg_139XNF5fUA>
    <xmx:sUI9ZNzTJq6MQHsfHdA0bYYSGoBnLlQyirZcCdWHZIGe2TJ5zHBzWA>
    <xmx:sUI9ZOXwDOeqRT5LWNiVA1Fm9TKZe8OuAspuptcrIKg8HxMguAxLpqHWCKK4xchY>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 08:59:28 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests 9/9] block/027: allow to run with built-in scsi_debug
Date:   Mon, 17 Apr 2023 21:59:13 +0900
Message-Id: <20230417125913.458726-5-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417125913.458726-1-shinichiro@fastmail.com>
References: <20230417125913.458726-1-shinichiro@fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

To allow the test case run with build-in scsi_debug, replace
'_have_module scsi_debug' with _have_scsi_debug, and replace
_init_scsi_debug with _configure_scsi_debug.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 tests/block/027 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/block/027 b/tests/block/027
index ab6369b..a79a115 100755
--- a/tests/block/027
+++ b/tests/block/027
@@ -20,12 +20,12 @@ CAN_BE_ZONED=1
 
 requires() {
 	_have_cgroup2_controller io
-	_have_module scsi_debug
+	_have_scsi_debug
 	_have_fio
 }
 
 scsi_debug_stress_remove() {
-	if ! _init_scsi_debug "$@"; then
+	if ! _configure_scsi_debug "$@"; then
 		return
 	fi
 
-- 
2.39.2

