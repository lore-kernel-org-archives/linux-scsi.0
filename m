Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B40C7EE30
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 23:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjCBXod (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 18:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjCBXoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 18:44:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC253193CB
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 15:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677800624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=44Bqd6yotCCK5/7jBJ/mmuc4gWLU35hi5f1+zPBfLeo=;
        b=FCoNErtrHI/rMLoC+eD/c8pkjWPj4i90aZRfB9JB+OydsrGTuFm/zpTiKc6C44VUYCJ8En
        vQzIC+XYUswRaSvjZqMSmgmuI1gJ9yAyt/atmfiFfNK9lW5mvF5lDnKVcTwYXEg3Wi/Lu+
        ZTzrXpggp/2/h/yfmfSYTMWJjznNGkE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-Yu_j-P8FNbOuQxCCNl8Ubg-1; Thu, 02 Mar 2023 18:43:41 -0500
X-MC-Unique: Yu_j-P8FNbOuQxCCNl8Ubg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5E7C3C0CD46;
        Thu,  2 Mar 2023 23:43:40 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30692140EBF6;
        Thu,  2 Mar 2023 23:43:40 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: [PATCH v2 3/6] scsi: mpi3mr: fix a memory leak
Date:   Fri,  3 Mar 2023 00:43:33 +0100
Message-Id: <20230302234336.25456-4-thenzl@redhat.com>
In-Reply-To: <20230302234336.25456-1-thenzl@redhat.com>
References: <20230302234336.25456-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

