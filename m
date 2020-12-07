Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB400C4167B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 14:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE3BA236FB
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 14:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgLGOMI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:12:08 -0500
Received: from verein.lst.de ([213.95.11.211]:42032 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbgLGOMH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 09:12:07 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7321567373; Mon,  7 Dec 2020 15:11:23 +0100 (CET)
Date:   Mon, 7 Dec 2020 15:11:23 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     SelvaKumar S <selvakuma.s1@samsung.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org, axboe@kernel.dk,
        damien.lemoal@wdc.com, hch@lst.de, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
Message-ID: <20201207141123.GC31159@lst.de>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com> <20201204094659.12732-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204094659.12732-1-selvakuma.s1@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So, I'm really worried about:

 a) a good use case.  GC in f2fs or btrfs seem like good use cases, as
    does accelating dm-kcopyd.  I agree with Damien that lifting dm-kcopyd
    to common code would also be really nice.  I'm not 100% sure it should
    be a requirement, but it sure would be nice to have
    I don't think just adding an ioctl is enough of a use case for complex
    kernel infrastructure.
 b) We had a bunch of different attempts at SCSI XCOPY support form IIRC
    Martin, Bart and Mikulas.  I think we need to pull them into this
    discussion, and make sure whatever we do covers the SCSI needs.

On Fri, Dec 04, 2020 at 03:16:57PM +0530, SelvaKumar S wrote:
> This patchset tries to add support for TP4065a ("Simple Copy Command"),
> v2020.05.04 ("Ratified")
> 
> The Specification can be found in following link.
> https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
> 
> This is an RFC. Looking forward for any feedbacks or other alternate
> designs for plumbing simple copy to IO stack.
> 
> Simple copy command is a copy offloading operation and is  used to copy
> multiple contiguous ranges (source_ranges) of LBA's to a single destination
> LBA within the device reducing traffic between host and device.
> 
> This implementation accepts destination, no of sources and arrays of
> source ranges from application and attach it as payload to the bio and
> submits to the device.
> 
> Following limits are added to queue limits and are exposed in sysfs
> to userspace
> 	- *max_copy_sectors* limits the sum of all source_range length
> 	- *max_copy_nr_ranges* limits the number of source ranges
> 	- *max_copy_range_sectors* limit the maximum number of sectors
> 		that can constitute a single source range.
> 
> Changes from v1:
> 
> 1. Fix memory leak in __blkdev_issue_copy
> 2. Unmark blk_check_copy inline
> 3. Fix line break in blk_check_copy_eod
> 4. Remove p checks and made code more readable
> 5. Don't use bio_set_op_attrs and remove op and set
>    bi_opf directly
> 6. Use struct_size to calculate total_size
> 7. Fix partition remap of copy destination
> 8. Remove mcl,mssrl,msrc from nvme_ns
> 9. Initialize copy queue limits to 0 in nvme_config_copy
> 10. Remove return in QUEUE_FLAG_COPY check
> 11. Remove unused OCFS
> 
> SelvaKumar S (2):
>   block: add simple copy support
>   nvme: add simple copy support
> 
>  block/blk-core.c          |  94 ++++++++++++++++++++++++++---
>  block/blk-lib.c           | 123 ++++++++++++++++++++++++++++++++++++++
>  block/blk-merge.c         |   2 +
>  block/blk-settings.c      |  11 ++++
>  block/blk-sysfs.c         |  23 +++++++
>  block/blk-zoned.c         |   1 +
>  block/bounce.c            |   1 +
>  block/ioctl.c             |  43 +++++++++++++
>  drivers/nvme/host/core.c  |  87 +++++++++++++++++++++++++++
>  include/linux/bio.h       |   1 +
>  include/linux/blk_types.h |  15 +++++
>  include/linux/blkdev.h    |  15 +++++
>  include/linux/nvme.h      |  43 ++++++++++++-
>  include/uapi/linux/fs.h   |  13 ++++
>  14 files changed, 461 insertions(+), 11 deletions(-)
> 
> -- 
> 2.25.1
---end quoted text---
