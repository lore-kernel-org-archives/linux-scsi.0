Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB8EC77B77
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 12:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjDQMs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 08:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjDQMsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 08:48:23 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CEA7EEB;
        Mon, 17 Apr 2023 05:47:58 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 46E632B0679F;
        Mon, 17 Apr 2023 08:47:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 Apr 2023 08:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1681735677; x=
        1681736277; bh=qytjDzneUj140M+Xh/g65kAwZaaW7nCzkWlPLlgiqs4=; b=Q
        bOT5Wlkk9m0LM95wQQgPxCHWr1izSMqm58lMx6yVV0+rBlXujs597Kjm2FD2n8hf
        w7hegWNmO+v02mqphYysL3R5azlk1QSd5fgpRsuEaEOM6bILSG1X307lVoF4IVzS
        LWV6TvzPfUh7lteBpgROMjs3G/VOKMCqLnCChBjH0v68skMFkfqrcPFbfQNVNBzt
        HXQ0XMVxTt1oGppFmo3K7IpScWsWZuKvvDuPUH8+kDqCGLQPhwU0RBXkxvf+z59S
        24MfJD2cdjV+BmTManazSWBmhEMQbamhF+KIzeRrYgm/FmEzcCKKWdlhTNTeiBb+
        wbksW1Z7mlxnbzEA0SnNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1681735677; x=1681736277; bh=qytjDzneUj140M+Xh/g65kAwZaaW7nCzkWl
        PLlgiqs4=; b=L/o+Oe38ZkARCCuuYMxIMITbHgA3TyYtBAZFvVZ/P+TgzH9MPX/
        b6YFTrjemai6c0oevT5aP9aGQn13c7pKI8zTSWD/8iD3UJIZyU3Qoe3spSkSN0KR
        bqYLiT2OH3uP3iC6e3mQtnJGvFpju2nXPpuePIiGxL0Q+Cko2XCfBnL42dQb3Ujh
        CfnQjJmPTlKdouQOKn3ZqEqWiE7taUwgYUIfxBY/Ko2i3QkYTmYsP2cGt5E8d3s4
        TAAOrlvZhWlc6tAnQ7G64zUV74Jodqenoodt1TGGMr27ccZ0eFwXX7AKJt5TJ5IQ
        toiVBb1ejgCldUuwnz/jLrD8fgESBKMiipA==
X-ME-Sender: <xms:_T89ZErha0NNR5ihWgT0V1jF9HuyszyIgOI4GS9aUOzW0svkk_yDjg>
    <xme:_T89ZKqEhcXmKgulLib6F6GTvmvXjtZKL8n0Hn8IU3OCfMPi5txXlX7hP4Bs7H6Mi
    H569nrAaGWMBacjltg>
X-ME-Received: <xmr:_T89ZJOQIr8M7d18S2PXKfTN5Y_MCXQMD2rx1igrizxDNimktEdZ5anolF3r_57HbtPxVfmclOV97bF0mowDWhvYnH_AtRB5bcCkDNMO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefuhhhinhdkihgthhhirhhoucfmrgifrghsrghkihcuoehs
    hhhinhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpe
    fggfegffejgeefueetgeeukedvhfeludfhhefftdeitdfhteelieefiefhueekgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhinhhitg
    hhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:_T89ZL4MA3ZCfjn54-ae-py7HfH6FsSiUJEoPlR3lwmzm1IIcDHKSQ>
    <xmx:_T89ZD7lKrw8lMgVZJ-9LlcyU3qoIs49VCflREse5RS_SWpA-VSl0w>
    <xmx:_T89ZLjrR0J2pWFnSmqTKlqlg2pj-xtNBHccUqRBbnOX3TUghQRzoQ>
    <xmx:_T89ZDEcqkakuDqg0wghkLc7nVrIox9OVQKZgLVaDd81ymrggxQRsDBbiFwvdqAT>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 08:47:56 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests 3/9] common/scsi_debug: factor out _setup_scsi_debug_vars
Date:   Mon, 17 Apr 2023 21:47:22 +0900
Message-Id: <20230417124728.458630-4-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417124728.458630-1-shinichiro@fastmail.com>
References: <20230417124728.458630-1-shinichiro@fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

As a preparation to introduce a new helper function to configure
scsi_debug device with built-in scsi_debug module, factor out a part
of _init_scsi_debug to a new function _setup_scsi_debug_vars.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 common/scsi_debug | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/common/scsi_debug b/common/scsi_debug
index 5f73354..0bf768a 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -8,22 +8,7 @@ _have_scsi_debug() {
 	_have_driver scsi_debug
 }
 
-_init_scsi_debug() {
-	local -a args=("$@")
-
-	if (( RUN_FOR_ZONED )); then
-		if ! _have_module_param scsi_debug zbc; then
-			return
-		fi
-		args+=(zbc=host-managed zone_nr_conv=0)
-	fi
-
-	if ! modprobe -r scsi_debug || ! modprobe scsi_debug "${args[@]}"; then
-		return 1
-	fi
-
-	udevadm settle
-
+_setup_scsi_debug_vars() {
 	local host_sysfs host target_sysfs target
 	SCSI_DEBUG_HOSTS=()
 	SCSI_DEBUG_TARGETS=()
@@ -55,6 +40,25 @@ _init_scsi_debug() {
 	return 0
 }
 
+_init_scsi_debug() {
+	local -a args=("$@")
+
+	if (( RUN_FOR_ZONED )); then
+		if ! _have_module_param scsi_debug zbc; then
+			return
+		fi
+		args+=(zbc=host-managed zone_nr_conv=0)
+	fi
+
+	if ! modprobe -r scsi_debug || ! modprobe scsi_debug "${args[@]}"; then
+		return 1
+	fi
+
+	udevadm settle
+
+	_setup_scsi_debug_vars
+}
+
 _exit_scsi_debug() {
 	unset SCSI_DEBUG_HOSTS
 	unset SCSI_DEBUG_TARGETS
-- 
2.39.2

