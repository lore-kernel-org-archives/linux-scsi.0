Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86CCC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1528613A7
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348061AbhI3FXW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 01:23:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236162AbhI3FXS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 01:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632979296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ng2IqlAgtnAP4wGSYV5UVVmpXi41Umti5/ShTua3c1I=;
        b=Qi0+tgKqvhTKEyj0n0+yjqEfohP2wLwi6hD/LqZHdWuBp3klE8tjakcMcaRyaa/loQOnUA
        odI6gEpWF+R6XYO+mvI48c43zpjTfWWDb2oL4Pz5nk6OucBtxowNr1LeuOXODcuFugBi/4
        ltLmIAtkKO+Z1rqAnsVGCIput4b0dZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544--8hcRtSdN4u12XoeoN-PQw-1; Thu, 30 Sep 2021 01:21:32 -0400
X-MC-Unique: -8hcRtSdN4u12XoeoN-PQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D4981084681;
        Thu, 30 Sep 2021 05:21:31 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2275A6B90C;
        Thu, 30 Sep 2021 05:21:12 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Changhui Zhong <czhong@redhat.com>, Yi Zhang <yi.zhang@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/2] driver core: tell caller if the device/kboject is really released
Date:   Thu, 30 Sep 2021 13:20:27 +0800
Message-Id: <20210930052028.934747-2-ming.lei@redhat.com>
In-Reply-To: <20210930052028.934747-1-ming.lei@redhat.com>
References: <20210930052028.934747-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return if the device/kobject is really released to caller.

One use case is scsi_device_put() and the scsi device's release handler
runs async work to clean up things. We have to piggyback the module_put()
into the async work for avoiding to touch unmapped module page.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/base/core.c     | 5 +++--
 include/linux/device.h  | 2 +-
 include/linux/kobject.h | 2 +-
 lib/kobject.c           | 5 +++--
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e65dd803a453..cd1365a934b9 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3459,11 +3459,12 @@ EXPORT_SYMBOL_GPL(get_device);
  * put_device - decrement reference count.
  * @dev: device in question.
  */
-void put_device(struct device *dev)
+int put_device(struct device *dev)
 {
 	/* might_sleep(); */
 	if (dev)
-		kobject_put(&dev->kobj);
+		return kobject_put(&dev->kobj);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(put_device);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index e270cb740b9e..ab089d743667 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -949,7 +949,7 @@ extern int (*platform_notify_remove)(struct device *dev);
  *
  */
 struct device *get_device(struct device *dev);
-void put_device(struct device *dev);
+int put_device(struct device *dev);
 bool kill_device(struct device *dev);
 
 #ifdef CONFIG_DEVTMPFS
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index ea30529fba08..c83cc8a7a170 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -111,7 +111,7 @@ extern int __must_check kobject_move(struct kobject *, struct kobject *);
 extern struct kobject *kobject_get(struct kobject *kobj);
 extern struct kobject * __must_check kobject_get_unless_zero(
 						struct kobject *kobj);
-extern void kobject_put(struct kobject *kobj);
+extern int kobject_put(struct kobject *kobj);
 
 extern const void *kobject_namespace(struct kobject *kobj);
 extern void kobject_get_ownership(struct kobject *kobj,
diff --git a/lib/kobject.c b/lib/kobject.c
index ea53b30cf483..7ebdd6b99064 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -743,15 +743,16 @@ static void kobject_release(struct kref *kref)
  *
  * Decrement the refcount, and if 0, call kobject_cleanup().
  */
-void kobject_put(struct kobject *kobj)
+int kobject_put(struct kobject *kobj)
 {
 	if (kobj) {
 		if (!kobj->state_initialized)
 			WARN(1, KERN_WARNING
 				"kobject: '%s' (%p): is not initialized, yet kobject_put() is being called.\n",
 			     kobject_name(kobj), kobj);
-		kref_put(&kobj->kref, kobject_release);
+		return kref_put(&kobj->kref, kobject_release);
 	}
+	return 0;
 }
 EXPORT_SYMBOL(kobject_put);
 
-- 
2.31.1

