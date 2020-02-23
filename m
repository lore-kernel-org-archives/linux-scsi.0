Return-Path: <SRS0=lsQb=4L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E954C35666
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 19:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D8C420836
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 19:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=flameeyes.com header.i=@flameeyes.com header.b="HRbp5Fcg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Q2mh7kzL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWTU5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 14:20:57 -0500
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:36557 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726208AbgBWTU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Feb 2020 14:20:57 -0500
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Feb 2020 14:20:56 EST
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id AD7A45BB;
        Sun, 23 Feb 2020 14:11:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 23 Feb 2020 14:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flameeyes.com;
         h=from:to:cc:subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=fm1; bh=NqHJ7pjogVK1iWeZHfoeN8Ry52
        q7E5Iy4csBbmlhhwk=; b=HRbp5FcgX0EpAng4fLuwJpRyYArubt92CE7uFkIHXL
        vY0BZeA0HNrjfG0wqKqhwrjr0pnVAqIOd8WVCKxDMIz3rykLXrUY94wRG2egKYol
        6NQ1YcHS2iE2IimCa1u1QU50ymlSECn85bi7B88bJ9e9ixHmxweTSfWmE4JDhWI7
        7iC5J4EZoiEXmxvD39W1NARJX0svcLrdFApENAlDaMdBTVCr71RXq13xaXIsaJYx
        h4/7cq177/oDMfj6dnn1F244LpQ80lnPcFhheSyLmFYKwVmNSH0lBA+siQMaTXcZ
        4ISZl0rPVUKi4ky0irn9lhAaqUXqPWNRgcgdacCQIY7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NqHJ7p
        jogVK1iWeZHfoeN8Ry52q7E5Iy4csBbmlhhwk=; b=Q2mh7kzLlitSf5w8wrQHXn
        Sc2+XGG3sZy9Ejnb3CsKfHEaZfgchDi3MdPXvQAy2/8WU5yk8gmEIqRoGOpBuEC8
        t6pxqqGuWluaY5XRKCqmrFWPfV5ySGDy9n4RwylzvEOkb8ebpS+i7wMW5HMu1dmW
        6gAVjdoT3KpTLSysLqa+cqqmQjMcYA3vfpfUXji1HgOc4HdgxEj5yaQd49e7D6Zc
        R05xLf06DYZHCnW2BkJNjkHDFINQuYFVHHgY6Mh1IoNAs/OlAfon3H1U2hZGzqJn
        0qUa5aY+bThyQHdaBTIfbvNX2oz2xY87WbWn1erIVTddTR/Fxqwnk+xhuk8vDAZA
        ==
X-ME-Sender: <xms:fc5SXgk48RevGS18AkF7l8klCBVGy-MqAlRtAwgQG_OrNPBJnRciHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeekgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffogggtgfesthekredtredtjeenucfhrhhomhepffhivghgohcu
    gfhlihhoucfrvghtthgvnhpjuceofhhlrghmvggvhigvshesfhhlrghmvggvhigvshdrtg
    homheqnecukfhppeekkedrleekrddvfeekrddufedtnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepfhhlrghmvggvhigvshesfhhlrghmvggvhi
    gvshdrtghomh
X-ME-Proxy: <xmx:fc5SXlfAd60_LbHI05NYgsxT7zc04-5zETxSufDBtN46b1E0Fj4EEw>
    <xmx:fc5SXjl7rjUHsGxT4Qgz6QvP0C9Q96K1QckU5jbnXp2QgOupGzmQcA>
    <xmx:fc5SXs8Io28hRoigiuXmA4vJzbBalAd9xaTHx3gks87P0Wb9Opnp4g>
    <xmx:fc5SXnBmprA8E1qysPa8i1S3u7qURIkfW3k8l5AGQjbtf9ueLzkAbwKGcJ13rBvR>
