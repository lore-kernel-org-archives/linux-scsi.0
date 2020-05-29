Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6FDC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 04:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB23A2074D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 04:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgE2EVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 00:21:49 -0400
Received: from smtp.infotech.no ([82.134.31.41]:58812 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgE2EVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 00:21:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0E1BC20419D;
        Fri, 29 May 2020 06:21:44 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1gWLKcOwE0Ez; Fri, 29 May 2020 06:21:37 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id A65C0204165;
        Fri, 29 May 2020 06:21:36 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCHv3 0/4] scsi: use xarray ... scsi_alloc_target()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200528163625.110184-1-hare@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <966f816a-d66e-e58f-d764-aeacf5026adf@interlog.com>
Date:   Fri, 29 May 2020 00:21:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528163625.110184-1-hare@suse.de>
Content-Type: multipart/mixed;
 boundary="------------05256AF7C71B859B03C3A16C"
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------05256AF7C71B859B03C3A16C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hannes,
I believe scsi_alloc_target() is broken in the found_target case.
For starters starget is created, built and _not_ put in the xarray,
hence it is leaked?  Seems to me that the code shouldn't go
as far as it does before it detects the found_target case.

What I'm seeing in testing (script attached) after applying my
patches outlined in earlier posts (second attachment) is that
LUN 0 is missing on all targets within a host apart from
target_id==0 . For example:

# modprobe scsi_debug ptype=0x9 no_uld=1 max_luns=2 num_tgts=2
# lsscsi -gs
[0:0:0:0]    comms   Linux    scsi_debug       0189  -  /dev/sg0        -
[0:0:0:1]    comms   Linux    scsi_debug       0189  -  /dev/sg1        -
[0:0:1:1]    comms   Linux    scsi_debug       0189  -  /dev/sg2        -
[N:0:1:1]    disk    INTEL SSDPEKKF256G7L__1     /dev/nvme0n1  -      256GB

# sg_luns /dev/sg2
Lun list length = 16 which imples 2 lun entries
Report luns [select_report=0x0]:
     0000000000000000
     0001000000000000

So where did [0:0:1:0] go? The response to REPORT LUNS says it should
be there.

I thought about jumping into scsi_alloc_target() but it is horribly
complicated, so I'll let you deal with it :-)

Doug Gilbert

--------------05256AF7C71B859B03C3A16C
Content-Type: application/x-shellscript;
 name="tst_sdebug_modpr_rmmod.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="tst_sdebug_modpr_rmmod.sh"

IyEvYmluL2Jhc2gKCiMgRXhhbXBsZSBpbnZvY2F0aW9uOgojICAgIC4vdHN0X3NkZWJ1Z19t
b2Rwcl9ybW1vZC5zaAojCiMgTi5CLiBXcml0ZXMgdG8gL2Rldi9zZzEKIyBVc2UgUERUIG9m
IDB4OSB3aGljaCBpcyBhIENvbW1zIGRldmljZSBhbmQgaXMgb2Jzb2xldGUuIFRoaXMgaXMg
YW4gYXR0ZW1wdAojIHRvIHNodXQgdWRldiB1cC4KIwoKIyBDbGVhciBvdXQgYW55IHNldHRp
bmcgdGhhdCBzY3NpX2RlYnVnIG1vZHVsZSBtaWdodCBoYXZlCnJtbW9kIHNjc2lfZGVidWcK
CmZvciBrIGluIDEgMiA0IDcgOCAxMSAxNiAzMSA2NApkbwoJZm9yIGogaW4gMSAyIDQgNiA4
CglkbwoJCWZvciBtIGluIDIgNCA4IDEyCgkJZG8KCQkJZWNobyAiSG9zdHM6ICR7bX0sIHRh
cmdldHM6ICR7an0sIGx1bnM6ICR7a30iCgkJCW1vZHByb2JlIHNjc2lfZGVidWcgcHR5cGU9
MHg5IG5vX3VsZD0xIG1heF9sdW5zPSR7a30gbnVtX3RndHM9JHtqfSBzZWN0b3Jfc2l6ZT01
MTIgZGV2X3NpemVfbWI9MTAwIG5kZWxheT0xMDAwMCBwZXJfaG9zdF9zdG9yZT0xIGFkZF9o
b3N0PSR7bX0KCQkJc2xlZXAgMC4xCgkJCWlmIFsgLWMgL2Rldi9zZzEgXSA7IHRoZW4KCQkJ
CXNnX3R1cnMgL2Rldi9zZzAKCQkJCXNnX3R1cnMgL2Rldi9zZzEKCQkJCSMgc2doX2RkIGlm
PS9kZXYvc2cwIGJzPTUxMiBvZj0vZGV2L3NnMQoJCQkJc2dfZGQgaWY9L2Rldi9zZzAgYnM9
NTEyIG9mPS9kZXYvc2cxIHRpbWU9MQoJCQllbHNlCgkJCQllY2hvICIvZGV2L3NnMSBub3Qg
cmVhZHkiCgkJCWZpCgkJCXJtbW9kIHNjc2lfZGVidWcKCQlkb25lCglkb25lCmRvbmUKCg==
--------------05256AF7C71B859B03C3A16C
Content-Type: text/x-patch; charset=UTF-8;
 name="hr2_fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hr2_fixes.patch"

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 004a50a95560..7dff8ac850ab 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -345,6 +345,7 @@ static void scsi_host_dev_release(struct device *dev)
 
 	if (parent)
 		put_device(parent);
