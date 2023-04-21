Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B34CC77B78
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 05:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbjDUFGv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 01:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjDUFGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 01:06:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B71D44B7
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 22:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682053558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OW3s0NvOmowyB3QXPhc3i2XN5BrOgFoO4koUc1e5NWo=;
        b=d/+1hzJ2Jzkd0VSGogO97nD958AtcDFm1Qex9HkUFZ52vMFHzCzLsEmRgFYvxm+eA2K5GA
        UkYQzSapIZCAWs/4hXdFTYqKorNPDFg20p8uFrLiipBjnzstk8/Nx4WQ/ylt9Iy1QCAdG1
        ObGghBe0Ls53CzsE0hfYwmdqKhrLBMw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-_Fx-ojTTPBWmMfh8oaCVnw-1; Fri, 21 Apr 2023 01:05:55 -0400
X-MC-Unique: _Fx-ojTTPBWmMfh8oaCVnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB3FA185A790;
        Fri, 21 Apr 2023 05:05:54 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.2.16.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3251D4020BF1;
        Fri, 21 Apr 2023 05:05:54 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Subject: [PATCH] iscsi iser: direct network namespace support for endpoints
Date:   Thu, 20 Apr 2023 22:05:20 -0700
Message-Id: <20230421050521.49903-3-cleech@redhat.com>
In-Reply-To: <20230421050521.49903-1-cleech@redhat.com>
References: <20230420164232.GA27885@localhost>
 <20230421050521.49903-1-cleech@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split endpoint creation into host-bound and with a specified namespace,
for iSER's unique use of enpoint objects + virtual host-per-session.

This is much like was done with sessions already for iscsi_tcp.

Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  6 ++--
 drivers/scsi/scsi_transport_iscsi.c      | 38 +++++++++++++++++++-----
 include/scsi/scsi_transport_iscsi.h      |  6 ++++
 3 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 49fbfeb49b34..ecb8aba1cee9 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -813,7 +813,7 @@ static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
  * Return: iscsi_endpoint created by iscsi layer or ERR_PTR(error)
  *         if fails.
  */
-static struct iscsi_endpoint *iscsi_iser_ep_connect(struct Scsi_Host *shost,
+static struct iscsi_endpoint *iscsi_iser_ep_connect(struct net *net,
 						    struct sockaddr *dst_addr,
 						    int non_blocking)
 {
@@ -821,7 +821,7 @@ static struct iscsi_endpoint *iscsi_iser_ep_connect(struct Scsi_Host *shost,
 	struct iser_conn *iser_conn;
 	struct iscsi_endpoint *ep;
 
-	ep = iscsi_create_endpoint(shost, 0);
+	ep = iscsi_create_endpoint_net(net, 0);
 	if (!ep)
 		return ERR_PTR(-ENOMEM);
 
@@ -1027,7 +1027,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
 
-	.ep_connect             = iscsi_iser_ep_connect,
+	.ep_connect_net         = iscsi_iser_ep_connect,
 	.ep_poll                = iscsi_iser_ep_poll,
 	.ep_disconnect          = iscsi_iser_ep_disconnect
 };
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b8e451a8c76c..d41b4c1ad611 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -190,6 +190,9 @@ static struct net *iscsi_endpoint_net(struct iscsi_endpoint *ep)
 {
 	struct Scsi_Host *shost = iscsi_endpoint_to_shost(ep);
 	struct iscsi_cls_host *ihost;
+
+	if (ep->netns)
+		return ep->netns;
 	if (!shost)
 		return &init_net;
 	ihost = shost->shost_data;
@@ -228,7 +231,7 @@ static struct attribute_group iscsi_endpoint_group = {
 };
 
 struct iscsi_endpoint *
-iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
+__iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size, struct net *net)
 {
 	struct iscsi_endpoint *ep;
 	int err, id;
@@ -256,6 +259,8 @@ iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
 	ep->dev.class = &iscsi_endpoint_class;
 	if (shost)
 		ep->dev.parent = &shost->shost_gendev;
+	if (net)
+		ep->netns = net;
 	dev_set_name(&ep->dev, "ep-%d", id);
 	err = device_register(&ep->dev);
         if (err)
@@ -283,8 +288,21 @@ iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
 	kfree(ep);
 	return NULL;
 }
+
+struct iscsi_endpoint *
+iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size) {
+	return __iscsi_create_endpoint(shost, dd_size, NULL);
+}
+
 EXPORT_SYMBOL_GPL(iscsi_create_endpoint);
 
+struct iscsi_endpoint *
+iscsi_create_endpoint_net(struct net *net, int dd_size) {
+	return __iscsi_create_endpoint(NULL, dd_size, net);
+}
+
+EXPORT_SYMBOL_GPL(iscsi_create_endpoint_net);
+
 void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
 {
 	sysfs_remove_group(&ep->dev.kobj, &iscsi_endpoint_group);
@@ -3279,10 +3297,10 @@ static int iscsi_if_ep_connect(struct net *net,
 	struct Scsi_Host *shost = NULL;
 	int non_blocking, err = 0;
 
-	if (!transport->ep_connect)
-		return -EINVAL;
-
 	if (msg_type == ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST) {
+		if (!transport->ep_connect)
+			return -EINVAL;
+
 		shost = iscsi_host_lookup(net,
 					ev->u.ep_connect_through_host.host_no);
 		if (!shost) {
@@ -3292,11 +3310,17 @@ static int iscsi_if_ep_connect(struct net *net,
 			return -ENODEV;
 		}
 		non_blocking = ev->u.ep_connect_through_host.non_blocking;
-	} else
+		dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
+		ep = transport->ep_connect(shost, dst_addr, non_blocking);
+	} else {
+		if (!transport->ep_connect_net)
+			return -EINVAL;
+
 		non_blocking = ev->u.ep_connect.non_blocking;
+		dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
+		ep = transport->ep_connect_net(net, dst_addr, non_blocking);
+	}
 
-	dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
-	ep = transport->ep_connect(shost, dst_addr, non_blocking);
 	if (IS_ERR(ep)) {
 		err = PTR_ERR(ep);
 		goto release_host;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index bb6734e900e0..a540e085de8d 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -127,6 +127,9 @@ struct iscsi_transport {
 	struct iscsi_endpoint *(*ep_connect) (struct Scsi_Host *shost,
 					      struct sockaddr *dst_addr,
 					      int non_blocking);
+	struct iscsi_endpoint *(*ep_connect_net) (struct net *net,
+					      struct sockaddr *dst_addr,
+					      int non_blocking);
 	int (*ep_poll) (struct iscsi_endpoint *ep, int timeout_ms);
 	void (*ep_disconnect) (struct iscsi_endpoint *ep);
 	int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
@@ -321,6 +324,7 @@ struct iscsi_endpoint {
 	struct device dev;
 	int id;
 	struct iscsi_cls_conn *conn;
+	struct net *netns;		/* used if there's no parent shost */
 };
 
 struct iscsi_iface {
@@ -477,6 +481,8 @@ extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
 extern struct iscsi_endpoint *iscsi_create_endpoint(struct Scsi_Host *shost,
 						    int dd_size);
+extern struct iscsi_endpoint *iscsi_create_endpoint_net(struct net *net,
+						    int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(struct net *net,
 						    u64 handle);
-- 
2.39.2

