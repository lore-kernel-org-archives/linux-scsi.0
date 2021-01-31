Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72177C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A1D864E27
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhAaHO3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 02:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhAaHN4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 31 Jan 2021 02:13:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF29D64DD6;
        Sun, 31 Jan 2021 07:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612077184;
        bh=FglZW/uYov0LpG0zR76gqAa9DRbX9rNVlulWVTKIC7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WF0vRmaCjBNOdB2iPWQIOOJuJPfNUFboj5VI3QPNa3MXHVXAJkLjY3qGf4eS9Vcmv
         rvReKrCPnYTuFL1JAe4Uit2zFX7yiMVAqgVnK8wIdsNFwLdIMGtE0EVx4o0qOinpEZ
         nVDSYs3IHSBtNZz1Ritu11qNt0aEFJYfxjj83lf8=
Date:   Sun, 31 Jan 2021 08:13:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: Re: [PATCH 1/8] scsi: ufshpb: Cache HPB Control mode on init
Message-ID: <YBZYfM/NjTo1lbGi@kroah.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-2-avri.altman@wdc.com>
 <YBGEh4cfPldXoQxI@kroah.com>
 <DM6PR04MB65756785F53B6D9FDE581013FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB65756785F53B6D9FDE581013FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 31, 2021 at 07:08:00AM +0000, Avri Altman wrote:
> > >
> > > +static enum UFSHPB_MODE ufshpb_mode;
> > 
> > How are you allowed to have a single variable for a device-specific
> > thing?  What happens when you have two controllers or disks or whatever
> > you are binding to here?  How does this work at all?
> > 
> > This should be per-device, right?
> Right. Done.
> 
> Not being bickering,  AFAIK, there aren't, nor will be in the foreseen future, any multi-ufs-hosts designs.

Why not?  What prevents someone from putting 2 PCI ufs host controllers
in a system tomorrow?

> There were some talks in the past about ufs cards, but this is officially off the table.

Never say never :)

Seriously, how can you somehow ensure that a random manufacturer will
not do this?

thanks,

greg k-h
