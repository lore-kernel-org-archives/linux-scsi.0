Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23975C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EACAF61360
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242909AbhI1Vja (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242989AbhI1Vj3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 17:39:29 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4475CC061753;
        Tue, 28 Sep 2021 14:37:49 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id w29so710262wra.8;
        Tue, 28 Sep 2021 14:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yZ9KGhrhLcywAqK/S5yjVM8wp4L0WP/cHm0W4+6MMRU=;
        b=TynBkh91NcxXO88rLVoNIYl+kzTlgXbo7O/uyYD0z6YVak9ltPT+0NoXD6pSqc9yt3
         l5q+RoyEOikkafNVgbaskV7595iX3+f5wQWw3HbcnocCd6RPhTPP5hIT0bMQ9pUPFoN9
         EVM48DULIC4y/FMf5xrxc1hxaBVMZ3G73hkkLZI2q+DyBBWhAX96wNwPI5LYaNy1pkrK
         XIgGDJnh7GslR+E8ID/ZYzJkqg11jREmjps4qcrWUQlJE37J6sFNdG/0hjQmNUghMI7y
         zS71+KmKMAYgpXQ+93z5n+eAKhztcRpvWn8gfwABqzzUBHZkkxfvdGibr98p3xWVioIG
         LFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yZ9KGhrhLcywAqK/S5yjVM8wp4L0WP/cHm0W4+6MMRU=;
        b=Xy9qmnpXWJ3TPz91f405wP4meneAZAEKueDMabR1nU89H2GjVnQx+U657mjb+WMT/y
         F9D8UXxyIDPYN3KXh8+xJ+YS7jf8v8MEfYEznImckYx5CUKNj/PU+IVmvdXo+CE91Z+g
         o3Pvs2EQSrz9UEt9pEQpwyoZWeIZtp6+P51MZUWm6f6hBriKcO8cv9OnjDiIxy5a22mX
         G35L0hkIIuQcQ9nKk4vSSGdtflIYfCLruPOPLpP9JY+VhklTFr/OSxTe/Y307Ew6K7n+
         5P1ZGeMBEWnS2+dVAqtR1iLVdImIIYnIjacHACzG0CND3G+Re/l1Zgf6SHq1Cl0PXwS+
         XXRA==
X-Gm-Message-State: AOAM5339NGRurB7iUq71dvya/FH0ryROibwhzDKefRD0ETgkRRHe7sqf
        LzQnSpnPF42zdaG/VNuhKUo=
X-Google-Smtp-Source: ABdhPJzup5O2OZbLG7zI8IX28sGXrasrAkRYdV83Z8/v0hckVAuYwrxqLMkOkD3+9Qw6MMTtnL7Ylg==
X-Received: by 2002:a5d:5104:: with SMTP id s4mr2822839wrt.16.1632865067954;
        Tue, 28 Sep 2021 14:37:47 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cfe07139628ae9da1147.dip0.t-ipconnect.de. [2003:e9:4717:cfe0:7139:628a:e9da:1147])
        by smtp.gmail.com with ESMTPSA id l18sm270461wrp.56.2021.09.28.14.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 14:37:47 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] scsi: ufs: core: Fix a non-constant function argument name
Date:   Tue, 28 Sep 2021 23:37:34 +0200
Message-Id: <20210928213734.778908-3-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928213734.778908-1-huobean@gmail.com>
References: <20210928213734.778908-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Since commit 568dd9959611 ("scsi: ufs: Rename the second
ufshcd_probe_hba() argument"), the second ufshcd_probe_hba()
argument has been changed to init_dev_params.

Fixes: 568dd9959611 ("scsi: ufs: Rename the second ufshcd_probe_hba() argument")
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index debef631c89a..081092418e2d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -225,7 +225,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
-static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
+static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
-- 
2.25.1

