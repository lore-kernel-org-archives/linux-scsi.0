Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E5CC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BC70206A1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:39:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="1YlSVyxI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733310AbgF2TjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbgF2TjS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:39:18 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8F3C03E97B
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 12:39:18 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i14so17950347ejr.9
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 12:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pTNM9h8B/nqBwhKTixeQ9FVaezgQyHZKWRfjki1YGQY=;
        b=1YlSVyxICn03xDVzQyl9p+CSdzh/aNFTM4r/v4y5m5E4f8zxUgyN5UTfef9+A0gdxy
         5hi94NNhd1ZeOZ6yaisWJH4nAVAq3DpKSKskLZfkiouLQDpwuhUb8mbjXiAJcJ1wTIBZ
         DHc5YgPk2/unjLzcxMNW9hNo8duS8VEeLkjIr8iCAGOCz4PLUYWkoBKUgKmqyuV4b2o8
         UiFpsBaUMmnFyn/giXbfcVMPqffSRT+anEAX10TuvIB+Tv0dEty47uFNtgrYa2VVDk5J
         Woh0LFbLBhZU1H9Lwgr+Q3Aey315dr4K8g6k25aIzulxpBToOafQ+QmC/4huZzuw4Vcu
         dEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pTNM9h8B/nqBwhKTixeQ9FVaezgQyHZKWRfjki1YGQY=;
        b=I6QfDl2/66wrFNVdFmhLWSKDzVEiJMfONvxJfDZ4KBLC31C/LpIxBGBVenWf8AI7as
         ijNGHxcgbmgXVdkpV8QRuYPFLl/0/YLQ8s43giJfBtY7W+YdP06YjExaC+mWMQ9PxAEV
         nz+vN+7epApOyMN62UNencDD1pe+F6uuUx0oG2BCWm20u6avSKKSSegmIzL6BDwocjQA
         CS3pfFOltvSC1ItiNdidfApVybU5Xbezr/0+4Gb7yL0c6hXXVPrPpE5cQWOAUTb9M1j5
         2SCVfXz6guFfR9MeifRcN48A1j/5RHWIXP/lxcFEMj/LVOMvm43GzApNVgRZFQNgBrNl
         13nQ==
X-Gm-Message-State: AOAM532HAGUTuN8pttKxdTnGFSUV49rrMWQxuOJYyd2Mcn2giXkMWt4w
        +XiQaoKu6VF5O24pjCkIwXUt7g==
X-Google-Smtp-Source: ABdhPJyu4DoXTag6Q5pqwdAxP7bhK9w84NZS2yngFv9ESecjsrMKRejAqD3hqpxBNUAj5rca3Ti5Bw==
X-Received: by 2002:a17:907:9486:: with SMTP id dm6mr15965193ejc.248.1593459556746;
        Mon, 29 Jun 2020 12:39:16 -0700 (PDT)
Received: from localhost (5.186.127.235.cgn.fibianet.dk. [5.186.127.235])
        by smtp.gmail.com with ESMTPSA id v27sm349942ejg.36.2020.06.29.12.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 12:39:16 -0700 (PDT)
Date:   Mon, 29 Jun 2020 21:39:15 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Matias Bjorling <Matias.Bjorling@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH 2/2] block: add BLKSETDESCZONE ioctl for Zoned Block
 Devices
Message-ID: <20200629193915.nopn5kprviddwitn@MacBook-Pro.localdomain>
References: <20200628230102.26990-1-matias.bjorling@wdc.com>
 <20200628230102.26990-3-matias.bjorling@wdc.com>
 <CY4PR04MB37518908765B458987C57702E76E0@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CY4PR04MB37518908765B458987C57702E76E0@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29.06.2020 01:00, Damien Le Moal wrote:
>On 2020/06/29 8:01, Matias Bjorling wrote:
>> The NVMe Zoned Namespace Command Set adds support for associating
>> data to a zone through the Zone Descriptor Extension feature.
>>
>> To allow user-space to associate data to a zone, add support through
>> the BLKSETDESCZONE ioctl. The ioctl requires that it is issued to
>> a zoned block device, and that it supports the Zone Descriptor
>> Extension feature. Support is detected through the
>> the zone_desc_ext_bytes sysfs queue entry for the specific block
>> device. A value larger than zero communicates that the device supports
>> the feature.

Have you considered the possibility of adding this an action to a IOCTL
that looks like the zone management one we discussed last week? We would
start saving IOCTLs already if we count the offline transition and this
one.

