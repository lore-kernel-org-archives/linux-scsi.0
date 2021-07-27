Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63460C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F4FA61108
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhG0MgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 08:36:22 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:27410 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbhG0MgW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 08:36:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627389382; x=1658925382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=UAVtttqGG06RhZJUkEl4p9T+hH0k4w3CjaEdb67yxKY=;
  b=MVB1Rf1/cF/rbCtq/TzLCbTNBjSO9dFtAujcwA2jDGwZEE1d4YnhBbcc
   BpcPcawM+KzQnjhw2f6x43vJPeVJpKjusvOo9E3v61UtxsXp3GXr7iUQ7
   I19UADOiqdIIVnNE+TJugptlrNHLwT39pBRwFsQvNttTsSd6MjWX/qN9q
   SgLz4YlbiwVJaQc6JAGAdE2rys5zYbCNN1EiDYqVT64YXs5SCDdLsbU6E
   psRCndW2hdREnbLGwbCkaRRQd3LXSsMdAONuv5BhyFusCXA9PO8ETZgTI
   MpsdKcIIxNKd9/1CWcTvECiHUtIoYhbNHcTuHzO1nQPL3AJJ72XrLd7y8
   w==;
X-IronPort-AV: E=Sophos;i="5.84,273,1620662400"; 
   d="scan'208";a="279424659"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 20:36:21 +0800
IronPort-SDR: W1zcUpueUSnT+tI9w4eqYKzHPgWpGQ44TYuZWQ249jhk5YOI4DAakPLj5bmOwvb42t+CSBGc2q
 T2whem/04/dtYf06ABFX4jxuwKMzqlLAYt7sPlzzv93VJ4uAvcQwKPfBpZ4gh0Ds0HUPnRIOVw
 UMeJt1blJhik85SztAbdjr/y0WHYchFd4wrwrX8J+9r5IROpxUR2pHOQFvalZGxH65Yx4MAl5Q
 Ob+R7/hiVG69PA/YggLMZ5/KIbRL9hs4+SILXS0GtR/0ejvyG9JVq6FWlwO+dfg6MiozOyENcD
 n2VKT2Q8zmESqLWPlQHgxbcV
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 05:12:16 -0700
IronPort-SDR: 2H/fKiPj0nvmRlTt2TLMkyWyUZV8RCZkr2HemLkeK9AjlsOA8maqUga4P3zKR8UyizwQxV848t
 SjfoBHgcupAk8a8tJdwMSBsHDmWbe2levWBhVikNzBU35vvuEK/n7DkUj+ONiEPLT5w4nV/M77
 i3LnkJ9JMGlt+kwViZc4es7eC9zfdAV44UPYpI/sJtOHzyFBGG7vPGTLzeEsdkEAcSVIuGeO/l
 sbLySfYYi8B4a1FXSsvC0rhYHxYMImS05KGBaB2pyuX6t8glDDLjmmrrmnp3x4sJCOe+iuOAZ2
 UIM=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jul 2021 05:36:20 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/3] scsi: ufs: Remove redundant define
Date:   Tue, 27 Jul 2021 15:35:44 +0300
Message-Id: <20210727123546.17228-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727123546.17228-1-avri.altman@wdc.com>
References: <20210727123546.17228-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS_UPIU_RPMB_WLUN already describe the rpmb wlun index.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs.h    | 1 -
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index cb80b9670bfe..579cf6f9e7a1 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -38,7 +38,6 @@
 #define UFS_UPIU_MAX_UNIT_NUM_ID	0x7F
 #define UFS_MAX_LUNS		(SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
 #define UFS_UPIU_WLUN_ID	(1 << 7)
-#define UFS_RPMB_UNIT		0xC4
 
 /* WriteBooster buffer is available only for the logical unit from 0 to 7 */
 #define UFS_UPIU_MAX_WB_LUN_ID	8
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 064a44e628d6..74ccfd2b80ce 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3334,7 +3334,8 @@ static void ufshcd_update_desc_length(struct ufs_hba *hba,
 				      unsigned char desc_len)
 {
 	if (hba->desc_size[desc_id] == QUERY_DESC_MAX_SIZE &&
-	    desc_id != QUERY_DESC_IDN_STRING && desc_index != UFS_RPMB_UNIT)
+	    desc_id != QUERY_DESC_IDN_STRING &&
+	    desc_index != UFS_UPIU_RPMB_WLUN)
 		/* For UFS 3.1, the normal unit descriptor is 10 bytes larger
 		 * than the RPMB unit, however, both descriptors share the same
 		 * desc_idn, to cover both unit descriptors with one length, we
-- 
2.17.1

