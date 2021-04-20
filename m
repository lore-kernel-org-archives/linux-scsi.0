Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFE2C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 16:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5F1613D4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 16:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhDTQpQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 12:45:16 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:45054 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbhDTQpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 12:45:15 -0400
Received: by mail-pl1-f169.google.com with SMTP id y1so4331579plg.11
        for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2021 09:44:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cgMzMaqgmsp3/nctA1zgx8mU48oyJid6bUjYcUqW50U=;
        b=rhajTLEs3n8OOYWs6+roLWoQiXOS4DsTngVUC1SV20HUnFW/YxnDFKy5W9r+whOMST
         3foUtIGSXl/qzKtp8DtZafjrB7S3qxBMtjUBnZmeL9taAmbFGSHYpkT0ySbHnXGeZq5H
         wy5i6Xu84rpT5s5eixaYXGDg3U0+c2+Xqvts3Ne2ADAG97cQC3esWQcoWul8EBWr01iC
         XajZdK/iO5S1/b+itIQJ/HuYaY8OTxL+hlO0myPmf+wlACNhBuK3/5YafA68kHgseI2T
         Y3jWuAKWSIJ+eyoA5pi9jVds4R8/S6/PJ4jO6GSTx5XN/o+vxNjJhRLjL0/Uqumc51dY
         nYcA==
X-Gm-Message-State: AOAM5307T3T9Ui64FlUriXl16JN5/SD2ZZBMjCfcJjtkE6QcLKLxHDsL
        s1+wGU5xd+ldszqU93jv4LI=
X-Google-Smtp-Source: ABdhPJw8t7Uv7YWOPGxI/UTXN1LFCUx73H6HrzlW1UgleKrBAc70DklsPvlLlX3tECwx4/wnVcreLw==
X-Received: by 2002:a17:902:8f8d:b029:ea:e059:84a6 with SMTP id z13-20020a1709028f8db02900eae05984a6mr30204610plo.35.1618937084029;
        Tue, 20 Apr 2021 09:44:44 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b389:6c06:5046:89e? ([2601:647:4000:d7:b389:6c06:5046:89e])
        by smtp.gmail.com with ESMTPSA id x22sm3666963pgx.19.2021.04.20.09.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 09:44:43 -0700 (PDT)
Subject: Re: [PATCH 075/117] nfsd: Convert to the scsi_status union
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bruce Fields <bfields@fieldses.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-76-bvanassche@acm.org>
 <67BD8DEF-7C29-458A-9135-6602192594D4@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8775e8c9-49cf-c3eb-0933-8029494f2ff8@acm.org>
Date:   Tue, 20 Apr 2021 09:44:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <67BD8DEF-7C29-458A-9135-6602192594D4@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 7:36 AM, Chuck Lever III wrote:
>> On Apr 19, 2021, at 8:08 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>> An explanation of the purpose of this patch is available in the patch
>> "scsi: Introduce the scsi_status union".
>>
>> Cc: "J. Bruce Fields" <bfields@fieldses.org>
>> Cc: Chuck Lever <chuck.lever@oracle.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Hi Bart, I assume this is going into v5.13 via the SCSI tree?
> Do you need an Acked-by: from the NFSD maintainers?

Hi Chuck,

Thanks for having taken a look. In case you would not yet have found the
"scsi: Introduce the scsi_status union" patch, it is available here:
https://lore.kernel.org/linux-scsi/20210420000845.25873-12-bvanassche@acm.org/T/#u

An Acked-by or Reviewed-by from an NFS expert would be great.

The names in the Cc: list come from the following entry in the
MAINTAINERS file: "KERNEL NFSD, SUNRPC, AND LOCKD SERVERS".

Bart.
