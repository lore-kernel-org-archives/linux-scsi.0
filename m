Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DB6C32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C8632467C
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iW7zEuSY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgASAOB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 19:14:01 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39182 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgASAOB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 19:14:01 -0500
Received: by mail-wm1-f68.google.com with SMTP id 20so11160523wmj.4;
        Sat, 18 Jan 2020 16:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sELIAc9JYznk8gLukGl5sh9ks34HnlMIU1NIlCV4wTE=;
        b=iW7zEuSYXDcEN+aUn69no6y2/t2qEqG9s+uaKRUQD46IoxNzuGFgHN42ldtJYynCOA
         Zd25bcAcApbUAw/X+z/RjlTe3MJQg+ww+lNOBXZnGjm9RUXwOGfDqth68LygsxIS3y6I
         7936Jf6am0ix7igdQDhcVTZlC0Or20mSDXuGtW21PQ6lh51cgxmDy0f7S6J1cOVo9R8v
         Obh6IoH/Hd2TEaRsCDcn/b2ayLW8Q9fhRrepcc0NoU6b/wy2qy7uYeCk6f8D9/XIZLfE
         j/19KzQVXAmMH8nRaG6t+oCiU2H5Dc3+Rsht9NzZcAc0fPdVVaTD3MfrDeN9zZfz9vyJ
         Pu3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sELIAc9JYznk8gLukGl5sh9ks34HnlMIU1NIlCV4wTE=;
        b=t6eo3X9O6oUROf/nH0eeMnzT0xWkrXh6zYnst+zw1OIsgMtKcD4LN+CzP/o9v2L4IE
         6qMTovGFiEEdKsL/yUOjfM+C6WGBQMLAATAZEBFfu623V9hAunjzxrc2TL3oeorMW+KB
         aq2c0+hkf/Zpuw4LpjB6ZEMVK+u+7Ym5jr25MWSiH3k11wm9kYv1Os9EOE39rU7uV6tA
         /IvDrpvz+ysbc3f+5whDzhrjGtYfIjMG4eDusPpIRDlw+7yrreI1rlibt8ZqqrIUxr3E
         SqEaE447uQ+4xmmb/H9e43jsDtWdcde7DkTpcSVbtQ0aGPvoBYThc+S4Rx99b+v53JgM
         Rv4g==
X-Gm-Message-State: APjAAAX+OR6Iy/bOpwhgkowMatdjBi5Yk2dsAPSddA+VZVBxSP5OSyJF
        zxC8CbyXJbCxZpUsxJLB86I=
X-Google-Smtp-Source: APXvYqxlD6y7Bt3F2MMMyeEUc+W/AKLH/NgaL57LWyBzSnFZRtGox1dpnD68RGayahUnrZC+sXEw/w==
X-Received: by 2002:a7b:c1d8:: with SMTP id a24mr11801469wmj.130.1579392839387;
        Sat, 18 Jan 2020 16:13:59 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id i8sm42177432wro.47.2020.01.18.16.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 16:13:58 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/8] scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails
Date:   Sun, 19 Jan 2020 01:13:20 +0100
Message-Id: <20200119001327.29155-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200119001327.29155-1-huobean@gmail.com>
References: <20200119001327.29155-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

A non-zero error value likely being returned by ufshcd_scsi_add_wlus()
in case of failure of adding the WLs, but ufshcd_probe_hba() doesn't
use this value, and doesn't report this failure to upper caller.
This patch is to fix this issue.

Fixes: 2a8fa600445c ("ufs: manually add well known logical units")
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bea036ab189a..9a9085a7bcc5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7032,7 +7032,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 			ufshcd_init_icc_levels(hba);
 
 		/* Add required well known logical units to scsi mid layer */
-		if (ufshcd_scsi_add_wlus(hba))
+		ret = ufshcd_scsi_add_wlus(hba);
+		if (ret)
 			goto out;
 
 		/* Initialize devfreq after UFS device is detected */
-- 
2.17.1

