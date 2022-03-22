Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150A5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 11:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiCVLW2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiCVLW1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 07:22:27 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8847EA36;
        Tue, 22 Mar 2022 04:21:00 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8834368AFE; Tue, 22 Mar 2022 12:20:57 +0100 (CET)
Date:   Tue, 22 Mar 2022 12:20:57 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hch@lst.de, ming.lei@redhat.com, hare@suse.de,
        chenxiang66@hisilicon.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com, beanhuo@micron.com
Subject: Re: [PATCH 03/11] libata: Send internal commands through the block
 layer
Message-ID: <20220322112057.GC29270@lst.de>
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com> <1647945585-197349-4-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1647945585-197349-4-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 22, 2022 at 06:39:37PM +0800, John Garry wrote:
> When SCSI HBA device drivers are required to process an ATA internal
> command they still need a tag for the IO. This often requires the driver
> to set aside a set of tags for these sorts of IOs and manage the tags
> themselves.
> 
> If we associate a SCSI command (and request) with an ATA internal command
> then the tag is already provided, so introduce the change to send ATA
> internal commands through the block layer with a set of custom blk-mq ops.
> 
> note: I think that the timeout handling needs to be fixed up.

Any reason to not just send them through an ATA_16 passthrough CDB and
just use all the normal SCSI command handling?
