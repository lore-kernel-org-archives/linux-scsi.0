Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13481C4320E
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB9C60525
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 21:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbhH3V1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 17:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhH3V1F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 17:27:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56461C061760;
        Mon, 30 Aug 2021 14:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=WZDOVyRqrotfblM3MrNHqoihizZi1dQWZqaOZFp5Q1M=; b=i8ELcjA/anrU1TOHpT3BXlv5sQ
        9q5jw+XOVVb/qUvV9ig0gbEr9CrSUmV3KpTOZDXHGFakrCIS18jy03q+1JzG3IWwARLfGn1Z/7fo/
        XOcVbLQBZElwJbcert/XSMBhSrXd977VdHJk+2AXpHpLvWfDd6FWkkd+Ie9d+lv89upJrOWSbAJSK
        nT0oSWfCoTlrFojFLLJ3zXxMvwbM0j0ElnF6FO/lzdjKqXXgHhhs3sE1xiVRyqkLqBTwNloi2o17C
        S6tz5a9SINyP3qxdan7AtdeT2cf48qweDik29nXili4ONS2xfgWdyOpQF8Qksp4ZnyNcDGVKJS1LK
        1iirUqCg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKomk-000ciA-Km; Mon, 30 Aug 2021 21:25:42 +0000
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
        Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 3/8] nvme: add error handling support for add_disk()
Date:   Mon, 30 Aug 2021 14:25:33 -0700
Message-Id: <20210830212538.148729-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830212538.148729-1-mcgrof@kernel.org>
References: <20210830212538.148729-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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

