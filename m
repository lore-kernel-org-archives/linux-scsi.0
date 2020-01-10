Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9C1C282DD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 18:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 034D520842
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 18:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhEaXCE9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgAJSgn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 13:36:43 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34440 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgAJSgl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 13:36:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so2777865wrr.1;
        Fri, 10 Jan 2020 10:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pdOwgb77hw5W7/fMrT3rXjdCdL0Strxze8eiojAXtTg=;
        b=fhEaXCE9ZImAaW0znUttr7EmxkKXyMJ8aAa6ctKxbgzIrBIi+Y/o8N8+RbXam6/HXZ
         Cw0KxpCHBgvU49O8HPlteulKyy6AXoibYu+wXLtuJEIncQmX7622CLdZtAw0UCl/3iHS
         9nilkbMvefeUlkb7ZhZLIgIKBhzhDnG+7SqFYrEMxDbtg5csU7XuV2mofg2JHyT+0cFI
         X/d4kDaExpQEst2ZdmG0kxpEYJ/x7AS5ZLGxnsoE1uK4jNIlEDqZBAVh443uZCisRIEG
         TLqw0M07L5rQ6T6XGO4JRpjJ8ZwTwtIBEVm6ag8ENdg2A7HaY7nO/h16JLSjmaLyESjw
         ffHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pdOwgb77hw5W7/fMrT3rXjdCdL0Strxze8eiojAXtTg=;
        b=bNaKr+T74I5fYzaXIDS7GuyGkUqM3CVHA1I1C/Gd9GtlLVUrAX4gV2yolvwiAREEkp
         cuvm5PUxSHFNVGR7j1+55c1nIMCAl1fHuEny4yxYprkkS//K19zdl88duePR7vOhD94q
         +Kmu+i4TVbcW6me0rwjY2U5m6iZ+M+9sJK6R+g8xgE3wt3b9URUjzM2Cq8pTZ4YnEqhM
         BIoNj3KuMe/lZMniTmiVxZnWJpjxv92hkJle/ckaK9U0rIyobKXuc0FaTWb5Z5/fmbDz
         Gu2ecsGgU/vEc08BOkpzt7eZSBu8ggPqXcA6LN9wMikVajmgnjfVawx/Q97W+HifoSLb
         TVOw==
X-Gm-Message-State: APjAAAUJlXgfHFvlwZiSpo8j+fa9F/SiurNA2O5SQ5mhodZ3kacD6s3V
        b6WlgIEzTeWaR34mckwMcIY=
X-Google-Smtp-Source: APXvYqxWzBzeoDTdUcPLmULJgQcWtmntniN4ym0sK8nVJke7SzAcOlGgtPAr86X0MnLklB4d4Bu7fA==
X-Received: by 2002:a5d:494f:: with SMTP id r15mr5038525wrs.143.1578681399816;
        Fri, 10 Jan 2020 10:36:39 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id x11sm3182825wre.68.2020.01.10.10.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 10:36:39 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] scsi: ufs: add max_lu_supported in struct ufs_dev_info
Date:   Fri, 10 Jan 2020 19:36:04 +0100
Message-Id: <20200110183606.10102-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110183606.10102-1-huobean@gmail.com>
References: <20200110183606.10102-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Add one new parameter max_lu_supported in struct ufs_dev_info,
which will be used to express exactly how many general LUs being
supported by UFS device.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index c89f21698629..5ca7ea4f223e 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -530,6 +530,8 @@ struct ufs_dev_info {
 	bool f_power_on_wp_en;
 	/* Keeps information if any of the LU is power on write protected */
 	bool is_lu_power_on_wp;
+	/* Maximum number of general LU supported by the UFS device */
+	u8 max_lu_supported;
 };
 
 #define MAX_MODEL_LEN 16
-- 
2.17.1

