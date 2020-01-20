Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C750C2D0DB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73EB222314
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:09:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eUjG3+sc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgATNJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:09:28 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33091 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgATNJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 08:09:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id d139so14726654wmd.0;
        Mon, 20 Jan 2020 05:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nfRc8qQhIj3SkQPDN7l7ruKxb1Lhpkv0HXJIJCsM07A=;
        b=eUjG3+sc7ERm3Es8wJRe+/7lo+gswYModoGJULMSR3hlyY+Ij3Em7ZY2/9ndsukfuN
         tf3XgP16sZO8Wt6eoaqIKS3TNPZUW5PN/SrFSPiR8tmDd5JyyVNl7LSVhvdMRVGYZVfQ
         t1mLoAWnVJ6F5eu2MBocx2Txxj70QeBjXCRLa13Ei1/29uri219MqWPaUas1xcX/2WpZ
         3ymr13bWKywazH1hlYAxFj0ZVgWpKBg7Jya4aAUvsprTgjdnSWI2+G/C7IydigXOTobS
         R2SJxTStqTZqjmCwz4aHAAsKOPa7Zm66lfeZqOkLw7qKLp37D6VTliK/nmBaQ2Xo5nAz
         vZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nfRc8qQhIj3SkQPDN7l7ruKxb1Lhpkv0HXJIJCsM07A=;
        b=eNJ1hwYSv2Ldk/h7lYVQEymbudarFQYQRHmTMfhHsjlMJNo79WBrfzTjyhrt0/qmTR
         bOIZEwA2mFecYlDwFsc4Jnbx9rgXNPK4F0nlWyrNLy36a9CcV9sXRCDyL8CfHbzTHFp/
         WNZD2xf/zaRTh2UA+CRQuVG6St6o7Ud5jOBXP2GLbLqEROJd1HrGgkgxMOqVqe3U1Gl5
         6q+j0hvhH+4/VybBsLJIndvLiS3bfvTvD/xp7AXCs4Eo39uX2StpfvCCAhk5B7RTV5MQ
         tEhA9CcmmvrOmlbFij9RpwWgb6SeZSmWrPo77Gi/C501h5qRBQ0riuLH7PM+t5FbXe1i
         12fA==
X-Gm-Message-State: APjAAAWjdUCLBl1rLMW3Y+jXirVPmCN6rlR4BEQKVTPWPp5iE+zTPDAG
        eaoHZsKZ9+Neeb+UJXZOYZU=
X-Google-Smtp-Source: APXvYqxm1eE4NCJQZ/6cZ/MJBwzv04zShUzVRAD22LmRwCnKVqCk7lhkUGEY6FIdYGMZeipLOCFlPg==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr17988259wmi.166.1579525766782;
        Mon, 20 Jan 2020 05:09:26 -0800 (PST)
Received: from ubuntu-G3.micron.com ([165.225.86.138])
        by smtp.gmail.com with ESMTPSA id p18sm23065386wmb.8.2020.01.20.05.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:09:26 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/8] scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails
Date:   Mon, 20 Jan 2020 14:08:13 +0100
Message-Id: <20200120130820.1737-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200120130820.1737-1-huobean@gmail.com>
References: <20200120130820.1737-1-huobean@gmail.com>
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
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
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

