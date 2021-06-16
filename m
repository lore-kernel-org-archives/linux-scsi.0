Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9DBC49361
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 04:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158C061375
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 04:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhFPEmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 00:42:42 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:36855 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhFPEmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 00:42:42 -0400
Received: by mail-pl1-f177.google.com with SMTP id x10so483104plg.3;
        Tue, 15 Jun 2021 21:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t+6BVRDTr9Si4S9xiqSirJ7UPxwVWhjDm67cnQcl9+8=;
        b=o0d8zp01ccdCwNx/SdAl94CMBbF0g71HUc9yapru11BxYPTJkBuLpnAvqwIK63qBSM
         5PGoC2qJ3B6TCo3CkG19cY1m17jgZkTEDuq/+3s1+wd9Nuszz6NnM2uISU+m7MPPX8Gi
         qWX3Pd1l3fKyMfnnRXQs1qQO8tN0nc2mnL+BruJJbdI3hmEaAwD753NigwSrCOULEO6T
         Q5ZdSgVcQgA+15aO2/lHugolc8hTUPe14E7raNprhyFEIWZoe114GZeMv2CD6iPOFzFJ
         zdvC+Ff1yBVrbMiq4kwL224mQ0RjA/ExOoQJsFa8Cj8VuXwMSfWjrje/tbG23Ef0nbya
         40bw==
X-Gm-Message-State: AOAM533paOkUIejBjMDjj+5kLitszlOBYPL1qjHcLvRx1WdnJtexQaGj
        C26tIFAzfGqH4BUwEhS1CH+dz5DtDX8=
X-Google-Smtp-Source: ABdhPJy1EbXO4sAPsHVe93XpTW+l945ZIEjK8+sAnbc6qTr7EwxySrl2lL34Of9ut3w6LjHyTKwLzg==
X-Received: by 2002:a17:90b:1d02:: with SMTP id on2mr2922771pjb.192.1623818436218;
        Tue, 15 Jun 2021 21:40:36 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 92sm4064959pjv.29.2021.06.15.21.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 21:40:35 -0700 (PDT)
Subject: Re: [PATCH v3 8/9] scsi: ufs: Update the fast abort path in
 ufshcd_abort() for PM requests
To:     Can Guo <cang@codeaurora.org>
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0081ad7c-8a15-62bb-0e6a-82552aab5309@acm.org>
Date:   Tue, 15 Jun 2021 21:40:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8aae95071b9ab3c0a3cab91d1ae138e1@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/15/21 9:00 PM, Can Guo wrote:
> I would like to stick to my way as of now because
> 
> 1. Merely preventing task abort cannot prevent suspend/resume fail.
> Task abort (to PM requests), in real cases, is just one of many kinds
> of failure which can fail the suspend/resume callbacks. During
> suspend/resume, if AH8 error and/or UIC errors happen, IRQ handler
> may complete SSU cmd with errors and schedule the error handler (I've
> seen such scenarios in real customer cases). My idea is to treat task
> abort (to PM requests) as a failure (let scsi_execute() return with
> whatever error) and let error handler recover everything just like
> any other UFS errors which invoke error handler. In case this, again,
> goes back to the topic that is why don't just do error recovery in
> suspend/resume, let me paste my previous reply here -

Does this mean that the IRQ handler can complete an SSU command with an
error and that the error handler can later recover from that error? That
sounds completely wrong to me. The IRQ handler should never complete any
command with an error if that error could be recoverable. Instead, the
IRQ handler should add that command to a list and leave it to the error
handler to fail that command or to retry it.

> 2. And say we want SCSI layer to resubmit PM requests to prevent
> suspend/resume fail, we should keep retrying the PM requests (so
> long as error handler can recover everything successfully), meaning
> we should give them unlimited retries (which I think is a bad idea),
> otherwise (if they have zero retries or limited retries), in extreme
> conditions, what may happen is that error handler can recover everything
> successfully every time, but all these retries (say 3) still time out,
> which block the power management for too long (retries * 60 seconds) and,
> most important, when the last retry times out, scsi layer will anyways
> complete the PM request (even we return DID_IMM_RETRY), then we end up
> same - suspend/resume shall run concurrently with error handler and we
> couldn't recover saved PM errors.

Hmm ... it is not clear to me why this behavior is considered a problem?

What is wrong with blocking RPM while a START STOP UNIT command is being
processed? If there are UFS devices for which it takes long to process
that command I think it is up to the vendors of these devices to fix
these UFS devices.

Additionally, if a UFS device needs more than (retries * 60 seconds) to
process a START STOP UNIT command, shouldn't it be marked as broken?

Thanks,

Bart.
