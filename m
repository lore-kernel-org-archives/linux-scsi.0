Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C7C9C0032E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 14:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377548AbjJTOQC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 10:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377477AbjJTOQA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 10:16:00 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B346F1A8
        for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2023 07:15:58 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-31fa15f4cc6so637927f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Oct 2023 07:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697811357; x=1698416157; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1MDLsNvnwVNc7KgH2iU9SUAVIeAvlB/7zLH1ThkmpBU=;
        b=JMZsmEUwNcQmOru6Fp8j6uqx2J+dSC+bprTxBoGQ9CPlniVXl8ik3vJcZLsRk3veqX
         43fopDsLd2n184nXE0yGdXhzl/fu/9wzg3jGJnsb1y7aHWqiPH5YUIJYTxlhVOTDAEWL
         c0uuOnf6LzzIHgO1xf8JXyblgjv8DBtUxjNpFWWkuzhxvDv9rpdn3AlnyUEK3JQzzcLM
         iFnHE7/b3l6CoUUbVxTWwD80Muw4c3WpImiypnSkVOUQWLK8vdWgRdiatVOQ+zjrDmcu
         EiUIBa+WSIol0OmLSfS5a3i+s9ycF+lZMYUjBC5IEa8XBSmAx5Eflj5yM7wd2VRsAG9N
         d1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697811357; x=1698416157;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1MDLsNvnwVNc7KgH2iU9SUAVIeAvlB/7zLH1ThkmpBU=;
        b=dy4K6PBNszmCN+xJhr+P69Z9wkTA7hVQGFajlB+4tsMTTO85RRsxyhyXRByj3q2iOZ
         61EkFNzbGr+hK4VChHQiTu4LKHbTSCFzLAywCb8phsBu0bkUVqXPJQGGKD/+f/SBTKwS
         4txMJPQbaWDZSosj2F7LZ7pCqUU0UYMU/a8IB9fhkmjsBTWotFID4v+vF/TQguK45Urh
         Um4CzDPVb5eCpLwFgTu9PB6Ub3ObCrum7W1K0DW9ys2ZPR+P54LF22XwNf8T4izdcf+M
         HJjzOkCzhpiRYFWBxNO8XSvzl3aSrtTxY8JzFOShAsUeq/Cg6XLHUyCuOQ+OwrVgzFEA
         Y7Og==
X-Gm-Message-State: AOJu0YyogDSHWkddoJE0PPvxWe8LJXlhP5xbYzUlzgFWPKInYfx+oXL6
        V+uwthmwbIeRiLi58hQ17/VCpZGpzbPJ86vVonQ=
X-Google-Smtp-Source: AGHT+IFRB+NRrVj8GrlclUrUi0o+o6skGs1oVvWc7548xPd2QWq8OCEXwu3W1xPkymUNzISF27EVzA==
X-Received: by 2002:adf:f38e:0:b0:321:68fa:70aa with SMTP id m14-20020adff38e000000b0032168fa70aamr1641374wro.9.1697811357173;
        Fri, 20 Oct 2023 07:15:57 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id u16-20020adff890000000b0032d8ce46caasm1773262wrp.93.2023.10.20.07.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 07:15:56 -0700 (PDT)
Date:   Fri, 20 Oct 2023 17:15:52 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Wenchao Hao <haowenchao2@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] scsi: scsi_debug: delete some bogus error checking
Message-ID: <f96d6366-9271-4020-ab66-f75737a1e8bd@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96d50cf7-afec-46af-9d98-08099f8dc76e@moroto.mountain>
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smatch complains that "dentry" is never initialized.  These days everyone
initializes all their stack variables to zero so this means that it will
trigger a warning every time this function is run.

Really debugfs functions are not supposed to be checked for errors so
this checking can just be deleted.

Fixes: f084fe52c640 ("scsi: scsi_debug: Add debugfs interface to fail target reset")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
See my blog for more information on the history of debugfs error
checking:

https://staticthinking.wordpress.com/2023/07/24/debugfs-functions-are-not-supposed-to-be-checked/
---
 drivers/scsi/scsi_debug.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0a4e41d84df8..c0be9a53ac79 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1127,7 +1127,6 @@ static const struct file_operations sdebug_target_reset_fail_fops = {
 static int sdebug_target_alloc(struct scsi_target *starget)
 {
 	struct sdebug_target_info *targetip;
-	struct dentry *dentry;
 
 	targetip = kzalloc(sizeof(struct sdebug_target_info), GFP_KERNEL);
 	if (!targetip)
@@ -1135,15 +1134,9 @@ static int sdebug_target_alloc(struct scsi_target *starget)
 
 	targetip->debugfs_entry = debugfs_create_dir(dev_name(&starget->dev),
 				sdebug_debugfs_root);
-	if (IS_ERR_OR_NULL(targetip->debugfs_entry))
-		pr_info("%s: failed to create debugfs directory for target %s\n",
-			__func__, dev_name(&starget->dev));
 
 	debugfs_create_file("fail_reset", 0600, targetip->debugfs_entry, starget,
 				&sdebug_target_reset_fail_fops);
-	if (IS_ERR_OR_NULL(dentry))
-		pr_info("%s: failed to create fail_reset file for target %s\n",
-			__func__, dev_name(&starget->dev));
 
 	starget->hostdata = targetip;
 
-- 
2.42.0

