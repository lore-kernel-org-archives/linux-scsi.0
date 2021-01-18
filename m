Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AD6C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B3A22E02
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437898AbhARUM4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437859AbhARULe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:11:34 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC077C0613C1;
        Mon, 18 Jan 2021 12:10:53 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gx5so6150007ejb.7;
        Mon, 18 Jan 2021 12:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=73XbxUbs64FU2jf4GNHlCLFC9xngJBFU6S4JYLdWQPY=;
        b=EElB4eeRk0qL+qtOQdwO4VzxuqCyj4d7facrUMagC5gqDrz3EmUba7cxdByuEbM4NN
         ZE8qTRHA6Y4wTRr5E4/L+jb9gnIj6LAAdKaKM53Q/w0C3Bil/XxOVq8gpsWUnzO9fEj7
         MdvJe9s/bOMDsByZeTJbo/MUHcfr2KKdW7Q122Z3e4dEXVe/UctSJqBMGQrSjgMdkdMS
         IVJD+qJPSfVhgk3N5D/2YbytJcMgRXz9+GGNKop1WgYC53mgWP7mnT4x0awmchAHOxVM
         cnTIe+tcWRDiLs/Tc/aXc3B23VDVMMlYswKKXAR65YJrFh/7KAT7JjgoVdk7n9af/dDf
         3WeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=73XbxUbs64FU2jf4GNHlCLFC9xngJBFU6S4JYLdWQPY=;
        b=dcUs9OlW4Xoy6vtVHCjr2OjUDjSvKdDErD9mwtxc3uF/0dJSKcHx+isMFA0ut7aFdT
         CLevPEEV8Y4txnCP2G5L0hCu0IcXfQvUr9bBXR8ybd3y6A4+U0ZIR+TQEl+uG+pKbadw
         Z8rfVYOYyJFIClqo8wRtMwM7n2BRQiUThS+T6GY89nQvUstXTJUkyHT32wzHG3xVKiiV
         BOkrLGra4xDc87uG/y9tBYvXcBDWSA26QC42D2iG7anAxmBEzDN26KFX5F3i71aJzNMt
         sAqoTSUdMIAfEOiUKapz4T586MQtf5jFxgMWRd86HEDur+TxANWMFpLl/dxMppyZZSQO
         mArQ==
X-Gm-Message-State: AOAM531Aqxq9cVD3bRDVRZc26k72cSZys7Ra0dOg5pibzAFZBqIRR3q/
        zkC/NvHM9BOTMZ9aZECqyEI=
X-Google-Smtp-Source: ABdhPJznGH4/1+AIfeU1Jj3YROTe4oOtb6hLcVKBQVnEphQbn+8G+XS/JiCjvNjEgj5gE9FW9O6XDA==
X-Received: by 2002:a17:906:6087:: with SMTP id t7mr910768ejj.90.1611000652628;
        Mon, 18 Jan 2021 12:10:52 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id qh13sm3972543ejb.33.2021.01.18.12.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:10:52 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/6] docs: ABI: Add wb_on documentation for UFS sysfs
Date:   Mon, 18 Jan 2021 21:10:35 +0100
Message-Id: <20210118201039.2398-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210118201039.2398-1-huobean@gmail.com>
References: <20210118201039.2398-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Adds UFS sysfs documentation for new entry wb_on.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index adc0d0e91607..f0a1ac385c7f 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1153,3 +1153,11 @@ Description:	This entry shows the configured size of WriteBooster buffer.
 		0400h corresponds to 4GB.
 
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_on
+Date:		January 2021
+Contact:	Bean Huo <beanhuo@micron.com>
+Description:	This node is used to set or display whether UFS WriteBooster is
+        enabled. Echo 0 to this file to disable UFS WriteBooster or 1 to enable
+        it. Note, this is only allowed for the platform doesen't support
+        UFSHCD_CAP_CLK_SCALING.
-- 
2.17.1

