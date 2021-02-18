Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86331C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 17:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E87164EB6
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 17:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhBRQ7C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhBRNta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Feb 2021 08:49:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5710864E76;
        Thu, 18 Feb 2021 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613656117;
        bh=m9n2RWGKyH7DlKz/4HUd/rwoeOVJIoj7rqtYKwqAeBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nozJmFDBjdsISqTrAWTu99Lt0fXxbMA7mcqQJ/KOBAdcQyC9RVA4EPErgBTIDRdS6
         82yx5KZXgHueCekkKb3bSNzj2KaxyMVK9fp0ZvIUIbL9RvSTngi9W7/cLjcNiHwT3C
         52PLUaLmWzmqvZ082S5OCcH82TwUTY+dVEGwi0L0=
Date:   Thu, 18 Feb 2021 14:48:34 +0100
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
Subject: Re: [PATCH v3 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Message-ID: <YC5wMu6Axu8G+Nsg@kroah.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
 <20210218131932.106997-10-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210218131932.106997-10-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 18, 2021 at 03:19:32PM +0200, Avri Altman wrote:
> We can make use of this commit, to elaborate some more of the host
> control mode logic, explaining what role play each and every variable.
> 
> While at it, allow those parameters to be configurable.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs |  68 ++++++
>  drivers/scsi/ufs/ufshpb.c                  | 254 +++++++++++++++++++--
>  drivers/scsi/ufs/ufshpb.h                  |  18 ++
>  3 files changed, 326 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index 0017eaf89cbe..1d72201c4953 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -1322,3 +1322,71 @@ Description:	This entry shows the maximum HPB data size for using single HPB
>  		===  ========
>  
>  		The file is read only.
> +
> +What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/activation_thld
> +Date:		February 2021
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:	In host control mode, reads are the major source of activation
> +		trials.  once this threshold hs met, the region is added to the
> +		"to-be-activated" list.  Since we reset the read counter upon
> +		write, this include sending a rb command updating the region
> +		ppn as well.
> +
> +What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/normalization_factor
> +Date:		February 2021
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:	In host control mode, We think of the regions as "buckets".
> +		Those buckets are being filled with reads, and emptied on write.
> +		We use entries_per_srgn - the amount of blocks in a subregion as
> +		our bucket size.  This applies because HPB1.0 only concern a
> +		single-block reads.  Once the bucket size is crossed, we trigger
> +		a normalization work - not only to avoid overflow, but mainly
> +		because we want to keep those counters normalized, as we are
> +		using those reads as a comparative score, to make various decisions.
> +		The normalization is dividing (shift right) the read counter by
> +		the normalization_factor. If during consecutive normalizations
> +		an active region has exhaust its reads - inactivate it.
> +
> +What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/eviction_thld_enter
> +Date:		February 2021
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:	Region deactivation is often due to the fact that eviction took
> +		place: a region become active on the expense of another. This is
> +		happening when the max-active-regions limit has crossed.
> +		In host mode, eviction is considered an extreme measure. We
> +		want to verify that the entering region has enough reads, and
> +		the exiting region has much less reads.  eviction_thld_enter is
> +		the min reads that a region must have in order to be considered
> +		as a candidate to evict other region.
> +
> +What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/eviction_thld_exit
> +Date:		February 2021
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:	same as above for the exiting region. A region is consider to
> +		be a candidate to be evicted, only if it has less reads than
> +		eviction_thld_exit.
> +
> +What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/read_timeout_ms
> +Date:		February 2021
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:	In order not to hang on to “cold” regions, we shall inactivate
> +		a region that has no READ access for a predefined amount of
> +		time - read_timeout_ms. If read_timeout_ms has expired, and the
> +		region is dirty - it is less likely that we can make any use of
> +		HPB-READing it.  So we inactivate it.  Still, deactivation has
> +		its overhead, and we may still benefit from HPB-READing this
> +		region if it is clean - see read_timeout_expiries.
> +
> +What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/read_timeout_expiries
> +Date:		February 2021
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:	if the region read timeout has expired, but the region is clean,
> +		just re-wind its timer for another spin.  Do that as long as it
> +		is clean and did not exhaust its read_timeout_expiries threshold.
> +
> +What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/timeout_polling_interval_ms
> +Date:		February 2021
> +Contact:	Avri Altman <avri.altman@wdc.com>
> +Description:	the frequency in which the delayed worker that checks the
> +		read_timeouts is awaken.
> +>>>>>>> ef6bf08e666d... scsi: ufshpb: Make host mode parameters configurable

Did you mean for this last line to be here?


