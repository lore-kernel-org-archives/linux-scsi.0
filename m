Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F88DC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 22:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbiGLWT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 18:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiGLWTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 18:19:52 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBB833343
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:51 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso553195pjj.5
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gp31xlzEC2i02lVg8krLl11Lk6DbeUjrmj3d4p0+mVE=;
        b=wMusbTcoWpqWoKElAUZyZjLAETRQjzXlFhWCn6bpLSyWV/GAn0ilLXSG/pC/xDb40J
         Zb7RHwwtDW8FUykgH+0syvT9PwAMJ2h3nVkgmbczvSmREg9QfYcvnDangKT2MPkttmaM
         2eN2BN9+TRYBlXSyeawZ/sdYqz9XtdyFtQrNdSSCnqxvV4GakO55hs3oWDxOSqRGVkXM
         jcW8HQ/kIjDDi4JQKpTXtPynuMvxoECGn3yIJa9FiKveEE+GOYfMlq4MQmW3PFy8vyXI
         56+FAsB3oSiX7sw/Aa428+IPvhS4UCH5UYScxNIuoN84oq5pJ3YSzjZo+kl+8V4RrO2s
         fI6w==
X-Gm-Message-State: AJIora8t6Y/32qdc/QK4fRuFi799M5/rNMVDQh9wlMxj1QaklfTltW2T
        aI9ufxb4qV4hiK1unGjywN0=
X-Google-Smtp-Source: AGRyM1t3rfLgdVRcPwwFoR8Yy3cITjfVMuyxAjOUjMyqNf9Q9evLpz1y8i2td5d4WNG6ciaZqkWAxQ==
X-Received: by 2002:a17:902:efd1:b0:16b:dc3b:7fbc with SMTP id ja17-20020a170902efd100b0016bdc3b7fbcmr388867plb.45.1657664391127;
        Tue, 12 Jul 2022 15:19:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:de3c:137c:f4d2:d291])
        by smtp.gmail.com with ESMTPSA id w12-20020a63f50c000000b0040d0a57be02sm6640192pgh.31.2022.07.12.15.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 15:19:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v4 4/4] scsi: core: Call blk_mq_free_tag_set() earlier
Date:   Tue, 12 Jul 2022 15:19:36 -0700
Message-Id: <20220712221936.1199196-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
In-Reply-To: <20220712221936.1199196-1-bvanassche@acm.org>
References: <20220712221936.1199196-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are two .exit_cmd_priv implementations. Both implementations use
resources associated with the SCSI host. Make sure that these resources are
still available when .exit_cmd_priv is called by moving the .exit_cmd_priv
calls from scsi_host_dev_release() to scsi_forget_host(). Moving
blk_mq_free_tag_set() from scsi_host_dev_release() to scsi_forget_host() is
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

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Fixes: 65ca846a5314 ("scsi: core: Introduce {init,exit}_cmd_priv()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c    | 10 +++++-----
 drivers/scsi/scsi_lib.c |  3 +++
 2 files changed, 8 insertions(+), 5 deletions(-)

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
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2aca0a838ca5..295c48fdb650 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1990,7 +1990,10 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 
 void scsi_mq_destroy_tags(struct Scsi_Host *shost)
 {
+	if (!shost->tag_set.tags)
+		return;
 	blk_mq_free_tag_set(&shost->tag_set);
+	WARN_ON_ONCE(shost->tag_set.tags);
 }
 
 /**
