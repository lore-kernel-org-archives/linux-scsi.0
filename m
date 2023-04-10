Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC5BC77B61
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Apr 2023 19:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDJTMP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Apr 2023 15:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjDJTMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2023 15:12:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA25171B
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2023 12:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681153883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhYtLENcNtcLyj9Yw2HJ5wz9v0cgAEwMxc8s0tHjoZA=;
        b=dxuXOJz8urF0yodPJeTGMdXMo9bpb6PD8gHJCXX8OQIPkKhqeDb9ssQj9xzG4yAVj7reSa
        JW1QHAdPeuvvHXGOY/2AhtUm2bOZ0j9/F+0Q7OAiUr0etjYjo/NzfLfJ4/kqbdjl7IIsrZ
        33TpIjUTAoq6Bb1ZlBYVL65YdRlo4wE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-g0sfIhgJOKebvqPo2cb-6w-1; Mon, 10 Apr 2023 15:11:13 -0400
X-MC-Unique: g0sfIhgJOKebvqPo2cb-6w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B7DD185A78B;
        Mon, 10 Apr 2023 19:11:12 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.2.16.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2BED40C20FA;
        Mon, 10 Apr 2023 19:11:11 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Hannes Reinecke <hare@suse.de>,
        Lee Duncan <leeman.duncan@gmail.com>, netdev@vger.kernel.org
Cc:     Chris Leech <cleech@redhat.com>
Subject: [PATCH 11/11] iscsi: force destroy sesions when a network namespace exits
Date:   Mon, 10 Apr 2023 12:10:33 -0700
Message-Id: <20230410191033.1069293-3-cleech@redhat.com>
In-Reply-To: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
References: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The namespace is gone, so there is no userspace to clean up.
Force close all the sessions.

This should be enough for software transports, there's no implementation
of migrating physical iSCSI hosts between network namespaces currently.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 3a068d8eca2d..8fafa8f0e0df 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -5200,9 +5200,27 @@ static int __net_init iscsi_net_init(struct net *net)
 
 static void __net_exit iscsi_net_exit(struct net *net)
 {
+	struct iscsi_cls_session *session, *tmp;
+	struct iscsi_transport *transport;
 	struct iscsi_net *isn;
+	unsigned long flags;
+	LIST_HEAD(sessions);
 
 	isn = net_generic(net, iscsi_net_id);
+
+	/* force session destruction, there is no userspace anymore */
+	spin_lock_irqsave(&isn->sesslock, flags);
+	list_for_each_entry_safe(session, tmp, &isn->sesslist, sess_list) {
+		list_move_tail(&session->sess_list, &sessions);
+	}
+	spin_unlock_irqrestore(&isn->sesslock, flags);
+	list_for_each_entry_safe(session, tmp, &sessions, sess_list) {
+		device_for_each_child(&session->dev, NULL,
+				      iscsi_iter_force_destroy_conn_fn);
+		transport = session->transport;
+		transport->destroy_session(session);
+	}
+
 	netlink_kernel_release(isn->nls);
 	isn->nls = NULL;
 }
-- 
2.39.2

