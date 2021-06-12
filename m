Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE97C48BE5
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 07:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99B3D6128A
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 07:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhFLHKH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Jun 2021 03:10:07 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:49140 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhFLHKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jun 2021 03:10:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623481687; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=uALzKA03nwUGmdoVFggm2ud1rs/4hZQVgjZNIyhKlGE=;
 b=upriuoT1VymrU9mww7Q39hALcdSs6Hky7H2I/cvZ0y5lw8rF0qdl7FICqa6YMU9v/tt//6xA
 zgPU/MTdv8Xfu9OX/bBjybenpRBPzkpmTYagujx91l3bUBD12O1kNpPhDoqOMtnOCvTARyc0
 sWtkDETe+UUvStzjD9c72RBMO4M=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60c45d3c51f29e6bae6074cd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Jun 2021 07:07:40
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 24531C43143; Sat, 12 Jun 2021 07:07:39 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 48F91C433F1;
        Sat, 12 Jun 2021 07:07:38 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 12 Jun 2021 15:07:38 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 8/9] scsi: ufs: Update the fast abort path in
 ufshcd_abort() for PM requests
In-Reply-To: <fa37645b-3c1e-2272-d492-0c2b563131b1@acm.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-9-git-send-email-cang@codeaurora.org>
 <fa37645b-3c1e-2272-d492-0c2b563131b1@acm.org>
Message-ID: <16f5bd448c7ae1a45fcb23133391aa3f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-12 05:02, Bart Van Assche wrote:
> On 6/9/21 9:43 PM, Can Guo wrote:
>> If PM requests fail during runtime suspend/resume, RPM framework saves 
>> the
>> error to dev->power.runtime_error. Before the runtime_error gets 
>> cleared,
>> runtime PM on this specific device won't work again, leaving the 
>> device
>> either runtime active or runtime suspended permanently.
>> 
>> When task abort happens to a PM request sent during runtime 
>> suspend/resume,
>> even if it can be successfully aborted, RPM framework anyways saves 
>> the
>> (TIMEOUT) error. In this situation, we can leverage error handling to
>> recover and clear the runtime_error. So, let PM requests take the fast
>> abort path in ufshcd_abort().
> 
> How can a PM request fail during runtime suspend/resume? Does such a
> failure perhaps indicate an UFS controller bug?

I've replied your similar question in previous series. I've seen too 
much
SSU cmd and SYNCHRONIZE_CACHE cmd timed out these years, 60s is not even
enough for them to complete. And you are right, most cases are that 
device
is not responding - UFS controller is busy with housekeeping.

> I appreciate your work
> but I'm wondering whether it's worth to complicate the UFS driver for
> issues that should be fixed in the controller instead of in software.
> 

Sigh... I also want my life and work to be easier... I agree with you.

In project bring up stage, we fix whatever error/bug/failure we face to
unblock the project, during which we only focus on and try to fix the 
very
first UFS error, but not quite care about the error recovery or what the
error can possibly cause (usually more UFS errors and system stability 
issues
follow the very first UFS error).

However, these years our customers tend to ask for more - they want UFS 
error
handling to recover everything whenever UFS error occurs, because they 
believe
it is the last line of defense after their products go out to market. So 
I took
a lot of effort fixing, testing and trying to make it robust. Now here 
we are.
FYI, I am on a tight schedule to have these UFS error handling changes 
ready in
Android12-5.10.

Thanks,

Can Guo.

> Thanks,
> 
> Bart.
