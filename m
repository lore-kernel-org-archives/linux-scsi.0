Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D63C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 16:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiBVQBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 11:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiBVQBC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 11:01:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E8EC11986A
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 08:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645545635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7j5XB5PHt4v2EZRj2xa7IPpDQY6qbeddhaMQI3ZMvR8=;
        b=gGE4iiuFqx/D0r0sNgf/K8sntMN/aPgypT1EgQfF63ZopeXJpJuiZJyIjinooi+/h5vkLf
        mvNTwUYhSlrGTeDW34Q94UmuCoc/yLNEDrXXvviSPAAK45ouDZGQefQo3Mxtx9ScCubVLR
        trwUcs/6M/f4vGYcWEMsdRmLkidRG5g=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-NJmTAlLWOOa2nqm_mn5jhg-1; Tue, 22 Feb 2022 11:00:34 -0500
X-MC-Unique: NJmTAlLWOOa2nqm_mn5jhg-1
Received: by mail-qv1-f70.google.com with SMTP id p18-20020a0cf552000000b0043256e3c1c1so881551qvm.16
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 08:00:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7j5XB5PHt4v2EZRj2xa7IPpDQY6qbeddhaMQI3ZMvR8=;
        b=T9bMsJ2pjIBuChrEj3kgvSF/1OpZ6U9m8kjRRZUqhElST2WyLXt4vM6pgDrh9eCOLE
         CH1DGsztnS/Vdq8paD9LY6fPQ+9q7iS9aPAm9rA9aaPdh9HSHhEw2R8r+qcqy3O2AyRD
         i4bTXKUctP7qaTf7Zipg+a7c6zubzjeCyqktOTGDlNWtz5MnOI6AWEkYIs/q0MVus7tC
         AlJz1LvrAm6xfrK+DXgyfxkvfFVwIEx+kxP777s6Q0GdBOA2nVc901Ly2QNyDvTGNo8B
         EKhataxGOezlmKo/WTsc4aJ9HADbKeXbQ4JpPjnEkCXqAFofbIGocfLuAHm0SYYkMCu3
         q32A==
X-Gm-Message-State: AOAM532Szx9qDr1nTO4ZlpbQBOloNL6DNHo0ij+pqxKnDAL7zy3aroQb
        w7bj6V/4Io6L/V+kTbOaX31w2Wgqwqmhom0nIDEcXypCKjFCFXgU/KMowOKH+eODP4FKvMFEnHC
        w8mrH0Q6g0zMGcXl4L06Q
X-Received: by 2002:a37:4646:0:b0:5e9:562c:ac48 with SMTP id t67-20020a374646000000b005e9562cac48mr16038759qka.140.1645545633645;
        Tue, 22 Feb 2022 08:00:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxryPhmCAvy6V12tr9ic0DJ2vhMYnP9pzcqZxnXZ3eH8/ot/d3iuhUAxdNQeoKTb7fJKlWKtg==
X-Received: by 2002:a37:4646:0:b0:5e9:562c:ac48 with SMTP id t67-20020a374646000000b005e9562cac48mr16038726qka.140.1645545633187;
        Tue, 22 Feb 2022 08:00:33 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id h21sm18450qtb.13.2022.02.22.08.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 08:00:32 -0800 (PST)
Date:   Tue, 22 Feb 2022 11:00:31 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Nitesh Shetty <nj.shetty@samsung.com>
Cc:     javier@javigon.com, chaitanyak@nvidia.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        msnitzer@redhat.com, bvanassche@acm.org,
        martin.petersen@oracle.com, hare@suse.de, kbusch@kernel.org,
        hch@lst.de, Frederick.Knight@netapp.com, osandov@fb.com,
        lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
        josef@toxicpanda.com, clm@fb.com, dsterba@suse.com, tytso@mit.edu,
        jack@suse.com, joshi.k@samsung.com, arnav.dawn@samsung.com,
        nitheshshetty@gmail.com, Alasdair Kergon <agk@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <james.smart@broadcom.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/10] dm: Add support for copy offload.
