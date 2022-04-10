Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED4BC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Apr 2022 17:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiDJRDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 13:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiDJRDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 13:03:00 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E26519C39
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:00:49 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id o20-20020a9d7194000000b005cb20cf4f1bso9752814otj.7
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vvinqhn2x+JW23zqPcpeNXr4GXksBDqn+h7Y6+aN6rY=;
        b=m/YqocP0LbOoJ5/HPkJSDH131C1igR5F/nJR14D+CUL6sLcdQBvYvG1/dffLmFsTlg
         xwYiKox1aQJKrnh8K1vbgPy00I8NvdJWboosKeURImUgGTSTE+IvUtJHJ+pjTVk13PyE
         Bol7NrpJ2AryY0sig5wqHI3NfuiG+VaKPqtUmZ5EPxQ8B/p2j7DvTopYpmH3oVRSAvhN
         bXNZ7ARxzLBhMGo546VHJ6XA+b0mR4Q5vMg5O6uygMbBpv9fr+w2nVvXDGIDHQNDggRr
         YQAkD2P8XDPWNOHonbFpCBjj53ur0x11KJQE1rLn1rBGIHcvt0TWaCAaZY7Cg243avdf
         Zwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vvinqhn2x+JW23zqPcpeNXr4GXksBDqn+h7Y6+aN6rY=;
        b=Eu+b6xSqby9DKjFlzJ0AZG0Hi0dye+/eoPUr1L++6bXV3fOv5nbxDcl+QT8q+QXadG
         N67gUbuAKlf+ng7octjJuKl/Alp2wT+LPxVrnk7eNZSejXo++T/YdEKabgqAH7LO+Ufm
         TbdFs21U7dlo/8EJubhGhNRWuCXr8JAEhpGXj9W16BN2bFSbtFzx616FqsuBsSan4L8O
         iAcn3yi7XaLEQ1rX3prxa0GeLb6eR0qEeXgidXsV/QUna36aQZm54OS02G9fVglJyWsr
         ih8gyPJmKp6lI3wm3ZrpOh/23mPXsLPaWtF9nduHvvQchqONPG/I+Lc4pJXG4cHVh6Mi
         Zpww==
X-Gm-Message-State: AOAM532J9oC+Ia8aUUHdwEQGetSdhWbH9ha3H8Qt/yrS66PikriJs9Wm
        i7/cJamZDYXFqqOcXFN87vU=
X-Google-Smtp-Source: ABdhPJysZWDYiti6zOGHozpBpLpCQMimBfJ+6fKV7NxAxuJadZKyIhq1jWOOKnzVB4/vME2dS7GN0g==
X-Received: by 2002:a05:6830:4106:b0:5c9:6651:9333 with SMTP id w6-20020a056830410600b005c966519333mr10078188ott.183.1649610048700;
        Sun, 10 Apr 2022 10:00:48 -0700 (PDT)
Received: from ?IPV6:2603:8081:140c:1a00:8884:2210:b4d7:3f81? (2603-8081-140c-1a00-8884-2210-b4d7-3f81.res6.spectrum.com. [2603:8081:140c:1a00:8884:2210:b4d7:3f81])
        by smtp.gmail.com with ESMTPSA id r8-20020a05683001c800b005cdadc2a837sm11303044ota.70.2022.04.10.10.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 10:00:48 -0700 (PDT)
Message-ID: <aaec898e-08f1-03da-a0c0-34729df4f68b@gmail.com>
Date:   Sun, 10 Apr 2022 12:00:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Revert "scsi: scsi_debug: Address races following module
 load"
Content-Language: en-US
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
From:   Bob Pearson <rpearsonhpe@gmail.com>
In-Reply-To: <CAHj4cs8CRK==3+ssCSLWrC-1-jtp+=QAoaopN97GgFs5bWcbow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/10/22 08:15, Yi Zhang wrote:
> Confirmed the blktests srp/ issue was fixed with this revert:
> 
> Tested-by: Yi Zhang <yi.zhang@redhat.com>
> 
> On Sat, Apr 9, 2022 at 12:37 PM Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> Revert the patch mentioned in the subject since it blocks I/O after
>> module unload has started while this is a legitimate use case. For e.g.
>> blktests test case srp/001 that patch causes a command timeout to be
>> triggered for the following call stack:
>>

I also applied Bart's patch reverting the scsi_debug change. And find
that now blktest/check -q srp runs successfully and the trace does not
show the inconsistent lock state warning. So it looks to me that there
is not a current need to revert the remaining _bh locks in the rxe driver
to _irqsave locks.

But, as far as I know the root cause of those warnings, when valid, are due to
code that calls into the verbs APIs while holding _irqsave locks. If we want to
make that generally possible then perhaps we should just get rid of the _bh
locks in favor of _irqsave locks. I have a patch that does that if you think
it is needed.

Bob
