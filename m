Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4676C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB122145D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgE2Nri (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 09:47:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:35664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgE2Nri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 09:47:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D113EAF5C;
        Fri, 29 May 2020 13:47:36 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] target_core_pscsi: use __scsi_device_lookup()
Date:   Fri, 29 May 2020 15:47:27 +0200
Message-Id: <20200529134730.146573-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200529134730.146573-1-hare@suse.de>
References: <20200529134730.146573-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of walking the list of devices manually use the helper
function to return the device directly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_pscsi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index c9d92b3e777d..5fb852d1281f 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -496,11 +496,9 @@ static int pscsi_configure_device(struct se_device *dev)
 	}
 
 	spin_lock_irq(sh->host_lock);
-	list_for_each_entry(sd, &sh->__devices, siblings) {
-		if ((pdv->pdv_channel_id != sd->channel) ||
-		    (pdv->pdv_target_id != sd->id) ||
-		    (pdv->pdv_lun_id != sd->lun))
-			continue;
+	sd = __scsi_device_lookup(sh, pdv->pdv_channel_id,
+				  pdv->pdv_target_id, pdv->pdv_lun_id);
+	if (sd) {
 		/*
 		 * Functions will release the held struct scsi_host->host_lock
 		 * before calling calling pscsi_add_device_to_list() to register
-- 
2.16.4