Received: from localhost.localdomain (unknown [88.98.238.130])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF551328005A;
        Sun, 23 Feb 2020 14:11:56 -0500 (EST)
From:   =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] sr_vendor: remove references to BLK_DEV_SR_VENDOR, leave it enabled.
Date:   Sun, 23 Feb 2020 19:11:44 +0000
Message-Id: <20200223191144.726-1-flameeyes@flameeyes.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This kernel configuration is basically enabling/disabling sr driver quirks
detection. While these quirks are for fairly rare devices (very old CD
burners, and a glucometer), the additional detection of these models is a
very minimal amount of code.

The logic behind the quirks is always built into the sr driver.

This also removes the config from all the defconfig files that are enabling
this already.

To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.com>
---
 arch/alpha/configs/defconfig                | 1 -
 arch/arm/configs/rpc_defconfig              | 1 -
 arch/arm/configs/s3c2410_defconfig          | 1 -
 arch/ia64/configs/zx1_defconfig             | 1 -
 arch/m68k/configs/amiga_defconfig           | 1 -
 arch/m68k/configs/apollo_defconfig          | 1 -
 arch/m68k/configs/atari_defconfig           | 1 -
 arch/m68k/configs/bvme6000_defconfig        | 1 -
 arch/m68k/configs/hp300_defconfig           | 1 -
 arch/m68k/configs/mac_defconfig             | 1 -
 arch/m68k/configs/multi_defconfig           | 1 -
 arch/m68k/configs/mvme147_defconfig         | 1 -
 arch/m68k/configs/mvme16x_defconfig         | 1 -
 arch/m68k/configs/q40_defconfig             | 1 -
 arch/m68k/configs/sun3_defconfig            | 1 -
 arch/m68k/configs/sun3x_defconfig           | 1 -
 arch/mips/configs/bigsur_defconfig          | 1 -
 arch/mips/configs/fuloong2e_defconfig       | 1 -
 arch/mips/configs/ip27_defconfig            | 1 -
 arch/mips/configs/ip32_defconfig            | 1 -
 arch/mips/configs/jazz_defconfig            | 1 -
 arch/mips/configs/malta_defconfig           | 1 -
 arch/mips/configs/malta_kvm_defconfig       | 1 -
 arch/mips/configs/malta_kvm_guest_defconfig | 1 -
 arch/mips/configs/maltaup_xpa_defconfig     | 1 -
 arch/mips/configs/rm200_defconfig           | 1 -
 arch/powerpc/configs/85xx-hw.config         | 1 -
 arch/powerpc/configs/amigaone_defconfig     | 1 -
 arch/powerpc/configs/chrp32_defconfig       | 1 -
 arch/powerpc/configs/g5_defconfig           | 1 -
 arch/powerpc/configs/maple_defconfig        | 1 -
 arch/powerpc/configs/pasemi_defconfig       | 1 -
 arch/powerpc/configs/pmac32_defconfig       | 1 -
 arch/powerpc/configs/powernv_defconfig      | 1 -
 arch/powerpc/configs/ppc64_defconfig        | 1 -
 arch/powerpc/configs/ppc64e_defconfig       | 1 -
 arch/powerpc/configs/ppc6xx_defconfig       | 1 -
 arch/powerpc/configs/pseries_defconfig      | 1 -
 arch/powerpc/configs/skiroot_defconfig      | 1 -
 arch/sh/configs/sh03_defconfig              | 1 -
 arch/sparc/configs/sparc64_defconfig        | 1 -
 arch/x86/configs/i386_defconfig             | 1 -
 arch/x86/configs/x86_64_defconfig           | 1 -
 drivers/scsi/Kconfig                        | 9 ---------
 drivers/scsi/sr_vendor.c                    | 8 --------
 45 files changed, 60 deletions(-)

