Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068A8C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC43664E09
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhAaHga (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 02:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhAaHgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 31 Jan 2021 02:36:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7C664E24;
        Sun, 31 Jan 2021 07:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612078528;
        bh=hfWoFSzQSusZX74pIPkuz0bi7jBqX9foozhC+sJESbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MWbOIR/KKjXuDPQ0SFqFzHGsrvekMNeiDHAJLQr/ZVNj8HWfcuSKJ1IiZD8TER9JB
         yWTtLBR4OSnkCwyhCYFHnL2SG4fK/nPW51HV1+UKTnVn2WbDTYMj0i1cFipK1yv8be
         j8bJ5TCF8w2ZoBszwXv6QZu+qNO0LA7ql4qJijYA=
Date:   Sun, 31 Jan 2021 08:35:24 +0100
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
Subject: Re: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Message-ID: <YBZdvE8JrNOj3QSa@kroah.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-4-avri.altman@wdc.com>
 <YBGFC+XcibjRg7Y/@kroah.com>
 <BL0PR04MB6564C0EB1584AE599A13E120FCB79@BL0PR04MB6564.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR04MB6564C0EB1584AE599A13E120FCB79@BL0PR04MB6564.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 31, 2021 at 07:25:37AM +0000, Avri Altman wrote:
> > >
> > > +     if (ufshpb_mode == HPB_HOST_CONTROL)
> > > +             reads = atomic64_inc_return(&rgn->reads);
> > > +
> > >       if (!ufshpb_is_support_chunk(transfer_len))
> > >               return;
> > >
> > > +     if (ufshpb_mode == HPB_HOST_CONTROL) {
> > > +             /*
> > > +              * in host control mode, reads are the main source for
> > > +              * activation trials.
> > > +              */
> > > +             if (reads == ACTIVATION_THRSHLD) {
> Oops - this is a bug...
> 
> > > +
> > > +     /* region reads - for host mode */
> > > +     atomic64_t reads;
> > 
> > Why do you need an atomic variable for this?  What are you trying to
> > "protect" here by flushing the cpus all the time?  What protects this
> > variable from changing right after you have read from it (hint, you do
> > that above...)
> > 
> > atomics are not race-free, use a real lock if you need that.
> We are on the data path here - this is called from queuecommand.
> The "reads" counter is being symmetrically read and written,
> so adding a spin lock here might become a source for contention.

And an atomic varible is not?  You do know what spinlocks are made of,
right?  :)

> Also I am not worried about the exact value of this counter, except of one place - 
> See above.  Will fix it.

So it's not really needed?

thanks,

greg k-h
