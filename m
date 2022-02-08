Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9A5C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 07:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347843AbiBHHCo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 02:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiBHHCl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 02:02:41 -0500
X-Greylist: delayed 67 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 23:02:40 PST
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D52C0401F6
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 23:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644303760; x=1675839760;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CiN1mtQpfnVM+S+oG/FguRPdfKuxbKIIXKfqOVpssD0=;
  b=mI/pFTozwyeZCWxP1uLaBoc7qaY6N8+ggspss8iUZqHt9aH/L9fpqswH
   CclOuLxrGIBMdS5y1i5PDFvXPkpUZu9Bz9UunupGvq+17MAxVwUzd4Ier
   9upn3m1D0SFCbWzGzQG+H1zH+7BuVepxoB6tTEEkXl9kJQ7nW0Z8We39i
   2fRA9kmDLF7sC7hmQj3x0XL4Q5YbA7o1VpxTnOpDB1O3vlGxtjsLwxy5F
   XP+9SA145nVXUyr8abatBY540Ubv1DGng2nk8ldycx9fUcDZPusdQCh88
   zWV55TLDJDA+5flzVWh3KRinfb/MJ84azwUE38w86wu64HnDoh2Kw0ib+
   A==;
X-IronPort-AV: E=Sophos;i="5.88,352,1635177600"; 
   d="scan'208";a="191334893"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Feb 2022 15:01:33 +0800
IronPort-SDR: 6i+3RtXWhG6IWXO5o57HliGfp2H/ad59M/NdRCG5UdIDPzpnaVoH/YlcaylrTmpScSF2A7USaR
 ee31Avnei4c/fZyD4ulcez9fNhy1XgHkoERqo5n9NP28PKv9d+pmx7WEgtmFNga9BBTCUApWv1
 /PrV9moRwYFDxiyA7hPFKhCpzhc0Nc+2EDn7Qhbta23l2X47bXuX6G3gSatpOPq4bWxjxtygwk
 L39KlFcedg4ozbtsCdzokQybVAqv6EPr8q+CF/T+xbAd7uUzX6fvGyeg+JyEvOctnfEjNelDTG
 kWzvRZ1L8AIXEXXyL5dQQSK5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 22:34:33 -0800
IronPort-SDR: f2+b0sFIc8BKU9Mu5frl4gzklnBVe1AqvOLeXIN9q8tLR1W71eDggw1wFzrs5ZiMXaWEIPJtQJ
 Mlsbc9ooagiUL4ozCuKzSXGSkzLsZQVzYW7+T6rzgR+EXAsYXPowd/mPp3AnC4XGfDnasafg8j
 fsz/nzSldT6dUwWaLdw3I8UVEvHy7w9EdYnNtQX05W3VUW8Iqxg1DI+vHgSlSuEeyASI5Jt7gn
 7sUgxdkhUTqaSP7pHhk9rk21WgJ7mXKyMtjO4B22HUp0WSR3A1aag7KH0aolNAQ0T4A84/agC2
 WK4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 23:01:33 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JtDSs0rn8z1SHwl
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 23:01:33 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644303691; x=1646895692; bh=CiN1mtQpfnVM+S+oG/FguRPdfKuxbKIIXKf
        qOVpssD0=; b=oEENnK4Dlm7k43S7nhUNxSwUu9bvfTqU9eMa0bUnYmO3+bjA11N
        Nt5gm/MOzZcR6x3/03x4xBmQNr4ikdYiG2wHftl4E2dfItMPvlBwBb5MFUIl+Uxr
        jjGpxQ+cwMnTZ87FoiJC/Rtd1kq2coBiVcorgnIuON8CHGHro9uzMicliEZBfWrp
        jBu4LlAYVRfhRXUYFWMNpIbTdsYQSBpABhftMPGCrCRe1pBrR1oYGe+i6PV2/Ixo
        MYxx/H1t7T3ON3eKK8CT0znLsXVQG7DXd8Ena+TEXWz8cuZn8bhwoshlI2n+QeVn
        bnJMgN329d6Oe6ZxSVrmT9P4NLHCvJLogqQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CNPJDBVl__Y7 for <linux-scsi@vger.kernel.org>;
        Mon,  7 Feb 2022 23:01:31 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JtDSh47jKz1Rwrw;
        Mon,  7 Feb 2022 23:01:24 -0800 (PST)
