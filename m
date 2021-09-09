Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1309C28B59
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 06:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAE8E61132
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 06:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352640AbhIIGhD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 02:37:03 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:25567 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbhIIGgv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 02:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631169341; x=1662705341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0KCiswRC35T1eDPbnblVO07BdfyHyu8aePuQQHHz0Jw=;
  b=SR6Jm/Dwams/m4Bdeyla175Xs7+aAGWJDjr+1qoktmxvZ8Zs/Sx3Gu1V
   L/x4uowccCZkq+ZIlbe0L1H1lyfLy52sqZEF/0vufvltvkAu9WJIwqRZf
   iHtHiVNynSfjoCsGdiR86tf1lTVg7yddOlBvG5jhxj4sCzqjZ+Dvlo21u
   FCQJumGZo8/DN4acwG7wljEexHTY3yf4Ao++s++iGBbdEyeUcgAxSzlu/
   gfO/luPHSvRwRFpbgAroSu4g7G4Yo29J3wyd56KXrg/R54EltbULY628r
   wN3j/bEEvxWwm5PbduDqXy5caShW52TRHEzC/LZg9P2L77ZDn2UvRDGgN
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,279,1624291200"; 
   d="scan'208";a="179551120"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Sep 2021 14:35:41 +0800
IronPort-SDR: xRuaJdc6RTVlPNKtBJRI71Yh8RVPUniZnu6MLw/ASdxekuFATSLOXuLvP9m3xq/l2Yt51kGqux
 BdwdpUiY5NRcWe6AIvSWtEnGJXnZnP5E3n1p3clY9YOF5bw508JPg3j4UchP6VtZtFzneGavvB
 YRM9YMquu3ytZHgx8+zQ+TOaMQ7MnbASoLr8FWtZSvXpwGh/2VcpSr9w+oGRqNd9WZ6hN6l5o8
 GXuRjsBATF8C+BXJyQ8zrNBvRm/3JP5ImXg6gLtU1edhti/qjSyfMVNbxwc2bOtk7Lmtxq5Uri
 VIpANkowwL/LzE9u5s973EHB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 23:10:39 -0700
IronPort-SDR: 30C9GZ/QtcDip/WRqUORD2qju+p0Na/xXjcEQLPXPaiAZwDrj0o27HfRKoJ+mwssMtlsmsVKsh
 LxSw/sVF9BOQ4SWh2l2QBMyXDefmKETDX8M94c5iMeodfdXPXhpazpmOu7J9cXbdWIH8XW3fCC
 3QWBVZqCtb0IIkRGhQCIshe3Rc6GyQgRo3YmUxCl7lu8xi5K06KFUF5qmXPyPztOARcGiiYnzi
 1PN7ufyqzfTUJ2G290zUiiQzL7UU/L6UGgezTWXpX6NPP5HBdclp48nEpD5jUrdFuqWu5wknVp
 JFg=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Sep 2021 23:35:40 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 2/2] scsi: ufs: Add temperature notification exception handling
Date:   Thu,  9 Sep 2021 09:34:44 +0300
Message-Id: <20210909063444.22407-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210909063444.22407-1-avri.altman@wdc.com>
References: <20210909063444.22407-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The device may notify the host of an extreme temperature by using the
exception event mechanism. The exception can be raised when the device’s
Tcase temperature is either too high or too low.

It is essentially up to the platform to decide what further actions need
to be taken. leave a placeholder for a designated vop for that.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs.h    |  2 ++
 drivers/scsi/ufs/ufshcd.c | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 171b27be7b1d..d9bc048c2a71 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -377,6 +377,8 @@ enum {
 	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
 };
 
+#define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
+
 /* Background operation status */
 enum bkops_status {
 	BKOPS_STATUS_NO_OP               = 0x0,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fc995bf1f296..1f61e8090220 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5642,6 +5642,22 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
+static void ufshcd_temp_exception_event_handler(struct ufs_hba *hba, u16 status)
+{
+	u32 value;
+
+	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			      QUERY_ATTR_IDN_CASE_ROUGH_TEMP, 0, 0, &value))
+		return;
+
+	dev_info(hba->dev, "exception Tcase %d\n", value - 80);
+
+	/*
+	 * A placeholder for the platform vendors to add whatever additional
+	 * steps required
+	 */
+}
+
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
 	u8 index;
@@ -5821,6 +5837,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_BKOPS)
 		ufshcd_bkops_exception_event_handler(hba);
 
+	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
+		ufshcd_temp_exception_event_handler(hba, status);
+
 	ufs_debugfs_exception_event(hba, status);
 out:
 	ufshcd_scsi_unblock_requests(hba);
-- 
2.17.1

