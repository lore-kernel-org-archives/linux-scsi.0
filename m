Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DD1C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A51CA60FDA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhH0Sei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 14:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhH0Sei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 14:34:38 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C1EC0613CF;
        Fri, 27 Aug 2021 11:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UgAMblA+47VmVeEhj3CWGn9zmJ4QFpkMvnKXqn8H+RQ=; b=lZCVwiClkSzKtXkgZImhvNhGJ/
        GY2KHc56J5JWK2SplL/wzWO/YqzXslQnjRszwBIRxwV8oReBdHkjsdHByX7UGFKSLdUktre+WA5ZD
        CKMSGHrVpYJCjxJjzthi+xCo3zJ4ePk5/My5eR/DBWeU5ojJb0O5x8m20Q1rhL45gSKvxkKQLeoI/
        Ta9TTswqjOXMCJqU/xXY5xexoApBj4QPFrnWbDJY2Bb7imBy0AvR905nsaF4ymaiw+VpZIHCftbkW
        J3wJQKawiw5Mn8Cq0D5cKAW1kX6lFHPKHJEAlWRGHsYFhxiWwq7Xzo1BkF3thw16nkTYmHD1Tszhr
        JRIwTYlA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJgeq-00Cxw6-V7; Fri, 27 Aug 2021 18:32:52 +0000
Date:   Fri, 27 Aug 2021 11:32:52 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] nvme: add error handling support for add_disk()
Message-ID: <YSkv1GtmFgvQ81Up@bombadil.infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-6-mcgrof@kernel.org>
 <YSSNIaYpUhrkvC+J@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSSNIaYpUhrkvC+J@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2021 at 07:09:37AM +0100, Christoph Hellwig wrote:
> On Mon, Aug 23, 2021 at 01:29:25PM -0700, Luis Chamberlain wrote:
> > +	rc = device_add_disk(ctrl->device, ns->disk, nvme_ns_id_attr_groups);
> > +	if (rc)
> > +		goto out_cleanup_ns_from_list;
> > +
> 
> Nit: no real need for the rc variable here as we never use the actual
> value.

Alrighty.

> >  	if (!nvme_ns_head_multipath(ns->head))
> >  		nvme_add_ns_cdev(ns);
> >  
> > @@ -3785,6 +3789,10 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
> >  
> >  	return;
> >  
> > + out_cleanup_ns_from_list:
> > +	down_write(&ctrl->namespaces_rwsem);
> > +	list_del_init(&ns->list);
> > +	up_write(&ctrl->namespaces_rwsem);
> 
> This also needs to do a nvme_put_ctrl.

Fixed.

  Luis
