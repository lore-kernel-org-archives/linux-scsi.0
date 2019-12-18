Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97751C3F68F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 14:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DAE32146E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 14:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kq3QSxfT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfLROwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 09:52:31 -0500
Received: from mail-vk1-f202.google.com ([209.85.221.202]:49196 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfLROwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 09:52:31 -0500
Received: by mail-vk1-f202.google.com with SMTP id w23so1141611vkd.16
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 06:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mhtaTnO1DoiL0agyS5vP61dJfLpyGPOzzP//JK01Scg=;
        b=kq3QSxfTzL8MJfEfESv7z6zCGYUInsitr00jeuZ8jR1x3qgA0kPbHS+zoGyuFT9HQN
         Lj5OU7z2mUnresPi+XLD7MO2S8zQ1UKTSOip44HF3ugpcGDEv9OxB8dFjpil3VRPxQqL
         OjLXxguCVET3zPff4YNQylQpIV+Y2EVxesb0BcB4qZl7mUCeyTMAl9LggUD7VDCU8kfD
         2BFbb5hoTYmkCcZk4I/ivxV77oFcYeAjA2TbLPxGGGo793F0PDsC/rvq0UqQIU7EFPDu
         mY0i6J7/W3SJw92jSadIeSvWzyTWc2qBLNAVlumKZdp9fMMGNfLhJG/fFwLZsG6gdOBl
         qEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mhtaTnO1DoiL0agyS5vP61dJfLpyGPOzzP//JK01Scg=;
        b=PTsPqka1kkNfSCNBPBCK893XJgmMNNzRUlPfbIu+zT1Q+rsE4a0U2heN9tFQFTHDrs
         2DWSqhwF0dbHd5exWRvttAuZEQXnv/1h5TdpsJT0L9bhfo2Sw0jR9Km0MV3pEGdILbll
         gLisD5KP5wsFmd1+exUTH/EkIWcJpPATNSfsRSGP0MZsxfuHsUWqbYuOTtTS00TiqDVd
         V4VlAFuY7VASyoa76FbcmyShQoNh+UAIB4K/F68E37ku0r73qgzbB4MDWVVgc8k8SUeT
         erkVY0+1/iANnsF45NSXDVsXb5hd8oaH6hIAoYuWWE77g31y45KnNSVY/TZ8hGiDCBwQ
         WcJA==
X-Gm-Message-State: APjAAAWwY6F1/g1HenlstqQ47Sk+OWPsgSIV4z+9LqXOmGD67v8ZGaEC
        ZiR6A/JWcltw39b5EYyURYYn6qd5dNQ=
X-Google-Smtp-Source: APXvYqyF6vyQ+fNxBwKkfxvz+Te0g9D78anRQs0f83h6cwX+UuYI5LEIVy2hZNsdHBB3H0bCyaLHBoI/ifg=
X-Received: by 2002:ac5:c1d4:: with SMTP id g20mr1930737vkk.83.1576680749856;
 Wed, 18 Dec 2019 06:52:29 -0800 (PST)
Date:   Wed, 18 Dec 2019 06:51:31 -0800
In-Reply-To: <20191218145136.172774-1-satyat@google.com>
Message-Id: <20191218145136.172774-5-satyat@google.com>
Mime-Version: 1.0
References: <20191218145136.172774-1-satyat@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v6 4/9] scsi: ufs: UFS driver v2.1 spec crypto additions
From:   Satya Tangirala <satyat@google.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the crypto registers and structs defined in v2.1 of the JEDEC UFSHCI
specification in preparation to add support for inline encryption to
UFS.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 drivers/scsi/ufs/ufshcd.c |  2 ++
 drivers/scsi/ufs/ufshcd.h |  5 +++
 drivers/scsi/ufs/ufshci.h | 67 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b5966faf3e98..809502c66e25 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4789,6 +4789,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_MISMATCH_RESP_UPIU_SIZE:
 	case OCS_PEER_COMM_FAILURE:
 	case OCS_FATAL_ERROR:
