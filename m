Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41852C4727F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 05:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA88123A5F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 05:30:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="lLBHVF5w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgIVFaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 01:30:39 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:55798 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgIVFai (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Sep 2020 01:30:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600752638; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=pi/Sw7He2cwNd088blGSKEwyilcs30+0qPagftWle0o=;
 b=lLBHVF5w83vRah8xwfdz5MihLnHHz5eXDBm1OgzG0blp28NAyLFP8vUnhsUADcmS9ympWgtC
 WSkXh4A5j9BAu042mL+ySeI1LdPJE8SrSy/fPnC/k9whpM5AQi4pbwsoSyIjxi7S71jiGBfk
 lr17BpUOgPMyze+Bo+APV8/gxDw=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f698bfd4a8a578ddcebb2f6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Sep 2020 05:30:37
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9B5B7C433F1; Tue, 22 Sep 2020 05:30:37 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C3038C433CA;
        Tue, 22 Sep 2020 05:30:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 22 Sep 2020 13:30:36 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Bean Huo <huobean@gmail.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 5/6] scsi: ufs: show ufs part info in error case
In-Reply-To: <20200918041355.GB3300389@google.com>
References: <20200915204532.1672300-1-jaegeuk@kernel.org>
 <20200915204532.1672300-5-jaegeuk@kernel.org>
 <bdc48d03dae86abef158aa33468f6c2f8e669ce8.camel@gmail.com>
 <20200916160533.GA1011272@google.com>
 <06eb20588007cf87181446ab3946e8b2@codeaurora.org>
 <20200918041355.GB3300389@google.com>
Message-ID: <c2daa34823b0102d28cafe7fcd741344@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-18 12:13, Jaegeuk Kim wrote:
> On 09/17, Can Guo wrote:
>> On 2020-09-17 00:05, Jaegeuk Kim wrote:
>> > On 09/16, Bean Huo wrote:
>> > > On Tue, 2020-09-15 at 13:45 -0700, Jaegeuk Kim wrote:
>> > > > Cc: Avri Altman <avri.altman@wdc.com>
>> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
>> > > > ---
>> > > >  drivers/scsi/ufs/ufshcd.c | 8 ++++++++
>> > > >  1 file changed, 8 insertions(+)
>> > > >
>> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > > > index bdc82cc3824aa..b81c116b976ff 100644
>> > > > --- a/drivers/scsi/ufs/ufshcd.c
>> > > > +++ b/drivers/scsi/ufs/ufshcd.c
>> > > > @@ -500,6 +500,14 @@ static void ufshcd_print_tmrs(struct ufs_hba
>> > > > *hba, unsigned long bitmap)
>> > > >  static void ufshcd_print_host_state(struct ufs_hba *hba)
>> > > >  {
>> > > >         dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
>> > > > +       if (hba->sdev_ufs_device) {
>> > > > +               dev_err(hba->dev, " vendor = %.8s\n",
>> > > > +                                       hba->sdev_ufs_device-
>> > > > >vendor);
>> > > > +               dev_err(hba->dev, " model = %.16s\n",
>> > > > +                                       hba->sdev_ufs_device->model);
>> > > > +               dev_err(hba->dev, " rev = %.4s\n",
>> > > > +                                       hba->sdev_ufs_device->rev);
>> > > > +       }
>> > >
>> > > Hi Jaegeuk
>> > > these prints have been added since this change:
>> > >
>> > > commit 3f8af6044713 ("scsi: ufs: Add some debug information to
>> > > ufshcd_print_host_state()")
>> > >
>> > > https://patchwork.kernel.org/patch/11694371/
>> >
>> > Cool, thank you for pointing this out. BTW, which branch can I see the
>> > -next
>> > patches?
>> >
>> 
>> Hi Jaegeuk,
>> 
>> This patch comes from a series of changes trying to fix and simplify
>> the UFS error handling. You can find the whole series here - they are
>> picked up on scsi-queue-5.10
>> 
>> https://lore.kernel.org/linux-scsi/1596975355-39813-10-git-send-email-cang@codeaurora.org/
>> 
>> Besides, several more fixes for error handling based on above series 
>> are
>> 
>> https://lore.kernel.org/patchwork/patch/1290405/
>> &
>> https://lore.kernel.org/linux-scsi/159961731708.5787.8825955850640714260.b4-ty@oracle.com/
>> 
>> I've mainline all above changes to Android12-5.4 and Android11-5.4.
> 
> I've seen the patches in Android branches. Thank you for the 
> explanation.
> 
>> 
>> Moreover, there are 2 more fixes on the way for error handling, I
>> will push them soon.
> 
> BTW, could you please take a look at these patches?
> 
> Thanks,
> 

Sure, but since I am not in your cc or to list, so I don't know which
patches. Maybe you can add me when you push the next version? Thanks.

Regards,

Can Guo.

>> 
>> Thanks,
>> 
>> Can Guo.
>> 
>> > >
>> > > Thanks,
>> > > Bean