diff --git a/arch/alpha/configs/defconfig b/arch/alpha/configs/defconfig
index f4ec420d7f2d..3a132c91d45b 100644
--- a/arch/alpha/configs/defconfig
+++ b/arch/alpha/configs/defconfig
@@ -36,7 +36,6 @@ CONFIG_BLK_DEV_CY82C693=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_SCSI_AIC7XXX=m
 CONFIG_AIC7XXX_CMDS_PER_DEVICE=253
 # CONFIG_AIC7XXX_DEBUG_ENABLE is not set
diff --git a/arch/arm/configs/rpc_defconfig b/arch/arm/configs/rpc_defconfig
index 3b82b64950d9..c090643b1ecb 100644
--- a/arch/arm/configs/rpc_defconfig
+++ b/arch/arm/configs/rpc_defconfig
@@ -32,7 +32,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index 73ed73a8785a..153009130dab 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -202,7 +202,6 @@ CONFIG_EEPROM_AT24=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/ia64/configs/zx1_defconfig b/arch/ia64/configs/zx1_defconfig
index 8c92e095f8bb..d42f79a33e91 100644
--- a/arch/ia64/configs/zx1_defconfig
+++ b/arch/ia64/configs/zx1_defconfig
@@ -35,7 +35,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_CHR_DEV_OSST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index e1134c3e0b69..e53008a9f00b 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -334,7 +334,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 484cb1643df1..3b0bf9d36594 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -319,7 +319,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index eb6a46b6d135..7b2bffe9538d 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -334,7 +334,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index bee9263a409c..6a9cc4cd0418 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -316,7 +316,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index c8847a8bcbd6..259787203552 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -318,7 +318,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index 303ffafd9cad..980b4de08fb3 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -325,7 +325,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 89a704226cd9..50b34ef2f0e5 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -358,7 +358,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index f62c1f4d03a0..ec3ad8a3b1c8 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -315,7 +315,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 58dcad26a751..5a276096f165 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -316,7 +316,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index 5d3c28d1d545..3a501740d96f 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -324,7 +324,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 5ef9e17dcd51..87c8674920c7 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -313,7 +313,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 22e1accc60a3..2c791cff21c6 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -313,7 +313,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SAS_ATTRS=m
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index f14ad0538f4e..eea9b613bb74 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -112,7 +112,6 @@ CONFIG_BLK_DEV_TC86C001=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_CHR_DEV_SCH=m
 CONFIG_ATA=y
diff --git a/arch/mips/configs/fuloong2e_defconfig b/arch/mips/configs/fuloong2e_defconfig
index 1788ae23bff9..6466e83067b4 100644
--- a/arch/mips/configs/fuloong2e_defconfig
+++ b/arch/mips/configs/fuloong2e_defconfig
@@ -99,7 +99,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_ATA_OVER_ETH=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 # CONFIG_SCSI_LOWLEVEL is not set
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index 82d942a6026e..638d7cf5ef01 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -99,7 +99,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 370884018aad..7b1fab518317 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -50,7 +50,6 @@ CONFIG_RAID_ATTRS=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/jazz_defconfig b/arch/mips/configs/jazz_defconfig
index 328d4dfeb4cb..982b990469af 100644
--- a/arch/mips/configs/jazz_defconfig
+++ b/arch/mips/configs/jazz_defconfig
@@ -191,7 +191,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 59eedf55419d..211bd3d6e6cb 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -239,7 +239,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/malta_kvm_defconfig b/arch/mips/configs/malta_kvm_defconfig
index 8ef612552a19..62b1969b4f55 100644
--- a/arch/mips/configs/malta_kvm_defconfig
+++ b/arch/mips/configs/malta_kvm_defconfig
@@ -247,7 +247,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/malta_kvm_guest_defconfig b/arch/mips/configs/malta_kvm_guest_defconfig
index d2a008c9907c..9185e0a0aa45 100644
--- a/arch/mips/configs/malta_kvm_guest_defconfig
+++ b/arch/mips/configs/malta_kvm_guest_defconfig
@@ -245,7 +245,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/maltaup_xpa_defconfig b/arch/mips/configs/maltaup_xpa_defconfig
index 970df6d42728..636311d67a53 100644
--- a/arch/mips/configs/maltaup_xpa_defconfig
+++ b/arch/mips/configs/maltaup_xpa_defconfig
@@ -245,7 +245,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index 2c7adea7638f..30d7c3db884e 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -203,7 +203,6 @@ CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/85xx-hw.config b/arch/powerpc/configs/85xx-hw.config
index 9575a38c9155..b507df6ac69f 100644
--- a/arch/powerpc/configs/85xx-hw.config
+++ b/arch/powerpc/configs/85xx-hw.config
@@ -2,7 +2,6 @@ CONFIG_AQUANTIA_PHY=y
 CONFIG_AT803X_PHY=y
 CONFIG_ATA=y
 CONFIG_BLK_DEV_SD=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BROADCOM_PHY=y
 CONFIG_C293_PCIE=y
