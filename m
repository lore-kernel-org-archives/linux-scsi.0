Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC529C77B72
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 13:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjDQNEB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 09:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjDQNDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 09:03:42 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6939F11BA2;
        Mon, 17 Apr 2023 06:00:42 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id 36E6F2B06733;
        Mon, 17 Apr 2023 08:59:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Apr 2023 08:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1681736361; x=
        1681736961; bh=2NZbhL7tjJaNUxYqL9byU5qKMZUlP07NY/no4LnIiOo=; b=m
        /zpokqEhLV4s0DCRdg23eNxo0EJjxziiwPXw/UzyZBQaF5QK9BZJ2n1ndDlxFUv6
        7Zd6uWwU/7F/BP1PnshMFcrXZm4FSxkt2470l9pIO/cQeRe0ftrK84Pr6sDp9IAc
        9hAObUnx9iGaxbRGqOySn4ITRMUtAit6VxswFdOC80ZPbFyfWVG5n/5mnJXQyEXG
        AoOiHRXaq+PjS0LYXosyu8EUme3/m7MGsy+xIebI5Rqp5mloDQz7mVvJQw1n3vh3
        2WbJQTlh+6tsjUlmMLjzX5pMKn9jFTyU/VJzdezZnWkMJ2Sxf3c89NzFDjjy9hga
        YfN4XiEgKcL8tmbPahcGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1681736361; x=1681736961; bh=2NZbhL7tjJaNUxYqL9byU5qKMZUlP07NY/n
        o4LnIiOo=; b=Vz84V/d4N3LeFd7pJhTBSr0n7laggwbDNEthKB2s3Mc86FwGqDK
        eX8sPzuuU4HfrT7TG8vIwClEzljXXNEMPA8hvIqdHhG6pw07CLuL8TspNX81r8+T
        YJjFXaUw+smWG5wrwDU9tOo7jG10/wiD9wrpTCItcW2LojIMvJIzHqMftXBmLNC6
        s6/ZdJ3H6nU4Q2nrKAUhiPPNbQKMKhMOcuJgWU2D/R0hE3YwEHOi+JESnOfYiWKO
        jQcEJ8J1yGevRCP2GEAoOr0xQE5oscs3dhvkIClplt48zRfilcmJ0oQtVQA3nPBy
        YE3jZq9dAQxh8igRKMxAFhYBksR/IBG5EkQ==
X-ME-Sender: <xms:qUI9ZGGPW0Ahxlpg-PacDu5ZhfriSqdlCBxYigZlWevAg6fsGvSMVw>
    <xme:qUI9ZHVOLz1aBxYwu7vqX71Qc8F2vfBjtG3vlIt6cQ9-dSP5CUaIhG_zmz_Z54G1K
    sjvQlkzi0lsAKQtaEk>
X-ME-Received: <xmr:qUI9ZALe3U7s1nd-Ulc4F-Tr9OxU2DIPs3nqbmwqCokZvxCH0gyuWP_32boA5tbmATZ5iQEqeITXYtSbbn434wbF-dZa0jrA_CdqSNeT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefuhhhinhdkihgthhhirhhoucfmrgifrghsrghkihcuoehs
    hhhinhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpe
    fggfegffejgeefueetgeeukedvhfeludfhhefftdeitdfhteelieefiefhueekgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhinhhitg
    hhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:qUI9ZAG_qJTmQiVY7ggB4VMPKxAvRegRFDEF2o5PL1hsyKwuBOVVMQ>
    <xmx:qUI9ZMX9oxaxDWZx5tkIjyqaHWWxozoCM0c9Lv4OV93vKDKYrKeFJQ>
    <xmx:qUI9ZDOnVEKaPIdpr1Ior84q03vQN5A3iMYHTuu5m15Ku9aRV8bfng>
    <xmx:qUI9ZJgeBYuT0YDwZfl89It50vIEce53_8K1DBsi1mLiprCvIPfbHo2NScOGadEI>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 08:59:20 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests 6/9] scsi/005: allow to run with built-in scsi_debug
Date:   Mon, 17 Apr 2023 21:59:10 +0900
Message-Id: <20230417125913.458726-2-shinichiro@fastmail.com>
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
 tests/scsi/005 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/scsi/005 b/tests/scsi/005
index efd3d82..bfa1014 100755
--- a/tests/scsi/005
+++ b/tests/scsi/005
@@ -11,7 +11,7 @@ DESCRIPTION="test SCSI device blacklisting"
 QUICK=1
 
 requires() {
-	_have_module scsi_debug
+	_have_scsi_debug
 	_have_module_param scsi_debug inq_vendor
 }
 
@@ -33,7 +33,7 @@ test() {
 	for inq in "${inqs[@]}"; do
 		vendor="${inq:0:8}"
 		model="${inq:8:16}"
-		if ! _init_scsi_debug inq_vendor="$vendor" inq_product="$model"; then
+		if ! _configure_scsi_debug inq_vendor="$vendor" inq_product="$model"; then
 			continue
 		fi
 		vendor="$(cat "/sys/block/${SCSI_DEBUG_DEVICES[0]}/device/vendor")"
-- 
2.39.2

