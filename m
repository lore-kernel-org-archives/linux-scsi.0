Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1687C4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 12:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0B622388E
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 12:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgLSMyl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 07:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgLSMyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Dec 2020 07:54:40 -0500
Date:   Sat, 19 Dec 2020 13:55:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608382440;
        bh=5Te/9R+PfljQzEy210BM/ZP2PlPMg9loYI54+GX0m6I=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=kFS3eLAdOlufqco/li6xq45/1A7vJWSAGztqPidHtRDF/I1iunPbRKimK0ccPP7Q1
         ESHmS8PEaHs/bw7fzSJ2ISFVAb5Kp1FLlwf74EJ9mpZOj21NRZL1zcshISTZT35Xso
         v+b/qVARFL9IXtiZzGQUrGvveFVcmZSWYgO4wVr8=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Daejun Park <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v16 1/3] scsi: ufs: Introduce HPB feature
Message-ID: <X934OOlXSf5up8Rd@kroah.com>
References: <20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p2>
 <CGME20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p7>
 <20201219091847epcms2p7afeebd03c47eed0b65f89375a881233e@epcms2p7>
 <X93XuJ4lsQbBgnU+@kroah.com>
 <DM6PR04MB6575AC2A541FCAAB60E581FBFCC20@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB6575AC2A541FCAAB60E581FBFCC20@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Dec 19, 2020 at 12:48:31PM +0000, Avri Altman wrote:
> > 
> > 
> > On Sat, Dec 19, 2020 at 06:18:47PM +0900, Daejun Park wrote:
> > > +static int ufshpb_get_state(struct ufshpb_lu *hpb)
> > > +{
> > > +     return atomic_read(&hpb->hpb_state);
> > > +}
> > > +
> > > +static void ufshpb_set_state(struct ufshpb_lu *hpb, int state)
> > > +{
> > > +     atomic_set(&hpb->hpb_state, state);
> > > +}
> > 
> > You have a lock for the state, and yet the state is an atomic variable
> > and you do not use the lock here at all.  You don't use the lock at all
> > infact...
> > 
> > So either the lock needs to be dropped, or you need to use the lock and
> > make the state a normal variable please.
> hpb_state_lock is mainly protecting the list of active regions.
> Just grep  lh_lru_rgn in patch 2/3.

Then why is the lock added in this patch if it is not used here?

thanks,

greg k-h
