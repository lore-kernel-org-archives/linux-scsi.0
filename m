Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EF2C6FA8E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 15:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCBPtc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 10:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCBPt0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 10:49:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4C91ACD1
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 07:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677772116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=44Bqd6yotCCK5/7jBJ/mmuc4gWLU35hi5f1+zPBfLeo=;
        b=ExUuHXtWZsyKGbV8sryqdE3Eu0dFtISY3vyQROEmX/1WIKtJ+DE5kBO94ZuAsW1yOhL88+
        saXYOvH3cWFmfmzu5GCFupalMTPNO/avU9w2VMkCbG3A0FJ1r/HJXlDUAfcdeK97t/sZmY
        zAXXAu7PUP8WXW/Bbz10aIGziL7s2pM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-wnK8laLgMPudeENDQoYX7g-1; Thu, 02 Mar 2023 10:48:35 -0500
X-MC-Unique: wnK8laLgMPudeENDQoYX7g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 847A41818E6E;
        Thu,  2 Mar 2023 15:48:30 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D239D492C3E;
        Thu,  2 Mar 2023 15:48:29 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: [PATCH 3/6] scsi: mpi3mr: fix a memory leak
Date:   Thu,  2 Mar 2023 16:48:23 +0100
Message-Id: <20230302154826.5862-4-thenzl@redhat.com>
In-Reply-To: <20230302154826.5862-1-thenzl@redhat.com>
References: <20230302154826.5862-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Free mpi3mr_hba_port at .remove.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6f9230a079c3..85bd45563686 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5112,6 +5112,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
+	struct mpi3mr_hba_port *port, *hba_port_next;
 
 	if (!shost)
 		return;
@@ -5151,6 +5152,16 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	mpi3mr_free_mem(mrioc);
 	mpi3mr_cleanup_resources(mrioc);
 
+	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
+	list_for_each_entry_safe(port, hba_port_next, &mrioc->hba_port_table_list, list) {
+		ioc_info(mrioc,
+		    "removing hba_port entry: %p port: %d from hba_port list\n",
+		    port, port->port_id);
+		list_del(&port->list);
+		kfree(port);
+	}
+	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
-- 
2.39.1

