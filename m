Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0DCC4363D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 01:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0EA7238A1
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 01:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mr1pk/bv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgIWBeu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 21:34:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727040AbgIWBeu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Sep 2020 21:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600824889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gNL62Da2IX2ajzThsk9Qwo0zBRRWD7vYqMVXqiXT+hw=;
        b=Mr1pk/bvKnSmFdKaBtLcFMhIFaHtEL18UDcC6li/TCmFWPswBeqaqvz9T5B8YmOjDwyT8t
        +xN+uOg1LYLC3OnweMYM6ei6AooPZ0q3kAWIST2lvQGi4or9oDqbgA6kDQWJa5OO+Rwbpk
        BDJbQ47GPVLS5uP/NX4mo7gDK54QRT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54--X1rIL3rNLSCQ9UAHiBS4Q-1; Tue, 22 Sep 2020 21:34:45 -0400
X-MC-Unique: -X1rIL3rNLSCQ9UAHiBS4Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A632D1007464;
        Wed, 23 Sep 2020 01:34:43 +0000 (UTC)
Received: from localhost (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E930278808;
        Wed, 23 Sep 2020 01:34:42 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V3 for 5.11 09/12] scsi: put hot fields of scsi_host_template into one cacheline
Date:   Wed, 23 Sep 2020 09:33:36 +0800
Message-Id: <20200923013339.1621784-10-ming.lei@redhat.com>
In-Reply-To: <20200923013339.1621784-1-ming.lei@redhat.com>
References: <20200923013339.1621784-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following three fields of scsi_host_template are referenced in
scsi IO submission path, so put them together into one cacheline:

- cmd_size
- queuecommand
- commit_rqs

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/scsi/scsi_host.h | 72 ++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 46ef8cccc982..6fa2697638b4 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -30,40 +30,15 @@ struct scsi_transport_template;
 #define MODE_TARGET 0x02
 
 struct scsi_host_template {
-	struct module *module;
-	const char *name;
-
 	/*
-	 * The info function will return whatever useful information the
-	 * developer sees fit.  If not provided, then the name field will
-	 * be used instead.
-	 *
-	 * Status: OPTIONAL
+	 * Put fields referenced in IO submission path together in
+	 * same cacheline
 	 */
-	const char *(* info)(struct Scsi_Host *);
 
 	/*
-	 * Ioctl interface
-	 *
-	 * Status: OPTIONAL
-	 */
-	int (*ioctl)(struct scsi_device *dev, unsigned int cmd,
-		     void __user *arg);
-
-
-#ifdef CONFIG_COMPAT
-	/* 
-	 * Compat handler. Handle 32bit ABI.
-	 * When unknown ioctl is passed return -ENOIOCTLCMD.
-	 *
-	 * Status: OPTIONAL
+	 * Additional per-command data allocated for the driver.
 	 */
-	int (*compat_ioctl)(struct scsi_device *dev, unsigned int cmd,
-			    void __user *arg);
-#endif
-
-	int (*init_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
-	int (*exit_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
+	unsigned int cmd_size;
 
 	/*
 	 * The queuecommand function is used to queue up a scsi
@@ -111,6 +86,41 @@ struct scsi_host_template {
 	 */
 	void (*commit_rqs)(struct Scsi_Host *, u16);
 
+	struct module *module;
+	const char *name;
+
+	/*
+	 * The info function will return whatever useful information the
+	 * developer sees fit.  If not provided, then the name field will
+	 * be used instead.
+	 *
+	 * Status: OPTIONAL
+	 */
+	const char *(*info)(struct Scsi_Host *);
+
+	/*
+	 * Ioctl interface
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (*ioctl)(struct scsi_device *dev, unsigned int cmd,
+		     void __user *arg);
+
+
+#ifdef CONFIG_COMPAT
+	/*
+	 * Compat handler. Handle 32bit ABI.
+	 * When unknown ioctl is passed return -ENOIOCTLCMD.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (*compat_ioctl)(struct scsi_device *dev, unsigned int cmd,
+			    void __user *arg);
+#endif
+
+	int (*init_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
+	int (*exit_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
+
 	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
@@ -475,10 +485,6 @@ struct scsi_host_template {
 	 */
 	u64 vendor_id;
 
-	/*
-	 * Additional per-command data allocated for the driver.
-	 */
-	unsigned int cmd_size;
 	struct scsi_host_cmd_pool *cmd_pool;
 
 	/* Delay for runtime autosuspend */
-- 
2.25.2

