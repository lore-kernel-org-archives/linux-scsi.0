Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB8FAC6FA99
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 21:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjCGVox (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 16:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjCGVov (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 16:44:51 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949D9A1FC7
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2023 13:44:35 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so61425pjz.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2023 13:44:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678225475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WertYbNyQZoAwK2dhL/DP3fy6e4ElWcn4JIFlCrz/cY=;
        b=jIN9rLkbb1YqRq4b7dky/iR9KjNTL7OA2iIyPnCN9dEUbCUdAr6t+CAuXfjKB2sQS7
         Z9pAUaY/OAKvkQzBata38P0IdemlYh0M/o0W3W97XDEoSgPT0xb5SWaFAzCv0V3SjdcN
         zeMKKSnbD5vFAMBAZOAQ/4y0nbEiNwzGBmDhf8bFeoczNofEn+cJGXHhw6nDDrub8hhk
         iXw2qbtiQhajpQ/U35+hKpu1dwBEjFjmr1VUm98ehSWM77TWS6w60aTNMlfgpESGw5Fs
         bIMaSBbdKPrNRvIZUmg4xDHQlZFgkjjUdXwGOsKDIROh7jleu5W/g3r3Vg3IVmFVJ4ja
         CfMw==
X-Gm-Message-State: AO0yUKUuSyojaQkvPpsY3qpLdFpWGYhd8Dq/ue/nNFf8lLdeR/Elka0m
        jEHxItiM9Ze5vB7HOmq2brk=
X-Google-Smtp-Source: AK7set8slf6Q94IbyGc1v/WzVWvNyAp+NgY2WU047iG0k5mKoHhEHI4OkHVpH8Nf+ytTbCEGxQpCSA==
X-Received: by 2002:a05:6a20:a01d:b0:be:c5de:7157 with SMTP id p29-20020a056a20a01d00b000bec5de7157mr14656547pzj.53.1678225474645;
        Tue, 07 Mar 2023 13:44:34 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8361:6b6b:1140:bcbb])
        by smtp.gmail.com with ESMTPSA id y22-20020aa78556000000b005a817ff3903sm8313151pfn.3.2023.03.07.13.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:44:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.g.garry@oracle.com>,
        syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: core: Fix a procfs host directory removal regression
Date:   Tue,  7 Mar 2023 13:44:28 -0800
Message-Id: <20230307214428.3703498-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_proc_hostdir_rm() decreases a reference counter and hence must
only be called once per host that is removed. This change does not
require a scsi_add_host_with_dma() change since scsi_add_host_with_dma()
will return 0 (success) if scsi_proc_host_add() is called.

Cc: John Garry <john.g.garry@oracle.com>
Reported-by: John Garry <john.g.garry@oracle.com>
Reported-by: syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com
Fixes: fc663711b944 ("scsi: core: Remove the /proc/scsi/${proc_name} directory earlier")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f7f62e56afca..9b6fbbe15d92 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -341,9 +341,6 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
-	/* In case scsi_remove_host() has not been called. */
-	scsi_proc_hostdir_rm(shost->hostt);
-
 	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
