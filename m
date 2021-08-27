Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E836C25AEC
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A3561004
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 19:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhH0TG2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 15:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhH0TGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 15:06:22 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F2DC0613CF;
        Fri, 27 Aug 2021 12:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=27g8RDzr7gEoy3tFbzlvyAEq2vJ4HGIhbsm28mk4NR8=; b=HASLpBMAktazGC/UDUfTeCquT0
        Xn3Gn1Z+VIN4+b/A0d8/B9WEpzaZFRWoUIkxwaC+lDXgrr4oFquFt8wHyildqUbIZKv+AalvoVmRA
        RuCEr7c4egusqMDGrFFDINcbWx73OBJH+4KNEOBH4HD7Xey2gjunzYRxxKM2Fgbi9qzNBo5x4d0GJ
        Hu49y2Q6m3Gu5Ja7ytRUidSeDVUjweUycGizJM9r2QEuHDwz7USTernnUEWoeugoMVWSFGisBjl70
        7P66WnJj7igoNp/U1R1br5Hk7M5eVGHEtvixVhgYNAxfHXwDPzURs0nze1zHw0ex6gt4RLNEmnJ2b
        q7mE6FZg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhA1-00D1L5-BD; Fri, 27 Aug 2021 19:05:05 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com
Cc:     hch@infradead.org, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 3/6] nvme: add error handling support for add_disk()
Date:   Fri, 27 Aug 2021 12:05:01 -0700
Message-Id: <20210827190504.3103362-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827190504.3103362-1-mcgrof@kernel.org>
References: <20210827190504.3103362-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvme/host/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8679a108f571..687d3be563a3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3763,7 +3763,9 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 
 	nvme_get_ctrl(ctrl);
 
-	device_add_disk(ctrl->device, ns->disk, nvme_ns_id_attr_groups);
+	if (device_add_disk(ctrl->device, ns->disk, nvme_ns_id_attr_groups))
+		goto out_cleanup_ns_from_list;
+
 	if (!nvme_ns_head_multipath(ns->head))
 		nvme_add_ns_cdev(ns);
 
@@ -3773,6 +3775,11 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 
 	return;
 
+ out_cleanup_ns_from_list:
+	nvme_put_ctrl(ctrl);
+	down_write(&ctrl->namespaces_rwsem);
+	list_del_init(&ns->list);
+	up_write(&ctrl->namespaces_rwsem);
  out_unlink_ns:
 	mutex_lock(&ctrl->subsys->lock);
 	list_del_rcu(&ns->siblings);
-- 
2.30.2

