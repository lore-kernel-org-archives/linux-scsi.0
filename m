Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A57CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3495664F4F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhBBLP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhBBLPx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 06:15:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E1D64E31;
        Tue,  2 Feb 2021 11:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612264513;
        bh=MLft9NsOvfSw2VK1prO/UadDIItNa/VFxOziTKxpZSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xjP6nT6FhYmSZ9frriQK7D+Ak3Vn+a3VN52wIiy1sPIlFdoj56HJxpXEhJ95kF1tS
         YZEY5UkcaDZJsewNbCbuHYMuxyHVyrkuUhfZlVHQRpM6NxGuejQqEDtTsWp4ubL7Tw
         yXe7SgH00RviHheYbeVoynB4XITnyAgJQzJRE2qk=
Date:   Tue, 2 Feb 2021 12:15:08 +0100
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
Subject: Re: [PATCH v2 3/9] scsi: ufshpb: Add region's reads counter
Message-ID: <YBk0PHFW+8klHN8Y@kroah.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-4-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202083007.104050-4-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 02, 2021 at 10:30:01AM +0200, Avri Altman wrote:
> @@ -175,6 +179,8 @@ struct ufshpb_lu {
>  
>  	/* for selecting victim */
>  	struct victim_select_info lru_info;
> +	struct work_struct ufshpb_normalization_work;
> +	unsigned long work_data_bits;

You only have 1 "bit" being used here, so perhaps just a u8?  Please
don't use things like "unsigned long" for types, this isn't Windows :)

thanks,

greg k-h