>>
>> The ioctl associates data to a zone by issuing a Zone Management Send
>> command with the Zone Send Action set as the Set Zone Descriptor
>> Extension.
>>
>> For the command to complete successfully, the specified zone must be
>> in the Empty state, and active resources must be available. On
>> success, the specified zone is transioned to Closed state by the
>> device. If less data is supplied by user-space then reported by the
>> the Zone Descriptor Extension size, the rest is zero-filled. If more
>> data or no data is supplied by user-space, the ioctl fails.
>>
>> To issue the ioctl, a new blk_zone_set_desc data structure is defined.
>> It has following parameters:
>>
>>  * the sector of the specific zone.
>>  * the length of the data to be associated to the zone.
>>  * any flags be used by the ioctl. None is defined.
>>  * data associated to the zone.
>>
>> The data is laid out after the flags parameter, and it is the caller's
>> responsibility to allocate memory for the data that is specified in the
>> length parameter.
>>
>> Signed-off-by: Matias Bjørling <matias.bjorling@wdc.com>
>> ---
>>  block/blk-zoned.c             | 108 ++++++++++++++++++++++++++++++++++
>>  block/ioctl.c                 |   2 +
>>  drivers/nvme/host/core.c      |   3 +
>>  drivers/nvme/host/nvme.h      |   9 +++
>>  drivers/nvme/host/zns.c       |  11 ++++
>>  include/linux/blk_types.h     |   2 +
>>  include/linux/blkdev.h        |   9 ++-
>>  include/uapi/linux/blkzoned.h |  20 ++++++-
>>  8 files changed, 162 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index 81152a260354..4dc40ec006a2 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -259,6 +259,50 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>>  }
>>  EXPORT_SYMBOL_GPL(blkdev_zone_mgmt);
>>
>> +/**
>> + * blkdev_zone_set_desc - Execute a zone management set zone descriptor
>> + *                        extension operation on a zone
>> + * @bdev:	Target block device
>> + * @sector:	Start sector of the zone to operate on
>> + * @data:	Pointer to the data that is to be associated to the zone
>> + * @gfp_mask:	Memory allocation flags (for bio_alloc)
>> + *
>> + * Description:
>> + *    Associate zone descriptor extension data to a specified zone.
>> + *    The block device must support zone descriptor extensions.
>> + *    i.e., by exposing a positive zone descriptor extension size.
>> + */
>> +int blkdev_zone_set_desc(struct block_device *bdev, sector_t sector,
>> +			 struct page *data, gfp_t gfp_mask)
>
>struct page for the data ? Why not just a "void *" to allow for kmalloc/vmalloc
>data ? And no length for the data ? This is a bit odd.
>
>> +{
>> +	struct request_queue *q = bdev_get_queue(bdev);
>> +	sector_t zone_sectors = blk_queue_zone_sectors(q);
>> +	struct bio_vec bio_vec;
>> +	struct bio bio;
>> +
>> +	if (!blk_queue_is_zoned(q))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (bdev_read_only(bdev))
>> +		return -EPERM;
>
>You are not checking the zone_desc_ext_bytes limit here. You should.
>> +
>> +	/* Check alignment (handle eventual smaller last zone) */
>> +	if (sector & (zone_sectors - 1))
>> +		return -EINVAL;
>
>The comment is incorrect. There is nothing special for handling the last zone in
>this test.
>
>> +
>> +	bio_init(&bio, &bio_vec, 1);
>> +	bio.bi_opf = REQ_OP_ZONE_SET_DESC | REQ_SYNC;
>> +	bio.bi_iter.bi_sector = sector;
>> +	bio_set_dev(&bio, bdev);
>> +	bio_add_page(&bio, data, queue_zone_desc_ext_bytes(q), 0);
>> +
>> +	/* This may take a while, so be nice to others */
>> +	cond_resched();
>
>This is not a loop, so you do not need this.
>
>> +
>> +	return submit_bio_wait(&bio);
>> +}
>> +EXPORT_SYMBOL_GPL(blkdev_zone_set_desc);
>> +
>>  struct zone_report_args {
>>  	struct blk_zone __user *zones;
>>  };
>> @@ -370,6 +414,70 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>>  				GFP_KERNEL);
>>  }
>>
>> +/*
>> + * BLKSETDESCZONE ioctl processing.
>> + * Called from blkdev_ioctl.
>> + */
>> +int blkdev_zone_set_desc_ioctl(struct block_device *bdev, fmode_t mode,
>> +			       unsigned int cmd, unsigned long arg)
>> +{
>> +	void __user *argp = (void __user *)arg;
>> +	struct request_queue *q;
>> +	struct blk_zone_set_desc zsd;
>> +	void *zsd_data;
>> +	int ret;
>> +
>> +	if (!argp)
>> +		return -EINVAL;
>> +
>> +	q = bdev_get_queue(bdev);
>> +	if (!q)
>> +		return -ENXIO;
>> +
>> +	if (!blk_queue_is_zoned(q))
>> +		return -ENOTTY;
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EACCES;
>> +
>> +	if (!(mode & FMODE_WRITE))
>> +		return -EBADF;
>> +
>> +	if (!queue_zone_desc_ext_bytes(q))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (copy_from_user(&zsd, argp, sizeof(struct blk_zone_set_desc)))
>> +		return -EFAULT;
>> +
>> +	/* no flags is currently supported */
>> +	if (zsd.flags)
>> +		return -ENOTTY;
>> +
>> +	if (!zsd.len || zsd.len > queue_zone_desc_ext_bytes(q))
>> +		return -ENOTTY;
>
>This should go into blkdev_zone_set_desc() as well so that in-kernel users are
>checked. So there may be no need to check this here.
>
>> +
>> +	/* allocate the size of the zone descriptor extension and fill
>> +	 * with the data in the user data buffer. If the data size is less
>> +	 * than the zone descriptor extension size, then the rest of the
>> +	 * zone description extension data buffer is zero-filled.
>> +	 */
>> +	zsd_data = (void *) get_zeroed_page(GFP_KERNEL);
>> +	if (!zsd_data)
>> +		return -ENOMEM;
>> +
>> +	if (copy_from_user(zsd_data, argp + sizeof(struct blk_zone_set_desc),
>> +			   zsd.len)) {
>> +		ret = -EFAULT;
>> +		goto free;
>> +	}
>> +
>> +	ret = blkdev_zone_set_desc(bdev, zsd.sector, virt_to_page(zsd_data),
>> +	      GFP_KERNEL);
>> +free:
>> +	free_page((unsigned long) zsd_data);
>> +	return ret;
>> +}
>> +
>>  static inline unsigned long *blk_alloc_zone_bitmap(int node,
>>  						   unsigned int nr_zones)
>>  {
>> diff --git a/block/ioctl.c b/block/ioctl.c
>> index bdb3bbb253d9..b9744705835b 100644
>> --- a/block/ioctl.c
>> +++ b/block/ioctl.c
>> @@ -515,6 +515,8 @@ static int blkdev_common_ioctl(struct block_device *bdev, fmode_t mode,
>>  	case BLKCLOSEZONE:
>>  	case BLKFINISHZONE:
>>  		return blkdev_zone_mgmt_ioctl(bdev, mode, cmd, arg);
>> +	case BLKSETDESCZONE:
>> +		return blkdev_zone_set_desc_ioctl(bdev, mode, cmd, arg);
>>  	case BLKGETZONESZ:
>>  		return put_uint(argp, bdev_zone_sectors(bdev));
>>  	case BLKGETNRZONES:
>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>> index e961910da4ac..b8f25b0d00ad 100644
>> --- a/drivers/nvme/host/core.c
>> +++ b/drivers/nvme/host/core.c
>> @@ -776,6 +776,9 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
>>  	case REQ_OP_ZONE_FINISH:
>>  		ret = nvme_setup_zone_mgmt_send(ns, req, cmd, NVME_ZONE_FINISH);
>>  		break;
>> +	case REQ_OP_ZONE_SET_DESC:
>> +		ret = nvme_setup_zone_set_desc(ns, req, cmd);
>> +		break;
>>  	case REQ_OP_WRITE_ZEROES:
>>  		ret = nvme_setup_write_zeroes(ns, req, cmd);
>>  		break;
>> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
>> index 662f95fbd909..5bd5a437b038 100644
>> --- a/drivers/nvme/host/nvme.h
>> +++ b/drivers/nvme/host/nvme.h
>> @@ -708,6 +708,9 @@ int nvme_report_zones(struct gendisk *disk, sector_t sector,
>>  blk_status_t nvme_setup_zone_mgmt_send(struct nvme_ns *ns, struct request *req,
>>  				       struct nvme_command *cmnd,
>>  				       enum nvme_zone_mgmt_action action);
>> +
>> +blk_status_t nvme_setup_zone_set_desc(struct nvme_ns *ns, struct request *req,
>> +				       struct nvme_command *cmnd);
>>  #else
>>  #define nvme_report_zones NULL
>>
>> @@ -718,6 +721,12 @@ static inline blk_status_t nvme_setup_zone_mgmt_send(struct nvme_ns *ns,
>>  	return BLK_STS_NOTSUPP;
>>  }
>>
>> +static inline blk_status_t nvme_setup_zone_set_desc(struct nvme_ns *ns,
>> +		struct request *req, struct nvme_command *cmnd)
>> +{
>> +	return BLK_STS_NOTSUPP;
>> +}
>> +
>>  static inline int nvme_update_zone_info(struct gendisk *disk,
>>  					struct nvme_ns *ns,
>>  					unsigned lbaf)
>> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
>> index 5792d953a8f3..bfa64cc685d3 100644
>> --- a/drivers/nvme/host/zns.c
>> +++ b/drivers/nvme/host/zns.c
>> @@ -239,3 +239,14 @@ blk_status_t nvme_setup_zone_mgmt_send(struct nvme_ns *ns, struct request *req,
>>
>>  	return BLK_STS_OK;
>>  }
>> +
>> +blk_status_t nvme_setup_zone_set_desc(struct nvme_ns *ns, struct request *req,
>> +		struct nvme_command *c)
>> +{
>> +	c->zms.opcode = nvme_cmd_zone_mgmt_send;
>> +	c->zms.nsid = cpu_to_le32(ns->head->ns_id);
>> +	c->zms.slba = cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
>> +	c->zms.action = NVME_ZONE_SET_DESC_EXT;
>> +
>> +	return BLK_STS_OK;
>> +}
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index ccb895f911b1..53b7b05b0004 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -316,6 +316,8 @@ enum req_opf {
>>  	REQ_OP_ZONE_FINISH	= 12,
>>  	/* write data at the current zone write pointer */
>>  	REQ_OP_ZONE_APPEND	= 13,
>> +	/* associate zone desc extension data to a zone */
>> +	REQ_OP_ZONE_SET_DESC	= 14,
>>
>>  	/* SCSI passthrough using struct scsi_request */
>>  	REQ_OP_SCSI_IN		= 32,
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 2ed55055f68d..c5f092dd5aa3 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -370,7 +370,8 @@ extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
>>  				     unsigned int cmd, unsigned long arg);
>>  extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>>  				  unsigned int cmd, unsigned long arg);
>> -
>> +extern int blkdev_zone_set_desc_ioctl(struct block_device *bdev, fmode_t mode,
>> +				      unsigned int cmd, unsigned long arg);
>>  #else /* CONFIG_BLK_DEV_ZONED */
>>
>>  static inline unsigned int blkdev_nr_zones(struct gendisk *disk)
>> @@ -392,6 +393,12 @@ static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
>>  	return -ENOTTY;
>>  }
>>
>> +static inline int blkdev_zone_set_desc_ioctl(struct block_device *bdev,
>> +					     fmode_t mode, unsigned int cmd,
>> +					     unsigned long arg)
>> +{
>> +	return -ENOTTY;
>> +}
>>  #endif /* CONFIG_BLK_DEV_ZONED */
>>
>>  struct request_queue {
>> diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
>> index 42c3366cc25f..68abda9abf33 100644
>> --- a/include/uapi/linux/blkzoned.h
>> +++ b/include/uapi/linux/blkzoned.h
>> @@ -142,6 +142,20 @@ struct blk_zone_range {
>>  	__u64		nr_sectors;
>>  };
>>
>> +/**
>> + * struct blk_zone_set_desc - BLKSETDESCZONE ioctl requests
>> + * @sector: Starting sector of the zone to operate on.
>> + * @flags: Feature flags.
>> + * @len: size, in bytes, of the data to be associated to the zone.
>> + * @data: data to be associated.
>> + */
>> +struct blk_zone_set_desc {
>> +	__u64		sector;
>> +	__u32		flags;
>> +	__u32		len;
>> +	__u8		data[0];
>> +};

Would it make sense to add nr_sectors if the host wants to associate the
same metadata to several zones. The use case would be the grouping of
larger zones in software.

>> +
>>  /**
>>   * Zoned block device ioctl's:
>>   *
>> @@ -158,6 +172,10 @@ struct blk_zone_range {
>>   *                The 512 B sector range must be zone aligned.
>>   * @BLKFINISHZONE: Mark the zones as full in the specified sector range.
>>   *                 The 512 B sector range must be zone aligned.
>> + * @BLKSETDESCZONE: Set zone description extension data for the zone
>> + *                  in the specified sector. On success, the zone
>> + *                  will transition to the closed zone state.
>> + *                  The 512B sector must be zone aligned.
>>   */
>>  #define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
>>  #define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
>> @@ -166,5 +184,5 @@ struct blk_zone_range {
>>  #define BLKOPENZONE	_IOW(0x12, 134, struct blk_zone_range)
>>  #define BLKCLOSEZONE	_IOW(0x12, 135, struct blk_zone_range)
>>  #define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
>> -
>> +#define BLKSETDESCZONE	_IOW(0x12, 137, struct blk_zone_set_desc)
>>  #endif /* _UAPI_BLKZONED_H */
>>
>
>How to you retreive an extended descriptor that was set ? I do not see any code
>doing that. Report zones is not changed, but I would leave that one as is and
>implement a BLKGETDESCZONE ioctl & in-kernel API.
>

In any case, this is needed. I also could not find a way to read the
extended descriptor back.

Javier