Message-ID: <af214223-8bb9-a1ca-6394-9c403c9becef@opensource.wdc.com>
Date:   Tue, 8 Feb 2022 16:01:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 02/10] block: Introduce queue limits for copy-offload
 support
Content-Language: en-US
To:     Nitesh Shetty <nj.shetty@samsung.com>, mpatocka@redhat.com
Cc:     javier@javigon.com, chaitanyak@nvidia.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        msnitzer@redhat.com, bvanassche@acm.org,
        martin.petersen@oracle.com, roland@purestorage.com, hare@suse.de,
        kbusch@kernel.org, hch@lst.de, Frederick.Knight@netapp.com,
        zach.brown@ni.com, osandov@fb.com,
        lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
        josef@toxicpanda.com, clm@fb.com, dsterba@suse.com, tytso@mit.edu,
        jack@suse.com, joshi.k@samsung.com, arnav.dawn@samsung.com,
        SelvaKumar S <selvakuma.s1@samsung.com>
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
 <20220207141348.4235-1-nj.shetty@samsung.com>
 <CGME20220207141913epcas5p4d41cb549b7cca1ede5c7a66bbd110da0@epcas5p4.samsung.com>
 <20220207141348.4235-3-nj.shetty@samsung.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220207141348.4235-3-nj.shetty@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/7/22 23:13, Nitesh Shetty wrote:
> Add device limits as sysfs entries,
>         - copy_offload (READ_WRITE)
>         - max_copy_sectors (READ_ONLY)

Why read-only ? With the name as you have it, it seems to be the soft
control for the max size of copy operations rather than the actual
device limit. So it would be better to align to other limits like max
sectors/max_hw_sectors and have:

	max_copy_sectors (RW)
	max_hw_copy_sectors (RO)

>         - max_copy_ranges_sectors (READ_ONLY)
>         - max_copy_nr_ranges (READ_ONLY)

Same for these.

> 
> copy_offload(= 0), is disabled by default. This needs to be enabled if
> copy-offload needs to be used.

How does this work ? This limit will be present for a DM device AND the
underlying devices of the DM target. But "offload" applies only to the
underlying devices, not the DM device...

Also, since this is not an underlying device limitation but an on/off
switch, this should probably be moved to a request_queue boolean field
or flag bit, controlled with sysfs.

