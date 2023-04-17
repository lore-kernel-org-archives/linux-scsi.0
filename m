Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63583C7EE20
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 13:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjDQNMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 09:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjDQNLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 09:11:43 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0185BB6;
        Mon, 17 Apr 2023 06:11:06 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 8AEB32B06737;
        Mon, 17 Apr 2023 08:59:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Apr 2023 08:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1681736367; x=
        1681736967; bh=F5pvrPFkViYfQ8iLbFVuREU31vxnXU/CgJoVzwvbI4g=; b=g
        End5n9DIPkPPY5gCCpCaJCqkJeBwxBPuYH4TQXpmLzobuwm0HTmNmuVSVVGTz5LO
        CFpMgobiVfvZVsXh1q9irl+nbarXwIzFneJztf638eVNTVsOtgH9MmStdgLkto3c
        Gxgw8+i5DgUa0yptHUdtITmco2kVCK4996fnaWdDfsAIiUDu6JgMy2jinGCo1Oiu
        zmznR0ktN3vtU4ECBRg+2o4ePdaWdtAlX2+5tHgricf/Iam/EktdGVsae+LLbqo4
        jR//IGmklhAdGd7SuaWe0XOk9eCm0TVGME/7zcU1bTyYuKRvH7fhwlxBx9RsJBrg
        cPILCVNPfjr8LV5HwhOKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1681736367; x=1681736967; bh=F5pvrPFkViYfQ8iLbFVuREU31vxnXU/CgJo
        VzwvbI4g=; b=jiizKRIqGyaNp+PZCq7a+pskTqNyhB27RbhVq7vm4nwf+1LJktU
        4EUHiOWVNnbe4O3+Y7Ie7LOXQxfh5lcdjTEh2Eq26CnNA/Qj8XZEIAq69ZR/hZhj
        B00mssy/PB0OY5YC49fxa/3CHwzQ/p/PCypoJP1oaNizuy5GJZ7/NDrbjn7VmlCS
        ve3CFaTEwgVLoFxK/C+dq8TczHk1Q9Kni5/EaVHTR1sjEUyFaKvd7ndjwVUOlqtk
        ikeZcPL3TkKzgcpv6DE+rXGhnnMHSYRSSwiXAkJnwKAZvVld71RC4a7HyTkTEU6D
        xXHyQ543V6a7AgkXCG5oVhrHCAHcZXT0xww==
X-ME-Sender: <xms:rkI9ZNCS4cothP85PnmxNWbY-iL42huYJEBpB1LBgq7CS6Z6gAh0Wg>
    <xme:rkI9ZLh-qAvZ_zy0jg6M8QbBrDJHtdpJLk2V1UCyV7rVZUjB4nyOvPDwtogsqAU5A
    hcZdXGd_sqqwH8vC_Q>
X-ME-Received: <xmr:rkI9ZImcl7EDAJO1I1e2wL6Z0ztO5ftfkvUWAcg_ZBpbeRLfw499S2DPWjiARf73QYTaIDJHN_phX6qOWHmxPbpHvxTCpbCh5VEN-M5y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefuhhhinhdkihgthhhirhhoucfmrgifrghsrghkihcuoehs
    hhhinhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpe
    fggfegffejgeefueetgeeukedvhfeludfhhefftdeitdfhteelieefiefhueekgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhinhhitg
    hhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:r0I9ZHwoYDXqtdbV99ypeqenRUcs74xBSXpS5J4bjipURPEFsPsiWw>
    <xmx:r0I9ZCRp5DRJzvLw7HA4N3fgFRAUzze8G2K8OObikQEnQ2MJuZ0hHQ>
    <xmx:r0I9ZKa4zWGp-zdsf0IheqDErl3mLBvn5stTebFVIH31w0njMKs-dg>
    <xmx:r0I9ZNf2vfmmY5OyZ4i0MLGIlNFC6hz_XcCN4dE6Fiow37S3xBjrOVGTF5YBlxfg>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 08:59:25 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests 8/9] block/002: allow to run with built-in scsi_debug
Date:   Mon, 17 Apr 2023 21:59:12 +0900
Message-Id: <20230417125913.458726-4-shinichiro@fastmail.com>
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
 tests/block/002 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/block/002 b/tests/block/002
index a5f3ee5..b16d014 100755
--- a/tests/block/002
+++ b/tests/block/002
@@ -13,13 +13,13 @@ QUICK=1
 
 requires() {
 	_have_blktrace
-	_have_module scsi_debug
+	_have_scsi_debug
 }
 
 test() {
 	echo "Running ${TEST_NAME}"
 
-	if ! _init_scsi_debug delay=0; then
+	if ! _configure_scsi_debug delay=0; then
 		return 1
 	fi
 
-- 
2.39.2

