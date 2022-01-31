Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA7DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 17:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380963AbiAaR27 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:28:59 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:38778 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380939AbiAaR2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 12:28:46 -0500
Received: by mail-pf1-f182.google.com with SMTP id e28so13455872pfj.5
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2022 09:28:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LWaZS0zyjYQgjJ9z1OeXTfoaF3uk4BZU8s6w18n3T+c=;
        b=cF/MVHyo+1x3LqPPtjuxegEzt+I87FajvOtQxquflV/GS4VbQEZwh3fsO4L+s8HqHo
         p2CpqHuVQp/aXtgJErDthQcJ2PQ3x8IVKu/GSdC5zlOXBKNSEMer12u/CHhn9XnDx4Sp
         xkQku2fua7vz3TiV1+nE2beLfnqR73RrZbHf0Ox6AcmupAP5vOUBWtTZysZRTkClDqc2
         +MAJmHsdFj5W6jCUWoPuMnq1qYIavJqTZVp0w0QTSlprj1lxSU8/YyPtyyzvDLUfES0A
         JO90yvjGTYjHS94mXl/g12nCNhxy+ra8gvVQlrGHVdeqvLP0ha9W8cS1iXS+xJEStx+9
         EuJQ==
X-Gm-Message-State: AOAM530/KdWlsYNt96sDgBZDA7hlKDIegFPckBQc4nBJcmvrCgFdVkZf
        c94IKUSqxD/nQbn9v8BP/F72Wz5/Qjwmbg==
X-Google-Smtp-Source: ABdhPJytCIdBcqJaNuDslpHoOYysWvXAEf18Z8KRjWsoxc3EHB4VHOgKsPgH56sVjYtEmB8L9geUdw==
X-Received: by 2002:a05:6a00:1256:: with SMTP id u22mr20637076pfi.41.1643650125181;
        Mon, 31 Jan 2022 09:28:45 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id k13sm20561906pfc.176.2022.01.31.09.28.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:28:44 -0800 (PST)
Message-ID: <3c101a20-bd46-ed1b-fa10-a54e07c671a1@acm.org>
Date:   Mon, 31 Jan 2022 09:28:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 32/44] nsp32: Stop using the SCSI pointer
Content-Language: en-US
To:     Masanori Goto <gotom@debian.or.jp>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-33-bvanassche@acm.org>
 <CALZLnaFmbbyPRwFUE_RfpxuxN95dfsaE5EKdTmnnUy-=+8Q9TA@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CALZLnaFmbbyPRwFUE_RfpxuxN95dfsaE5EKdTmnnUy-=+8Q9TA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/30/22 18:53, Masanori Goto wrote:
> This is my style, but I prefer retaining DID_OK, even though it's 0 -
> to make sure we fill the right field.  Could you retain the DID_OK <<
> 16 part?

Hi Masanori,

I will restore "(DID_OK << 16) |". Thanks for having taken a look at 
this patch.

Bart.
