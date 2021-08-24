Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B22C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 06:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6599D6124B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 06:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhHXGOF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 02:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhHXGOE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 02:14:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C31C061575;
        Mon, 23 Aug 2021 23:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f7fH1rEvs0xJyERlr1GeZJ7G2DDZAEuI5WBFO6aM0DE=; b=IawXlIwSwAzz4WaAqpSzlEYxuz
        YiMQyUZgyoz6kZjcZVo1wk9wnfy8loh2so2h4F0X6QTyc0UumyE1gSMOAESY0Wgk9RKtw9E2EUrOJ
        IpzX0i8DVqmIyy4L3J+wUOM6gSArc/8+o1oQro7eRQSN0Mea6zOI+O+3Y5oUgqy6Iwnuk8hVd4OiB
        WcUde1NJHpd7HYCa5qUS537YP7wYEVRMGEQhPKT29n5iWmWtEy8vhDoA7iHO5dsxhIPSkBBVbRHc4
        vNKG1wE5yZW+Pua4UHYAjlWohpQHBS4ePYZdMerkcT+36IeBcq4CnFhzMNGhxfue7Y0Y8jf9L6fHL
        7+6xITiQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIPcv-00AdX1-Qy; Tue, 24 Aug 2021 06:09:50 +0000
Date:   Tue, 24 Aug 2021 07:09:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com, hch@infradead.org, hare@suse.de,
        bvanassche@acm.org, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mmc@vger.kernel.org, dm-devel@redhat.com,
        nbd@other.debian.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] nvme: add error handling support for add_disk()
Message-ID: <YSSNIaYpUhrkvC+J@infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-6-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823202930.137278-6-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 23, 2021 at 01:29:25PM -0700, Luis Chamberlain wrote:
> +	rc = device_add_disk(ctrl->device, ns->disk, nvme_ns_id_attr_groups);
> +	if (rc)
> +		goto out_cleanup_ns_from_list;
> +

Nit: no real need for the rc variable here as we never use the actual
value.

>  	if (!nvme_ns_head_multipath(ns->head))
>  		nvme_add_ns_cdev(ns);
>  
> @@ -3785,6 +3789,10 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
>  
>  	return;
>  
> + out_cleanup_ns_from_list:
> +	down_write(&ctrl->namespaces_rwsem);
> +	list_del_init(&ns->list);
> +	up_write(&ctrl->namespaces_rwsem);

This also needs to do a nvme_put_ctrl.
