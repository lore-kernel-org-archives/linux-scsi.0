Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D005CC4CEC5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A48BA206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IH2R2Za3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbfIMNF2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35507 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id 205so18053509pfw.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SRj0c5G429iSG116CLiEpdfd+23LgYkL7nkuDUVI6yE=;
        b=IH2R2Za3oh6upvL4TDY7cbvQbD4AQ3J6RwXCcOTn9t+d7o2++SYyxzMRDZcn+AsfaI
         5RtLJFmb2ffDCMU5s/JuUTp8QNx7Jj+k3Xh4mJSd7PHYy65v1eHWmf6z/vgmYh49Dj5H
         gh5E4WOLO2O1k2YL1FaCofUjYZAAjDSi7ler4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SRj0c5G429iSG116CLiEpdfd+23LgYkL7nkuDUVI6yE=;
        b=L/HVXbslk/D8pD972xgV+TAKmlZ9HgaDWuk4qqNtaeznhyeKCWTDPewbY0KzmryrL3
         arzYU09OG+LLjALUGx3qXIXXsOQh20Aw7rW+KhJvUbQmOhymohp4vnzIKw1rlGHCcl9z
         gqi6JNXEc2vSQntgBJhHTLIiKS4xm3yfrAPjAggkYYUVS7A3JZ98I+T6iODnsgfZJnKk
         Qf66X4dt5TuMZWHIKzvLwQl0LQvTOw7Ida/t2yscyoAOiKoEANSR2cwAVJsyHl6cMUjR
         fnyQTVGDJBmhTGOk7cNLJHs8ny+nD8QEozX4/ajRtJD6jH1DmRoFsf9xWmqfooLqieDS
         CUdg==
X-Gm-Message-State: APjAAAVXX8k7wyOsM1OZ+/k+KZreSkCHiGIAGUOwWaD8/puOPiEUGdfH
        MbaXfbDcHO4HQc1YXXqwmBkg/Q==
X-Google-Smtp-Source: APXvYqwQvLbdYLRjcB8iEO4peZcTyv6ORiDqXIMhawy+4KoripmL+EzDdDCj9mi0t94m/7vpt+AiCA==
X-Received: by 2002:a63:5c06:: with SMTP id q6mr43552696pgb.45.1568379927418;
        Fri, 13 Sep 2019 06:05:27 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:26 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 12/13] mpt3sas: Fix module parameter max_msix_vectors
Date:   Fri, 13 Sep 2019 09:04:49 -0400
Message-Id: <1568379890-18347-13-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Issue:
Load driver with module parameter "max_msix_vectors".
Value provided in module parameter is not used by mpt3sas
driver. Driver loads with max controller supported
MSIX value.

Fix:
In _base_alloc_irq_vectors use reply_queue_count which is
determined using user provided msix value insted of
ioc->msix_vector_count which tells max supported msix value
of the controller.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6eb0cef..ddecdb1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3042,11 +3042,11 @@ _base_alloc_irq_vectors(struct MPT3SAS_ADAPTER *ioc)
 		descp = NULL;
 
 	ioc_info(ioc, " %d %d\n", ioc->high_iops_queues,
-	    ioc->msix_vector_count);
+	    ioc->reply_queue_count);
 
 	i = pci_alloc_irq_vectors_affinity(ioc->pdev,
 	    ioc->high_iops_queues,
-	    ioc->msix_vector_count, irq_flags, descp);
+	    ioc->reply_queue_count, irq_flags, descp);
 
 	return i;
 }
-- 
1.8.3.1

