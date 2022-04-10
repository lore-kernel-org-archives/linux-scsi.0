Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2072DC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Apr 2022 17:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiDJR2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 13:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbiDJR2k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 13:28:40 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B5760D8E
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:26:29 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c24-20020a9d6c98000000b005e6b7c0a8a8so6327341otr.2
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=b6S1Hp+iFokkZeh+FP2LaecRO9njLAVtb2MAU5iUBKA=;
        b=hMu1vLUtIiiqimce4K5cKiifA7lXl3H4+8DG+0g9RarA4bFwtNSDHW01xUmAql/qBV
         QxSp9Z7suRcwrVbzH6qEPO4pkMnt+gmeZy20bvQbN1W0ovpMS4a2cH/KOYBZHzzwVUDL
         TR9mAtOYfu0eOeto82sA70eawlD/i5+Gz6z3mIQgkjS9+RyifnuOq6+8CCKj1M12AMxK
         fTkrY+VlgZDAHpKEHGOsotsTqOqnhtwAdNTLQ/sRa/dZO3dd8tTd/zCsGYbPWbC2nuYg
         9rlbgIV+SGH/wFpgSOc+rWnjEDnmTkpWLwbMJyrkZet8M5kMPdOWjz+Lb20PJr/qpiUt
         gZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=b6S1Hp+iFokkZeh+FP2LaecRO9njLAVtb2MAU5iUBKA=;
        b=xGjVGHBTws6ptAyHbXKNmJ6kAQNFOIb21kidyXAoDyYvBJBq56/IMCheM2gEs8jN7F
         ptfmVes7VdCdyhkllEjnqVoN/2ye2bAaKjmFiBdxc0ZPprKAgqpXkq8hE8tYUpZVn2GA
         ibrOabrdy0a8SYjs0vpr1CA/nbkj/7IFLa22RBkQz8TKTbgw5DtMUHhOB/AkTwj4+3GB
         lF6XU9wBZeUr9zDUhYJ/So4mGL4/vhH+Z+BXuJmm/l6o7PhHVrZJSuVO+ZMxkN886Gnv
         vwXlBaOeD4aYH6vD3pWPA2KLWkvGa0KP+RiPC9621fVnF/CXKEVHnIcNuRnlbUFfcIoi
         XnDA==
X-Gm-Message-State: AOAM530u6Rojc8wupEwCCMbeMVX5LuKPGn30ebS+znm19UDnUk+UnEGa
        VjUnyowdwyTHMNCidG9j3A4Abhd0tbc=
X-Google-Smtp-Source: ABdhPJxcsCF09U74c2vnemsdrYwBCi+X4tg4BO8SQVh/pw73dec2GJN5VMJVbFLRJrkqlFf47jg5RA==
X-Received: by 2002:a9d:3b2:0:b0:5b2:2abc:fe8c with SMTP id f47-20020a9d03b2000000b005b22abcfe8cmr10173155otf.309.1649611588682;
        Sun, 10 Apr 2022 10:26:28 -0700 (PDT)
Received: from ?IPV6:2603:8081:140c:1a00:8884:2210:b4d7:3f81? (2603-8081-140c-1a00-8884-2210-b4d7-3f81.res6.spectrum.com. [2603:8081:140c:1a00:8884:2210:b4d7:3f81])
        by smtp.gmail.com with ESMTPSA id f8-20020a4a8908000000b0032472938f95sm9662818ooi.17.2022.04.10.10.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 10:26:28 -0700 (PDT)
Message-ID: <b726c9b6-89be-ea97-4aca-93192d939a36@gmail.com>
Date:   Sun, 10 Apr 2022 12:26:27 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Revert "scsi: scsi_debug: Address races following module
 load"
Content-Language: en-US
From:   Bob Pearson <rpearsonhpe@gmail.com>
To:     Yi Zhang <yi.zhang@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220409043704.28573-1-bvanassche@acm.org>
 <CAHj4cs8CRK==3+ssCSLWrC-1-jtp+=QAoaopN97GgFs5bWcbow@mail.gmail.com>
 <aaec898e-08f1-03da-a0c0-34729df4f68b@gmail.com>
In-Reply-To: <aaec898e-08f1-03da-a0c0-34729df4f68b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/10/22 12:00, Bob Pearson wrote:
> On 4/10/22 08:15, Yi Zhang wrote:
>> Confirmed the blktests srp/ issue was fixed with this revert:
>>
>> Tested-by: Yi Zhang <yi.zhang@redhat.com>
>>
>> On Sat, Apr 9, 2022 at 12:37 PM Bart Van Assche <bvanassche@acm.org> wrote:
>>>
>>> Revert the patch mentioned in the subject since it blocks I/O after
>>> module unload has started while this is a legitimate use case. For e.g.
>>> blktests test case srp/001 that patch causes a command timeout to be
>>> triggered for the following call stack:
>>>
> 
> I also applied Bart's patch reverting the scsi_debug change. And find
> that now blktest/check -q srp runs successfully and the trace does not
> show the inconsistent lock state warning. So it looks to me that there
> is not a current need to revert the remaining _bh locks in the rxe driver
> to _irqsave locks.
> 
> But, as far as I know the root cause of those warnings, when valid, are due to
> code that calls into the verbs APIs while holding _irqsave locks. If we want to
> make that generally possible then perhaps we should just get rid of the _bh
> locks in favor of _irqsave locks. I have a patch that does that if you think
> it is needed.
> 
> Bob

Oops. I was ahead of for-next. Going back to origin/for-next. The warning is back.
I'll figure out what fixed it.
