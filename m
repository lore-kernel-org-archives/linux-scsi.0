Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3FFC77B75
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 05:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjDUFGs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 01:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjDUFGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 01:06:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C476A5B
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 22:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682053557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=50GPcrWZS0LRGuULqlAbl1KOy4D8eYkSmtRPN+fm0h8=;
        b=h/eJXyAhxt1ppqQ635KsCZYGzz/A4UD7BN/vOJDlZCpIWDZwtx2HEevswMrBs92reFD8iu
        19Lw1zqH6M8fbAIv3HLy7dpQaFZjx63oGtw5at3MEcj+sHdKfzINxSDFprlH9oW2OouPUg
        9TELCtUe6I0gaJ1MEKvTSrcjqtRSwUE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-ck5vV_jhNAaV2HPrlrxmIA-1; Fri, 21 Apr 2023 01:05:54 -0400
X-MC-Unique: ck5vV_jhNAaV2HPrlrxmIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C730800B35;
        Fri, 21 Apr 2023 05:05:54 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.2.16.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7994E4020BED;
        Fri, 21 Apr 2023 05:05:53 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [PATCH] iscsi iser: fix iser, allow virtual endpoints again
Date:   Thu, 20 Apr 2023 22:05:19 -0700
Message-Id: <20230421050521.49903-2-cleech@redhat.com>
In-Reply-To: <20230421050521.49903-1-cleech@redhat.com>
References: <20230420164232.GA27885@localhost>
 <20230421050521.49903-1-cleech@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSER creates endpoints before hosts and sessions, so we need to keep
compatibility with virtual device paths and not always expect a parent
host.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 9 ++++++---
 include/scsi/scsi_transport_iscsi.h | 3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 41f0de2165e0..b8e451a8c76c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -189,8 +189,10 @@ static struct net *iscsi_host_net(struct iscsi_cls_host *ihost)
 static struct net *iscsi_endpoint_net(struct iscsi_endpoint *ep)
 {
 	struct Scsi_Host *shost = iscsi_endpoint_to_shost(ep);
-	struct iscsi_cls_host *ihost = shost->shost_data;
-
+	struct iscsi_cls_host *ihost;
+	if (!shost)
+		return &init_net;
+	ihost = shost->shost_data;
 	return iscsi_host_net(ihost);
 }
 
@@ -252,7 +254,8 @@ iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
 
 	ep->id = id;
 	ep->dev.class = &iscsi_endpoint_class;
-	ep->dev.parent = &shost->shost_gendev;
+	if (shost)
+		ep->dev.parent = &shost->shost_gendev;
 	dev_set_name(&ep->dev, "ep-%d", id);
 	err = device_register(&ep->dev);
         if (err)
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d233618a17de..bb6734e900e0 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -293,8 +293,9 @@ struct iscsi_cls_session {
 #define iscsi_session_to_shost(_session) \
 	dev_to_shost(_session->dev.parent)
 
+/* endpoints might not have a parent host (iSER) */
 #define iscsi_endpoint_to_shost(_ep) \
-	dev_to_shost(_ep->dev.parent)
+	dev_to_shost(&_ep->dev)
 
 extern struct net *iscsi_sess_net(struct iscsi_cls_session *session);
 
-- 
2.39.2

