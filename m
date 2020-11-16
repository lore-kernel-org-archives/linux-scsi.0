Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28631C83010
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 15:05:59 +0000 (UTC)
Received: from vger.kernel.org (unknown [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C87F02344C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 15:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iXlgdH+J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C87F02344C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-scsi-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbgKPPEp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 10:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730624AbgKPO6k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 09:58:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D23CC0613CF;
        Mon, 16 Nov 2020 06:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=79ABHzAqAgUDi+r50gNTM9KzgxZfWtsd0Ks61Se8Jjk=; b=iXlgdH+JkeL6roCvy9N8OmOptV
        1Ll+Te6ItuycUsm1mpg5y8MmMvSDVgOMN0DW4BJjUzEL2YXMUw9FI/gCg+GglIDP+2ssWuLid2fb0
        cJZnJp4fVhOgNW619uL3/Kd6hYd61L2NdpCEsJu2r2sYtsuKn5OWNCme31Wn3/FHGbzcF/v5kYRm2
        JnXQsbwRBlyoUcHtnndvHGCnGiJjghxupsGPmu0u5FKR/+UjbjsAeA9OHsZoDrRaOzkGH06M+kWrS
        F/Df603StVMFLWH3uWTjYYJHcHqMIvbijKLsxzszv3RzSONMJItnrjbuYjjQ6SdDQT1ZrHiZj6i2L
        17QgIiog==;
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kefxa-0003md-8r; Mon, 16 Nov 2020 14:58:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/78] dm: use set_capacity_and_notify
Date:   Mon, 16 Nov 2020 15:57:03 +0100
Message-Id: <20201116145809.410558-13-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
References: <20201116145809.410558-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use set_capacity_and_notify to set the size of both the disk and block
device.  This also gets the uevent notifications for the resize for free.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c18fc25485186d..62ad44925e73ec 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1971,8 +1971,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	if (size != dm_get_size(md))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	set_capacity(md->disk, size);
-	bd_set_nr_sectors(md->bdev, size);
+	set_capacity_and_notify(md->disk, size);
 
 	dm_table_event_callback(t, event_callback, md);
 
-- 
2.29.2

