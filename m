Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE118C4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A642023B1A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbgLHVKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgLHVKf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:10:35 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304E3C06179C;
        Tue,  8 Dec 2020 13:09:55 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id lt17so26715047ejb.3;
        Tue, 08 Dec 2020 13:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pcUFeGN1uwzpyJXiBF01tsjkIE/O4GFCTJ/pyCmdmBU=;
        b=QIHsxzx6gd3fFLf1zUHC6i3YFsw4z7RdrhdaLFyeEJBDe4e+XqhkZnyMoHL7iVe17v
         RhBzzd4VpQyRi4uO7MdaUlCrW5djq6MvQx+BHf1BWXC3pyjtpSYIy6KzkuYLQgljszdO
         hp42xJ2m42tBXR05FVz++pQExVQOufK8o7Z6vn5DmDrwCqmx+LI6DVqPv32fZTN9f8MJ
         Vq8QssCLFTqttTQi0vQFtCP49gKd/W0zDDRYLRf39HiEKHAR4GpqDzRo3yEtKdyTYrt6
         oY0UAN4nJvLp2MwJY8Ob55Nks31Sdxts/bhMtqmSvCX+ozN31L45BuJ/b0zQiORe/HDk
         BN7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pcUFeGN1uwzpyJXiBF01tsjkIE/O4GFCTJ/pyCmdmBU=;
        b=OPoM6q7ur8wuKrl1cDFdz+1TEqDrRP1Yy3wARly7SNiYD8A79aT+g7UPgaFF5/D3m9
         PkPjJXa87w1HfGX4PJIvZnqlleWR+SbY/tCHtc0gg56/qrlCNh7A09sjk9QHgRFjYbzC
         U1jSV2439fMnDE43RltZcifYU/MNGGGF0HnHfFBRUI/uNAw0kK7jgg5M1KuRFgjwln1z
         NGcNIbr1C5xgCRzMlCVNvYb/OE3IV2zgzNV0vGlzTdwHz+06L5rAMzN65LuurQJUQ2VB
         VPy89ESVgHMod1WBA5SMXcl9d3J+olpdyUjM/dq9r3AfQocvmtuNmt0dw+7bqkLiUnHM
         kM4A==
X-Gm-Message-State: AOAM530W304NZ2zsNgXqPUhIQdhwP1DvGdBNB4TiXxquFPNar1bEZi1k
        vuKzowp31StD/KgHh1w0eKM=
X-Google-Smtp-Source: ABdhPJyjzP5NFJy3eu7Vc0AjmAczfmBkCADjF9lFg/pGiZEoLKxkC7/UjFEbyFl6SMPPHoMdUyxs4g==
X-Received: by 2002:a17:906:d62:: with SMTP id s2mr5548458ejh.61.1607461793933;
        Tue, 08 Dec 2020 13:09:53 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id n22sm17908edr.11.2020.12.08.13.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 13:09:53 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] scsi: ufs: Changes comment in the function ufshcd_wb_probe()
Date:   Tue,  8 Dec 2020 22:09:41 +0100
Message-Id: <20201208210941.2177-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201208210941.2177-1-huobean@gmail.com>
References: <20201208210941.2177-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

USFHCD supports WriteBooster "LU dedicated buffer” mode and
“shared buffer” mode both, so changes the comment in the
function ufshcd_wb_probe().

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f3ba46c48383..75ea74748bc6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7167,10 +7167,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 		goto wb_disabled;
 
 	/*
-	 * WB may be supported but not configured while provisioning.
-	 * The spec says, in dedicated wb buffer mode,
-	 * a max of 1 lun would have wb buffer configured.
-	 * Now only shared buffer mode is supported.
+	 * WB may be supported but not configured while provisioning. The spec
+	 * says, in dedicated wb buffer mode, a max of 1 lun would have wb
+	 * buffer configured.
 	 */
 	dev_info->b_wb_buffer_type =
 		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
-- 
2.17.1

