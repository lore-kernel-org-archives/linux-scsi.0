Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C985CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5BFA208C0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZYKAltR2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388505AbfJ1Uy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:54:26 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34446 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJ1Uy0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:54:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id k7so6289046pll.1;
        Mon, 28 Oct 2019 13:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=GLvxNZigDjIH0DGpnyLz+xuaagvehXTngUpiN5P3UPE=;
        b=ZYKAltR2nlkZSpfM+xj9WQKVKtkVmCLxoyytmDwhgLSaymK9wkdvs9+y+hQJwr2Dxt
         cfUpBvszqnGopfTmm4UOl1ugzIdRecFrUiWkNsnMO1zMt5UaYjS35tJLBSDovyI/Noey
         XQ7wPy4VmA7pR3JRToR3ZkU2XlE6smkrX8QGkjhyXfTWEAgr038l2IHzOX4EqcujLrZz
         IomKgLvcJV66nVS16BRuUDCIhIXAI0nq6o+50K/Gb9QDGZIy6kjN8Fnw1RmDOHXRk+7S
         ijI94828NKPSXaSAFdDQ6FrJQuHtbwICzeuCD6Jg2lzyaYzjD078pV4GZI0vw0NRl4ky
         thMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=GLvxNZigDjIH0DGpnyLz+xuaagvehXTngUpiN5P3UPE=;
        b=L4JOueVD/1Pa6WfjaepVF/ePOnJLXcK3gJpTDv3lSmw93Znh3eJh3bCwsZUUn4nm3g
         oMY+dZKZctkRIaZmOfhrXeaf4VRQSy4hsM5A3tTA8Wp6Nz0RQMpa7HfySwGbS69Ao76L
         F5l00/eIHCHMHruNSFSJl9WYxXcSCrs8HcbNq1PhW0hNSXHztauqiep4cULpc1x7F/6S
         n8jXwdgEnB06k/0yErX4H2uhK/HZnotKdwQaIDv9aMBOo1g+lQBJcGDmovRJbgnpRUIb
         +N2bsCru7Rc9RdQ1gOxUxDOm7ya3O6IsMSZ5RIgc88uCAHZ7hZJ7nbEwuAGTOrj6Uz9r
         v9TA==
X-Gm-Message-State: APjAAAVLfltfNgPgZjjVKTRC7412UEp+NUrPyexM7HkK3Z/V4XOjEWUW
        xBhgmppXm2mGK/CI2fHee1frr2Id4zc=
X-Google-Smtp-Source: APXvYqwfjAMzuz8V7lUBoqVvBeXj6ek2KgSWXTDZBYmXzPqarNRnxWuwAivIN4j0x/wlsOqtQDpqRQ==
X-Received: by 2002:a17:902:6802:: with SMTP id h2mr28402plk.135.1572296065039;
        Mon, 28 Oct 2019 13:54:25 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id s3sm8804729pfm.138.2019.10.28.13.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:54:24 -0700 (PDT)
Date:   Tue, 29 Oct 2019 02:24:18 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cxlflash: superpipe.c: remove unneeded variable
Message-ID: <20191028205417.GA29635@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove unneeded variable rc as it is not modified in function.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/scsi/cxlflash/superpipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 593669ac3669..4ca64cdec438 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1233,7 +1233,7 @@ const struct file_operations cxlflash_cxl_fops = {
  */
 int cxlflash_mark_contexts_error(struct cxlflash_cfg *cfg)
 {
-	int i, rc = 0;
+	int i;
 	struct ctx_info *ctxi = NULL;
 
 	mutex_lock(&cfg->ctx_tbl_list_mutex);
@@ -1252,7 +1252,7 @@ int cxlflash_mark_contexts_error(struct cxlflash_cfg *cfg)
 	}
 
 	mutex_unlock(&cfg->ctx_tbl_list_mutex);
-	return rc;
+	return 0;
 }
 
 /*
-- 
2.20.1

