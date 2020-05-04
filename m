Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7D5C47247
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 01:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E05682071C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 01:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DM2MrpGH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgEDBJw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 May 2020 21:09:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44785 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727806AbgEDBJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2020 21:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588554588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a006YMxBlpdsYC6Hn7MLJEpwuF1EjHqPJMXWp4WNuZo=;
        b=DM2MrpGHt7m7brh2GuNczWIqGga1CU/dC6gwDmvE2FuKE5Yhd6xBiz7Pu6B1CHq69qMjSH
        0RI3UgW4PPL9FSfpGwoUNWPhK6qqkhPFe++V24P22ESus+Kw8EnJsUbfXuYggUF2N9cYf5
        Njkaz579DpxJZMcsb7cF++x8CtrSOVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62--qNRk7BUNYSj3vt4k9_7gA-1; Sun, 03 May 2020 21:09:46 -0400
X-MC-Unique: -qNRk7BUNYSj3vt4k9_7gA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA462107ACCA;
        Mon,  4 May 2020 01:09:44 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D61A71943D;
        Mon,  4 May 2020 01:09:37 +0000 (UTC)
Date:   Mon, 4 May 2020 09:09:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH V2] scsi: put hot fields of scsi_host_template into one
 cacheline
Message-ID: <20200504010919.GA1136774@T590>
References: <20200422095425.319674-1-ming.lei@redhat.com>
 <841bd018-eff5-d242-97dd-416384eb4b08@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <841bd018-eff5-d242-97dd-416384eb4b08@interlog.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 01, 2020 at 06:27:07PM -0400, Douglas Gilbert wrote:
> On 2020-04-22 5:54 a.m., Ming Lei wrote:
> > The following three fields of scsi_host_template are referenced in
> > scsi IO submission path, so put them together into one cacheline:
> > 
> > - cmd_size
> > - queuecommand
> > - commit_rqs
> > 
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: John Garry <john.garry@huawei.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> > V2:
> > 	- move the 3 fields at the beginning of scsi_host_template
> > 	- comment why we do this way
> > 
> >   include/scsi/scsi_host.h | 72 ++++++++++++++++++++++------------------
> >   1 file changed, 39 insertions(+), 33 deletions(-)
> 
> Hi,
> I would like to test this patch. However it doesn't apply on Martin's
> tree (all 3 chunks fail). Could you post a clean version?
> 
> Doug Gilbert
> 

Hi Doug,

Please try the following one:

From 356220ede9f06a20d90fa387cc84eb63eea2335d Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Tue, 21 Apr 2020 17:27:30 +0800
Subject: [PATCH] scsi: put hot fields of scsi_host_template into one cacheline

The following three fields of scsi_host_template are referenced in
scsi IO submission path, so put them together into one cacheline:

- cmd_size
- queuecommand
- commit_rqs

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.garry@huawei.com>
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



-- 
Ming

