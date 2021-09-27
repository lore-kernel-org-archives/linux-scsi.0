Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C73D6C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC68660EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhI0WCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 18:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbhI0WCI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 18:02:08 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5253C061769;
        Mon, 27 Sep 2021 15:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Dn0nwO97tF5sgMNA9UASzPzbBLRiiVkhBQPIhqix1v4=; b=M3AH6Wnz5zIiS4kLah8jwnFJa1
        ltMKTFrQbN9BwJYv5ZCv995arAvOdhSKf8EhWlYPhIV7Sr4AAwpOdJUyB/F7ufNhgmWKlJA6kT51u
        oEr8JdB9+9L2GBUGN066ftfZvxsFamjpWTEunnhVUUlrH0gNd7c9KTDB5OwTMlb2O/mt+cQjgJpxf
        EADkOpygKHi6dbUm5sFFGcyQ4TNHklG/jXADY24VCBj8UGxfRD6IUN/ewsC4aZXuMafNSgQZs1d2N
        kmO4Jj/Pkj7TUy+slVYTrDQ5GgBAgTRhJEN1V6r0g+5HcdKvRMN4F6JlNsbifP6Tro38G+UrmTvbP
        1KQBjKAw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyfN-004SV5-96; Mon, 27 Sep 2021 22:00:05 +0000
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
Subject: [PATCH v4 6/6] nbd: add error handling support for add_disk()
Date:   Mon, 27 Sep 2021 14:59:58 -0700
Message-Id: <20210927215958.1062466-7-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927215958.1062466-1-mcgrof@kernel.org>
References: <20210927215958.1062466-1-mcgrof@kernel.org>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/nbd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5170a630778d..741365295157 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1757,7 +1757,9 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
 	sprintf(disk->disk_name, "nbd%d", index);
-	add_disk(disk);
+	err = add_disk(disk);
+	if (err)
+		goto out_err_disk;
 
 	/*
 	 * Now publish the device.
@@ -1766,6 +1768,8 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	nbd_total_devices++;
 	return nbd;
 
+out_err_disk:
+	blk_cleanup_disk(disk);
 out_free_idr:
 	mutex_lock(&nbd_index_mutex);
 	idr_remove(&nbd_index_idr, index);
-- 
2.30.2

