Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704F1C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3737464E0A
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 07:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhBAHbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 02:31:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230264AbhBAHbf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Feb 2021 02:31:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8995264DD8;
        Mon,  1 Feb 2021 07:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612164655;
        bh=N57ktDJC3aGWz+f41E6ISG/c9UMTTQ0q+tcDH7dDLAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M5GVHysd7D7mUYdyRUpUhpyt1Gq4BrIofppQRKTJkFKbysDNuq03c+6CP6C2RU2KY
         yJ2k2Zd171U0rWzsH3e6dYNjVVS3qxkvOpUpU0kcN7hynwiVek5nfRSYgo4g6wScvv
         SjTwg7T4Mo/pk5guWTTepGtVuqDbLg1QP8W1uA0M=
Date:   Mon, 1 Feb 2021 08:30:51 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: Re: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Message-ID: <YBeuK92cgBkvYpk1@kroah.com>
References: <20210127151217.24760-4-avri.altman@wdc.com>
 <20210127151217.24760-1-avri.altman@wdc.com>
 <CGME20210127151311epcas2p1696c2b73f3b4777ac0e7f603790b552f@epcms2p2>
 <1891546521.01612153501819.JavaMail.epsvc@epcpadp3>
 <DM6PR04MB657521540E2769C5F1BA2BBFFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB657521540E2769C5F1BA2BBFFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 01, 2021 at 07:12:53AM +0000, Avri Altman wrote:
> > > +#define WORK_PENDING 0
> > > +#define ACTIVATION_THRSHLD 4 /* 4 IOs */
> > Rather than fixing it with macro, how about using sysfs and make it
> > configurable?
> Yes.
> I will add a patch making all the logic configurable.
> As all those are hpb-related parameters, I think module parameters are more adequate.

No, this is not the 1990's, please never add new module parameters to
drivers.  If not for the basic problem of they do not work on a
per-device basis, but on a per-driver basis, which is what you almost
never want.

But why would you want to change this value, why can't the driver "just
work" and not need manual intervention?

thanks,

greg k-h
