Return-Path: <SRS0=Owrj=3T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B3FC33C9E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 07:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6525220702
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 07:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgA3H4D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jan 2020 02:56:03 -0500
Received: from verein.lst.de ([213.95.11.211]:39318 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbgA3H4D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jan 2020 02:56:03 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2BD0768B05; Thu, 30 Jan 2020 08:56:01 +0100 (CET)
Date:   Thu, 30 Jan 2020 08:56:00 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra Basappa <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        abdhalee@linux.vnet.ibm.com
Subject: Re: [PATCH] mpt3sas: don't change the dma coherent mask after
 allocations
Message-ID: <20200130075600.GB30735@lst.de>
References: <20200117134506.633586-1-hch@lst.de> <CAK=zhgpVDti+qRwnj=Jg+RtmO_b3Bu00q_TvrNWGCjTU=4humg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=zhgpVDti+qRwnj=Jg+RtmO_b3Bu00q_TvrNWGCjTU=4humg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 24, 2020 at 04:16:47PM +0530, Sreekanth Reddy wrote:
> Our HBA hardware has a requirement that each set of RDPQ reply
> descriptor pools should be within the 4gb region. so to accommodate
> this requirement driver is first setting the DMA coherent mask to 32
> bit then allocating the RDPQ pools

So far the requirement makes sense.

> and then resetting the DMA coherent
> make to 64 and allocating the remaining pools.

And this is where the trouble start.  You simply can't reset the mask
with outstanding allocations.  This breaks various implementations that
change the allocator based on the mask.

> if we completely set the DMA coherent mask to 32 bit then there are
> chances that sometimes driver may not get requested memory within the
> first 4gb region and HBA initialization may fail. So instead of
> setting the DMA coherent mask to 32 bit, we follow the same below
> logic which megaraid_sas driver is doing now. i.e we first allocate
> set of rdpq pools at once and check this allocated block is within the
> 4gb region, if not then free this block and allocate a new block from
> aligned pci pool.

Which is completely broken.
