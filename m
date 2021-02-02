Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1719C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80FA064F4F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhBBLwm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:52:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhBBLwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 06:52:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C05B564ED7;
        Tue,  2 Feb 2021 11:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612266720;
        bh=rKxNW2PzZr2cvmy1pctNg+eGKneyKt1DjppPAeRgZ4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rLQLY40qTJUrAl/eCeU3Qt8VZCb41OBuy9RRDYc0C0G3NBHlaPBzJbW2U/3TUNeIb
         BywhYX5jJ34AKT6eEsZRXfrrGlC7HgfnxHF6FVgvBJHSWlA9byC8IKD+UsiWAYM9mL
         J+3LM5oBMsnb6jQxq4Xp7fQ3+bQISaESLbUx48eY=
Date:   Tue, 2 Feb 2021 12:51:55 +0100
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
Subject: Re: [PATCH v2 2/9] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Message-ID: <YBk827Gh9JU3sNJZ@kroah.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-3-avri.altman@wdc.com>
 <YBkz7m7uMP4iJ/qn@kroah.com>
 <DM6PR04MB65754BB7B07301D2B35B6490FCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB65754BB7B07301D2B35B6490FCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 02, 2021 at 11:24:04AM +0000, Avri Altman wrote:
>  
> > 
> > On Tue, Feb 02, 2021 at 10:30:00AM +0200, Avri Altman wrote:
> > > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> > > index afeb6365daf8..5ec4023db74d 100644
> > > --- a/drivers/scsi/ufs/ufshpb.h
> > > +++ b/drivers/scsi/ufs/ufshpb.h
> > > @@ -48,6 +48,11 @@ enum UFSHPB_MODE {
> > >       HPB_DEVICE_CONTROL,
> > >  };
> > >
> > > +enum HPB_RGN_FLAGS {
> > > +     RGN_FLAG_UPDATE = 0,
> > > +     RGN_FLAG_DIRTY,
> > > +};
> > > +
> > >  enum UFSHPB_STATE {
> > >       HPB_PRESENT = 1,
> > >       HPB_SUSPEND,
> > > @@ -109,6 +114,7 @@ struct ufshpb_region {
> > >
> > >       /* below information is used by lru */
> > >       struct list_head list_lru_rgn;
> > > +     unsigned long rgn_flags;
> > 
> > Why an unsigned long for a simple enumerated type?  And why not make
> > this "type safe" by explicitly saying this is an enumerated type
> > variable?
> I am using it for atomic bit operations.

That's not obvious given you have an enumerated type above.  Seems like
an odd mix...
