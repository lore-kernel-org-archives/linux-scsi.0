Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FD3C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 18:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A977321974
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600280786;
	bh=HyK6e1+O96SknV92tJzQftwOnmSFa30VAHDCHZnsim0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=BfZGz/dJOUuHJwDsfG6TXz75Youta2klZRDJ4Xk+1SGt/pvz22W+DtV2dc83Krmzs
	 kkZKz9ztI3SLXSTjMpzeAliiZZZihqVFb1Bk7AyulnbqbEk8xurjDzax0cFJUmT02i
	 WycHUiWGm9NxRa6htpTILu3+cabIPkUTqousWEPg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgIPS0T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 14:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgIPSZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Sep 2020 14:25:43 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F713206B5;
        Wed, 16 Sep 2020 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600272334;
        bh=HyK6e1+O96SknV92tJzQftwOnmSFa30VAHDCHZnsim0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sn/PKPBsbuwouKfzLqpPiPeRrRMelmWbS8zJ7JWaVVbmx6TztXUZ95QFwktdNXrt7
         OzJqNVplOzkMkoBDQvJjzBJHXuLiNQVoERsDU7MfoFPyJ0fV0AcpzU1Nmo1pX5NSZ3
         EfFrOKBv+sFZdEFJ2MpaoZxNa7WF7voExrLr8fOY=
Date:   Wed, 16 Sep 2020 09:05:33 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Can Guo <cang@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 5/6] scsi: ufs: show ufs part info in error case
Message-ID: <20200916160533.GA1011272@google.com>
References: <20200915204532.1672300-1-jaegeuk@kernel.org>
 <20200915204532.1672300-5-jaegeuk@kernel.org>
 <bdc48d03dae86abef158aa33468f6c2f8e669ce8.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdc48d03dae86abef158aa33468f6c2f8e669ce8.camel@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/16, Bean Huo wrote:
> On Tue, 2020-09-15 at 13:45 -0700, Jaegeuk Kim wrote:
> > Cc: Avri Altman <avri.altman@wdc.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index bdc82cc3824aa..b81c116b976ff 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -500,6 +500,14 @@ static void ufshcd_print_tmrs(struct ufs_hba
> > *hba, unsigned long bitmap)
> >  static void ufshcd_print_host_state(struct ufs_hba *hba)
> >  {
> >         dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
> > +       if (hba->sdev_ufs_device) {
> > +               dev_err(hba->dev, " vendor = %.8s\n",
> > +                                       hba->sdev_ufs_device-
> > >vendor);
> > +               dev_err(hba->dev, " model = %.16s\n",
> > +                                       hba->sdev_ufs_device->model);
> > +               dev_err(hba->dev, " rev = %.4s\n",
> > +                                       hba->sdev_ufs_device->rev);
> > +       }
> 
> Hi Jaegeuk
> these prints have been added since this change:
> 
> commit 3f8af6044713 ("scsi: ufs: Add some debug information to
> ufshcd_print_host_state()")                
> 
> https://patchwork.kernel.org/patch/11694371/

Cool, thank you for pointing this out. BTW, which branch can I see the -next
patches?

> 
> Thanks,
> Bean
