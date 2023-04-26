Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D443C7618E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Apr 2023 10:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbjDZKGr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Apr 2023 06:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjDZKGq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2023 06:06:46 -0400
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E533344A6;
        Wed, 26 Apr 2023 03:06:37 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 7DF2C2B06855;
        Wed, 26 Apr 2023 06:06:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 26 Apr 2023 06:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1682503594; x=
        1682507194; bh=XS+A2EyuWt8WLj8nQhjcPl1FG93psrNw71yORB+BVXw=; b=a
        Nom9mA9U0yfqPG2d1vraQJZPhYRMo7I2t2dUPQR37EUScaJmd+o+h17klyYOs3cy
        jIkB73EMScNz4GHttsW27cLusuE7E/IXfZdNuAw2UC4dVodshrIoMvS1X7BjzRlG
        dYtf+qOV3x8yndSXmOOM2HzQaWAiVcHG4SR2cKA0Ew9P1H1421CG42MrE5oepAvU
        yerUsIrrt5mI4bxCsA7DPt0xCUiM72yfgAENrXoLdAL8TtlaUsShAchdlRGP3BNm
        XybBxAfbx+tq7uO7cMYR26T9tiwPDDrhoa/LVdvUB1vqn7/GEvRIeZFBe86d8OBa
        g1T2oeRf0ly0Z+TObhUcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1682503594; x=
        1682507194; bh=XS+A2EyuWt8WLj8nQhjcPl1FG93psrNw71yORB+BVXw=; b=J
        lpXa71VHAGR4GOn1SC7xGJtIZx4KU/w+ZFi52qmTlUd5rliqnJ53HycnUYIzwh67
        SsHvlx485ORSEJX1OeokC6IiqA/F8I9Me26eoLzYF+ZWERJ7sWG6EjHyYvjCZqb1
        mn2+f+Sj5VoVg5B9fc0tYSiWWDtWo29AnrNm6ndgHoJ1pI6Wkw9WGACWk2oxJjJz
        FkY0wmlsedPsjqijyMrCmcrjNW6HmJqD/q3VghDSBFwcdvnvEvPHldXi/T9GcXyY
        /aISqBSP8l7hsn4ZY8fw3COfPVt7s96DoqLtb4t/EdXNyDhfDy91kcldfsyvSIqu
        rWig/q5SkzzYhiSCOobMQ==
X-ME-Sender: <xms:qfdIZFWzd89EiNhxEGF-SAUqA-wxeS67JsxZmLhK0nMdAU6XLWe5Ew>
    <xme:qfdIZFnVZzE4Mvm_GQwXGR5cK5hR1noUGjiTzWLZt-w-WkG5bZmQUTpIRItqrmgck
    tDyVbZnVn9oRxGyxFw>
X-ME-Received: <xmr:qfdIZBYlUCbPLCQgMiLvpC9TNfrVSP9dFxChPSQ8XNw468_UUx6zkQtsfQnLkMnHqxWx4NmuXtu4APjeZvMnT0qe1finPAjRTY9QyqIF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedugedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepgffggeffjeegfeeuteegueekvdfhledu
    hfehffdtiedthfetleeifeeihfeukeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtgho
    mh
X-ME-Proxy: <xmx:qfdIZIX6nNpJjKGEoSYu7jM56MOnVrm4ppPLWkKYiqa-qu-OqbgHsg>
    <xmx:qfdIZPnsyaLIKG-IyvkzafZBfwjC0bE5QlXL7g2WW0H1_rD1k8GFkA>
    <xmx:qfdIZFc4VJ-Ta12N-TG8P8GQviB3jyCPy8LYFHNat7Mu2f_iwPMZHA>
    <xmx:qvdIZNixFOwXiG3GdJ8tUN6L_rCCC_A0jcydPDuaa1eqqWSZBgGbY9XAj0I>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Apr 2023 06:06:32 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests v2 6/6] block/{001,002,027}: allow to run with built-in scsi_debug and sd_mod
Date:   Wed, 26 Apr 2023 19:06:11 +0900
Message-Id: <20230426100611.2120-1-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230425114745.376322-1-shinichiro@fastmail.com>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

To allow the test cases run with build-in scsi_debug, replace
'_have_module scsi_debug' with _have_scsi_debug, and replace
_init_scsi_debug with _configure_scsi_debug.

Also to allow block/001 run with built-in sd_mod, replace
'_have_module sd_mod' with '_have_kernel_option BLK_DEV_SD'. When sd_mod
driver is built-in, /sys/module/sd_mod directory is not created. Then
_have_driver() can not detect availability of the driver. Instead, refer
the kernel config to check availability of the driver.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 tests/block/001 | 6 +++---
 tests/block/002 | 4 ++--
 tests/block/027 | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/block/001 b/tests/block/001
index 2ea3754..32dd22f 100755
--- a/tests/block/001
+++ b/tests/block/001
@@ -13,13 +13,13 @@ DESCRIPTION="stress device hotplugging"
 TIMED=1
 
 requires() {
-	_have_module scsi_debug
-	_have_driver sd_mod
+	_have_scsi_debug
+	_have_kernel_option BLK_DEV_SD
 	_have_driver sr_mod
 }
 
 stress_scsi_debug() {
-	if ! _init_scsi_debug "$@"; then
+	if ! _configure_scsi_debug "$@"; then
 		return
 	fi
 
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
2.40.0

