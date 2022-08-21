Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEDAC00140
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 22:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiHUWFV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 18:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiHUWFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 18:05:16 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB0213F6D
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:15 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id x15so7807178pfp.4
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0VwZUnoAKsTU3QZyo0Wn07IK3n+pQzKKsf+5q3gT3x4=;
        b=ltHuBzoqYI7bZrrie8ZnqzaaRtT4EnvxjRE+8gOk6jRgLxyDetHuRh89bbElfKP1lf
         4VhJEI8pI7hmixCd6ebrhXE76Hx1sa5tQlPuUojm44xUVNdwkl45JDuyBMVyfiRwThVN
         dSa7PSbTXee4fnp6mhMpR5qoJ4vnv9zPL9y7XTxQWCxUiCTenOnd5SkAw+TToUh+Iqnp
         ZwV7ecCOxI/QLCyb4xBroUVDPAhJsyELNhBKnN14QnOzBrcKqpSdOEkbHjsSEdxyouqZ
         i9i91w3kF6Ffk9dd2jkgcnhNhWj1hFKkA/LVsRw76do6mgERjmIBfFKE8tsFGunIKdl8
         ThaA==
X-Gm-Message-State: ACgBeo0kQ2/e0PFKOk38+O1qna0DV/Rhs+Ac0xuQBIBBlr1EV2fteXEA
        cj6XQmzO1IjE4jpA8GeSHHQ=
X-Google-Smtp-Source: AA6agR463FihpAVZOfZnxkdMkhGjpILCw7UsUOVuPvLmrW3yJ/vud1HNiqoF1Jq0/YH3SSZo79zFLg==
X-Received: by 2002:a65:6bca:0:b0:420:712f:ab98 with SMTP id e10-20020a656bca000000b00420712fab98mr14624976pgw.350.1661119514740;
        Sun, 21 Aug 2022 15:05:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902ce9100b0016c09a0ef87sm3110994plg.255.2022.08.21.15.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 15:05:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com
Subject: [PATCH 1/4] scsi: core: Revert "Call blk_mq_free_tag_set() earlier"
Date:   Sun, 21 Aug 2022 15:04:59 -0700
Message-Id: <20220821220502.13685-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220821220502.13685-1-bvanassche@acm.org>
References: <20220821220502.13685-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Revert the patch series "Call blk_mq_free_tag_set() earlier" because it
introduces a deadlock if the scsi_remove_host() caller holds a reference
on a device, target or host.

Reported-by: syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com
Fixes: f323896fe6fa ("scsi: core: Call blk_mq_free_tag_set() earlier")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 0738238ed6cc..20c1f5420ba6 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -197,8 +197,6 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	 * the dependent SCSI targets and devices are gone before returning.
 	 */
 	wait_event(shost->targets_wq, atomic_read(&shost->target_count) == 0);
-
-	scsi_mq_destroy_tags(shost);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -309,8 +307,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	return error;
 
 	/*
-	 * Any resources associated with the SCSI host in this function except
-	 * the tag set will be freed by scsi_host_dev_release().
+	 * Any host allocation in this function will be freed in
+	 * scsi_host_dev_release().
 	 */
  out_del_dev:
 	device_del(&shost->shost_dev);
@@ -326,7 +324,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
-	scsi_mq_destroy_tags(shost);
  fail:
 	return error;
 }
@@ -360,6 +357,9 @@ static void scsi_host_dev_release(struct device *dev)
 		kfree(dev_name(&shost->shost_dev));
 	}
 
+	if (shost->tag_set.tags)
+		scsi_mq_destroy_tags(shost);
+
 	kfree(shost->shost_data);
 
 	ida_free(&host_index_ida, shost->host_no);