+	xa_destroy(&shost->__targets);
 	kfree(shost);
 }
 
@@ -382,7 +383,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->host_lock = &shost->default_lock;
 	spin_lock_init(shost->host_lock);
 	shost->shost_state = SHOST_CREATED;
-	xa_init(&shost->__targets);
+	xa_init_flags(&shost->__targets, XA_FLAGS_LOCK_IRQ);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
@@ -501,6 +502,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
  fail_index_remove:
 	ida_simple_remove(&host_index_ida, shost->host_no);
  fail_kfree:
+	xa_destroy(&shost->__targets);
 	kfree(shost);
 	return NULL;
 }
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e75e7f93f8f6..e146c36adcf3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -309,6 +309,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
 {
 	struct device *dev = &starget->dev;
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
+	struct scsi_target *e_starg;
 	unsigned long flags;
 	unsigned long tid = scsi_target_index(starget);
 
@@ -318,8 +319,10 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
 		shost->hostt->target_destroy(starget);
-	xa_erase(&shost->__targets, tid);
+	e_starg = xa_erase(&shost->__targets, tid);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	if (e_starg != starget)
+		pr_err("%s: bad xa_erase()\n", __func__);
 	put_device(dev);
 }
 
@@ -328,6 +331,7 @@ static void scsi_target_dev_release(struct device *dev)
 	struct device *parent = dev->parent;
 	struct scsi_target *starget = to_scsi_target(dev);
 
+	xa_destroy(&starget->devices);
 	kfree(starget);
 	put_device(parent);
 }
@@ -415,7 +419,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->id = id;
 	starget->channel = channel;
 	starget->can_queue = 0;
-	xa_init(&starget->devices);
+	xa_init_flags(&starget->devices, XA_FLAGS_LOCK_IRQ);
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
@@ -428,7 +432,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		get_device(&found_target->dev);
 		goto found;
 	}
-	if (xa_insert(&shost->__targets, tid, starget, GFP_KERNEL)) {
+	if (xa_insert(&shost->__targets, tid, starget, GFP_ATOMIC)) {
 		dev_printk(KERN_ERR, dev, "target index busy\n");
 		kfree(starget);
 		return NULL;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 63fa57684782..8a5e6c0a4bed 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -434,6 +434,7 @@ static void scsi_device_cls_release(struct device *class_dev)
 static void scsi_device_dev_release_usercontext(struct work_struct *work)
 {
 	struct scsi_device *sdev;
+	struct scsi_device *e_sdev;
 	struct scsi_target *starget;
 	struct device *parent;
 	struct list_head *this, *tmp;
@@ -449,9 +450,11 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	parent = sdev->sdev_gendev.parent;
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	xa_erase(&starget->devices, sdev->lun_idx);
+	e_sdev = xa_erase(&starget->devices, sdev->lun_idx);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	if (e_sdev != sdev)
+		pr_err("%s: bad sdev erase\n", __func__);
 
 	cancel_work_sync(&sdev->event_work);
 
@@ -1621,14 +1624,14 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	if (sdev->lun < 256) {
 		sdev->lun_idx = sdev->lun;
 		WARN_ON(xa_insert(&starget->devices, sdev->lun_idx,
-				   sdev, GFP_KERNEL) < 0);
+				   sdev, GFP_ATOMIC) < 0);
 	} else {
 		struct xa_limit scsi_lun_limit = {
 			.min = 256,
 			.max = UINT_MAX,
 		};
 		WARN_ON(xa_alloc(&starget->devices, &sdev->lun_idx,
-				  sdev, scsi_lun_limit, GFP_KERNEL) < 0);
+				  sdev, scsi_lun_limit, GFP_ATOMIC) < 0);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/*

--------------05256AF7C71B859B03C3A16C--
