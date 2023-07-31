Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D566C04A94
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 07:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjGaH3Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 03:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjGaH2Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 03:28:16 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D57C3C0E;
        Mon, 31 Jul 2023 00:24:57 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 02FA567373; Mon, 31 Jul 2023 09:14:10 +0200 (CEST)
Date:   Mon, 31 Jul 2023 09:14:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH V2 0/9] blk-mq: fix wrong queue mapping for kdump kernel
Message-ID: <20230731071409.GA31608@lst.de>
References: <20230726094027.535126-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726094027.535126-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 26, 2023 at 05:40:18PM +0800, Ming Lei wrote:
> Hi,
> 
> On arm and ppc64, 'maxcpus=1' is required for kdump kernel,
> see `Documentation/admin-guide/kdump/kdump.rst`, so num_possible_cpus()
> still returns all CPUs because 'maxcpus=1' just bring up one single
> cpu core during booting.

Just as said last time:  Please drop the odd is_kdump_kernel checks
in blk_mq_update_queue_map and blk_mq_alloc_tag_set instead of sprinkling
this crap even further. 

