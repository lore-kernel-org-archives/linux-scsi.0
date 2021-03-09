Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAB0C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 02:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44FDA6527E
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 02:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCIC1q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Mar 2021 21:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhCIC12 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2021 21:27:28 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A952C06174A;
        Mon,  8 Mar 2021 18:27:28 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so4145407pjb.0;
        Mon, 08 Mar 2021 18:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rj6oQ4IFYTilxkF7OoIJ90szUzse8S46mCr6GX2/bfU=;
        b=HcT2lUKj+yEHpiC+3lSZHbHqbUdhv0x8pp5lxuEsUJc2MWiJYwUL3ON9FFpxZFkb3q
         JuwPjN59wA9uspSyC1M68oW6+L/T+edPpRWbaNmArOpFY1Z8DY4rk1e9yzWaqusenRYH
         gre4ieYC1fw0zThy+sNGHviiJlPFN2F9+jKFnGsFEqI70thfJUF7o3i0LTM+TEyKmnX8
         3OrBTz86Gq0N/S+sS4emunEAtH2H+9JQisP3AR6BAXO/nI4JdWCG8KUoQw9uherhQHDo
         UyJYmJjLdW01b9EVTlDHi7qyouDFRZKAkwWQuyXqjMSDuSowdmE3f8OWvh2SzXQIQw3A
         kMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rj6oQ4IFYTilxkF7OoIJ90szUzse8S46mCr6GX2/bfU=;
        b=ssZY0HFgWVDTSlM7DsVK6J0+ZcHBmJvmMn1WucVYZgl2KYwOhO2yphP2eR0975K4gf
         FTYwKPaNIUa9bw4G20mstVVzdm2GCOYxYF9J0q45Hr7exb5q/ZG3vr8yjFd6uj1qdz9t
         A+/rJr8Y1orjrZMATUUb37kLcp3NbgPFHBQ5oOQIPPhxbNqYmUHYbahpcgUj3fKzWVA4
         Q1RZukcfQ49mqcg7gfZdQpuMGIZdry0kDtBuRWMQtCurP8S5zIcYQEa1QJhuobSEaow9
         o0pc46W3IbDW4x45tYI1C4zOWPRWLAFmsw2+ubvmg0G7ru0V1xb8uAQL3Ni/sjZAD3W1
         DdPw==
X-Gm-Message-State: AOAM531pqpLbWqts65soFyRuAtxCV7oOQAB3QXiD7btgCIPqHdYlpEdj
        Ww3iCRtFO0MEGjUG7LsHpBU=
X-Google-Smtp-Source: ABdhPJz2WAPpZvlB94fcAgE87Wvh3NtfxKCFB52ElTrB1MEdzsSZ0b6iAwOMFu5vCQ96/CPHHiKYYQ==
X-Received: by 2002:a17:90a:8811:: with SMTP id s17mr2085211pjn.74.1615256847962;
        Mon, 08 Mar 2021 18:27:27 -0800 (PST)
Received: from tj.ccdomain.com ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id x4sm4311496pfn.134.2021.03.08.18.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 18:27:27 -0800 (PST)
From:   Yue Hu <zbestahu@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        stanley.chu@mediatek.com, cang@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, asutoshd@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyue2@yulong.com, zbestahu@163.com
Subject: [PATCH] scsi: ufs: Don't spew log for enabling WB in ufshcd_wb_config()
Date:   Tue,  9 Mar 2021 10:27:03 +0800
Message-Id: <20210309022703.422-1-zbestahu@gmail.com>
X-Mailer: git-send-email 2.29.2.windows.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yue Hu <huyue2@yulong.com>

Since ufshcd_wb_ctrl() will spew error/debug log firstly, no need to
spew similar error/info log again in the caller ufshcd_wb_config().

Also, several log words in ufshcd_wb_ctrl() are not consistent with
other sites, let's improve them. And remove unhelpful ret from debug
log due to successful control.

Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7716175..991c880 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -280,11 +280,7 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
 
-	ret = ufshcd_wb_ctrl(hba, true);
-	if (ret)
-		dev_err(hba->dev, "%s: Enable WB failed: %d\n", __func__, ret);
-	else
-		dev_info(hba->dev, "%s: Write Booster Configured\n", __func__);
+	ufshcd_wb_ctrl(hba, true);
 	ret = ufshcd_wb_toggle_flush_during_h8(hba, true);
 	if (ret)
 		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
@@ -5452,14 +5448,14 @@ int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
 	ret = ufshcd_query_flag_retry(hba, opcode,
 				      QUERY_FLAG_IDN_WB_EN, index, NULL);
 	if (ret) {
-		dev_err(hba->dev, "%s write booster %s failed %d\n",
+		dev_err(hba->dev, "%s Write Booster %s failed %d\n",
 			__func__, enable ? "enable" : "disable", ret);
 		return ret;
 	}
 
 	hba->dev_info.wb_enabled = enable;
-	dev_dbg(hba->dev, "%s write booster %s %d\n",
-			__func__, enable ? "enable" : "disable", ret);
+	dev_dbg(hba->dev, "%s Write Booster %s\n",
+			__func__, enable ? "enabled" : "disabled");
 
 	return ret;
 }
-- 
1.9.1

