Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C140C25B4E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 14:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbjAXOai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 09:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234765AbjAXOag (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 09:30:36 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E339E12879
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 06:30:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 984241FD7D;
        Tue, 24 Jan 2023 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674570633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=aXYj1yAZ94ZD19pB50SH7tLgoVmpV1OrHYvLzm3swwU=;
        b=gXiQV+9sEUgtRuWfzIghbuQpVauzmzHlWgvkuyP1G19UaRvt1ynX8BSFqJkwgbt9SnmOZ/
        wLbgo9zZXaLF8unnd7LTN0QQmEZIYRLsUEc8/NFzaamwzTI5KRNK9K/MC+tJ9efWok4pJb
        oX3hFNT9xqYHQfUT5qfq5AY/Vk156Bs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47383139FB;
        Tue, 24 Jan 2023 14:30:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 24q7D4nrz2N5BQAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 24 Jan 2023 14:30:33 +0000
From:   mwilck@suse.com
To:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH v2] scsi: add non-sleeping variant of scsi_device_put() and use it in alua
Date:   Tue, 24 Jan 2023 15:30:25 +0100
Message-Id: <20230124143025.3464-1-mwilck@suse.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Since the might_sleep() annotation was added in scsi_device_put() and
alua_rtpg_queue(), we have seen repeated reports of "BUG: sleeping function
called from invalid context" [1], [2]. alua_rtpg_queue() is always called
from contexts where the caller must hold at least one reference to the scsi
device in question. This means that the reference taken by
alua_rtpg_queue() itself can't be the last one, and thus can be dropped
without entering the code path in which scsi_device_put() might actually
sleep.

Add a new helper function, scsi_device_put_nosleep() for cases like this,
where a device reference is put from atomic context, and at the same time
it is certain that this reference is not the last one, and use it from
alua_rtpg_queue().

[1] https://lore.kernel.org/linux-scsi/b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com/
[2] https://lore.kernel.org/linux-scsi/55c35e64-a7d4-9072-46fd-e8eae6a90e96@linux.ibm.com/

Fixes: f93ed747e2c7 ("scsi: core: Release SCSI devices synchronously")
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sachin Sant <sachinp@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>
Reported-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>

----
Changes since v1:
 - rebased onto the scsi-fixes branch.
 - fixed several mistakes pointed out  by Steffen Maier.
---
 drivers/scsi/device_handler/scsi_dh_alua.c |  2 +-
 drivers/scsi/scsi.c                        | 23 ++++++++++++++++++----
 include/scsi/scsi_device.h                 |  1 +
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 29a2865b8e2e..8f3aac9e6a50 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1032,7 +1032,7 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
 			kref_put(&pg->kref, release_port_group);
 	}
 	if (sdev)
-		scsi_device_put(sdev);
+		scsi_device_put_nosleep(sdev);
 
 	return true;
 }
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1426b9b03612..22b82e57dee3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -576,6 +576,24 @@ int scsi_device_get(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(scsi_device_get);
 
+/**
+ * scsi_device_put_nosleep  -  release a reference to a scsi_device
+ * @sdev:	device to release a reference on.
+ *
+ * Description: Release a reference to the scsi_device and decrements the use
+ * count of the underlying LLDD module. This function may only be called from
+ * a call context where it is certain that the reference dropped is not the
+ * last one.
+ */
+void scsi_device_put_nosleep(struct scsi_device *sdev)
+{
+	struct module *mod = sdev->host->hostt->module;
+
+	put_device(&sdev->sdev_gendev);
+	module_put(mod);
+}
+EXPORT_SYMBOL(scsi_device_put_nosleep);
+
 /**
  * scsi_device_put  -  release a reference to a scsi_device
  * @sdev:	device to release a reference on.
@@ -586,12 +604,9 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	struct module *mod = sdev->host->hostt->module;
-
 	might_sleep();
 
-	put_device(&sdev->sdev_gendev);
-	module_put(mod);
+	scsi_device_put_nosleep(sdev);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3642b8e3928b..f1ad48c9c601 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -365,6 +365,7 @@ void scsi_attach_vpd(struct scsi_device *sdev);
 
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
+void scsi_device_put_nosleep(struct scsi_device *sdev);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
 					      uint, uint, u64);
-- 
2.39.0

