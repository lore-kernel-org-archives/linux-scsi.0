Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175E3C2B9F4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E635061375
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhFWBhS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:37:18 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:61849 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFWBhS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jun 2021 21:37:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624412102; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=+4WX1+XKSVWz3RW6iMyqFbDGyD0cNV+UYK/Z+DXHS7M=;
 b=jPIstFSX6fOrKsnTl4m4vU17EojsUmN3Gp+JYQbJBiqXR6F8b828WHvB19Q+J24DH/XIzfRK
 p9ig4476XoZVGL7fDZWpOhKPIO8VqO1o+Vmz/lCMQGXdK4PQQhJdB5jFsf7iLp22cr+miS4P
 n66aLL3aTf+rf46+XPwQRiV6zE0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60d28fb3638039e9977d6dec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Jun 2021 01:34:43
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 349A9C4360C; Wed, 23 Jun 2021 01:34:43 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5974CC433F1;
        Wed, 23 Jun 2021 01:34:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Jun 2021 09:34:42 +0800
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
In-Reply-To: <2fa53602-8968-09e4-60f4-28462d85ae08@acm.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-9-git-send-email-cang@codeaurora.org>
 <fa37645b-3c1e-2272-d492-0c2b563131b1@acm.org>
 <16f5bd448c7ae1a45fcb23133391aa3f@codeaurora.org>
 <926d8c4a-0fbf-a973-188a-b10c9acaa444@acm.org>
 <75527f0ba5d315d6edbf800a2ddcf8c7@codeaurora.org>
 <8b27b0cc-ae16-173a-bd6f-0321a6aba01c@acm.org>
 <3fce15502c2742a4388817538eb4db97@codeaurora.org>
 <fabc70f8-6bb8-4b62-3311-f6e0ce9eb2c3@acm.org>
 <8aae95071b9ab3c0a3cab91d1ae138e1@codeaurora.org>
 <0081ad7c-8a15-62bb-0e6a-82552aab5309@acm.org>
 <8eadb2f2e30804faf23c9c71e5724d08@codeaurora.org>
 <2fa53602-8968-09e4-60f4-28462d85ae08@acm.org>
Message-ID: <386c2e650232d7a900f5c1bbf98bd5a5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-17 01:55, Bart Van Assche wrote:
> On 6/16/21 1:47 AM, Can Guo wrote:
>> On 2021-06-16 12:40, Bart Van Assche wrote:
>>> On 6/15/21 9:00 PM, Can Guo wrote:
>>>> 2. And say we want SCSI layer to resubmit PM requests to prevent
>>>> suspend/resume fail, we should keep retrying the PM requests (so
>>>> long as error handler can recover everything successfully),
>>>> meaning we should give them unlimited retries (which I think is a
>>>> bad idea), otherwise (if they have zero retries or limited
>>>> retries), in extreme conditions, what may happen is that error
>>>> handler can recover everything successfully every time, but all
>>>> these retries (say 3) still time out, which block the power
>>>> management for too long (retries * 60 seconds) and, most
>>>> important, when the last retry times out, scsi layer will
>>>> anyways complete the PM request (even we return DID_IMM_RETRY),
>>>> then we end up same - suspend/resume shall run concurrently with
>>>> error handler and we couldn't recover saved PM errors.
>>> 
>>> Hmm ... it is not clear to me why this behavior is considered a
>>> problem?
>> 
>> To me, task abort to PM requests does not worth being treated so
>> differently, after all suspend/resume may fail due to any kinds of
>> UFS errors (as I've explained so many times). My idea is to let PM
>> requests fast fail (60 seconds has passed, a broken device maybe, we
>> have reason to fail it since it is just a passthrough req) and
>> schedule UFS error handler, UFS error handler shall proceed after
>> suspend/resume fails out then start to recover everything in a safe
>> environment. Is this way not working?
> Hi Can,
> 
> Thank you for the clarification. As you probably know the power
> management subsystem serializes runtime power management (RPM) and
> system suspend callbacks. I was concerned about the consequences of a
> failed RPM transition on system suspend and resume. Having taken a
> closer look at the UFS driver, I see that failed RPM transitions do not
> require special handling in the system suspend or resume callbacks. In
> other words, I'm fine with the approach of failing PM requests fast.
> 

Thank you for your time and efforts spent on this series, I will upload
next version to address your previous comments (hope I can convince 
Trilok
to pick these up).

Thanks,

Can Guo.

> Bart.
