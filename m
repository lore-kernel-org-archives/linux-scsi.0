Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4029C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 21:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbiF3Vht (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 17:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiF3Vhs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 17:37:48 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AF752396
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 14:37:47 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id s206so574864pgs.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 14:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C8A1tJBtGVfB7BIe1SGk9cvQJRe9KmUpBgpcoVMDFVY=;
        b=8Le4cJYaKPifeFP3ioyaKGVHQNmc8GxE3ydDF8LO5eOfjNQTntzySmPXsmoRbVLsYS
         MXvxwgbClqfPnFp9KkZ74KYCnee6j2sKfeQk3dxIkjwStTITBKLfPIhTYQLeeO3L+igU
         Ig0DOmqQXQdFluZiCBWk9ptg04dMgq4xw2Nyr/HvNUrogF8mInJBQ58ZnG2+xIfkHXgq
         fd5OskCtj57IwhTLrp3Bw1Cuwd2SK7m3cFVKWpaqoa3AO0NdflVIqD3bVSMlnGDxczzl
         yQpuRQInKC9loIAO41ayrwjAZaG8d60MxoYp2UQQmKnnoI8G6INGh12U4AV52zJCVBRQ
         lSUQ==
X-Gm-Message-State: AJIora9acN4mQd8wSQzCapnpr11AeL0e37WH+tBGC6fXo2dGP4u4smYs
        qcZjMv2bR51UuDHVQLmBvoQ=
X-Google-Smtp-Source: AGRyM1sfu3eHRO9F736bhs+BSJEVg3S4Pl9q4EiKECmEMEaoh0FbIECiajHFlbH+e+Otz+Bhps7BDg==
X-Received: by 2002:a05:6a00:a8b:b0:4cd:6030:4df3 with SMTP id b11-20020a056a000a8b00b004cd60304df3mr16426634pfl.40.1656625066598;
        Thu, 30 Jun 2022 14:37:46 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id mt18-20020a17090b231200b001e0899052f1sm2484701pjb.3.2022.06.30.14.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 14:37:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v2 3/3] scsi: core: Call blk_mq_free_tag_set() earlier
Date:   Thu, 30 Jun 2022 14:37:33 -0700
Message-Id: <20220630213733.17689-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630213733.17689-1-bvanassche@acm.org>
References: <20220630213733.17689-1-bvanassche@acm.org>
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
safe because scsi_forget_host() drains all the request queues that use the
host tag set. This guarantees that no requests are in flight and also that
no new requests will be allocated from the host tag set.

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
index ef6c0e37acce..74bfa187fe19 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -182,6 +182,8 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
 
+	scsi_mq_destroy_tags(shost);
+
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
@@ -295,8 +297,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	return error;
 
 	/*
-	 * Any host allocation in this function will be freed in
-	 * scsi_host_dev_release().
+	 * Any resources associated with the SCSI host in this function except
+	 * the tag set will be freed by scsi_host_dev_release().
 	 */
  out_del_dev:
 	device_del(&shost->shost_dev);
@@ -312,6 +314,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
+	scsi_mq_destroy_tags(shost);
  fail:
 	return error;
 }
@@ -345,9 +348,6 @@ static void scsi_host_dev_release(struct device *dev)
 		kfree(dev_name(&shost->shost_dev));
 	}
 
-	if (shost->tag_set.tags)
-		scsi_mq_destroy_tags(shost);
-
 	kfree(shost->shost_data);
 
 	ida_free(&host_index_ida, shost->host_no);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6ffc9e4258a8..1aa1a279f8f3 100644
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
