Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49340C77B73
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 23:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjEFXbd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 May 2023 19:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjEFXb1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 May 2023 19:31:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E28A5E7
        for <linux-scsi@vger.kernel.org>; Sat,  6 May 2023 16:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683415804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FfaTz/2MrDTTsMWsUnYC5jvyRAk9JjCsw82BS68rkgY=;
        b=Y0VL91LijQTOT/I8uIfYADAmYHB/tKMA7dSjSdAeojvxDbJpv+mJn+IMLGU9GaKkndkeav
        Og0za6FRdKnVrFheIAEGuscmBxrJolX87cPGxwYl229NKBYHD4LJeOKrxF7RJq+w97qVar
        ttI/oGXvceAMOdS/isRIujM/lE/PzIM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-9PcE-jBHMyeYo5I4A6zfxg-1; Sat, 06 May 2023 19:30:01 -0400
X-MC-Unique: 9PcE-jBHMyeYo5I4A6zfxg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 220703806700;
        Sat,  6 May 2023 23:30:01 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E59E440BC;
        Sat,  6 May 2023 23:30:00 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Chris Leech <cleech@redhat.com>
Subject: [PATCH 11/11] iscsi: force destroy sesions when a network namespace exits
Date:   Sat,  6 May 2023 16:29:30 -0700
Message-Id: <20230506232930.195451-12-cleech@redhat.com>
In-Reply-To: <20230506232930.195451-1-cleech@redhat.com>
References: <20230506232930.195451-1-cleech@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The namespace is gone, so there is no userspace to clean up.
Force close all the sessions.

This should be enough for software transports, there's no implementation
of migrating physical iSCSI hosts between network namespaces currently.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 15d28186996d..10e9414844d8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -5235,9 +5235,25 @@ static int __net_init iscsi_net_init(struct net *net)
 
 static void __net_exit iscsi_net_exit(struct net *net)
 {
+	struct iscsi_cls_session *session, *tmp;
 	struct iscsi_net *isn;
+	unsigned long flags;
+	LIST_HEAD(sessions);
 
 	isn = net_generic(net, iscsi_net_id);
+
+	spin_lock_irqsave(&isn->sesslock, flags);
+	list_replace_init(&isn->sesslist, &sessions);
+	spin_unlock_irqrestore(&isn->sesslock, flags);
+
+	/* force session destruction, there is no userspace anymore */
+	list_for_each_entry_safe(session, tmp, &sessions, sess_list) {
+		device_for_each_child(&session->dev, NULL,
+				      iscsi_iter_force_destroy_conn_fn);
+		flush_work(&session->destroy_work);
+		__iscsi_destroy_session(&session->destroy_work);
+	}
+
 	netlink_kernel_release(isn->nls);
 	isn->nls = NULL;
 }
-- 
2.39.2