> max_copy_sectors = 0, indicates the device doesn't support native copy.
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  block/blk-settings.c   |  4 ++++
>  block/blk-sysfs.c      | 51 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blkdev.h | 12 ++++++++++
>  3 files changed, 67 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index b880c70e22e4..818454552cf8 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -57,6 +57,10 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->misaligned = 0;
>  	lim->zoned = BLK_ZONED_NONE;
>  	lim->zone_write_granularity = 0;
> +	lim->copy_offload = 0;
> +	lim->max_copy_sectors = 0;
> +	lim->max_copy_nr_ranges = 0;
> +	lim->max_copy_range_sectors = 0;
>  }
>  EXPORT_SYMBOL(blk_set_default_limits);
>  
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 9f32882ceb2f..dc68ae6b55c9 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -171,6 +171,48 @@ static ssize_t queue_discard_granularity_show(struct request_queue *q, char *pag
>  	return queue_var_show(q->limits.discard_granularity, page);
>  }
>  
> +static ssize_t queue_copy_offload_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->limits.copy_offload, page);
> +}
> +
> +static ssize_t queue_copy_offload_store(struct request_queue *q,
> +				       const char *page, size_t count)
> +{
> +	unsigned long copy_offload;
> +	ssize_t ret = queue_var_store(&copy_offload, page, count);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (copy_offload && q->limits.max_copy_sectors == 0)
> +		return -EINVAL;
> +
> +	if (copy_offload)
> +		q->limits.copy_offload = BLK_COPY_OFFLOAD;
> +	else
> +		q->limits.copy_offload = 0;
> +
> +	return ret;
> +}
> +
> +static ssize_t queue_max_copy_sectors_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->limits.max_copy_sectors, page);
> +}
> +
> +static ssize_t queue_max_copy_range_sectors_show(struct request_queue *q,
> +		char *page)
> +{
> +	return queue_var_show(q->limits.max_copy_range_sectors, page);
> +}
> +
> +static ssize_t queue_max_copy_nr_ranges_show(struct request_queue *q,
> +		char *page)
> +{
> +	return queue_var_show(q->limits.max_copy_nr_ranges, page);
> +}
> +
>  static ssize_t queue_discard_max_hw_show(struct request_queue *q, char *page)
>  {
>  
> @@ -597,6 +639,11 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
>  QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
>  QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
>  
> +QUEUE_RW_ENTRY(queue_copy_offload, "copy_offload");
> +QUEUE_RO_ENTRY(queue_max_copy_sectors, "max_copy_sectors");
> +QUEUE_RO_ENTRY(queue_max_copy_range_sectors, "max_copy_range_sectors");
> +QUEUE_RO_ENTRY(queue_max_copy_nr_ranges, "max_copy_nr_ranges");
> +
>  QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
>  QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
>  QUEUE_RW_ENTRY(queue_poll, "io_poll");
> @@ -643,6 +690,10 @@ static struct attribute *queue_attrs[] = {
>  	&queue_discard_max_entry.attr,
>  	&queue_discard_max_hw_entry.attr,
>  	&queue_discard_zeroes_data_entry.attr,
> +	&queue_copy_offload_entry.attr,
> +	&queue_max_copy_sectors_entry.attr,
> +	&queue_max_copy_range_sectors_entry.attr,
> +	&queue_max_copy_nr_ranges_entry.attr,
>  	&queue_write_same_max_entry.attr,
>  	&queue_write_zeroes_max_entry.attr,
>  	&queue_zone_append_max_entry.attr,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index efed3820cbf7..f63ae50f1de3 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -51,6 +51,12 @@ extern struct class block_class;
>  /* Doing classic polling */
>  #define BLK_MQ_POLL_CLASSIC -1
>  
> +/* Define copy offload options */
> +enum blk_copy {
> +	BLK_COPY_EMULATE = 0,
> +	BLK_COPY_OFFLOAD,
> +};
> +
>  /*
>   * Maximum number of blkcg policies allowed to be registered concurrently.
>   * Defined here to simplify include dependency.
> @@ -253,6 +259,10 @@ struct queue_limits {
>  	unsigned int		discard_granularity;
>  	unsigned int		discard_alignment;
>  	unsigned int		zone_write_granularity;
> +	unsigned int            copy_offload;
> +	unsigned int            max_copy_sectors;
> +	unsigned short          max_copy_range_sectors;
> +	unsigned short          max_copy_nr_ranges;
>  
>  	unsigned short		max_segments;
>  	unsigned short		max_integrity_segments;
> @@ -562,6 +572,7 @@ struct request_queue {
>  #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
>  #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
>  #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
> +#define QUEUE_FLAG_COPY		30	/* supports copy offload */

Then what is the point of max_copy_sectors limit ? You can test support
by the device by looking at max_copy_sectors != 0, no ? This flag is
duplicated information.
I would rather use it for the on/off switch for the copy offload,
removing the copy_offload limit.

>  
>  #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>  				 (1 << QUEUE_FLAG_SAME_COMP) |		\
> @@ -585,6 +596,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
>  #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
>  #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
>  #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
> +#define blk_queue_copy(q)	test_bit(QUEUE_FLAG_COPY, &(q)->queue_flags)
>  #define blk_queue_zone_resetall(q)	\
>  	test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
>  #define blk_queue_secure_erase(q) \


-- 
Damien Le Moal
Western Digital Research
