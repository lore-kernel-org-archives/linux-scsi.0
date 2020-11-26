Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B91CC56202
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A875720B1F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 01:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="N020bvW2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbgKZBpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 20:45:47 -0500
Received: from z5.mailgun.us ([104.130.96.5]:29804 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbgKZBpr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 20:45:47 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606355147; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=6kA4yB6bdKjcHInjZZatsMpg7eCWZl7Qhyizne2iGx8=;
 b=N020bvW2Y+kUuVUyqbfdjdgeyBTici04vd3bNBlo76gOfsFdRCCqTsjvxjDRZ/FJy3h718Sa
 cDtlnL8v4WqmjkyCcm+PE5WOSKKOCklT+BiQ1yzOJuu6+z02tfkmSYGMVKhm76oXYBcmLW79
 EyFb0fNT/vDfJnzA3GHSFQyuc60=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fbf08c522377520eec62096 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 26 Nov 2020 01:45:41
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 77855C43464; Thu, 26 Nov 2020 01:45:41 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C013C433C6;
        Thu, 26 Nov 2020 01:45:40 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 26 Nov 2020 09:45:40 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Refector ufshcd_setup_clocks() to
 remove skip_ref_clk
In-Reply-To: <4e84df2ecb17dfb1fc8070953d8690b29615f409.camel@gmail.com>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
 <1606202906-14485-2-git-send-email-cang@codeaurora.org>
 <9070660d115dd96c70bc3cc90d5c7dab833f36a8.camel@gmail.com>
 <d112935400a5ef115a384a4c753b6d04@codeaurora.org>
 <0b0c545d80f9a0e8106a634063c23a8f0ba895fc.camel@gmail.com>
 <9484cba7b95c6c6fcbafd96bc35c1dee@codeaurora.org>
 <4e84df2ecb17dfb1fc8070953d8690b29615f409.camel@gmail.com>
Message-ID: <e56e31f68142cf4175a9024e107eb728@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-26 03:02, Bean Huo wrote:
> On Wed, 2020-11-25 at 20:28 +0800, Can Guo wrote:
>> > On Wed, 2020-11-25 at 08:53 +0800, Can Guo wrote:
>> > > > > +       bool always_on_while_link_active;
>> > > >
>> > > > Can,
>> > > > using a sentence as a parameter name looks a little bit clumsy
>> > > > to
>> > > > me.
>> > > > The meaning has been explained in the comments section. How
>> > > > about
>> > > > simplify it and in line with other parameters in the structure?
>> > > >
>> > >
>> > > Do you have a better name in mind?
>> > >
>> >
>> > no specail input in mind, maybe just "bool eternal_on"
>> 
>> It is like plain "always_on", but it cannot tell the whole story.
>> If it is not something crutial, let's just let it go first so long
>> as it does not break the original functionality. What do you say?
>> 
>> Thanks,
>> 
>> Can Guo.
> 
> Can,
> 
> yes, it is not functional change, but always_on_while_link_active is
> too fat, and not non-productive way.
> anyway,

I will change it to keep_link_active in next version. Thank you sir.

Regards,

Can Guo.

> 
> Reviewed-by: Bean Huo <beanhuo@micron.com>
