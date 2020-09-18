Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B61FC43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 04:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDC1223770
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 04:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600402440;
	bh=Dzx2SgdN6Jiki5P08sC+O9f4HKaRJsQSU/WYw/7w1cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=R91p5moszds+sg6ZuJEfhNCm6SBNXPi7VvsOgAaVOYcty8UALvPIzeFvTdIZHRaxq
	 2tTVvS0Kb5U1hK/ixQCVFQoD9bzz1cv66EWZf9rke1Z8SFVnT8nkk4anuez0faVr7j
	 HCWlsWkH7FkWhEIRCia3X7ag/loRK5pTuPdt4cJU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgIREN5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 00:13:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgIREN5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 00:13:57 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5573123770;
        Fri, 18 Sep 2020 04:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600402436;
        bh=Dzx2SgdN6Jiki5P08sC+O9f4HKaRJsQSU/WYw/7w1cs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VPyBFZNwGNGNEVVrc8IUbtRybiul5rxNJIusgPICS+h2n6vjSU2lhGgJYML5FJjIR
         T7Ga6ErZGPHu1DVa3/7RhU8Wri8lMfGf0ZaneDoUia1H3F+5LNZTFxVKa1RdDWQHU1
         88O5imM089P1bYcVpUdQ8gZ6XvR/EGe1UYtN/vDA=
Date:   Thu, 17 Sep 2020 21:13:55 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     Bean Huo <huobean@gmail.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 5/6] scsi: ufs: show ufs part info in error case
Message-ID: <20200918041355.GB3300389@google.com>
References: <20200915204532.1672300-1-jaegeuk@kernel.org>
 <20200915204532.1672300-5-jaegeuk@kernel.org>
 <bdc48d03dae86abef158aa33468f6c2f8e669ce8.camel@gmail.com>
 <20200916160533.GA1011272@google.com>
 <06eb20588007cf87181446ab3946e8b2@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06eb20588007cf87181446ab3946e8b2@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/17, Can Guo wrote:
> On 2020-09-17 00:05, Jaegeuk Kim wrote:
> > On 09/16, Bean Huo wrote:
> > > On Tue, 2020-09-15 at 13:45 -0700, Jaegeuk Kim wrote:
> > > > Cc: Avri Altman <avri.altman@wdc.com>
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> > > > ---
> > > >  drivers/scsi/ufs/ufshcd.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > > index bdc82cc3824aa..b81c116b976ff 100644
> > > > --- a/drivers/scsi/ufs/ufshcd.c
> > > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > > @@ -500,6 +500,14 @@ static void ufshcd_print_tmrs(struct ufs_hba
> > > > *hba, unsigned long bitmap)
> > > >  static void ufshcd_print_host_state(struct ufs_hba *hba)
> > > >  {
> > > >         dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
> > > > +       if (hba->sdev_ufs_device) {
> > > > +               dev_err(hba->dev, " vendor = %.8s\n",
> > > > +                                       hba->sdev_ufs_device-
> > > > >vendor);
> > > > +               dev_err(hba->dev, " model = %.16s\n",
> > > > +                                       hba->sdev_ufs_device->model);
> > > > +               dev_err(hba->dev, " rev = %.4s\n",
> > > > +                                       hba->sdev_ufs_device->rev);
> > > > +       }
> > > 
> > > Hi Jaegeuk
> > > these prints have been added since this change:
> > > 
> > > commit 3f8af6044713 ("scsi: ufs: Add some debug information to
> > > ufshcd_print_host_state()")
> > > 
> > > https://patchwork.kernel.org/patch/11694371/
> > 
> > Cool, thank you for pointing this out. BTW, which branch can I see the
> > -next
> > patches?
> > 
> 
> Hi Jaegeuk,
> 
> This patch comes from a series of changes trying to fix and simplify
> the UFS error handling. You can find the whole series here - they are
> picked up on scsi-queue-5.10
> 
> https://lore.kernel.org/linux-scsi/1596975355-39813-10-git-send-email-cang@codeaurora.org/
> 
> Besides, several more fixes for error handling based on above series are
> 
> https://lore.kernel.org/patchwork/patch/1290405/
> &
> https://lore.kernel.org/linux-scsi/159961731708.5787.8825955850640714260.b4-ty@oracle.com/
> 
> I've mainline all above changes to Android12-5.4 and Android11-5.4.

I've seen the patches in Android branches. Thank you for the explanation.

> 
> Moreover, there are 2 more fixes on the way for error handling, I
> will push them soon.

BTW, could you please take a look at these patches?

Thanks,

> 
> Thanks,
> 
> Can Guo.
> 
> > > 
> > > Thanks,
> > > Bean
