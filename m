Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9B5C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 03:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiDCDcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 23:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiDCDcO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 23:32:14 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B0232059
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 20:30:20 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so5990185pjo.2
        for <linux-scsi@vger.kernel.org>; Sat, 02 Apr 2022 20:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MZJhzECc53ueMVgylRVgdJ0EJxtrAxOYo3SD8SYm+ho=;
        b=CU+0EQD0oQ1Qp3pHqGm1pIreeyPS80AhUN/AiWilfBIqqDypxwaz1Em5czcHOACtl0
         nHm5LUIO6Kk7xML6UQox4LBqY6zhw3P0w2T6L+AAnEa5+Y9tUfJ6IMyNW76HIgZZnfzx
         /oIHnOMwmwXK49B5fvDlohDHvS7a5o9AZ8RcfT5E8DfmDkjrgscEXapFXoqxRdUD8Ki+
         GDgpxHkGzf1GhmIbxZ2kT5lxumqQOi2WmZMjC+GLH5WT/ba8J3XrNaPK/9bXGXUriYPv
         lxSd6qtsyBadAobrXjsnyPaD180uHmVotJjeS89E4Wkvz/6bJBa1vs3M33nj2uQPwgQr
         YhJg==
X-Gm-Message-State: AOAM530c3JLugNIlCCPJ0LynnxnrDMqPx5jWf7f07iXjevNPnGetvbZI
        mh4QlYY329ZXJ9w5l1ONhrw=
X-Google-Smtp-Source: ABdhPJzIrHZtouBzcPF06+PAAS6Hhcs46RdSedUrLKIOoJ+edM76xxkW7md51znz3Kwz5nkU7gZ5CA==
X-Received: by 2002:a17:90b:4ad2:b0:1c7:cee:b126 with SMTP id mh18-20020a17090b4ad200b001c70ceeb126mr19382788pjb.219.1648956619712;
        Sat, 02 Apr 2022 20:30:19 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j6-20020a63b606000000b003808b0ea96fsm6294207pgf.66.2022.04.02.20.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 20:30:18 -0700 (PDT)
Message-ID: <e1f04b46-4b09-91fd-b536-93bd25a690d6@acm.org>
Date:   Sat, 2 Apr 2022 20:30:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 03/29] scsi: ufs: Simplify statements that return a
 boolean
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-4-bvanassche@acm.org>
 <DM6PR04MB6575F201FD004FCF0140B87AFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575F201FD004FCF0140B87AFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/22 11:49, Avri Altman wrote:
>   
>> Convert "if (expr) return true; else return false;" into "return expr;"
>> if either 'expr' is a boolean expression or the return type of the function is 'bool'.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Maybe also add ufshpb_is_pinned_region()

Thanks for the feedback. I will take a look at that function.

Bart.
