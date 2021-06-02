Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAE1C47080
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36AD86139A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhFBCQh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:16:37 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:12077 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFBCQg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 22:16:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622600094; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=iOQwgqabrc1MbfT07CPHtQODLtRaNjncaWi9mJJSGlQ=;
 b=G7TqxZz7NYfTW6FC5UCMgRIzR5h498GWyxDz8HNcBPxpOjOzJ/Lg8Cs78OvciSqsbKj5iNzC
 mvIgshlhUVCF3OTDFgWp0f1rsXcITXgx78VJe6+Rg9P9j0uNK/O95hbvvvKXfHtP57mdiXl3
 aybqmVvwBshKjWf6d1umLVajhzA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60b6e993f726fa4188928ac6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Jun 2021 02:14:43
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1EC6BC4338A; Wed,  2 Jun 2021 02:14:43 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 61B2DC433F1;
        Wed,  2 Jun 2021 02:14:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 02 Jun 2021 10:14:39 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
In-Reply-To: <6d6d296a84f1e62f65fda4d172a85bb35d9a3684.camel@gmail.com>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
 <6d6d296a84f1e62f65fda4d172a85bb35d9a3684.camel@gmail.com>
Message-ID: <adc85803e27226bc8d24c53061e39214@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

On 2021-06-01 00:04, Bean Huo wrote:
> On Mon, 2021-05-24 at 01:36 -0700, Can Guo wrote:
>> Current UFS IRQ handler is completely wrapped by host lock, and
>> because
>> 
>> ufshcd_send_command() is also protected by host lock, when IRQ
>> handler
>> 
>> fires, not only the CPU running the IRQ handler cannot send new
>> requests,
>> 
>> the rest CPUs can neither. Move the host lock wrapping the IRQ
>> handler into
>> 
>> specific branches, i.e., ufshcd_uic_cmd_compl(),
>> ufshcd_check_errors(),
>> 
>> ufshcd_tmc_handler() and ufshcd_transfer_req_compl(). Meanwhile, to
>> further
>> 
>> reduce occpuation of host lock in ufshcd_transfer_req_compl(), host
>> lock is
>> 
>> no longer required to call __ufshcd_transfer_req_compl(). As per
>> test, the
>> 
>> optimization can bring considerable gain to random read/write
>> performance.
>> 
>> 
>> 
>> Cc: Stanley Chu <stanley.chu@mediatek.com>
>> 
>> Co-developed-by: Asutosh Das <asutoshd@codeaurora.org>
>> 
>> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> 
> Can,
> The patch looks good to me.
> I did a UFS queue limitation test before, observed that once the queue
> is full, then the active task number in the queue will get down. For
> the Nvme, the scenario is the same. You can refer to the slide 23, and
> slide 24 in the pdf:
> https://elinux.org/images/6/6c/Linux_Storage_System_Bottleneck_Exploration_V0.3.pdf
> I don't know if your patch can fix this
> issue.

I've studied these slides made by you many times, it is really good.
I will do some study later on this. Thanks for the slides.

> 
> Unfortunately, I cannot verify UTRLCNR usage flow since my platform is
> v2.1. But at least my test can prove that the patch doesn't impact the
> legacy(UFSHCI is less than v3.0) doorbell usage flow.
> 

Thanks for your time :).

Regards,
Can Guo.

> Reviewed-by: Bean Huo <beanhuo@micron.com>
> 
> 
> Bean
