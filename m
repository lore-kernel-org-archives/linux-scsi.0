Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4604C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 14:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389519AbiDUOnP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 10:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387779AbiDUOnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 10:43:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFD04092D;
        Thu, 21 Apr 2022 07:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4832261999;
        Thu, 21 Apr 2022 14:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B346C385A8;
        Thu, 21 Apr 2022 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650552018;
        bh=9IAAcCvrEPSn21yDMdjSL6TR0C08QQgDmLi7rCEVcHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=intENJ7Te1q4aCle98ktM5R7wVs5/EgQTX6tTA4bCrz0/WeSiM9HBFTXwuKZi4tWe
         YZ4DVPudbmsbtAAVBGQ6lRgCg7tj7ufgQEDt0lgbQNjoIw03Gx18ZNJH3oGBDb39th
         /lBrE6IePJV6gltTlvH8Z20D2Ytibm0IPAE9xQgY=
Date:   Thu, 21 Apr 2022 16:40:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
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
Message-ID: <YmFsz3lZt7jPUCGV@kroah.com>
References: <20220420064745.1119823-1-hch@lst.de>
 <20220420064745.1119823-3-hch@lst.de>
 <YmBiAQ/IZbFhRc6o@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmBiAQ/IZbFhRc6o@sol.localdomain>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 20, 2022 at 12:41:53PM -0700, Eric Biggers wrote:
> On Wed, Apr 20, 2022 at 08:47:45AM +0200, Christoph Hellwig wrote:
> > Once the blk_crypto_profile is exposed in sysfs it needs to stay alive
> > as long as sysfs accesses are possibly pending.  Ensure that by removing
> > the blk_crypto_kobj wrapper and just embedding the kobject into the
> > actual blk_crypto_profile.  This requires the blk_crypto_profile
> > structure to be dynamically allocated, which in turn requires a private
> > data pointer for driver use.
> > 
> > Fixes: 20f01f163203 ("blk-crypto: show crypto capabilities in sysfs")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Can you elaborate on what you think the actual problem is here?  The lifetime of
> the blk_crypto_profile matches that of the host controller kobject, and I
> thought that it is not destroyed until after higher-level objects such as
> gendisks and request_queues are destroyed.  Similar assumptions are made by the
> queue kobject, which assumes it is safe to access the gendisk, and by the
> independent_access_ranges kobject which assumes it is safe to access the queue.
> 
> I suppose this wouldn't have worked with the original sysfs design where opening
> a file in sysfs actually got a refcount to the kobject.  But that's long gone,
> having been changed in Linux v2.6.23 (https://lwn.net/Articles/229774).
> 
> Note that commit 20f01f163203 which added this code got an "all looks good" from
> Greg KH (https://lore.kernel.org/r/YaH1CmHClx5WvDWD@kroah.com).  I'd have hoped
> that he would've noticed if there was a major problem with how kobjects are used
> here!  Greg, would you mind taking a look at this part again?

I do not know the model for the block devices and queues and all of that
well at all.  My first glance this seemed sane, but if the lifetime
rules are not normal in any way, I do not know.  I defer to Christoph
for all of this, he knows it way better than I do.

thanks,

greg k-h
