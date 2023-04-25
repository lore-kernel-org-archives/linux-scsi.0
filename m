Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D458CC77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 11:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbjDYLs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 07:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbjDYLsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 07:48:24 -0400
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0F2468A;
        Tue, 25 Apr 2023 04:48:09 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 0F5D22B066B3;
        Tue, 25 Apr 2023 07:48:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 25 Apr 2023 07:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1682423288; x=
        1682423888; bh=Lgv7zBNwsGhepSdHkyWfO85nqwIblTAETSpxgkvJfMU=; b=I
        c1Wmi7uXjgIktKuzmFOF3j4Cm6Dk58s0gEiW+fu/SxeqMVlzf2zYYZUgTjRiI/yH
        +yt8nqZC6/4lwkVysLN1UfX0n0GopII3Qf7djemxvCCSnt8KDLA9ITZZWkYIdQtK
        zY2uLxSRCEPkEwqzC8QbrkMEgVi/pw6QNZgO3aWXQU10NxsQf32tkYn0XPmoc4z5
        /bs8+yTqSDZYer8BEUlHZZD1L/DitJQdQoitUAs4y3dLwzuTXVirwo81h/aTgvGf
        xuHt+axW4dW7MaYYBtPKCEdxMyFN7BEAO04QmjvvzLqWI2FnFuOwzVVbsYT6cDO1
        DXSrGdzDUADlHfpc/oKRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1682423288; x=1682423888; bh=Lgv7zBNwsGhepSdHkyWfO85nqwIblTAETSp
        xgkvJfMU=; b=CaPpwUm7OI+osRv7wTKNayqZnfx1x9VKY0tZ0eGdsE9j+Bm2NQ7
        ygglVzgoFxGmtRlClpCKnnXDamfOJ0in9IBUaaCTDI9nlZrTXQ9Y38CbbSLP/6RA
        Gtzj+FJ51aGIsrWyo2gpbbailQ8CtGoQKdsfoMLHonn9I1xCut6Avtrxz56u09HR
        Sfrs5gnYRZ/BYLdlmf3e/7FfKU/e1w5lPwm8mfVd4YgVAo2kihhhiTD3IxXU4hwM
        Y8WKPkS/7M0VZTACuemFT4V0K4//s7wGdJFKxe31IPpkRaQ2iOyyTyckblYMrp18
        OPdFWCh1Tl5vHXA0qUO+pKF0PEMAuxlX4fA==
X-ME-Sender: <xms:-L1HZD4vt5a8X5TgrysUoJMO993ex5wknQhqZ4LFiGWaEPPRUMQCuQ>
    <xme:-L1HZI7tjlke_f4EgJGk82OHV1Ku7l1QwUZY8BOUds8KXlaW04dTIni7k8tKeVuwu
    ZxN0kMcraKiQPQEjzc>
X-ME-Received: <xmr:-L1HZKcRkaUFRBKG_5nM9uTVNQCjA9QTYtU8loluDzQ69yyGiaTH0AIF9_oMv3JA2Z1BEonpkUmdMZm4ktdpketA0eH66wBzNGnLXPNm>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepgffggeffjeegfeeuteegueekvdfhledu
    hfehffdtiedthfetleeifeeihfeukeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtgho
    mh
X-ME-Proxy: <xmx:-L1HZEL6dzH9f-RD4jmuGprm4LDdqG7NUjfqUQrHWO9PY2IFRSIrOA>
    <xmx:-L1HZHKeCAgXfa5oYSNPMuk_He5-LBc4MWTHzqTM8-vosrilyq4Vxg>
    <xmx:-L1HZNx-BJhIB39DorLTFQ3AQ2WYvtYQCaQo1FqNJXU-j4EdhuPzUQ>
    <xmx:-L1HZP1j00LcRztyRxkc4BojA3LS03WhnJwaTCdOJJA15ygvSyHQmRCHzCXByKR7>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Apr 2023 07:48:06 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests v2 3/6] common/scsi_debug: factor out _setup_scsi_debug_vars
Date:   Tue, 25 Apr 2023 20:47:42 +0900
Message-Id: <20230425114745.376322-4-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230425114745.376322-1-shinichiro@fastmail.com>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
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
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
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
2.40.0

