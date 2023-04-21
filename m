Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED10C7618E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 05:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjDUFGu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 01:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjDUFGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 01:06:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F6B6584
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 22:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682053559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JeBqBXc6xJc1N0ml9lM86IC8CjoavxXOPuLqA1dkxw8=;
        b=R53wCSpfuVVAQviBRlF6F4izeiOfGuLClzSo39IgqCgbxvt2T4293927gGrn17s/K8tED2
        LKivXlUlxKxlWXbvU3dsN4tn1eXWyTSVFQIM4hWmiYHcmOzrMIm2L22q26/7kELlXXt1yD
        /g3ok00k1+bhg+qzJnqc7rrKYZZGPv8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-aE7pLG6oPMOAlfBk9e7B6A-1; Fri, 21 Apr 2023 01:05:55 -0400
X-MC-Unique: aE7pLG6oPMOAlfBk9e7B6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76B253C01E13;
        Fri, 21 Apr 2023 05:05:55 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.2.16.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1C684020BED;
        Fri, 21 Apr 2023 05:05:54 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [PATCH] iscsi iser: enable network namespace awareness in iser
Date:   Thu, 20 Apr 2023 22:05:21 -0700
Message-Id: <20230421050521.49903-4-cleech@redhat.com>
In-Reply-To: <20230421050521.49903-1-cleech@redhat.com>
References: <20230420164232.GA27885@localhost>
 <20230421050521.49903-1-cleech@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the logic to store the network namespace during virtual host
creation (due to the way transport-class object setup callbacks
function) from iscsi_tcp into libiscsi, and share it with iser.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  7 ++++++-
 drivers/scsi/iscsi_tcp.c                 | 10 ++--------
 drivers/scsi/iscsi_tcp.h                 |  1 -
 drivers/scsi/libiscsi.c                  | 12 ++++++++++++
 include/scsi/libiscsi.h                  |  4 ++++
 5 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index ecb8aba1cee9..381f48a832ce 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -646,6 +646,8 @@ __iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		if (!(ib_dev->attrs.kernel_cap_flags & IBK_SG_GAPS_REG))
 			shost->virt_boundary_mask = SZ_4K - 1;
 
+		iscsi_host_set_netns(shost, ep->netns);
+
 		if (iscsi_host_add(shost, ib_dev->dev.parent)) {
 			mutex_unlock(&iser_conn->state_mutex);
 			goto free_host;
@@ -653,6 +655,7 @@ __iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		mutex_unlock(&iser_conn->state_mutex);
 	} else {
 		shost->can_queue = min_t(u16, cmds_max, ISER_DEF_XMIT_CMDS_MAX);
+		iscsi_host_set_netns(shost, net);
 		if (iscsi_host_add(shost, NULL))
 			goto free_host;
 	}
@@ -1029,7 +1032,9 @@ static struct iscsi_transport iscsi_iser_transport = {
 
 	.ep_connect_net         = iscsi_iser_ep_connect,
 	.ep_poll                = iscsi_iser_ep_poll,
-	.ep_disconnect          = iscsi_iser_ep_disconnect
+	.ep_disconnect          = iscsi_iser_ep_disconnect,
+	/* net namespace */
+	.get_netns		= iscsi_host_get_netns,
 };
 
 static int __init iser_init(void)
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 17f07ca2bbb8..3150d9c7a1ee 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -947,7 +947,7 @@ iscsi_sw_tcp_session_create(struct net *net, uint16_t cmds_max,
 	shost->can_queue = rc;
 
 	tcp_sw_host = iscsi_host_priv(shost);
-	tcp_sw_host->net_ns = net;
+	iscsi_host_set_netns(shost, net);
 
 	if (iscsi_host_add(shost, NULL))
 		goto free_host;
@@ -1068,12 +1068,6 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct net *iscsi_sw_tcp_netns(struct Scsi_Host *shost)
-{
-	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
-	return tcp_sw_host->net_ns;
-}
-
 static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
@@ -1130,7 +1124,7 @@ static struct iscsi_transport iscsi_sw_tcp_transport = {
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
 	/* net namespace */
-	.get_netns		= iscsi_sw_tcp_netns,
+	.get_netns		= iscsi_host_get_netns,
 };
 
 static int __init iscsi_sw_tcp_init(void)
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index f0020cb22f59..68e14a344904 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -53,7 +53,6 @@ struct iscsi_sw_tcp_conn {
 
 struct iscsi_sw_tcp_host {
 	struct iscsi_session	*session;
-	struct net *net_ns;
 };
 
 struct iscsi_sw_tcp_hdrbuf {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 127f3d7f19dc..ca8856c24688 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3929,6 +3929,18 @@ int iscsi_host_set_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 }
 EXPORT_SYMBOL_GPL(iscsi_host_set_param);
 
+void iscsi_host_set_netns(struct Scsi_Host *shost, struct net *netns) {
+	struct iscsi_host *ihost = shost_priv(shost);
+	ihost->net_ns = netns;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_set_netns);
+
+struct net *iscsi_host_get_netns(struct Scsi_Host *shost) {
+	struct iscsi_host *ihost = shost_priv(shost);
+	return ihost->net_ns;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_get_netns);
+
 MODULE_AUTHOR("Mike Christie");
 MODULE_DESCRIPTION("iSCSI library functions");
 MODULE_LICENSE("GPL");
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index e39fb0736ade..acd868b5f6ef 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -383,6 +383,7 @@ struct iscsi_host {
 	int			state;
 
 	struct workqueue_struct	*workq;
+	struct net *net_ns;
 };
 
 /*
@@ -492,6 +493,9 @@ extern void iscsi_pool_free(struct iscsi_pool *);
 extern int iscsi_pool_init(struct iscsi_pool *, int, void ***, int);
 extern int iscsi_switch_str_param(char **, char *);
 
+extern void iscsi_host_set_netns(struct Scsi_Host *, struct net *);
+extern struct net *iscsi_host_get_netns(struct Scsi_Host *);
+
 /*
  * inline functions to deal with padding.
  */
-- 
2.39.2

