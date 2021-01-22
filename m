Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA7CC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 378BA22CAE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbhAVCgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 21:36:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbhAVCgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 21:36:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611282885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OliV7Tg6pMpw735vc/YIf3XDE6XRT8FDZyfnor+mRxA=;
        b=TSBu4G7++uIcI0HjaJizF6ZS8LymEaywKwelp02qykpOhvEBN+YFgjs8v2LzTdbU4Dg9vm
        wkNIrYtK70l9PR7L9NqOrrsP+GoA/qXTcmCl73cwnrMh5r/3LcMTRJsgeb7OkbO66tSVwc
        bcnI+t2caY/Dp+ZlQq4++A53EryFUho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-GnzbPZPvMWq_DcZCRD_Hew-1; Thu, 21 Jan 2021 21:34:44 -0500
X-MC-Unique: GnzbPZPvMWq_DcZCRD_Hew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68ADA1005513;
        Fri, 22 Jan 2021 02:34:42 +0000 (UTC)
Received: from localhost (ovpn-13-11.pek2.redhat.com [10.72.13.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B24EE5D765;
        Fri, 22 Jan 2021 02:34:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V7 09/13] scsi: put hot fields of scsi_host_template into one cacheline
Date:   Fri, 22 Jan 2021 10:33:13 +0800
Message-Id: <20210122023317.687987-10-ming.lei@redhat.com>
In-Reply-To: <20210122023317.687987-1-ming.lei@redhat.com>
References: <20210122023317.687987-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/scsi/scsi_host.h | 72 ++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 701f178b20ae..2d6e3a1f5f0b 100644
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
@@ -478,10 +488,6 @@ struct scsi_host_template {
 	 */
 	u64 vendor_id;
 
-	/*
-	 * Additional per-command data allocated for the driver.
-	 */
-	unsigned int cmd_size;
 	struct scsi_host_cmd_pool *cmd_pool;
 
 	/* Delay for runtime autosuspend */
-- 
2.28.0

