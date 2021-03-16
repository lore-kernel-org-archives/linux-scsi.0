Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA44C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 20:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8E8464F80
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 20:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhCPUkc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 16:40:32 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:36030 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbhCPUkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 16:40:04 -0400
Received: by mail-pf1-f174.google.com with SMTP id x21so8335825pfa.3
        for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2021 13:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Okvb8hMlwqk0l3HamdbXOJzinK2go0wx3mk69axSKiA=;
        b=BCcc0eL2W2JH9SfEi4iRKmERy4n3cOQ9LRt7I+5u4Yl5DxY/RmS96wh+vDlu5iJJQy
         hQ1U74+b5V2YknzIcNMVVwbUK0e6mG8E5kaEhFzCbLI6E99F2DZtmya8gGxJldx/RB+a
         X1bB38Ff9rdYyA1DcZ1wmx3dmDfta4KEZLmMgq1selAGpsapRGGwsQwnM6ro14/+40gi
         VQ4fBST/3KBrEFBrhZUErTHf3Z/AsPWCQm4HvN5vRt/O9mSKcrDM6uVrDRbneE+VAGYS
         0KHSbABSooVTjuFfBvJgOj/HMsn7McJaVdHgYJowxDMApMY3xVUVEhE1TIirqDWmydwx
         VvJw==
X-Gm-Message-State: AOAM533VpINZHQKO62Bcuudbolvtf9njrECSthhkwry4N9/h1iijJ0RS
        O2f1IJ+beMBmlwOYHkgf1nA=
X-Google-Smtp-Source: ABdhPJzsPhq4x76vZTGXm9UbXaViL0LYTNye5tZ+GLYHn42TLMlVH4ajEAs6B4B5fAFM9HMIA2tqYA==
X-Received: by 2002:a63:fa4c:: with SMTP id g12mr1303552pgk.205.1615927203929;
        Tue, 16 Mar 2021 13:40:03 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b6b5:afbd:6ae4:8f83? ([2601:647:4000:d7:b6b5:afbd:6ae4:8f83])
        by smtp.gmail.com with ESMTPSA id m21sm17440426pff.61.2021.03.16.13.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 13:40:03 -0700 (PDT)
Subject: Re: [PATCH 7/7] qla2xxx: Always check the return value of
 qla24xx_get_isp_stats()
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-8-bvanassche@acm.org>
 <20210316084803.67if66dxxqs475f5@beryllium.lan>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <43062f93-20a9-9e38-8b17-b26c034d6072@acm.org>
Date:   Tue, 16 Mar 2021 13:40:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210316084803.67if66dxxqs475f5@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/21 1:48 AM, Daniel Wagner wrote:
> On Mon, Mar 15, 2021 at 08:56:55PM -0700, Bart Van Assche wrote:
>>  		/* reset firmware statistics */
>> -		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
>> +		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
>> +		WARN_ONCE(rval != QLA_SUCCESS, "rval = %d\n", rval);
> 
> ql_log() instead of WARN_ONCE? The function uses ql_log() if
> dma_alloc_coherrent() fails a few lines above.

Hi Daniel,

I will make that change.

Thanks,

Bart.

