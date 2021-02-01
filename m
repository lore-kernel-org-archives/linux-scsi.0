Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36C4C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D50B64E33
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhBAIpF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 03:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232452AbhBAIpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Feb 2021 03:45:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3825164E33;
        Mon,  1 Feb 2021 08:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612169062;
        bh=zVmeZjSKPYgQEaLUS6EY0CKKZiQUZErvhF5byvqvT9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kd2PZHj4xQK0mXTWKDAAp3yKTqd52zZj9zgMyJK6iTCz4JyXgPCST/gYsPYWfN4yl
         3AQMd0qvT+OGifw2/hyZUowy8hjyDCGQH0RBQYInyWnp9iCB7AjNI1nuBCHndjrVnq
         3n8svPXM6fDw0N2q0Rokam3YohMy5TjRUrULEfwI=
Date:   Mon, 1 Feb 2021 09:44:18 +0100
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
Message-ID: <YBe/YjlF4GewQFi6@kroah.com>
References: <20210127151217.24760-4-avri.altman@wdc.com>
 <20210127151217.24760-1-avri.altman@wdc.com>
 <CGME20210127151311epcas2p1696c2b73f3b4777ac0e7f603790b552f@epcms2p2>
 <1891546521.01612153501819.JavaMail.epsvc@epcpadp3>
 <DM6PR04MB657521540E2769C5F1BA2BBFFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBeuK92cgBkvYpk1@kroah.com>
 <DM6PR04MB6575018DEE12E7A5910FF2CBFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBe1QxSyMBKSTJA9@kroah.com>
 <DM6PR04MB65751A2F42801BAACF073F6FFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB65751A2F42801BAACF073F6FFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 01, 2021 at 08:17:59AM +0000, Avri Altman wrote:
> > 
> > On Mon, Feb 01, 2021 at 07:51:19AM +0000, Avri Altman wrote:
> > > >
> > > > On Mon, Feb 01, 2021 at 07:12:53AM +0000, Avri Altman wrote:
> > > > > > > +#define WORK_PENDING 0
> > > > > > > +#define ACTIVATION_THRSHLD 4 /* 4 IOs */
> > > > > > Rather than fixing it with macro, how about using sysfs and make it
> > > > > > configurable?
> > > > > Yes.
> > > > > I will add a patch making all the logic configurable.
> > > > > As all those are hpb-related parameters, I think module parameters are
> > > > more adequate.
> > > >
> > > > No, this is not the 1990's, please never add new module parameters to
> > > > drivers.  If not for the basic problem of they do not work on a
> > > > per-device basis, but on a per-driver basis, which is what you almost
> > > > never want.
> > > OK.
> > >
> > > >
> > > > But why would you want to change this value, why can't the driver "just
> > > > work" and not need manual intervention?
> > > It is.
> > > But those are a knobs each vendor may want to tweak,
> > > So it'll be optimized with its internal device's implementation.
> > >
> > > Tweaking the parameters, as well as the entire logic, is really an endless
> > task.
> > > Some logic works better for some scenarios, while falling behind on others.
> > 
> > Shouldn't the hardware know how to handle this dynamically?  If not, how
> > is a user going to know?
> There is one "brain".
> It is either in the device - in device mode, Or in the host - in host mode control.
> The "brain" decides which region is active, thus carrying the physical address along with the logical -
> minimizing context switches in the device's RAM.
> 
> There can be up to N active regions.
> Activation and deactivation has its overhead.
> So basically it is a constraint-optimization problem.

So how do you solve it?  And how would you expect a user to solve it if
the kernel can not?

You better document the heck out of these configuration options :)

thanks,

greg k-h
