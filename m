Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB05C77B73
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 23:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjEFXbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 May 2023 19:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjEFXbe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 May 2023 19:31:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6138811540
        for <linux-scsi@vger.kernel.org>; Sat,  6 May 2023 16:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683415804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hqhmg8Av0eHkGffW04hqyQM86CV5Jf1/OdaPhsIJszw=;
        b=Pri8hs7aUqSKeThoyWtJYgZ3FyIh3ty97vPwvBRNvsvdDNPHyn/QeV/siokDOQZYj8YM1W
        tbf+YiCUKDdM22QaLoUY5FV10lZKPtYKpGiscbuXDxEwVH1xXNvGaOqIRMz2Omf7v4I30t
        81ilZaN1K3fM+LjSVAJ98pXOoeIu7rY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-Sw4aRg4WPYKqbogOMpK5Nw-1; Sat, 06 May 2023 19:30:00 -0400
X-MC-Unique: Sw4aRg4WPYKqbogOMpK5Nw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0E9F857DD7;
        Sat,  6 May 2023 23:29:59 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 294E6440BC;
        Sat,  6 May 2023 23:29:59 +0000 (UTC)
From:   Chris Leech <cleech@redhat.com>
To:     Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Chris Leech <cleech@redhat.com>
Subject: [PATCH 09/11] iscsi: filter flashnode sysfs by net namespace
Date:   Sat,  6 May 2023 16:29:28 -0700
Message-Id: <20230506232930.195451-10-cleech@redhat.com>
In-Reply-To: <20230506232930.195451-1-cleech@redhat.com>
References: <20230506232930.195451-1-cleech@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

This finishes the net namespace support for flashnode sysfs devices.

Signed-off-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 34 +++++++++++++++++++++++++++++
 include/scsi/scsi_transport_iscsi.h |  4 ----
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 26b3d479b6ac..cd3228293a64 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1289,8 +1289,42 @@ static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
 	return dev->type == &iscsi_flashnode_conn_dev_type;
 }
 
+static struct net *iscsi_flashnode_sess_net(struct iscsi_flash_session *f_sess)
+{
+	struct Scsi_Host *shost = iscsi_flash_session_to_shost(f_sess);
+	struct iscsi_cls_host *ihost = shost->shost_data;
+
+	return iscsi_host_net(ihost);
+}
+
+static struct net *iscsi_flashnode_conn_net(struct iscsi_flash_conn *f_conn)
+{
+	struct iscsi_flash_session *f_sess =
+		iscsi_flash_conn_to_flash_session(f_conn);
+
+	return iscsi_flashnode_sess_net(f_sess);
+}
+
+static const void *iscsi_flashnode_namespace(const struct device *dev)
+{
+	struct iscsi_flash_conn *f_conn;
+	struct iscsi_flash_session *f_sess;
+	struct device *dev_tmp = (struct device *)dev;
+
+	if (iscsi_is_flashnode_conn_dev(dev_tmp, NULL)) {
+		f_conn = iscsi_dev_to_flash_conn(dev);
+		return iscsi_flashnode_conn_net(f_conn);
+	} else if (iscsi_is_flashnode_session_dev(dev_tmp)) {
+		f_sess = iscsi_dev_to_flash_session(dev);
+		return iscsi_flashnode_sess_net(f_sess);
+	}
+	return NULL;
+}
+
 static struct class iscsi_flashnode = {
 	.name = "iscsi_flashnode",
+	.ns_type = &net_ns_type_operations,
+	.namespace = iscsi_flashnode_namespace,
 };
 
 /**
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index a23b511b6f53..a540e085de8d 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -516,8 +516,6 @@ extern void
 iscsi_destroy_flashnode_sess(struct iscsi_flash_session *fnode_sess);
 
 extern void iscsi_destroy_all_flashnode(struct Scsi_Host *shost);
-extern int iscsi_flashnode_bus_match(struct device *dev,
-				     struct device_driver *drv);
 extern struct device *
 iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 			  int (*fn)(struct device *dev, void *data));
@@ -526,8 +524,6 @@ iscsi_find_flashnode_conn(struct iscsi_flash_session *fnode_sess);
 
 extern bool iscsi_is_flashnode_session_dev(struct device *dev);
 
-extern bool iscsi_is_flashnode_session_dev(struct device *dev);
-
 extern char *
 iscsi_get_ipaddress_state_name(enum iscsi_ipaddress_state port_state);
 extern char *iscsi_get_router_state_name(enum iscsi_router_state router_state);
-- 
2.39.2

