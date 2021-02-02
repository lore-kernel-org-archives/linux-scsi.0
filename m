Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C35C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 179FF64E4C
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhBBLRy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:17:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhBBLRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 06:17:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C267064E4C;
        Tue,  2 Feb 2021 11:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612264632;
        bh=Gt/tRLSzeC4EBMRqE7w8RU/ECKnbCos15/tnw0of2J8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KEARUBv73fJRZJqbAvj8GNznrlObLkHQMhAKUmNZqUc/suX+Qa4DqCI/U2InILw4S
         G+wZYDWTx3zEUBvo4RtNKFNMO1R8s2sdqKNOFjzTMgpK5BE3pWbsa8+qLspbQm8HgR
         vznCfGAistzf+Bn2HMfdX2cOKqSI7uOd85qJDvUs=
Date:   Tue, 2 Feb 2021 12:17:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com
Subject: Re: [PATCH v2 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Message-ID: <YBk0s1Y4DOXuup+q@kroah.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-10-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210202083007.104050-10-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 02, 2021 at 10:30:07AM +0200, Avri Altman wrote:
> We can make use of this commit, to elaborate some more of the host
> control mode logic, explaining what role play each and every variable:
> 
>  - activation_thld - In host control mode, reads are the major source of
>     activation trials.  once this threshold hs met, the region is added
>     to the "to-be-activated" list.  Since we reset the read counter upon
>     write, this include sending a rb command updating the region ppn as
>     well.
> 
> - normalization_factor - We think of the regions as "buckets".  Those
>     buckets are being filled with reads, and emptied on write.  We use
>     entries_per_srgn - the amount of blocks in a subregion as our bucket
>     size.  This applies because HPB1.0 only concern a single-block
>     reads.  Once the bucket size is crossed, we trigger a normalization
>     work - not only to avoid overflow, but mainly because we want to
>     keep those counters normalized, as we are using those reads as a
>     comparative score, to make various decisions. The normalization is
>     dividing (shift right) the read counter by the normalization_factor.
>     If during consecutive normalizations an active region has exhaust
>     its reads - inactivate it.
> 
> - eviction_thld_enter - Region deactivation is often due to the fact
>     that eviction took place: a region become active on the expense of
>     another. This is happening when the max-active-regions limit has
>     crossed. In host mode, eviction is considered an extreme measure.
>     We want to verify that the entering region has enough reads, and the
>     exiting region has much less reads.  eviction_thld_enter is the min
>     reads that a region must have in order to be considered as a
>     candidate to evict other region.
> 
> - eviction_thld_exit - same as above for the exiting region.  A region
>     is consider to be a candidate to be evicted, only if it has less
>     reads than eviction_thld_exit.
> 
>  - read_timeout_ms - In order not to hang on to “cold” regions, we
>     shall inactivate a region that has no READ access for a predefined
>     amount of time - read_timeout_ms. If read_timeout_ms has expired,
>     and the region is dirty - it is less likely that we can make any
>     use of HPB-READing it.  So we inactivate it.  Still, deactivation
>     has its overhead, and we may still benefit from HPB-READing this
>     region if it is clean - see read_timeout_expiries.
> 
> - read_timeout_expiries - if the region read timeout has expired, but
>     the region is clean, just re-wind its timer for another spin.  Do
>     that as long as it is clean and did not exhaust its
>     read_timeout_expiries threshold.
> 
> - timeout_polling_interval_ms - the frequency in which the delayed
>     worker that checks the read_timeouts is awaken.

You create new sysfs files, but fail to document them in
Documentation/ABI/ which is where the above information needs to go :(

thanks,

greg k-h
