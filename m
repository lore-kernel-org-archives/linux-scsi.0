Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C700C54FD0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 12:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B35A20775
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 12:50:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QOPchf46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgDUMuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 08:50:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUMuN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 08:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587473412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jd7/ygd9yWXCzRcSyuNFQYYxjQje7ED2dRVBt8FfY7o=;
        b=QOPchf46NxA5YPHrFJyPYAQxAGnLcITo5TEOG0iNUPAqRL+ZmRfoOLlJeOVpz5xYhvE1dW
        0muS0iUV9tUcsA985+cVBV7ODvdR/oojas7r2PQrtfU3iWgi3ByYue6lXWOkM+5HYTqpbU
        zHd+ELeIQjo0QzVQkD5GXLRNECPedbQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-uPv8UFLrODShGAEAOpM9NQ-1; Tue, 21 Apr 2020 08:50:10 -0400
X-MC-Unique: uPv8UFLrODShGAEAOpM9NQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40FE01007279;
        Tue, 21 Apr 2020 12:50:09 +0000 (UTC)
Received: from localhost (ovpn-8-38.pek2.redhat.com [10.72.8.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A743176E6E;
        Tue, 21 Apr 2020 12:49:58 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: put hot fields of scsi_host_template into one cacheline
Date:   Tue, 21 Apr 2020 20:49:52 +0800
Message-Id: <20200421124952.297448-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following three fields of scsi_host_template are referenced in
scsi IO submission path, so put them together into one cacheline:

- cmd_size
- queuecommand
- commit_rqs

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/scsi/scsi_host.h | 67 +++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 822e8cda8d9b..959dc5160f72 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -33,37 +33,12 @@ struct scsi_host_template {
 	struct module *module;
 	const char *name;
=20
-	/*
-	 * The info function will return whatever useful information the
-	 * developer sees fit.  If not provided, then the name field will
-	 * be used instead.
-	 *
-	 * Status: OPTIONAL
-	 */
-	const char *(* info)(struct Scsi_Host *);
+	/* Put hot fields together in same cacheline */
=20
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
-	/*=20
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
=20
 	/*
 	 * The queuecommand function is used to queue up a scsi
@@ -111,6 +86,38 @@ struct scsi_host_template {
 	 */
 	void (*commit_rqs)(struct Scsi_Host *, u16);
=20
+	/*
+	 * The info function will return whatever useful information the
+	 * developer sees fit.  If not provided, then the name field will
+	 * be used instead.
+	 *
+	 * Status: OPTIONAL
+	 */
+	const char *(* info)(struct Scsi_Host *);
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
+	/*=20
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
@@ -468,10 +475,6 @@ struct scsi_host_template {
 	 */
 	u64 vendor_id;
=20
-	/*
-	 * Additional per-command data allocated for the driver.
-	 */
-	unsigned int cmd_size;
 	struct scsi_host_cmd_pool *cmd_pool;
=20
 	/* Delay for runtime autosuspend */
--=20
2.25.2