+	case OCS_INVALID_CRYPTO_CONFIG:
+	case OCS_GENERAL_CRYPTO_ERROR:
 	default:
 		result |= DID_ERROR << 16;
 		dev_err(hba->dev,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2740f6941ec6..dbb581244bdb 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -722,6 +722,11 @@ struct ufs_hba {
 	 * for userspace to control the power management.
 	 */
 #define UFSHCD_CAP_RPM_AUTOSUSPEND (1 << 6)
+	/*
+	 * This capability allows the host controller driver to use the
+	 * inline crypto engine, if it is present
+	 */
+#define UFSHCD_CAP_CRYPTO (1 << 7)
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index c2961d37cc1c..c0651fe6dbbc 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -90,6 +90,7 @@ enum {
 	MASK_64_ADDRESSING_SUPPORT		= 0x01000000,
 	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
+	MASK_CRYPTO_SUPPORT			= 0x10000000,
 };
 
 #define UFS_MASK(mask, offset)		((mask) << (offset))
@@ -143,6 +144,7 @@ enum {
 #define DEVICE_FATAL_ERROR			0x800
 #define CONTROLLER_FATAL_ERROR			0x10000
 #define SYSTEM_BUS_FATAL_ERROR			0x20000
+#define CRYPTO_ENGINE_FATAL_ERROR		0x40000
 
 #define UFSHCD_UIC_HIBERN8_MASK	(UIC_HIBERNATE_ENTER |\
 				UIC_HIBERNATE_EXIT)
@@ -155,11 +157,13 @@ enum {
 #define UFSHCD_ERROR_MASK	(UIC_ERROR |\
 				DEVICE_FATAL_ERROR |\
 				CONTROLLER_FATAL_ERROR |\
-				SYSTEM_BUS_FATAL_ERROR)
+				SYSTEM_BUS_FATAL_ERROR |\
+				CRYPTO_ENGINE_FATAL_ERROR)
 
 #define INT_FATAL_ERRORS	(DEVICE_FATAL_ERROR |\
 				CONTROLLER_FATAL_ERROR |\
-				SYSTEM_BUS_FATAL_ERROR)
+				SYSTEM_BUS_FATAL_ERROR |\
+				CRYPTO_ENGINE_FATAL_ERROR)
 
 /* HCS - Host Controller Status 30h */
 #define DEVICE_PRESENT				0x1
@@ -318,6 +322,61 @@ enum {
 	INTERRUPT_MASK_ALL_VER_21	= 0x71FFF,
 };
 
+/* CCAP - Crypto Capability 100h */
+union ufs_crypto_capabilities {
+	__le32 reg_val;
+	struct {
+		u8 num_crypto_cap;
+		u8 config_count;
+		u8 reserved;
+		u8 config_array_ptr;
+	};
+};
+
+enum ufs_crypto_key_size {
+	UFS_CRYPTO_KEY_SIZE_INVALID	= 0x0,
+	UFS_CRYPTO_KEY_SIZE_128		= 0x1,
+	UFS_CRYPTO_KEY_SIZE_192		= 0x2,
+	UFS_CRYPTO_KEY_SIZE_256		= 0x3,
+	UFS_CRYPTO_KEY_SIZE_512		= 0x4,
+};
+
+enum ufs_crypto_alg {
+	UFS_CRYPTO_ALG_AES_XTS			= 0x0,
+	UFS_CRYPTO_ALG_BITLOCKER_AES_CBC	= 0x1,
+	UFS_CRYPTO_ALG_AES_ECB			= 0x2,
+	UFS_CRYPTO_ALG_ESSIV_AES_CBC		= 0x3,
+};
+
+/* x-CRYPTOCAP - Crypto Capability X */
+union ufs_crypto_cap_entry {
+	__le32 reg_val;
+	struct {
+		u8 algorithm_id;
+		u8 sdus_mask; /* Supported data unit size mask */
+		u8 key_size;
+		u8 reserved;
+	};
+};
+
+#define UFS_CRYPTO_CONFIGURATION_ENABLE (1 << 7)
+#define UFS_CRYPTO_KEY_MAX_SIZE 64
+/* x-CRYPTOCFG - Crypto Configuration X */
+union ufs_crypto_cfg_entry {
+	__le32 reg_val[32];
+	struct {
+		u8 crypto_key[UFS_CRYPTO_KEY_MAX_SIZE];
+		u8 data_unit_size;
+		u8 crypto_cap_idx;
+		u8 reserved_1;
+		u8 config_enable;
+		u8 reserved_multi_host;
+		u8 reserved_2;
+		u8 vsb[2];
+		u8 reserved_3[56];
+	};
+};
+
 /*
  * Request Descriptor Definitions
  */
@@ -339,6 +398,7 @@ enum {
 	UTP_NATIVE_UFS_COMMAND		= 0x10000000,
 	UTP_DEVICE_MANAGEMENT_FUNCTION	= 0x20000000,
 	UTP_REQ_DESC_INT_CMD		= 0x01000000,
+	UTP_REQ_DESC_CRYPTO_ENABLE_CMD	= 0x00800000,
 };
 
 /* UTP Transfer Request Data Direction (DD) */
@@ -358,6 +418,9 @@ enum {
 	OCS_PEER_COMM_FAILURE		= 0x5,
 	OCS_ABORTED			= 0x6,
 	OCS_FATAL_ERROR			= 0x7,
+	OCS_DEVICE_FATAL_ERROR		= 0x8,
+	OCS_INVALID_CRYPTO_CONFIG	= 0x9,
+	OCS_GENERAL_CRYPTO_ERROR	= 0xA,
 	OCS_INVALID_COMMAND_STATUS	= 0x0F,
 	MASK_OCS			= 0x0F,
 };
-- 
2.24.1.735.g03f4e72817-goog

