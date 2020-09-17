Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5DDC35256
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 00:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 863E0206CA
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 00:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="uIdarbCK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgIQA72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 20:59:28 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:62623 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgIQA7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Sep 2020 20:59:25 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 20:59:24 EDT
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600304364; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=8pI1//eDzriKf81JxhFe+YUeQTcTypsWCIXjCbZwU54=;
 b=uIdarbCKVQxe/nebob3aSu/aKFpVRPaH0lA7XM+3Dx63axKojT723K+7qscZcEuBjKfONU/U
 n6jDD8oQcjG2QltdF4Zsn0mUvQs/HTaZZeaPQxQ1MyirDKbAsBxT//I/CmvZKivOqxr5oWhi
 wuCXedkSEVggIl7yAZOMd/SoANI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f62b3ad91755cb92b328128 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 17 Sep 2020 00:54:05
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0C84BC433CA; Thu, 17 Sep 2020 00:54:05 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB543C433C8;
        Thu, 17 Sep 2020 00:54:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 17 Sep 2020 08:54:03 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     Bean Huo <huobean@gmail.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 5/6] scsi: ufs: show ufs part info in error case
In-Reply-To: <20200916160533.GA1011272@google.com>
References: <20200915204532.1672300-1-jaegeuk@kernel.org>
 <20200915204532.1672300-5-jaegeuk@kernel.org>
 <bdc48d03dae86abef158aa33468f6c2f8e669ce8.camel@gmail.com>
 <20200916160533.GA1011272@google.com>
Message-ID: <06eb20588007cf87181446ab3946e8b2@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-17 00:05, Jaegeuk Kim wrote:
> On 09/16, Bean Huo wrote:
>> On Tue, 2020-09-15 at 13:45 -0700, Jaegeuk Kim wrote:
>> > Cc: Avri Altman <avri.altman@wdc.com>
>> > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
>> > ---
>> >  drivers/scsi/ufs/ufshcd.c | 8 ++++++++
>> >  1 file changed, 8 insertions(+)
>> >
>> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > index bdc82cc3824aa..b81c116b976ff 100644
>> > --- a/drivers/scsi/ufs/ufshcd.c
>> > +++ b/drivers/scsi/ufs/ufshcd.c
>> > @@ -500,6 +500,14 @@ static void ufshcd_print_tmrs(struct ufs_hba
>> > *hba, unsigned long bitmap)
>> >  static void ufshcd_print_host_state(struct ufs_hba *hba)
>> >  {
>> >         dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
>> > +       if (hba->sdev_ufs_device) {
>> > +               dev_err(hba->dev, " vendor = %.8s\n",
>> > +                                       hba->sdev_ufs_device-
>> > >vendor);
>> > +               dev_err(hba->dev, " model = %.16s\n",
>> > +                                       hba->sdev_ufs_device->model);
>> > +               dev_err(hba->dev, " rev = %.4s\n",
>> > +                                       hba->sdev_ufs_device->rev);
>> > +       }
>> 
>> Hi Jaegeuk
>> these prints have been added since this change:
>> 
>> commit 3f8af6044713 ("scsi: ufs: Add some debug information to
>> ufshcd_print_host_state()")
>> 
>> https://patchwork.kernel.org/patch/11694371/
> 
> Cool, thank you for pointing this out. BTW, which branch can I see the 
> -next
> patches?
> 

Hi Jaegeuk,

This patch comes from a series of changes trying to fix and simplify
the UFS error handling. You can find the whole series here - they are
picked up on scsi-queue-5.10

https://lore.kernel.org/linux-scsi/1596975355-39813-10-git-send-email-cang@codeaurora.org/

Besides, several more fixes for error handling based on above series are

https://lore.kernel.org/patchwork/patch/1290405/
&
https://lore.kernel.org/linux-scsi/159961731708.5787.8825955850640714260.b4-ty@oracle.com/

I've mainline all above changes to Android12-5.4 and Android11-5.4.

Moreover, there are 2 more fixes on the way for error handling, I
will push them soon.

Thanks,

Can Guo.

>> 
>> Thanks,
>> Bean
