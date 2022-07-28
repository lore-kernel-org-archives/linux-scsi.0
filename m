Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C148C19F2C
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 22:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiG1WTb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 18:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiG1WTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 18:19:12 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83740796B0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:10 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id 72so2632557pge.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fVzKx7LpKP33lH5KeVaRNLNNYCuSjsOmOSePqGt9R50=;
        b=RL60aDZGOF1h7XkDZCKrdX8R9Vd7lIbpGiHvp9QaYU90MmC987gaXSgaHeQsOSls3z
         GVFZb8fIKMgZbTI1se0rPvG/wwV9ybhq8Eha3JZyOyQRvIlJobiiSQsmYXv/IYNh/7QR
         22tfJuKV2R3/gTRsKARiCV1Ua1BgwrA+32towFl6Jjy8pQre/9IUL1YIE6GNPzeBJPv4
         2kYXLlK+fHIkpuUgEio5LrhbR9aG1VtyMmNseDlpwhy33Pib8mDXJpFrAQ7RAko38uER
         xI0HXu/EmAarWBcLNSszAu/qSG3xmG0RIXpXnHP2LVk3MOEZKUdS51ywSraYq/XZnxb9
         pO7g==
X-Gm-Message-State: AJIora8yJkMHK93Gc4rWQ6bLHpQUdt16d4vYXrfbyROQjoGP2cwkZCyV
        UBtv6Stp0GCGi6ioPMZkNhw=
X-Google-Smtp-Source: AGRyM1tO05aDR6KqDknJHoT1vTOh9VaymDCDpvC3pQcZAAvsfn3/LN36twJfrpTVEwFMbahlLQG8VQ==
X-Received: by 2002:a63:541:0:b0:419:aea5:eff9 with SMTP id 62-20020a630541000000b00419aea5eff9mr634532pgf.291.1659046749934;
        Thu, 28 Jul 2022 15:19:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9520:2952:8318:8e3e])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902c40b00b0016dc8932725sm1556709plk.285.2022.07.28.15.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:19:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 4/4] scsi: core: Call blk_mq_free_tag_set() earlier
Date:   Thu, 28 Jul 2022 15:18:51 -0700
Message-Id: <20220728221851.1822295-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
In-Reply-To: <20220728221851.1822295-1-bvanassche@acm.org>
References: <20220728221851.1822295-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are two .exit_cmd_priv implementations. Both implementations use
resources associated with the SCSI host. Make sure that these resources are
still available when .exit_cmd_priv is called by moving the .exit_cmd_priv
calls from scsi_host_dev_release() to scsi_forget_host(). Moving
blk_mq_free_tag_set() from scsi_host_dev_release() to scsi_remove_host() is
safe because scsi_forget_host() waits until all SCSI devices associated
with the host have been removed.

This patch fixes the following use-after-free:

==================================================================
BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
Read of size 8 at addr ffff888100337000 by task multipathd/16727
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x5e/0x5db
 kasan_report+0xab/0x120
 srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
 scsi_mq_exit_request+0x4d/0x70
 blk_mq_free_rqs+0x143/0x410
 __blk_mq_free_map_and_rqs+0x6e/0x100
 blk_mq_free_tag_set+0x2b/0x160
 scsi_host_dev_release+0xf3/0x1a0
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 scsi_device_dev_release_usercontext+0x4c1/0x4e0
 execute_in_process_context+0x23/0x90
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 scsi_disk_release+0x3f/0x50
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 disk_release+0x17f/0x1b0
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 dm_put_table_device+0xa3/0x160 [dm_mod]
 dm_put_device+0xd0/0x140 [dm_mod]
 free_priority_group+0xd8/0x110 [dm_multipath]
 free_multipath+0x94/0xe0 [dm_multipath]
 dm_table_destroy+0xa2/0x1e0 [dm_mod]
 __dm_destroy+0x196/0x350 [dm_mod]
 dev_remove+0x10c/0x160 [dm_mod]
 ctl_ioctl+0x2c2/0x590 [dm_mod]
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0xb4/0xf0
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0xb4/0xf0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Fixes: 65ca846a5314 ("scsi: core: Introduce {init,exit}_cmd_priv()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8fa98c8d0ee0..6c63672971f1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -197,6 +197,8 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	 * the dependent SCSI targets and devices are gone before returning.
 	 */
 	wait_event(shost->targets_wq, atomic_read(&shost->target_count) == 0);
+
+	scsi_mq_destroy_tags(shost);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -302,8 +304,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	return error;
 
 	/*
-	 * Any host allocation in this function will be freed in
-	 * scsi_host_dev_release().
+	 * Any resources associated with the SCSI host in this function except
+	 * the tag set will be freed by scsi_host_dev_release().
 	 */
  out_del_dev:
 	device_del(&shost->shost_dev);
@@ -319,6 +321,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
+	scsi_mq_destroy_tags(shost);
  fail:
 	return error;
 }
@@ -352,9 +355,6 @@ static void scsi_host_dev_release(struct device *dev)
 		kfree(dev_name(&shost->shost_dev));
 	}
 
-	if (shost->tag_set.tags)
-		scsi_mq_destroy_tags(shost);
-
 	kfree(shost->shost_data);
 
 	ida_free(&host_index_ida, shost->host_no);
