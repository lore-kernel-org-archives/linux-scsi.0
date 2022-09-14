Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD297ECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 22:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiINW5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiINW45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 18:56:57 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82AB7FF9D
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:56:56 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so15824521pjl.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:56:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=J2XQsX+0ms+bazFRVKIAEDMgyTBXxMOAVpbtlR1zqtY=;
        b=1vfOALCrW15xX+iUJPvGCekvwPKF+muwNTGc7eKX1NIIDbrwUn1anNoxbgtXJfFu2u
         bLss5e3BEmazUWqCBOhVaLvMZa5aHtRFGJz5lzgP/8rCwGRaWAfNP3W2P0alevoNQtl7
         ebIahDhHGrF6Uxb39j8RIHrxi43Mz6Wj0aN52Rx5xoI67kDpE60YZA1PtOPb4t3Ks3n9
         SxtJwZvIVTyz1qG1OzSlghkZ8do73re0bYFseK7GzDFrSQhR+IgDBw+nuyF9QiKLXUQS
         kxwz1qwtVRE+I4OWSrGzFtVFZ4VHBPWZez0diUVuOqMSomGEfPkmwic23lCa8VoipbVI
         BcLA==
X-Gm-Message-State: ACrzQf37ueFOdofmbmVgIgEBY4aRuU3DXal8vGLKonsSJdxP68WRBifu
        /kuUMMDlvnqkke9oGyQ3jBg=
X-Google-Smtp-Source: AMsMyM6j2wPL/eYW0Zte5z2hG12fNb4iMJ1zU63Va2E57M2aFOgghIX1DUEah8hfzscTBi9rheD64Q==
X-Received: by 2002:a17:902:7082:b0:177:f7fc:5290 with SMTP id z2-20020a170902708200b00177f7fc5290mr1238807plk.143.1663196216113;
        Wed, 14 Sep 2022 15:56:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9147:e0c1:9227:cf53])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902d70900b0016d1b70872asm2606926ply.134.2022.09.14.15.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 15:56:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@Odin.com>
Subject: [PATCH v5 5/7] scsi: core: Fix a use-after-free related to releasing device handlers
Date:   Wed, 14 Sep 2022 15:56:19 -0700
Message-Id: <20220914225621.415631-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220914225621.415631-1-bvanassche@acm.org>
References: <20220914225621.415631-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI device name can be freed by kobject_cleanup() before
scsi_device_dev_release_usercontext() is called since the latter function
may be called asynchronously. Hence, the SCSI device name must not be
dereferenced from inside the SCSI device release function. Since
scsi_dh_release_device() dereferences the SCSI device name, call it
earlier. This patch fixes the following use-after-free:

BUG: KASAN: use-after-free in string+0xdc/0x1d0
Read of size 1 at addr ffff8881280d05f0 by task kworker/54:2/1373

CPU: 54 PID: 1373 Comm: kworker/54:2 Tainted: G            E      6.0.0-rc5-dbg #12
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-debian-1.16.0-4 04/01/2014
Workqueue: events scsi_device_dev_release_usercontext
Call Trace:
 <TASK>
 show_stack+0x4e/0x53
 dump_stack_lvl+0x51/0x66
 print_address_description.constprop.0.cold+0xd5/0x412
 print_report.cold+0x90/0x219
 kasan_report+0xb1/0xe0
 __asan_load1+0x4d/0x50
 string+0xdc/0x1d0
 vsnprintf+0x44d/0x7f0
 snprintf+0x88/0xa0
 dev_vprintk_emit+0x19c/0x1dc
 dev_printk_emit+0x8c/0xa6
 __dev_printk+0x73/0x8f
 _dev_printk+0xa8/0xbe
 sdev_prefix_printk+0x12c/0x180
 scsi_dh_release_device+0x74/0xa0
 scsi_device_dev_release_usercontext+0x60/0x8a0
 process_one_work+0x571/0xa40
 worker_thread+0x90/0x650
 kthread+0x185/0x1c0
 ret_from_fork+0x1f/0x30

Freed by task 509:
 kasan_save_stack+0x26/0x50
 kasan_set_track+0x25/0x30
 kasan_set_free_info+0x24/0x40
 ____kasan_slab_free+0x155/0x1c0
 __kasan_slab_free+0x12/0x20
 kfree+0x1fe/0x3e0
 kfree_const+0x21/0x30
 kobject_cleanup+0x8d/0x1c0
 kobject_put+0x6e/0x90
 put_device+0x13/0x20
 __scsi_remove_device+0x140/0x200
 scsi_forget_host+0xa7/0xb0
 scsi_remove_host+0x9b/0x1b0
 srp_remove_work+0x12b/0x2e0 [ib_srp]
 process_one_work+0x571/0xa40
 worker_thread+0x90/0x650
 kthread+0x185/0x1c0
 ret_from_fork+0x1f/0x30

Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: 23695e41a1ca ("scsi_dh: fix use-after-free when removing scsi device")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5d61f58399dc..a3aaafdeac1d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -456,8 +456,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	mod = sdev->host->hostt->module;
 
-	scsi_dh_release_device(sdev);
-
 	parent = sdev->sdev_gendev.parent;
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
@@ -1479,6 +1477,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 	cancel_work_sync(&sdev->requeue_work);
 
+	/* Only detach the device handler after I/O processing has finished. */
+	scsi_dh_release_device(sdev);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
