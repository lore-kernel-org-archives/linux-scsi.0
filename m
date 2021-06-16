Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C856C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 08:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 057236115B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 08:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhFPIuD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 04:50:03 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:30299 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhFPIuC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Jun 2021 04:50:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623833277; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=UDMXvBeHQdcQ+tqXCHrPDtv2AvZ2wHEj+q2+GdZpS+U=;
 b=bo8x3tVtActGdjNKXrDLXU2HAccIgxxmoWkSYPVyL0PNC/vNnavFXcPKIc5jFq2p4dE1fkwF
 s5PFMVpIPayF8yYYM6JFSuFxbn22VLgg0jGwt1i2+mrwBh/kMp8MhJ2RwLyhtEJkitLBH7J+
 /Z5VXI8W3oClg+qYON7yRs0pJ0w=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60c9baa5b6ccaab753049d0f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Jun 2021 08:47:33
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B029FC43146; Wed, 16 Jun 2021 08:47:32 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5252FC433F1;
        Wed, 16 Jun 2021 08:47:31 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 16 Jun 2021 16:47:31 +0800
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
In-Reply-To: <0081ad7c-8a15-62bb-0e6a-82552aab5309@acm.org>
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
Message-ID: <8eadb2f2e30804faf23c9c71e5724d08@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-16 12:40, Bart Van Assche wrote:
> On 6/15/21 9:00 PM, Can Guo wrote:
>> I would like to stick to my way as of now because
>> 
>> 1. Merely preventing task abort cannot prevent suspend/resume fail.
>> Task abort (to PM requests), in real cases, is just one of many kinds
>> of failure which can fail the suspend/resume callbacks. During
>> suspend/resume, if AH8 error and/or UIC errors happen, IRQ handler
>> may complete SSU cmd with errors and schedule the error handler (I've
>> seen such scenarios in real customer cases). My idea is to treat task
>> abort (to PM requests) as a failure (let scsi_execute() return with
>> whatever error) and let error handler recover everything just like
>> any other UFS errors which invoke error handler. In case this, again,
>> goes back to the topic that is why don't just do error recovery in
>> suspend/resume, let me paste my previous reply here -
> 
> Does this mean that the IRQ handler can complete an SSU command with an
> error and that the error handler can later recover from that error?

Not exactly, sorry that I didn't put it clearly. There are cases where 
cmds
are completed with an error (either OCS is not SUCCESS or device returns
check condition in resp) and accompanied by fatal or non-fatal UIC 
errors
(UIC errors invoke UFS error handler). For example, SSU is completed 
with
OCS_MISMATCH_RESPONSE_UPIU_SIZE (whatever the reason is in HW), then 
auto
hibern8 enter (AH8 timer timeout hba->ahit is set to a very low value) 
kicks
start right after but fails with fatal UIC errors. From dmesg log, these 
all
happen at once. I've seen even more complicated cases where all kinds of 
errors
mess up together.

> That sounds completely wrong to me. The IRQ handler should never 
> complete any
> command with an error if that error could be recoverable. Instead, the
> IRQ handler should add that command to a list and leave it to the error
> handler to fail that command or to retry it.
> 
>> 2. And say we want SCSI layer to resubmit PM requests to prevent
>> suspend/resume fail, we should keep retrying the PM requests (so
>> long as error handler can recover everything successfully), meaning
>> we should give them unlimited retries (which I think is a bad idea),
>> otherwise (if they have zero retries or limited retries), in extreme
>> conditions, what may happen is that error handler can recover 
>> everything
>> successfully every time, but all these retries (say 3) still time out,
>> which block the power management for too long (retries * 60 seconds) 
>> and,
>> most important, when the last retry times out, scsi layer will anyways
>> complete the PM request (even we return DID_IMM_RETRY), then we end up
>> same - suspend/resume shall run concurrently with error handler and we
>> couldn't recover saved PM errors.
> 
> Hmm ... it is not clear to me why this behavior is considered a 
> problem?
> 

To me, task abort to PM requests does not worth being treated so 
differently,
after all suspend/resume may fail due to any kinds of UFS errors (as 
I've
explained so many times). My idea is to let PM requests fast fail (60 
seconds
has passed, a broken device maybe, we have reason to fail it since it is 
just
a passthrough req) and schedule UFS error handler, UFS error handler 
shall
proceed after suspend/resume fails out then start to recover everything 
in a
safe environment. Is this way not working?

Thanks,

Can Guo.

> What is wrong with blocking RPM while a START STOP UNIT command is 
> being
> processed? If there are UFS devices for which it takes long to process
> that command I think it is up to the vendors of these devices to fix
> these UFS devices.
> 
> Additionally, if a UFS device needs more than (retries * 60 seconds) to
> process a START STOP UNIT command, shouldn't it be marked as broken?
> 
> Thanks,
> 
> Bart.
