Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7806C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Nov 2022 17:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiK1RjO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Nov 2022 12:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbiK1Ril (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2022 12:38:41 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2297E0A3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2022 09:38:28 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id vp12so26439972ejc.8
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2022 09:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UTE42HdZAGmXhBDYmfwGAngC8xApBrhJInF0uxlylV8=;
        b=mYhRWPWEQlU6CX8Fccal8dbkhbx9RCytIluKrrX6W9K6q0pTOw6gANJmWFmeNEv1OW
         NBN1gvSSg6AaEbYowpnFy6Y97TA4xeD0FR/K7DIHBPke7saJsv7IQ/fkkyuvX/2P00JW
         mLDywLwQOmzxI4VJDjjwf0bCZj2tdskrkwKaEtb+NIDjJGidZtg4Xi3PC9cOlsecjf8+
         iBcD++zxkCyhz0emjt2MADqENZZosA2T6lJq4IoLhEiheiA05V4gZaMsjTBjl7DNsGr1
         +zKHYVwzcAyFcBtA3HFEaZAGaJ1EaBaEBW6OGTI/bNB7iuuhb4mXqL62dFaNCQBZa2jC
         Ahcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UTE42HdZAGmXhBDYmfwGAngC8xApBrhJInF0uxlylV8=;
        b=z0qQTUwdVxuvVAbLB3F4sYP5FmdYfMyiVn0Nz3POrT1fuuXEyNahQ3PK+eSDuZE0W7
         f+9dUwXNiGjoZPaxCrEYVbOWkkeuo+KRuecLsPJbL1t1L9YXLOKrx8uxqtoynJp9vXRB
         BeUOcG6Pow/pb7stIaotXquWd7/dxJLxvKOohpaG3ngtit8MQgQ1I5IIIBIvKvHnDput
         srXRQCZaMNEgZv15IZV8TPrbN8M5vclXc576efZ06xZQLGJ0DnA4ta0T+vo9LOMRLuxG
         yvd07HVa1UQEIeS9p7WDm1/weI5ThVIeb2k9NuiAz6tMhKXUtvRczld+wTXtA72oVxuu
         zyFA==
X-Gm-Message-State: ANoB5pkPhW4hjiGL9aWJtVr6ehAtGuwctrPWRgzO/h8ldQ62OspyYBh1
        rlMxV1LnYOQW6Z9SJzssbaxFWpHd7yebpPB5wILSCXB4/sH/6w==
X-Google-Smtp-Source: AA0mqf7wIf3iyBi7cGMikqfHPTb/Erkyp7ea1ekGICHBYg/Mq3iTYC6s7UZW13KQnupWBaC+p+BWs+rMufQdMGOcy6M=
X-Received: by 2002:a17:906:e2c5:b0:7b7:90e0:f63b with SMTP id
 gr5-20020a170906e2c500b007b790e0f63bmr29410703ejb.749.1669657107399; Mon, 28
 Nov 2022 09:38:27 -0800 (PST)
MIME-Version: 1.0
References: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
 <ca7e2aba5db5bd6e15182070f26e0c2c77c70927.camel@linux.ibm.com>
 <ada12c1d-b732-59a9-8dba-1662673b6a5d@huawei.com> <70f4d744d64bc075138128a7a98b7186375170d8.camel@linux.ibm.com>
In-Reply-To: <70f4d744d64bc075138128a7a98b7186375170d8.camel@linux.ibm.com>
From:   Wenchao Hao <haowenchao22@gmail.com>
Date:   Tue, 29 Nov 2022 01:38:15 +0800
Message-ID: <CAOptpSPfswNrmYe4rnKFM3zWXY7P0JuWY94p=mfp7tV9ghFQ2w@mail.gmail.com>
Subject: Re: [QUESTION]: Why did we clear the lowest bit of SCSI command's
 status in scsi_status_is_good
To:     jejb@linux.ibm.com
Cc:     Wenchao Hao <haowenchao@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linfeilong@huawei.com,
        yanaijie@huawei.com, xuhujie@huawei.com, lijinlin3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 28, 2022 at 11:24 PM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Mon, 2022-11-28 at 22:41 +0800, Wenchao Hao wrote:
> > On 2022/11/28 20:52, James Bottomley wrote:
> > > On Mon, 2022-11-28 at 11:58 +0800, Wenchao Hao wrote:
> [...]
> > > > We found some firmware or drivers would return status which did
> > > > not defined in SAM. Now SCSI middle level do not have an uniform
> > > > behavior for these undefined status. I want to change the logic
> > > > to return error for all status which did not defined in SAM or
> > > > define a method in host template to let drivers to judge what to
> > > > do in this condition.
> > >
> > > Why? The general rule of thumb is be strict in what you emit and
> > > generous in what you receive (which is why reserved bits are
> > > ignored). Is the drive you refer to above not working in some way,
> > > in which case detail it so people can understand the actual
> > > problem.
> > >
> > > James
> > >
> > > .
> >
> >
> > We come with an issue with megaraid_sas driver. Where scsi_cmnd is
> > completed with result's status byte set to 1,
>
> Megaraid_sas is an emulation driver for the most part, so it sounds
> like this is in the RAID emulation firmware, correct?  The driver can
> correct for emulation failures, if you can figure out what it's trying
> to signal and convert it to the correct SAM error code. There's no need
> to change anything in the layers above.  If you can't figure out the
> translation and you want the transfer to error, then add DID_ERROR,
> which is a nice catch all.  If this is transient and could be fixed by
> a retry, then do DID_SOFT_ERROR instead.
>
> James
>

Thanks for your answer, Of curse we can recognize these undefined status
and map to an error which can be handled by SCSI middle level now. But I
still confused why shouldn't we change the scsi_status_is_good() to
respect to SAM?

I downloaded the sam6r08.pdf from t10.org, the status byte still did not
use the reserved bit. I think we should return an exact for all status
which is undefined in SAM rather than return true for some status
codes(0x1, 0x3, 0x5... and so on), but return false for other status.
I don't think there is any  difference between these undefined status.
