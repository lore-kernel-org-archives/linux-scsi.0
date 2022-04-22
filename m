Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 452E0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 06:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444348AbiDVGaR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 02:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiDVGaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 02:30:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBA050B16;
        Thu, 21 Apr 2022 23:27:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B799B82A95;
        Fri, 22 Apr 2022 06:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B3FC385A4;
        Fri, 22 Apr 2022 06:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650608840;
        bh=XxjsLsvWcK6CqCtflZA+9R5xcA372mrc15pzj4NnL7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fVZOg7KAw+UIrDFFuuY8FcshhU7pbl+oWL95GOVSuMMo5pi7gmTNT2exO++pUnIGW
         rVqXOvSG8V5f3nyzEnVF3ZLZLr9Aa5jHRFygnGIqdofnddxNwxT/rYACTLhVC2k37r
         1mnLYgoOX4c6a0VW/35QtTLM5Z2Kkd8GhsURYmaHf6RWoeVn2nxUhDo2ra2nihIYHU
         JlxieI/z78rekZdhc8uIImeNM0/C70n6d4tuSv0fhdaq3FcIAhlQrI8SA4KjACQsDh
         lRCYUxgyr9218DVkAynVZ7W0SuNQyCV2GMabwAdARBs4zIiAlfp+BZEU42KQJakXhs
         eN+cvC8g7IaMQ==
Date:   Thu, 21 Apr 2022 23:27:18 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <YmJKxsqV5k+vKA+h@sol.localdomain>
References: <20220420064745.1119823-1-hch@lst.de>
 <20220420064745.1119823-3-hch@lst.de>
 <YmBiAQ/IZbFhRc6o@sol.localdomain>
 <20220421142535.GA21025@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220421142535.GA21025@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 21, 2022 at 04:25:35PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 20, 2022 at 12:41:53PM -0700, Eric Biggers wrote:
> > Can you elaborate on what you think the actual problem is here?  The lifetime of
> > the blk_crypto_profile matches that of the host controller kobject, and I
> > thought that it is not destroyed until after higher-level objects such as
> > gendisks and request_queues are destroyed.
> 
> I don't think all driver authors agree with that assumption (and it isn't
> documented anywhere). 
> 
> The most trivial case is device mapper, where the crypto profіle is freed
> before putting the gendisk reference acquired by blk_alloc_disk.  So
> anyone who opened the sysfs file at some point before the delete can
> still have it open and triviall access freed memory when then doing
> a read on it after the dm table is freed.
> 
> For UFS things seem to work out ok because the ufs_hba is part of
> the Scsi_Host, which is the parent device of the gendisk.

I tried to reproduce a use-after-free in the device-mapper case, and it doesn't
seem to be possible.  What actually happens is that before freeing the crypto
profile, cleanup_mapped_device() calls del_gendisk(), which deletes the disk
kobject and everything underneath it.  That not only deletes the corresponding
sysfs hierarchy, but also "deactivates" it such that even if a file descriptor
is open to one of the files, attempts to read from it fail with ENODEV.   (It
also waits for any ongoing reads to complete.)

The reference to the disk kobject is indeed released after the crypto profile is
freed, but that doesn't matter as far as sysfs is concerned.

It doesn't appear that concurrent I/O can be a problem either, as the
device-mapper subsystem doesn't allow devices to be deleted while they are open.

It's probably still worth flipping the order of
dm_queue_destroy_crypto_profile() and blk_cleanup_disk() anyway so that it's
less fragile and more similar to the real device drivers, though.

> > Similar assumptions are made by the
> > queue kobject, which assumes it is safe to access the gendisk, and by the
> > independent_access_ranges kobject which assumes it is safe to access the queue.
> 
> Yes, every queue/ object that references the gendisk has a problem I think.
> I've been wading through this code and trying to fix it, which made me
> notice this code.

Based on how sysfs works above, with the entire hierarchy being deactivated by
del_gendisk(), I'm not sure this is really a problem either.

> > In any case, this proposal is not correct since it is assuming that each
> > blk_crypto_profile is referenced by only one request_queue, which is not
> > necessarily the case since a host controller can have multiple disks.
> > The same kobject can't be added to multiple places in the hierarchy.
> 
> Indeed.
> 
> > If we did need to do something differently here, I think we'd either need to put
> > the blk_crypto_profile kobject under the host controller one and link to it from
> > the queue directories (which I mentioned in commit 20f01f163203 as an
> > alternative considered), or duplicate the crypto capabilities in each
> > request_queue and only share the actual keyslot management data structures.
> 
> Do we even need the link instead of letting the user walk down the
> directory hierachy?  But yes, having the sysfs attributes on the
> actual object is a much better idea.

The directories would be in different places for different kind of devices (dm,
ufs, mmc, etc.).  I think we really do need the crypto properties in the queue
directory, otherwise it would be a pain for userspace to actually use them.  (It
could also be the disk directory, but the queue directory is what I chose since
that's where most of the other generic block properties related to I/O are.)

If we did add the properties to the device directories (dm, ufs, mmc, etc.) too,
we'd also have to support them there forever in case someone started using them
(which would be uncommon since they would be a pain to use, but someone will do
it anyway), so we should be careful about that.  I think generic block layer
attributes are really the right way to go here.

- Eric
