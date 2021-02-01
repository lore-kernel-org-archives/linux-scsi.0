Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F06EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A10B64E25
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhBAIB5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 03:01:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231598AbhBAIBx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Feb 2021 03:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 967D064D73;
        Mon,  1 Feb 2021 08:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612166471;
        bh=dwZGpeS1TcK5yFFhy+waTC8VkChqi0kUMHO06WjX2kE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0dIcGQcYEF2T4qVgJpyt0Lni9yV1hdE2LBY2mV6NPuFFNewm9dvGtxz+Wprqs09bh
         9SLCyDY3NeRWsWusG5bBq6yW3UMXtdhuauTExJxtkuHD4NhEjZYZ6zj81d8LxXCjhv
         YHb/nJ0f1B1c+G5qiXAx4xQNYLIZpxjkFaOyoBP8=
Date:   Mon, 1 Feb 2021 09:01:07 +0100
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
Message-ID: <YBe1QxSyMBKSTJA9@kroah.com>
References: <20210127151217.24760-4-avri.altman@wdc.com>
 <20210127151217.24760-1-avri.altman@wdc.com>
 <CGME20210127151311epcas2p1696c2b73f3b4777ac0e7f603790b552f@epcms2p2>
 <1891546521.01612153501819.JavaMail.epsvc@epcpadp3>
 <DM6PR04MB657521540E2769C5F1BA2BBFFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBeuK92cgBkvYpk1@kroah.com>
 <DM6PR04MB6575018DEE12E7A5910FF2CBFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB6575018DEE12E7A5910FF2CBFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 01, 2021 at 07:51:19AM +0000, Avri Altman wrote:
> > 
> > On Mon, Feb 01, 2021 at 07:12:53AM +0000, Avri Altman wrote:
> > > > > +#define WORK_PENDING 0
> > > > > +#define ACTIVATION_THRSHLD 4 /* 4 IOs */
> > > > Rather than fixing it with macro, how about using sysfs and make it
> > > > configurable?
> > > Yes.
> > > I will add a patch making all the logic configurable.
> > > As all those are hpb-related parameters, I think module parameters are
> > more adequate.
> > 
> > No, this is not the 1990's, please never add new module parameters to
> > drivers.  If not for the basic problem of they do not work on a
> > per-device basis, but on a per-driver basis, which is what you almost
> > never want.
> OK.
> 
> > 
> > But why would you want to change this value, why can't the driver "just
> > work" and not need manual intervention?
> It is.
> But those are a knobs each vendor may want to tweak,
> So it'll be optimized with its internal device's implementation.
> 
> Tweaking the parameters, as well as the entire logic, is really an endless task.
> Some logic works better for some scenarios, while falling behind on others.

Shouldn't the hardware know how to handle this dynamically?  If not, how
is a user going to know?

> How about leaving it for now, to be elaborated it in the future?

I do not care, just do not make it a module parameter for the reason
that does not work on a per-device basis.

> Maybe even can be a part of a scheme, to make the logic proprietary?

What do you mean by "proprietary"?

thanks,

greg k-h
