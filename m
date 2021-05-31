Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84160C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 21:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53C1E6127C
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 21:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaVYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 17:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhEaVYD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 17:24:03 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B80C061574
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 14:22:16 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id a15so8805880qta.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 14:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=nZsFxHO6xEkOsAl6RljPMDlCkqArxHXwF6ixyH6zbNg=;
        b=eRZz8/QBImDNwBEmezwX2gdzEiyddSb0zHotnPuhOupmG81lgZUAzWbTI/xKSLIz8f
         2vjXvnH19K2dDZzmdNJdwdBAUn7T80NpTwE0XUaRhmEaj+zShR3PU8Em8fo6HaazqHRl
         YWb88yvvGgon1Dr01YszdC+Q4CtnxwMLd4BMH3gONnTWoFDL0xyWMWgXhbe+Y1poKz0B
         0btb2hhqVwKbNfSJ6dIoYr4cd2k/1S4pwiuNZDbbID/8VwXD3j6Jk18/I+Xs1upy7u5p
         kUIWoYrV2NeTXhAzFGnBGCcCQJGZjI1VNEgPlyFT0E3rn9rb1DRq9ZLsX6RO0mCqJqGr
         n0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=nZsFxHO6xEkOsAl6RljPMDlCkqArxHXwF6ixyH6zbNg=;
        b=Yr+jp0gCjLl2ZqCTdNCXXMVGHGkEU6kIBMTvq1X+9RmRggtaNRjZYkT6XN7pjeaORe
         wADu5QxHkKG0WDfeEKEs/MLjc6CoUTYS9MDC0Km8c8eIvxvIqULzOL4uOCYHGjYsln5n
         1b/cULPKV6ZoVBUCwsCQNhukeDSfwQqRuPKAEeOInEe+bDRSeFGta5kGtlyuzQFAjxoi
         yemngaA8mYP+kwXSxw8zJRH6X27lCXKT4Y7+yNPVM4vFqxs17Yx1pxNI2bOxfc7yF+Nw
         PIKMlQq6qYkHarPGgsolBGVPksMuQu1OW83/Ht4ywJHN8Y7edsVm5r+6I9w/Na9zT+fp
         Nb5A==
X-Gm-Message-State: AOAM530j0HHeNxW3IM84Nqe9mNwZsoqyyyFSm08r0t1exDf13ptxU28j
        1bDs2Mpl4OHZ4mToLmKLUnw=
X-Google-Smtp-Source: ABdhPJzKJxWpIxJXSqSlkD0icKMBbyOcxkEFy0Q0toNTIRvaDYZ58QCBom0Nyj96ySOGnzwgQ/JJgg==
X-Received: by 2002:a05:622a:309:: with SMTP id q9mr16274007qtw.320.1622496135674;
        Mon, 31 May 2021 14:22:15 -0700 (PDT)
Received: from david-pc (c-73-82-11-57.hsd1.ga.comcast.net. [73.82.11.57])
        by smtp.gmail.com with ESMTPSA id d12sm10133296qkn.126.2021.05.31.14.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 14:22:15 -0700 (PDT)
Date:   Mon, 31 May 2021 17:22:13 -0400
From:   David Sebek <dasebek@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     dasebek@gmail.com
Subject: [PATCH] scsi: Set BLIST_TRY_VPD_PAGES for WD Black P10 external HDD
Message-ID: <YLVThaYJ0cXzy57D@david-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 5TB 2.5-inch WD Black P10 external USB hard drive seems
to use SMR technology. It supports TRIM via the unmap operation.
Maybe because it is marketed as a drive for gaming that is
compatible with PlayStation, Xbox, PC and Mac, it does not
support UASP protocol but uses bulk-only transport.
Therefore, Linux does not attempt to read the VPD and does
not enable TRIM by default. (Currently, there is a bug and
Linux incorrectly enables a writesame_16 TRIM operation on
the drive and does not change it to the correct unmap TRIM
operation because it does not attempt to read the info from
the VPD. I already submitted a patch for that bug.)

This patch adds this drive to the scsi_static_device_list
with a BLIST_TRY_VPD_PAGES flag. Although there are comments
in the code indicating that this list is deprecated and that
'echo "WD:Game Drive:0x10000400" > /proc/scsi/device_info'
should be used instead, I haven't found a better place to
persist this information. Moreover, the list already contains
a similar entry for the SanDisk Cruzer Blade USB flash drive.

Signed-off-by: David Sebek <dasebek@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index d92cec12454c..3ed558c168be 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -256,6 +256,7 @@ static struct {
 	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
+	{"WD", "Game Drive", NULL, BLIST_TRY_VPD_PAGES | BLIST_INQUIRY_36},
 	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN},
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
-- 
2.31.1

