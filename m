Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6323C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 14:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389197AbiDUO2c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 10:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388932AbiDUO2a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 10:28:30 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AE911A3D;
        Thu, 21 Apr 2022 07:25:41 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9CB7B68B05; Thu, 21 Apr 2022 16:25:35 +0200 (CEST)
Date:   Thu, 21 Apr 2022 16:25:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] blk-crypto: fix the blk_crypto_profile liftime
Message-ID: <20220421142535.GA21025@lst.de>
References: <20220420064745.1119823-1-hch@lst.de> <20220420064745.1119823-3-hch@lst.de> <YmBiAQ/IZbFhRc6o@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YmBiAQ/IZbFhRc6o@sol.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 20, 2022 at 12:41:53PM -0700, Eric Biggers wrote:
> Can you elaborate on what you think the actual problem is here?  The lifetime of
> the blk_crypto_profile matches that of the host controller kobject, and I
> thought that it is not destroyed until after higher-level objects such as
> gendisks and request_queues are destroyed.

I don't think all driver authors agree with that assumption (and it isn't
documented anywhere). 

The most trivial case is device mapper, where the crypto profіle is freed
before putting the gendisk reference acquired by blk_alloc_disk.  So
anyone who opened the sysfs file at some point before the delete can
still have it open and triviall access freed memory when then doing
a read on it after the dm table is freed.

For UFS things seem to work out ok because the ufs_hba is part of
the Scsi_Host, which is the parent device of the gendisk.

> Similar assumptions are made by the
> queue kobject, which assumes it is safe to access the gendisk, and by the
> independent_access_ranges kobject which assumes it is safe to access the queue.

Yes, every queue/ object that references the gendisk has a problem I think.
I've been wading through this code and trying to fix it, which made me
notice this code.

> In any case, this proposal is not correct since it is assuming that each
> blk_crypto_profile is referenced by only one request_queue, which is not
> necessarily the case since a host controller can have multiple disks.
> The same kobject can't be added to multiple places in the hierarchy.

Indeed.

> If we did need to do something differently here, I think we'd either need to put
> the blk_crypto_profile kobject under the host controller one and link to it from
> the queue directories (which I mentioned in commit 20f01f163203 as an
> alternative considered), or duplicate the crypto capabilities in each
> request_queue and only share the actual keyslot management data structures.

Do we even need the link instead of letting the user walk down the
directory hierachy?  But yes, having the sysfs attributes on the
actual object is a much better idea.

> 
> - Eric
---end quoted text---