Message-ID: <YhUIny/Huielcit9@redhat.com>
References: <20220214080002.18381-1-nj.shetty@samsung.com>
 <CGME20220214080649epcas5p36ab21e7d33b99eac1963e637389c8be4@epcas5p3.samsung.com>
 <20220214080002.18381-9-nj.shetty@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214080002.18381-9-nj.shetty@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 14 2022 at  2:59P -0500,
Nitesh Shetty <nj.shetty@samsung.com> wrote:

> Before enabling copy for dm target, check if underlying devices and
> dm target support copy. Avoid split happening inside dm target.
> Fail early if the request needs split, currently splitting copy
> request is not supported.
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>  drivers/md/dm-table.c         | 45 +++++++++++++++++++++++++++++++++++
>  drivers/md/dm.c               |  6 +++++
>  include/linux/device-mapper.h |  5 ++++
>  3 files changed, 56 insertions(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e43096cfe9e2..8dc9ae6a6a86 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1903,6 +1903,38 @@ static bool dm_table_supports_nowait(struct dm_table *t)
>  	return true;
>  }
>  
> +static int device_not_copy_capable(struct dm_target *ti, struct dm_dev *dev,
> +				      sector_t start, sector_t len, void *data)
> +{
> +	struct request_queue *q = bdev_get_queue(dev->bdev);
> +
> +	return !blk_queue_copy(q);
> +}
> +
> +static bool dm_table_supports_copy(struct dm_table *t)
> +{
> +	struct dm_target *ti;
> +	unsigned int i;
> +
> +	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> +		ti = dm_table_get_target(t, i);
> +
> +		if (!ti->copy_supported)
> +			return false;
> +
> +		/*
> +		 * target provides copy support (as implied by setting
> +		 * 'copy_supported') and it relies on _all_ data devices having copy support.
> +		 */
> +		if (ti->copy_supported &&
> +		    (!ti->type->iterate_devices ||
> +		     ti->type->iterate_devices(ti, device_not_copy_capable, NULL)))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
>  				      sector_t start, sector_t len, void *data)
>  {
> @@ -2000,6 +2032,19 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	} else
>  		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
>  
> +	if (!dm_table_supports_copy(t)) {
> +		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
> +		/* Must also clear discard limits... */

copy-and-paste mistake: s/discard/copy/ ^

> +		q->limits.max_copy_sectors = 0;
> +		q->limits.max_hw_copy_sectors = 0;
> +		q->limits.max_copy_range_sectors = 0;
> +		q->limits.max_hw_copy_range_sectors = 0;
> +		q->limits.max_copy_nr_ranges = 0;
> +		q->limits.max_hw_copy_nr_ranges = 0;
> +	} else {
> +		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
> +	}
> +
>  	if (dm_table_supports_secure_erase(t))
>  		blk_queue_flag_set(QUEUE_FLAG_SECERASE, q);
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ab9cc91931f9..3b4cd49c489d 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1372,6 +1372,12 @@ static int __split_and_process_non_flush(struct clone_info *ci)
>  	if (__process_abnormal_io(ci, ti, &r))
>  		return r;
>  
> +	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
> +				max_io_len(ti, ci->sector) < ci->sector_count)) {
> +		DMERR("%s: Error IO size(%u) is greater than maximum target size(%llu)\n",
> +				__func__, ci->sector_count, max_io_len(ti, ci->sector));
> +		return -EIO;
> +	}
>  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
>  
>  	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);

There isn't a need for __func__ prefix here.

You'll also need to rebase on latest dm-5.18 (or wait until 5.18 merge
window opens) because there has been some conflicting changes since
you posted.

> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index b26fecf6c8e8..acfd4018125a 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -362,6 +362,11 @@ struct dm_target {
>  	 * zone append operations using regular writes.
>  	 */
>  	bool emulate_zone_append:1;
> +
> +	/*
> +	 * copy offload is supported
> +	 */
> +	bool copy_supported:1;
>  };

Would prefer this be "copy_offload_supported".

>  
>  void *dm_per_bio_data(struct bio *bio, size_t data_size);
> -- 
> 2.30.0-rc0
> 

