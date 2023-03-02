Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D21C678D4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 15:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCBPtm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 10:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjCBPt3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 10:49:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9608C1A967
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 07:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677772119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ls4YhmUjGqxUvqm44RrzLr1gLS3axmc0i7vDEP5J7PY=;
        b=LE764xhkIL7bQkCiQLWmVKUN7VfWHukYd0/swfMyOXFAQ4MT94bIq1KaP2ekpdld5T+SLo
        ZnvSgoFFKrotWe0/gkW2RmtUww0Z47vvFnDgqcwAepUfLxlzgcTXeLk0FNlkrb1BNi205k
        N4NPfMIFimKd3GmlWLgikJt6yMG/BrY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-YT3FJhScNpOIEV520q53aQ-1; Thu, 02 Mar 2023 10:48:36 -0500
X-MC-Unique: YT3FJhScNpOIEV520q53aQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A705281722D;
        Thu,  2 Mar 2023 15:48:33 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8948A492C3E;
        Thu,  2 Mar 2023 15:48:32 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: [PATCH 6/6] scsi: mpi3mr: fix a memory leak
Date:   Thu,  2 Mar 2023 16:48:26 +0100
Message-Id: <20230302154826.5862-7-thenzl@redhat.com>
In-Reply-To: <20230302154826.5862-1-thenzl@redhat.com>
References: <20230302154826.5862-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a missing resource clean up in .remove.

Fixes: e22bae30667a ("scsi: mpi3mr: Add expander devices to STL")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           | 2 ++
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 7 +++++++
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 5 +----
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index e6a9c81bba33..c5347a004cd5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1407,4 +1407,6 @@ void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_cmds_for_unrecovered_controller(struct mpi3mr_ioc *mrioc);
 void mpi3mr_free_enclosure_list(struct mpi3mr_ioc *mrioc);
 int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc);
+void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_sas_node *sas_expander);
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8f17a7953eb4..b329e1ee46dc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5113,6 +5113,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
 	struct mpi3mr_hba_port *port, *hba_port_next;
+	struct mpi3mr_sas_node *sas_expander, *sas_expander_next;
 
 	if (!shost)
 		return;
@@ -5153,6 +5154,12 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	mpi3mr_cleanup_resources(mrioc);
 
 	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_for_each_entry_safe_reverse(sas_expander, sas_expander_next,
+	    &mrioc->sas_expander_list, list) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		mpi3mr_expander_node_remove(mrioc, sas_expander);
+		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	}
 	list_for_each_entry_safe(port, hba_port_next, &mrioc->hba_port_table_list, list) {
 		ioc_info(mrioc,
 		    "removing hba_port entry: %p port: %d from hba_port list\n",
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 121fae310692..4d84d5bd173f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -9,9 +9,6 @@
 
 #include "mpi3mr.h"
 
-static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
-	struct mpi3mr_sas_node *sas_expander);
-
 /**
  * mpi3mr_post_transport_req - Issue transport requests and wait
  * @mrioc: Adapter instance reference
@@ -2164,7 +2161,7 @@ int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
  *
  * Return nothing.
  */
-static void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
+void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_node *sas_expander)
 {
 	struct mpi3mr_sas_port *mr_sas_port, *next;
-- 
2.39.1

