Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B756CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C0A92078D
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="wzHj9+Bu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbgF2TmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387923AbgF2Tlv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:41:51 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BA7C03E97A
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 12:41:51 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d15so13976975edm.10
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 12:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6a8cX4N7tIU78Bd4F2J28aUNQpAoW/gTIhMzNFxYwFY=;
        b=wzHj9+BuUUyCxdkKKiVEO9Ay5o9qtrK16ExaJLYOzw9UjAZQdvSNNgtbBCPwpsy/DK
         oOPPisPG3Jp6HMjyAM88YEmbc4MDI7lDa7lekQFpo9RI9gN3n9mARHGJEwrNKi9kC38r
         Ce3aUZZ+nEMx9yRyJBLUvGZbk5xaDb6NWnMGjIj16rwPeBiYEbInz0zi20nb9qNOgstC
         wNZrkFMkycFHtcxYH+4vMjgNQZrnLfYkT3RQ4NcC0f5LkbXSt4M6eGqtfetmnqe8GV8S
         2fNCPhZVLkcIeUdVeVcXi5koewbAqwpWVD8ZaYMi7h6Gy4t3JE8Mkz7HXMGVRP9Gzk9j
         D2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6a8cX4N7tIU78Bd4F2J28aUNQpAoW/gTIhMzNFxYwFY=;
        b=ISLGzz6w+US6/e8aKQGA+x77v1FHrik1Awjh74O9PmMX+fILs76I3zTvXdPJRbYmd+
         4DoIdSzXVIl90oacSYKOq3cdbdaMCHpPKjo9lh4uEtZN+kjunZlodTVwABhwpsPKcZdW
         y/Mb7gx7SFqm6AMQ+WEHEAdgpTxW6hT9LbrrO9i7pnHgI4gb4+8CDygx24brXHF0PZc7
         LNN4Sl0YMJ88mYW9kwhpVkIbhSCfhhmAZUp/tMop10TopTNXm0/BFtqLOoUooE0a2KmQ
         3DFlgzn3rxCPpohd75DqxSFeTvzUdLduo9zDre9CRMoJEjLW0Xtm9yh5RqGdbwZJ5pZg
         gm3A==
X-Gm-Message-State: AOAM530PB9H6ztCDbhTrSRkJy2iZWe6XXzw3h5mhrn5M/ajGv3svntYy
        Upy6UtTALoxBTcPPgDM2PA2AWg==
X-Google-Smtp-Source: ABdhPJwaQcnwY52SximMvE4NidS6hrc6E1VXJzI8qyuuYEC11lN320FeP2VQ2lnXILPB7F8de+Ejfw==
X-Received: by 2002:a50:8467:: with SMTP id 94mr18907410edp.249.1593459709993;
        Mon, 29 Jun 2020 12:41:49 -0700 (PDT)
Received: from localhost (5.186.127.235.cgn.fibianet.dk. [5.186.127.235])
        by smtp.gmail.com with ESMTPSA id l18sm599845eds.46.2020.06.29.12.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 12:41:49 -0700 (PDT)
Date:   Mon, 29 Jun 2020 21:41:48 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Niklas Cassel <niklas.cassel@wdc.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 1/2] block: add max_open_zones to blk-sysfs
Message-ID: <20200629194148.vaifnt4fhr2t5bi2@MacBook-Pro.localdomain>
References: <20200616102546.491961-1-niklas.cassel@wdc.com>
 <20200616102546.491961-2-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200616102546.491961-2-niklas.cassel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16.06.2020 12:25, Niklas Cassel wrote:
