Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920EFC7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjCVUDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjCVUCa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:02:30 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ADF6C196
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:20 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id d13so19542793pjh.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xqqv+aHKme2XMo/FdJ5muGw9JOXNAt4DfJWK98zODgU=;
        b=RTcDAXiYmLlKqTDEMBriuOlnnhz6uRUI7mwhMKh/t9kLvYMJxEIGGq14JEQ9PXrHSJ
         mkbIOqfpuqCQs27GCtJz8uVl/TL9PE7V+ozXLQDjPmAYyEOD8H7XKd0Wpj9FN3u7axzn
         CSTXnndK58WKovF665n+NDerdF0RJnmAEwZ7AF0q6NCciiFOO6pFPmm3N0+TTCOQeLvG
         b1tYbcZV+DRvXKnaTGMFcCYuL/4dBrW6KVSnx+EKu/K8A7Apz2yfIfhh99lk1GUOPNvA
         40zEHNMtQCNw/zzaC67rO9Si4nMIP/9dmsSSHlY5JI/CxL1r8Q2jOzK583JzUGMPSduL
         pp2w==
X-Gm-Message-State: AO0yUKVlbiTXOsLY52/TzKigNhARDlLfKgsiaek4IXJJmAYbGaR8N7q/
        J4O17LoOtvdYZ+oO6k5JMUQ=
X-Google-Smtp-Source: AK7set86avqIM/zetdEK61N26UV8forebrfoWOhxqpyvVnW/3HMcL3aRifOIdJmUe5zQs2M5ICeXqg==
X-Received: by 2002:a17:90b:1c81:b0:23f:7d05:8765 with SMTP id oo1-20020a17090b1c8100b0023f7d058765mr4971741pjb.10.1679515129118;
        Wed, 22 Mar 2023 12:58:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 74/80] scsi: virtio-scsi: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:09 -0700
Message-Id: <20230322195515.1267197-75-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c5558c45ab3a..58498da9869a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -746,7 +746,7 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
 	return SCSI_EH_RESET_TIMER;
 }
 
-static struct scsi_host_template virtscsi_host_template = {
+static const struct scsi_host_template virtscsi_host_template = {
 	.module = THIS_MODULE,
 	.name = "Virtio SCSI HBA",
 	.proc_name = "virtio_scsi",
