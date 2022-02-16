Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE7FC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 13:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbiBPNdQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 08:33:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbiBPNdM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 08:33:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50EDB1897CF
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 05:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645018379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ugIJWQk3SMKfMsohcYmO1QoDdMHhYRu0T2WPYwlO3u4=;
        b=MnPEzgtS5ObkKt1o3jW/9mweawgHSmz8C5FB//eyYc+0yZfwdYZRL7C+cxiRQLYV1IJ59D
        uvu3DeEoVe5xvoeFixobRMCf/KFXa+kuPmXG1nQAbUuW+s2r3zk5unSgO9uyI+ohK0mLOD
        QjtmSjaByh1PZgc5TTpyn8Z9cMRmF7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-z8ORJ7cSMN6lryLeURn9Xg-1; Wed, 16 Feb 2022 08:32:54 -0500
X-MC-Unique: z8ORJ7cSMN6lryLeURn9Xg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDDB4814246;
        Wed, 16 Feb 2022 13:32:50 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFDB32AA93;
        Wed, 16 Feb 2022 13:32:47 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 21GDWli7022921;
        Wed, 16 Feb 2022 08:32:47 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 21GDWjiY022917;
        Wed, 16 Feb 2022 08:32:46 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 16 Feb 2022 08:32:45 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Nitesh Shetty <nj.shetty@samsung.com>
cc:     javier@javigon.com, chaitanyak@nvidia.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        msnitzer@redhat.com, bvanassche@acm.org,
        martin.petersen@oracle.com, roland@purestorage.com, hare@suse.de,
        kbusch@kernel.org, hch@lst.de, Frederick.Knight@netapp.com,
        zach.brown@ni.com, osandov@fb.com,
        lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
        josef@toxicpanda.com, clm@fb.com, dsterba@suse.com, tytso@mit.edu,
        jack@suse.com, joshi.k@samsung.com, arnav.dawn@samsung.com
Subject: Re: [PATCH v2 05/10] block: add emulation for copy
In-Reply-To: <20220207141348.4235-6-nj.shetty@samsung.com>
Message-ID: <alpine.LRH.2.02.2202160830150.22021@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com> <20220207141348.4235-1-nj.shetty@samsung.com> <CGME20220207141930epcas5p2bcbff65f78ad1dede64648d73ddb3770@epcas5p2.samsung.com> <20220207141348.4235-6-nj.shetty@samsung.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Mon, 7 Feb 2022, Nitesh Shetty wrote:

> +				goto retry;
> +			return PTR_ERR(bio);
> +		}
> +
> +		bio->bi_iter.bi_sector = sector >> SECTOR_SHIFT;
> +		bio->bi_opf = op;
> +		bio_set_dev(bio, bdev);
> @@ -346,6 +463,8 @@ int blkdev_issue_copy(struct block_device *src_bdev, int nr,
>  
>  	if (blk_check_copy_offload(src_q, dest_q))
>  		ret = blk_copy_offload(src_bdev, nr, rlist, dest_bdev, gfp_mask);
> +	else
> +		ret = blk_copy_emulate(src_bdev, nr, rlist, dest_bdev, gfp_mask);
>  
>  	return ret;
>  }

The emulation is not reliable because a device mapper device may be 
reconfigured and it may lose the copy capability between the calls to 
blk_check_copy_offload and blk_copy_offload.

You should call blk_copy_emulate if blk_copy_offload returns an error.

Mikulas

