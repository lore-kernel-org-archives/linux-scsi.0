Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDF342AB7;
	Sun, 26 Apr 2026 00:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777161812; cv=none; b=k0EFfrt1BpILUGcmZfkdptARYYv1bcrQIfbf7JCY1vaMf0jVvWNYEOaOcDrWe7FeOy5iutG48zKY8BxC5NO4hXZUnuPGHDhxMeOysvse8BlBpT19x1YR28VbPwas7aEelcRuU15tWA0tUTXsUjipsWr6UFVsNWoFrvqWkRQFluE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777161812; c=relaxed/simple;
	bh=OOwvPLGivssVQ3hYdm3DGwj3DBD07H/U6hqMioMgCh0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QS4x6jFtxNsSI7zS5tF5wwROkhAtsa8zTLpYuYfUUkgE9okSA6NMbt1lEmbwOztWc86W6nLMdjvHGmWRs4nI5ELOySC/w/3Q5s2IYvlnMSfTBkmNzFIp2++Uf0lDbkl92hiO4pF489kbmB+DKJeUkf7WpmGMO8HE+D6e8BF+9zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4Q/DHo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4Q/DHo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F81C2BCB5;
	Sun, 26 Apr 2026 00:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777161812;
	bh=OOwvPLGivssVQ3hYdm3DGwj3DBD07H/U6hqMioMgCh0=;
	h=From:To:Cc:Subject:Date:From;
	b=l4Q/DHo+XjcoPYtaYQ2guLoLNDgCge1CtW/qo2G4TpleeAwuueoelCTETO9llJ/8L
	 OjgTmZg8tjHxz495BqqYhRAPO6U2YprYkpVRDgVAylHDofZujJpqYlNoYv3WU562Iz
	 Sluk2ovcrQt2XsMBBZz9Wy/qsmqy2Cyoxr1qv1gS01qXPl7N1dT8iZIY880xHg7Pcu
	 ZfQOCoc7LtpzpXxpTc3UUQN8BmC4Af59fuIxDtlw0UrXT90m+ExhLE/9/eCrxQITwh
	 7rqcIRMM1ZKjtXRW4NmuZBfCOEMUx8NTm/I+zhmu/A3R5xJpr9+hsDuHzwfFxKTiJB
	 vwFxrHdItgsXQ==
From: Sasha Levin <sashal@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ncr53c8xx: Drop CONFIG_ prefix from Zalon-specific compiler defines
Date: Sat, 25 Apr 2026 20:03:30 -0400
Message-ID: <20260426000330.56137-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kconfiglint reports:

  X001: CONFIG_NCR53C8XX_PREFETCH referenced in Makefile but not
        defined in any Kconfig
  X001: CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS referenced in Makefile
        but not defined in any Kconfig

The ncr53c8xx SCSI driver uses two preprocessor defines that carry the
CONFIG_ prefix but are not defined in any Kconfig file:

  -DCONFIG_NCR53C8XX_PREFETCH
  -DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS

These are hardcoded compiler flags in drivers/scsi/Makefile, passed
only when CONFIG_SCSI_ZALON is enabled:

  ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
      := -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
          -DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS

The source files ncr53c8xx.c and ncr53c8xx.h check these defines
with #ifdef to enable script prefetching and disable 16-bit word
transfers respectively — both specific to the PA-RISC Zalon SCSI
controller's big-endian bus requirements.

These defines have been present since the initial git import in
commit 1da177e4c3f4 ("Linux-2.6.12-rc2"). They predate the modern Kconfig
convention that CONFIG_ prefixed symbols should always originate from
Kconfig. The third define on the same line, SCSI_NCR_BIG_ENDIAN, already
correctly omits the CONFIG_ prefix.

The CONFIG_ prefix is misleading: these are not user-configurable options
and do not appear in any Kconfig menu. They are unconditionally enabled
for all Zalon builds. Remove the CONFIG_ prefix from both symbols —
renaming them to NCR53C8XX_PREFETCH and SCSI_NCR53C8XX_NO_WORD_TRANSFERS
— to match the convention used by SCSI_NCR_BIG_ENDIAN on the same line
and to avoid confusion with actual Kconfig-managed symbols.

No functional change.

Assisted-by: Claude:claude-opus-4-6 kconfiglint
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/Makefile    | 4 ++--
 drivers/scsi/ncr53c8xx.c | 2 +-
 drivers/scsi/ncr53c8xx.h | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 16de3e41f94c4..842c254bb2269 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -177,8 +177,8 @@ sd_mod-$(CONFIG_BLK_DEV_ZONED) += sd_zbc.o
 
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
-		:= -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
-			-DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
+		:= -DNCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
+			-DSCSI_NCR53C8XX_NO_WORD_TRANSFERS
 CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-y) $(ncr53c8xx-flags-m)
 zalon7xx-objs	:= zalon.o ncr53c8xx.o
 
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 4a255aafed806..5369ca3fe4fd3 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -1776,7 +1776,7 @@ struct ncb {
 **	return from the subroutine.
 */
 
-#ifdef CONFIG_NCR53C8XX_PREFETCH
+#ifdef NCR53C8XX_PREFETCH
 #define PREFETCH_FLUSH_CNT	2
 #define PREFETCH_FLUSH		SCR_CALL, PADDRH (wait_dma),
 #else
diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index be38c902859e0..2f6865ca1b87d 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -397,7 +397,7 @@
 
 #else
 
-#ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
+#ifdef SCSI_NCR53C8XX_NO_WORD_TRANSFERS
 /* Only 8 or 32 bit transfers allowed */
 #define INW_OFF(o)		(readb((char __iomem *)np->reg + ncr_offw(o)) << 8 | readb((char __iomem *)np->reg + ncr_offw(o) + 1))
 #else
@@ -405,7 +405,7 @@
 #endif
 #define INL_OFF(o)		readl_raw((char __iomem *)np->reg + (o))
 
-#ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
+#ifdef SCSI_NCR53C8XX_NO_WORD_TRANSFERS
 /* Only 8 or 32 bit transfers allowed */
 #define OUTW_OFF(o, val)	do { writeb((char)((val) >> 8), (char __iomem *)np->reg + ncr_offw(o)); writeb((char)(val), (char __iomem *)np->reg + ncr_offw(o) + 1); } while (0)
 #else
-- 
2.53.0

