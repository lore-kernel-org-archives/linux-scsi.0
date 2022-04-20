Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EC6C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 19:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381807AbiDTTo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 15:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347556AbiDTTo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 15:44:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084D813FB1;
        Wed, 20 Apr 2022 12:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A1E861617;
        Wed, 20 Apr 2022 19:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C871C385A0;
        Wed, 20 Apr 2022 19:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650483727;
        bh=VkstLNUnX452bwgxVbRIkkIiLOBzV/cxnUGwTZse+38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pz9skgakdcihR9csrUcjZT44NnjtWbJ8iPQVCsk8Bt4o9WuCBhLXYSzur/HQUFBJD
         ManinBuSF5ltDZDb/nyBtQIuyjkh+fRifJgvhSXi5SgqQj4AImO46y4MvzC4E59WuI
         FAFMZo673HxfxypD1JRbsuV1EBBa2ua1OJPwzH/LTk2kc5qg1xbCvFNkfINkCoiL1B
         xrUoAT7Qw2jqPxpewcc2bSSWpGQhZuuN5WkZwt672JiuEIoucKhHrV1XR2MQ6CTyFE
         L+RQ+mnNwLHOW14E9sUwSIxu9EDBMbiaOVdMng5v882yuCetMkbHOpSYe1RZVYYuX8
         FYf1lk3HXT1ag==
Date:   Wed, 20 Apr 2022 12:41:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] blk-crypto: fix the blk_crypto_profile liftime
Message-ID: <YmBiAQ/IZbFhRc6o@sol.localdomain>
References: <20220420064745.1119823-1-hch@lst.de>
 <20220420064745.1119823-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420064745.1119823-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 20, 2022 at 08:47:45AM +0200, Christoph Hellwig wrote:
> Once the blk_crypto_profile is exposed in sysfs it needs to stay alive
> as long as sysfs accesses are possibly pending.  Ensure that by removing
> the blk_crypto_kobj wrapper and just embedding the kobject into the
> actual blk_crypto_profile.  This requires the blk_crypto_profile
> structure to be dynamically allocated, which in turn requires a private
> data pointer for driver use.
> 
> Fixes: 20f01f163203 ("blk-crypto: show crypto capabilities in sysfs")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Can you elaborate on what you think the actual problem is here?  The lifetime of
the blk_crypto_profile matches that of the host controller kobject, and I
thought that it is not destroyed until after higher-level objects such as
gendisks and request_queues are destroyed.  Similar assumptions are made by the
queue kobject, which assumes it is safe to access the gendisk, and by the
independent_access_ranges kobject which assumes it is safe to access the queue.

I suppose this wouldn't have worked with the original sysfs design where opening
a file in sysfs actually got a refcount to the kobject.  But that's long gone,
having been changed in Linux v2.6.23 (https://lwn.net/Articles/229774).

Note that commit 20f01f163203 which added this code got an "all looks good" from
Greg KH (https://lore.kernel.org/r/YaH1CmHClx5WvDWD@kroah.com).  I'd have hoped
that he would've noticed if there was a major problem with how kobjects are used
here!  Greg, would you mind taking a look at this part again?

>  int blk_crypto_sysfs_register(struct request_queue *q)
>  {
> -	struct blk_crypto_kobj *obj;
>  	int err;
>  
>  	if (!q->crypto_profile)
>  		return 0;
>  
> -	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
> -	if (!obj)
> -		return -ENOMEM;
> -	obj->profile = q->crypto_profile;
> -
> -	err = kobject_init_and_add(&obj->kobj, &blk_crypto_ktype, &q->kobj,
> -				   "crypto");
> -	if (err) {
> -		kobject_put(&obj->kobj);
> -		return err;
> -	}
> -	q->crypto_kobject = &obj->kobj;
> -	return 0;
> +	err = kobject_add(&q->crypto_profile->kobj, &q->kobj, "crypto");
> +	if (err)
> +		kobject_put(&q->crypto_profile->kobj);
> +	return err;
>  }

In any case, this proposal is not correct since it is assuming that each
blk_crypto_profile is referenced by only one request_queue, which is not
necessarily the case since a host controller can have multiple disks.
The same kobject can't be added to multiple places in the hierarchy.

If we did need to do something differently here, I think we'd either need to put
the blk_crypto_profile kobject under the host controller one and link to it from
the queue directories (which I mentioned in commit 20f01f163203 as an
alternative considered), or duplicate the crypto capabilities in each
request_queue and only share the actual keyslot management data structures.

- Eric
