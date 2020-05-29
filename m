Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE6AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CB6D20814
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bf+1ZHGR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgE2Qlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 12:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2Qla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 12:41:30 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26B5C03E969;
        Fri, 29 May 2020 09:41:30 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so4479585wrp.2;
        Fri, 29 May 2020 09:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NaB7VWR04f+B+3g+DA/Cuf8vF3CQZRXxRPnbwEDcUjg=;
        b=bf+1ZHGR8XG85nypZi034t9JRcYxpaf8XixZwpJlZCIJps3M2xax75YQ+QOXZpZLC9
         7qd6O44tTa6xFoitSy+5umbWo0J+fnEX0h4XYfUa+mF7sxhh8wIIthZb25/Ojr6T4cNx
         53svAawW4PvsGR7SnnCN1XDE3Jj5+SuimrKRKklKeIQ4WLWU1cUq4xHaTQejhcv/Qdfk
         3iFx79kTI9b6PG7V069vDmalzkQjDvRat9KKyopPRX3FpuQt4+N+fx5fTz7iB+cKe8tX
         HLJpQdI8NE60GvjgF6nVLEf5rYtAjyzsTsI21YOvLVEp5Int/9k151X3hM5fTxtT9ryv
         JzEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NaB7VWR04f+B+3g+DA/Cuf8vF3CQZRXxRPnbwEDcUjg=;
        b=d8DBdvm1w/OQxSwcSbKxuQUM7MUaQ8eVC3HlOY2KMqdP/nfqiDJnkLg5Qy/GNwfLwF
         AYFU3WMxUb7dwrfLs7XEaaQxbIa9nEMDa4d1l9CyCdwv3jq/QmCh5arfa9sx0swpjhl9
         T7b4MvZ7hiZcEXlto1ut4pLNY6fBuUvvbImilJgJ+/Eqt/BsuiNVeJVldps5PJPi9XAN
         Scix94YTYfztz2R8LmUcQfi1N9Pg5lrynpqWyJ4mH6ltxyDOOHKSdx+oKzNO+FQLXBA9
         WZTJf7PbclbijdTCFjLvT1C1vwbeLbfR35XK/3ETfN3TJQz0WcbVrRyJC7R45Vf0Visy
         /5wg==
X-Gm-Message-State: AOAM532FQfF+1Gl+sxkOj9Rdz7KNc7hguW2YlCmOdTCPKHZ04u1OZqNG
        5FsujbGI9SHyFS69xHB5Du0=
X-Google-Smtp-Source: ABdhPJxhVthUTmCxFIOx6ZYGEra973usr+hG6fG86hZ+KectIAx+zR9bO8isvhfbCc2Gs34L+MbYPQ==
X-Received: by 2002:adf:9544:: with SMTP id 62mr9124451wrs.32.1590770489450;
        Fri, 29 May 2020 09:41:29 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id z25sm17344wmf.10.2020.05.29.09.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:41:29 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/4] scsi: ufs: add compatibility with 3.1 UFS unit descriptor length
Date:   Fri, 29 May 2020 18:40:54 +0200
Message-Id: <20200529164054.27552-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529164054.27552-1-huobean@gmail.com>
References: <20200529164054.27552-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

For UFS 3.1, the normal unit descriptor is 10 bytes larger
than the RPMB unit, however, both descriptors share the same
desc_idn, to cover both unit descriptors with one length, we
choose the normal unit descriptor length by desc_index.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    |  1 +
 drivers/scsi/ufs/ufshcd.c | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 6548ef102eb9..332ae09e6238 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -63,6 +63,7 @@
 #define UFS_UPIU_MAX_UNIT_NUM_ID	0x7F
 #define UFS_MAX_LUNS		(SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
 #define UFS_UPIU_WLUN_ID	(1 << 7)
+#define UFS_RPMB_UNIT		0xC4
 
 /* WriteBooster buffer is available only for the logical unit from 0 to 7 */
 #define UFS_UPIU_MAX_WB_LUN_ID	8
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 951e52babf65..3cdc585d0095 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3070,11 +3070,16 @@ void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
 
 static void ufshcd_update_desc_length(struct ufs_hba *hba,
-				      enum desc_idn desc_id,
+				      enum desc_idn desc_id, int desc_index,
 				      unsigned char desc_len)
 {
 	if (hba->desc_size[desc_id] == QUERY_DESC_MAX_SIZE &&
-	    desc_id != QUERY_DESC_IDN_STRING)
+	    desc_id != QUERY_DESC_IDN_STRING && desc_index != UFS_RPMB_UNIT)
+		/* For UFS 3.1, the normal unit descriptor is 10 bytes larger
+		 * than the RPMB unit, however, both descriptors share the same
+		 * desc_idn, to cover both unit descriptors with one length, we
+		 * choose the normal unit descriptor length by desc_index.
+		 */
 		hba->desc_size[desc_id] = desc_len;
 }
 
@@ -3141,7 +3146,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		goto out;
 	}
 
-	ufshcd_update_desc_length(hba, desc_id,
+	ufshcd_update_desc_length(hba, desc_id, desc_index,
 				  desc_buf[QUERY_DESC_LENGTH_OFFSET]);
 
 	/* Check wherher we will not copy more data, than available */
-- 
2.17.1

