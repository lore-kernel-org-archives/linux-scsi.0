Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815F8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 11 May 2022 06:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239003AbiEKGCe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 May 2022 02:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbiEKGCZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2022 02:02:25 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A6F35DE0;
        Tue, 10 May 2022 23:02:22 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 08AF268BFE; Wed, 11 May 2022 08:02:14 +0200 (CEST)
Date:   Wed, 11 May 2022 08:02:12 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
Subject: Re: [PATCH] swiotlb: Max mapping size takes min align mask into
 account
Message-ID: <20220511060212.GA32192@lst.de>
References: <20220510142109.777738-1-ltykernel@gmail.com> <cd64adcd-26fc-0452-754d-7ab0f5536142@arm.com> <PH0PR21MB302530B081D6CE6470D5F9A4D7C99@PH0PR21MB3025.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR21MB302530B081D6CE6470D5F9A4D7C99@PH0PR21MB3025.namprd21.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 10, 2022 at 06:26:55PM +0000, Michael Kelley (LINUX) wrote:
> > Hmm, this seems a bit pessimistic - the offset can vary per mapping, so
> > it feels to me like it should really be the caller's responsibility to
> > account for it if they're already involved enough to care about both
> > constraints. But I'm not sure how practical that would be.
> 
> Tianyu and I discussed this prior to his submitting the patch.
> Presumably dma_max_mapping_size() exists so that the higher
> level blk-mq code can limit the size of I/O requests to something
> that will "fit" in the swiotlb when bounce buffering is enabled.

Yes, the idea that upper level code doesn't need to care was very
much the idea behind dma_max_mapping_size().

> As you mentioned, how else would a caller handle this situation?

Well, we could look at dma_get_min_align_mask in the caller and do
the calculation there, but I really don't think that is a good idea.

So this patch looks sensible to me.
