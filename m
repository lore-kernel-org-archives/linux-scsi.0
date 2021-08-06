Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4F3C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 19:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6256261165
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 19:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhHFTdQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 15:33:16 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:36402 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhHFTdP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 15:33:15 -0400
Received: by mail-pj1-f44.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so24255250pjr.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 Aug 2021 12:32:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=SMFpXbTbzf2/l//Kx6Te2PIFDzhB8slWmIuGsyu4OtPESLZnwzJTmQUfJY75N6/Q9H
         lbLvMl3VF5yagJvhlQ8zo+yujV3vkEk3xh6PdOOuZvTawps1ntMEh5Z6OE76vjdpEfRf
         dwEJnP+euFtFJW1RTPNQFdSYPQR5o1CtuYtPmEJjB8eBsnZ2xRx2NhPuW9IjyyTlQ1vw
         kxBDtjC4/YKj0g/U2nMxGfvc91G+HdH0GW4z+4azKMuJdW5/3CnZGPS3f+5H2Ct5pVB/
         nyTsI4UyODBev/kYgqXUuk4DV4ftZeviNojArhPrg2XztIVCnpXWkYZi4xmGOkWbjRES
         MurA==
X-Gm-Message-State: AOAM5337f99veXdagtFQOMUkWVJDPNXXeYEIHWHXuxrH7K9lNvReEvnP
        MvONtaT1f+9EHvjVHZqqkgc=
X-Google-Smtp-Source: ABdhPJxJyA23OkDYsw1XXgrzdf4Me3qUHgaqCObhNaKYmhE3prt9uLBEMCIcpfqFNg1hTuwzhb5TnA==
X-Received: by 2002:aa7:9828:0:b029:3bd:dc3d:de5f with SMTP id q8-20020aa798280000b02903bddc3dde5fmr12190848pfl.47.1628278377851;
        Fri, 06 Aug 2021 12:32:57 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:4a77:cdda:c1bf:a6b7? ([2601:647:4802:9070:4a77:cdda:c1bf:a6b7])
        by smtp.gmail.com with ESMTPSA id b204sm11732552pfb.81.2021.08.06.12.32.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 12:32:57 -0700 (PDT)
Subject: Re: [PATCH v4 08/52] RDMA/iser: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20210805191828.3559897-1-bvanassche@acm.org>
 <20210805191828.3559897-9-bvanassche@acm.org>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <823ffdea-df7b-af67-25e9-7a7c7878cc1d@grimberg.me>
Date:   Fri, 6 Aug 2021 12:32:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210805191828.3559897-9-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
