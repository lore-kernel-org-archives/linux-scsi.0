Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E8FC4332F
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Dec 2021 00:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383712AbhLDAaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 19:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383668AbhLDAaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 19:30:20 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A52CC061359
        for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2021 16:26:55 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id f125so4697215pgc.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 16:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F2b6CO0wbY7ltn0TUDXIpHpO2ZaLmPQnprTRUm0/D/g=;
        b=LzTIeZlGFAPSgykOBkV1jrdoL7uXA/SB4uXF4/JotolfCznyDjiU7AaMMl7Ts1ppUj
         70SPyWUBO8WDIKAtl9VjCQPhTeGeD8sIGxdecx0r77sIwYr0qQqU8aumSCn/AMcnk67K
         7KGarYaz0zatpX+N/8q4VfxnpaBOSWvDU4y9TaEn4xLObMqozPT6ovs94rkoAxbl9+fR
         3l4t27vp8/30L40RTHsGze/YBWuEvd0vaIrjVY2FLniruBtS9qxgfsTcJalZcFNAFXkJ
         xQ+TrJssBgwtIFCwlpJnCRNq34PezsLbda+Mzf5GBrRyCGmMgUl5YbEuGKwtxqOO5Fbl
         vCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F2b6CO0wbY7ltn0TUDXIpHpO2ZaLmPQnprTRUm0/D/g=;
        b=bADf3oCO3/c1ivlIgefuPJsLOYcLgA33joQcOV2dYZcv5ooZUe9SDxsessZtQNfNHY
         WdTROUbUGbRySnHTPjEB+A+xX2U4yHrec9ENlXNffmKThkq0x29u6ZuNWQW9REmXFWy7
         cdx830/sItLBGkr3bg05TIXCOskWWujtQFdstIZAR8oMlqdOyMM999cKM+m7gzyvKX3y
         yenL97xlrQVbSMpLpM8GiHutuNP0MFWKUHEprY/zjY5c0USSVNcu4t6aYNfJBYWIM32H
         pj1mR1KjV5Soyhl6wqar2c+oW4Ijr4NvVknNIHWcIX8Lsa7A4ttH7sTNwHE4510qqz9e
         rxFQ==
X-Gm-Message-State: AOAM532eIIRAwpe9iE1mrcAMZksQjvMGJuN1vu5kM7bE86mTq6NoLvW2
        IvUvBdcozdJzOfqBDZwa5oXBZsVLBMo=
X-Google-Smtp-Source: ABdhPJy+Civ5wgKJYJRQO/QiGt8DXSvmVSsyQtZIvsQeWLE7MUxbchI90oE+QfLqqyO12hmcJMaEsg==
X-Received: by 2002:a05:6a00:228f:b0:49f:d8ac:2f1c with SMTP id f15-20020a056a00228f00b0049fd8ac2f1cmr22563916pfe.35.1638577615007;
        Fri, 03 Dec 2021 16:26:55 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q17sm4970707pfu.117.2021.12.03.16.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:26:54 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 7/9] lpfc: Cap CMF read bytes to MBPI
Date:   Fri,  3 Dec 2021 16:26:42 -0800
Message-Id: <20211204002644.116455-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ensure read bytes data does not go over MBPI for CMF timer intervals that
are purposely shortened.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |  2 +-
 drivers/scsi/lpfc/lpfc_init.c | 11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 49abbf132bee..3faadcfcdcbb 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1028,7 +1028,7 @@ struct lpfc_hba {
 					 */
 #define HBA_PCI_ERR		0x80000 /* The PCI slot is offline */
 #define HBA_FLOGI_ISSUED	0x100000 /* FLOGI was issued */
-#define HBA_CGN_RSVD1		0x200000 /* Reserved CGN flag */
+#define HBA_SHORT_CMF		0x200000 /* shorter CMF timer routine */
 #define HBA_CGN_DAY_WRAP	0x400000 /* HBA Congestion info day wraps */
 #define HBA_DEFER_FLOGI		0x800000 /* Defer FLOGI till read_sparm cmpl */
 #define HBA_SETUP		0x1000000 /* Signifies HBA setup is completed */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 132f2e60bdb4..2fe7d9d885d9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6004,8 +6004,13 @@ lpfc_cmf_timer(struct hrtimer *timer)
 		if (ms && ms < LPFC_CMF_INTERVAL) {
 			cnt = div_u64(total, ms); /* bytes per ms */
 			cnt *= LPFC_CMF_INTERVAL; /* what total should be */
-			if (cnt > mbpi)
+
+			/* If the timeout is scheduled to be shorter,
+			 * this value may skew the data, so cap it at mbpi.
+			 */
+			if ((phba->hba_flag & HBA_SHORT_CMF) && cnt > mbpi)
 				cnt = mbpi;
+
 			extra = cnt - total;
 		}
 		lpfc_issue_cmf_sync_wqe(phba, LPFC_CMF_INTERVAL, total + extra);
@@ -6088,6 +6093,8 @@ lpfc_cmf_timer(struct hrtimer *timer)
 	/* Each minute save Fabric and Driver congestion information */
 	lpfc_cgn_save_evt_cnt(phba);
 
+	phba->hba_flag &= ~HBA_SHORT_CMF;
+
 	/* Since we need to call lpfc_cgn_save_evt_cnt every minute, on the
 	 * minute, adjust our next timer interval, if needed, to ensure a
 	 * 1 minute granularity when we get the next timer interrupt.
@@ -6098,6 +6105,8 @@ lpfc_cmf_timer(struct hrtimer *timer)
 						  jiffies);
 		if (timer_interval <= 0)
 			timer_interval = LPFC_CMF_INTERVAL;
+		else
+			phba->hba_flag |= HBA_SHORT_CMF;
 
 		/* If we adjust timer_interval, max_bytes_per_interval
 		 * needs to be adjusted as well.
-- 
2.26.2