diff --git a/arch/powerpc/configs/amigaone_defconfig b/arch/powerpc/configs/amigaone_defconfig
index f6d140f2d922..200bb1ecb560 100644
--- a/arch/powerpc/configs/amigaone_defconfig
+++ b/arch/powerpc/configs/amigaone_defconfig
@@ -44,7 +44,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SYM53C8XX_2=y
diff --git a/arch/powerpc/configs/chrp32_defconfig b/arch/powerpc/configs/chrp32_defconfig
index 502a75d49789..a4a805b87469 100644
--- a/arch/powerpc/configs/chrp32_defconfig
+++ b/arch/powerpc/configs/chrp32_defconfig
@@ -42,7 +42,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SYM53C8XX_2=y
diff --git a/arch/powerpc/configs/g5_defconfig b/arch/powerpc/configs/g5_defconfig
index fbfcc85e4dc0..a68c7f3af10e 100644
--- a/arch/powerpc/configs/g5_defconfig
+++ b/arch/powerpc/configs/g5_defconfig
@@ -62,7 +62,6 @@ CONFIG_CDROM_PKTCDVD=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SPI_ATTRS=y
diff --git a/arch/powerpc/configs/maple_defconfig b/arch/powerpc/configs/maple_defconfig
index 2975e64629aa..161351a18517 100644
--- a/arch/powerpc/configs/maple_defconfig
+++ b/arch/powerpc/configs/maple_defconfig
@@ -41,7 +41,6 @@ CONFIG_BLK_DEV_RAM_SIZE=8192
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_IPR=y
 CONFIG_ATA=y
diff --git a/arch/powerpc/configs/pasemi_defconfig b/arch/powerpc/configs/pasemi_defconfig
index 4b6d31d4474e..08b7f4cef243 100644
--- a/arch/powerpc/configs/pasemi_defconfig
+++ b/arch/powerpc/configs/pasemi_defconfig
@@ -60,7 +60,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_CHR_DEV_OSST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=y
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index f492e7d35925..05e325ca3fbd 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -117,7 +117,6 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/powernv_defconfig b/arch/powerpc/configs/powernv_defconfig
index 71749377d164..df8bdbaa5d8f 100644
--- a/arch/powerpc/configs/powernv_defconfig
+++ b/arch/powerpc/configs/powernv_defconfig
@@ -108,7 +108,6 @@ CONFIG_BLK_DEV_NVME=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 7e68cb222c7b..bae8170d7401 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -110,7 +110,6 @@ CONFIG_VIRTIO_BLK=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/ppc64e_defconfig b/arch/powerpc/configs/ppc64e_defconfig
index 0d746774c2bd..33a01a9e86be 100644
--- a/arch/powerpc/configs/ppc64e_defconfig
+++ b/arch/powerpc/configs/ppc64e_defconfig
@@ -60,7 +60,6 @@ CONFIG_BLK_DEV_RAM_SIZE=65536
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 3e2f44f38ac5..feb5d47d8d1e 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -368,7 +368,6 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_CHR_DEV_OSST=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_ENCLOSURE=m
diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index 6b68109e248f..0bea4d3ffb85 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -97,7 +97,6 @@ CONFIG_VIRTIO_BLK=m
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=m
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_FC_ATTRS=y
diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 1b6bdad36b13..ad6739ac63dc 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -84,7 +84,6 @@ CONFIG_EEPROM_AT24=m
 # CONFIG_OCXL is not set
 CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SCAN_ASYNC=y
