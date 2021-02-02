Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE861C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C9464F50
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhBBLwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:52:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231349AbhBBLwM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Feb 2021 06:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC8F764EDA;
        Tue,  2 Feb 2021 11:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612266691;
        bh=oQSn79aftyH7uGpea6Y6ZKbRHlClxKT7EnCy9j5mu6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KK9bYO37E2FaElLdXySz5TIENWBjx4vahDzo3fjQ2KiVwfrHBdCX2vnld8JVRISxV
         Gxm8/IYe1ZWln0kVNauPkUQ72wOUo9fsFw1FmPNJibRbz5GZbYeN23ARQ1Mt4UP5hy
         kdMOi+jX0oYFbiVyI1B6stNgkDOhExSocbSHX02Q=
Date:   Tue, 2 Feb 2021 12:51:26 +0100
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
Subject: Re: [PATCH v2 3/9] scsi: ufshpb: Add region's reads counter
Message-ID: <YBk8vkmxkoR3lTSO@kroah.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-4-avri.altman@wdc.com>
 <YBk0PHFW+8klHN8Y@kroah.com>
 <DM6PR04MB65750EECC22CC837D028003DFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB65750EECC22CC837D028003DFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 02, 2021 at 11:23:17AM +0000, Avri Altman wrote:
> > 
> > 
> > On Tue, Feb 02, 2021 at 10:30:01AM +0200, Avri Altman wrote:
> > > @@ -175,6 +179,8 @@ struct ufshpb_lu {
> > >
> > >       /* for selecting victim */
> > >       struct victim_select_info lru_info;
> > > +     struct work_struct ufshpb_normalization_work;
> > > +     unsigned long work_data_bits;
> > 
> > You only have 1 "bit" being used here, so perhaps just a u8?  Please
> > don't use things like "unsigned long" for types, this isn't Windows :)
> I am using it for atomic bit operations.

Ah, and that requires "unsigned long"?  Ok, nevermind :)