>Add a new max_open_zones definition in the sysfs documentation.
>This definition will be common for all devices utilizing the zoned block
>device support in the kernel.
>
>Export max open zones according to this new definition for NVMe Zoned
>Namespace devices, ZAC ATA devices (which are treated as SCSI devices by
>the kernel), and ZBC SCSI devices.
>
>Add the new max_open_zones struct member to the request_queue, rather
>than as a queue limit, since this property cannot be split across stacking
>drivers.
>
>Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>---
> Documentation/block/queue-sysfs.rst |  7 +++++++
> block/blk-sysfs.c                   | 15 +++++++++++++++
> drivers/nvme/host/zns.c             |  1 +
> drivers/scsi/sd_zbc.c               |  4 ++++
> include/linux/blkdev.h              | 20 ++++++++++++++++++++
> 5 files changed, 47 insertions(+)
>
>diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
>index 6a8513af9201..f01cf8530ae4 100644
>--- a/Documentation/block/queue-sysfs.rst
>+++ b/Documentation/block/queue-sysfs.rst
>@@ -117,6 +117,13 @@ Maximum number of elements in a DMA scatter/gather list with integrity
> data that will be submitted by the block layer core to the associated
> block driver.
>
>+max_open_zones (RO)
>+-------------------
>+For zoned block devices (zoned attribute indicating "host-managed" or
>+"host-aware"), the sum of zones belonging to any of the zone states:
>+EXPLICIT OPEN or IMPLICIT OPEN, is limited by this value.
>+If this value is 0, there is no limit.
>+
> max_sectors_kb (RW)
> -------------------
> This is the maximum number of kilobytes that the block layer will allow
>diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>index 02643e149d5e..fa42961e9678 100644
>--- a/block/blk-sysfs.c
>+++ b/block/blk-sysfs.c
>@@ -305,6 +305,11 @@ static ssize_t queue_nr_zones_show(struct request_queue *q, char *page)
> 	return queue_var_show(blk_queue_nr_zones(q), page);
> }
>
>+static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
>+{
>+	return queue_var_show(queue_max_open_zones(q), page);
>+}
>+
> static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
> {
> 	return queue_var_show((blk_queue_nomerges(q) << 1) |
>@@ -667,6 +672,11 @@ static struct queue_sysfs_entry queue_nr_zones_entry = {
> 	.show = queue_nr_zones_show,
> };
>
>+static struct queue_sysfs_entry queue_max_open_zones_entry = {
>+	.attr = {.name = "max_open_zones", .mode = 0444 },
>+	.show = queue_max_open_zones_show,
>+};
>+
> static struct queue_sysfs_entry queue_nomerges_entry = {
> 	.attr = {.name = "nomerges", .mode = 0644 },
> 	.show = queue_nomerges_show,
>@@ -765,6 +775,7 @@ static struct attribute *queue_attrs[] = {
> 	&queue_nonrot_entry.attr,
> 	&queue_zoned_entry.attr,
> 	&queue_nr_zones_entry.attr,
>+	&queue_max_open_zones_entry.attr,
> 	&queue_nomerges_entry.attr,
> 	&queue_rq_affinity_entry.attr,
> 	&queue_iostats_entry.attr,
>@@ -792,6 +803,10 @@ static umode_t queue_attr_visible(struct kobject *kobj, struct attribute *attr,
> 		(!q->mq_ops || !q->mq_ops->timeout))
> 			return 0;
>
>+	if (attr == &queue_max_open_zones_entry.attr &&
>+	    !blk_queue_is_zoned(q))
>+		return 0;
>+
> 	return attr->mode;
> }
>
>diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
>index c08f6281b614..af156529f3b6 100644
>--- a/drivers/nvme/host/zns.c
>+++ b/drivers/nvme/host/zns.c
>@@ -82,6 +82,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct nvme_ns *ns,
>
> 	q->limits.zoned = BLK_ZONED_HM;
> 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
>+	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
> free_data:
> 	kfree(id);
> 	return status;
>diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>index 183a20720da9..aa3564139b40 100644
>--- a/drivers/scsi/sd_zbc.c
>+++ b/drivers/scsi/sd_zbc.c
>@@ -717,6 +717,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
> 	/* The drive satisfies the kernel restrictions: set it up */
> 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
> 	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
>+	if (sdkp->zones_max_open == U32_MAX)
>+		blk_queue_max_open_zones(q, 0);
>+	else
>+		blk_queue_max_open_zones(q, sdkp->zones_max_open);
> 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
>
> 	/* READ16/WRITE16 is mandatory for ZBC disks */
>diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>index 8fd900998b4e..2f332f00501d 100644
>--- a/include/linux/blkdev.h
>+++ b/include/linux/blkdev.h
>@@ -520,6 +520,7 @@ struct request_queue {
> 	unsigned int		nr_zones;
> 	unsigned long		*conv_zones_bitmap;
> 	unsigned long		*seq_zones_wlock;
>+	unsigned int		max_open_zones;
> #endif /* CONFIG_BLK_DEV_ZONED */
>
> 	/*
>@@ -729,6 +730,17 @@ static inline bool blk_queue_zone_is_seq(struct request_queue *q,
> 		return true;
> 	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);
> }
>+
>+static inline void blk_queue_max_open_zones(struct request_queue *q,
>+		unsigned int max_open_zones)
>+{
>+	q->max_open_zones = max_open_zones;
>+}
>+
>+static inline unsigned int queue_max_open_zones(const struct request_queue *q)
>+{
>+	return q->max_open_zones;
>+}
> #else /* CONFIG_BLK_DEV_ZONED */
> static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
> {
>@@ -744,6 +756,14 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
> {
> 	return 0;
> }
>+static inline void blk_queue_max_open_zones(struct request_queue *q,
>+		unsigned int max_open_zones)
>+{
>+}
>+static inline unsigned int queue_max_open_zones(const struct request_queue *q)
>+{
>+	return 0;
>+}
> #endif /* CONFIG_BLK_DEV_ZONED */
>
> static inline bool rq_is_sync(struct request *rq)
>-- 
>2.26.2
>
>
>_______________________________________________
>linux-nvme mailing list
>linux-nvme@lists.infradead.org
>http://lists.infradead.org/mailman/listinfo/linux-nvme

Looks good to me.

Reviewed-by: Javier González <javier@javigon.com>
