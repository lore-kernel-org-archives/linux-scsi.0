Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285D8C3A59F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 16:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF9552070B
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 16:23:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gbn8r8pM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731288AbfHZQXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 12:23:15 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35027 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbfHZQXP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2019 12:23:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id n4so10926165pgv.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2019 09:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SBlAyJP5JKU0LICkQWok/5Qd9KtE6loCkSPvvitZeRo=;
        b=gbn8r8pMGnmxI94JaJ1ivwgHviqKFRQvfn8qovMbc7h3purJWhFWZVo8V4kCg4Pl0Z
         mIXiyQamr9/yTje7czmOdudVPLubpblRpkF4hCJODhp+IZYPO0vymyop2dU41N1vgbFj
         J3DDQJMwQOES1RCh5r6QSiCPJXinolo0l/jom+5U3WLxmBHRY/BGtYt4oBGsIkKlCHEO
         ptQAcga0g9MV+LEa4sdVGgHEU2K0FQ16So4bJFJoDjQ0iJckPPdwp7uBxzkQEtTuh9pe
         GoNsqOEQQSzDL1kaPfltaAS89+nKbAPUyanwbspztmtxYG4toXCCGG4NN+DflQOMI9bL
         Oeig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SBlAyJP5JKU0LICkQWok/5Qd9KtE6loCkSPvvitZeRo=;
        b=bqi18xC6ATWAGiraJtRuXv9RP5h2rR71aNPteI8CG+YINRTkDzMB/Zc5dwwA4UAHz6
         c3KSJ18/tViI2989Nu83CLF/UqctKGGcWrnU1wghKOQ2iE7v6fFTnnRMI72Sh/vYI0cf
         y5xfV5e1H5UgUjgLGabT8Km2wonoTxw5LJMIrEJHjE7z16uGTXjxyt7pkqFQglznR2ha
         cunsco/3+jEo6JFs+E2sC5RTvB7i5fT/8fI2/0dZcwutQSGlAxt2bH2dXIiYnWGhF8ei
         yxzDOLvdE6lXLyTL0x4o6dpk2Sbk8k2qpCEcRYbTar36FSYqa2CLiu9yisBnibB4oW1o
         yQnQ==
X-Gm-Message-State: APjAAAVPc4u9fikoyVKMCb1DSVknxUgHMIKw7a9m13gjh6CP7sd5No5T
        KXbjiG3TOg3M/Z/ggNtXdKE=
X-Google-Smtp-Source: APXvYqyun1qg58jfRUBvQph5SlLVAMtT9OXkTQ1IIBR1Ls4vtX112a82VJaK/3uUHtZxOoF5TXXyhA==
X-Received: by 2002:a63:1b66:: with SMTP id b38mr17284231pgm.54.1566836594626;
        Mon, 26 Aug 2019 09:23:14 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 65sm14030525pff.148.2019.08.26.09.23.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 09:23:14 -0700 (PDT)
Subject: Re: [PATCH v3] lpfc: Mitigate high memory pre-allocation by SCSI-MQ
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <jsmart2021@gmail.com>
References: <20190816023649.16682-1-jsmart2021@gmail.com>
 <517f8e7c-5984-5b72-4e32-d0d84ec90ea5@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <08a0d10c-8656-fdb0-0c28-a9fe60eb2549@gmail.com>
Date:   Mon, 26 Aug 2019 09:23:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <517f8e7c-5984-5b72-4e32-d0d84ec90ea5@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/26/2019 12:18 AM, Hannes Reinecke wrote:
> On 8/16/19 4:36 AM, James Smart wrote:
>> When SCSI-MQ is enabled, the SCSI-MQ layers will do pre-allocation of
>> MQ resources based on shost values set by the driver. In newer cases
>> of the driver, which attempts to set nr_hw_queues to the cpu count,
>> the multipliers become excessive, with a single shost having SCSI-MQ
>> pre-allocation reaching into the multiple GBytes range.  NPIV, which
>> creates additional shosts, only multiply this overhead. On lower-memory
>> systems, this can exhaust system memory very quickly, resulting in a
>> system crash or failures in the driver or elsewhere due to low memory
>> conditions.
>>
>> After testing several scenarios, the situation can be mitigated by
>> limiting the value set in shost->nr_hw_queues to 4. Although the shost
>> values were changed, the driver still had per-cpu hardware queues of
>> its own that allowed parallelization per-cpu.  Testing revealed that
>> even with the smallish number for nr_hw_queues for SCSI-MQ, performance
>> levels remained near maximum with the within-driver affiinitization.
>>
>> A module parameter was created to allow the value set for the
>> nr_hw_queues to be tunable.
>>
>> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
>> Signed-off-by: James Smart <jsmart2021@gmail.com>
>> Reviewed-by: Ming Lei <ming.lei@redhat.com>
>>
>> ---
>> v3: add Ming's reviewed-by tag
>> ---
>>   drivers/scsi/lpfc/lpfc.h      |  1 +
>>   drivers/scsi/lpfc/lpfc_attr.c | 15 +++++++++++++++
>>   drivers/scsi/lpfc/lpfc_init.c | 10 ++++++----
>>   drivers/scsi/lpfc/lpfc_sli4.h |  5 +++++
>>   4 files changed, 27 insertions(+), 4 deletions(-)
>>
> Well, that doesn't actually match with my measurements (where I've seen
> max I/O performance at about 16 queues); so I guess this is pretty much
> setup-specific.

Keep in mind, when we ran our benchmarks, the driver was still using 
per-cpu hdwq's selected by cpu #.


> However, I'm somewhat loath to have a cap at 128; we actually have
> several machines where we'll be having more CPUs than that.
> Can't we increase the cap to 512 to give us a bit more leeway during
> testing?

I'm fine if you want me to raise the max for the attribute. Keep in 
mind, if 0, it can go > 128 to whatever the cpu number is, assuming it's 
 > 128.

-- james