diff --git a/arch/sh/configs/sh03_defconfig b/arch/sh/configs/sh03_defconfig
index e5beb625ab88..87db9a84b5ec 100644
--- a/arch/sh/configs/sh03_defconfig
+++ b/arch/sh/configs/sh03_defconfig
@@ -46,7 +46,6 @@ CONFIG_BLK_DEV_IDETAPE=m
 CONFIG_SCSI=m
 CONFIG_BLK_DEV_SD=m
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 6c325d53a20a..bde4d21a8ac8 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -73,7 +73,6 @@ CONFIG_RAID_ATTRS=m
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=m
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 59ce9ed58430..18806b4fb26a 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -137,7 +137,6 @@ CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SPI_ATTRS=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 0b9654c7a05c..7f5cb3bead37 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -135,7 +135,6 @@ CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
-CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_SPI_ATTRS=y
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a7881f8eb05e..2b882b96e0d4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -115,15 +115,6 @@ config BLK_DEV_SR
 	  <file:Documentation/scsi/scsi.txt>.
 	  The module will be called sr_mod.
 
-config BLK_DEV_SR_VENDOR
-	bool "Enable vendor-specific extensions (for SCSI CDROM)"
-	depends on BLK_DEV_SR
-	help
-	  This enables the usage of vendor specific SCSI commands. This is
-	  required to support multisession CDs with old NEC/TOSHIBA cdrom
-	  drives (and HP Writers). If you have such a drive and get the first
-	  session only, try saying Y here; everybody else says N.
-
 config CHR_DEV_SG
 	tristate "SCSI generic support"
 	depends on SCSI
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index 17a56c87d383..1f988a1b9166 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -67,9 +67,6 @@
 
 void sr_vendor_init(Scsi_CD *cd)
 {
-#ifndef CONFIG_BLK_DEV_SR_VENDOR
-	cd->vendor = VENDOR_SCSI3;
-#else
 	const char *vendor = cd->device->vendor;
 	const char *model = cd->device->model;
 	
@@ -118,7 +115,6 @@ void sr_vendor_init(Scsi_CD *cd)
 			CDC_PLAY_AUDIO
 			);
 	}
-#endif
 }
 
 
@@ -132,10 +128,8 @@ int sr_set_blocklength(Scsi_CD *cd, int blocklength)
 	struct ccs_modesel_head *modesel;
 	int rc, density = 0;
 
-#ifdef CONFIG_BLK_DEV_SR_VENDOR
 	if (cd->vendor == VENDOR_TOSHIBA)
 		density = (blocklength > 2048) ? 0x81 : 0x83;
-#endif
 
 	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer)
@@ -223,7 +217,6 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 		}
 		break;
 
-#ifdef CONFIG_BLK_DEV_SR_VENDOR
 	case VENDOR_NEC:{
 			unsigned long min, sec, frame;
 			cgc.cmd[0] = 0xde;
@@ -316,7 +309,6 @@ int sr_cd_check(struct cdrom_device_info *cdi)
 		sector = buffer[11] + (buffer[10] << 8) +
 		    (buffer[9] << 16) + (buffer[8] << 24);
 		break;
-#endif				/* CONFIG_BLK_DEV_SR_VENDOR */
 
 	default:
 		/* should not happen */
-- 
2.25.1

