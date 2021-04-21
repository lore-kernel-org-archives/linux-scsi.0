Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB8AC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 22:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58DEF611F1
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 22:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhDUW05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 18:26:57 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:42972 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbhDUW05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 18:26:57 -0400
Received: by mail-pf1-f181.google.com with SMTP id q2so260271pfk.9
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 15:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G2lUuhU9UKErsdxHrtzcdYd5TFDIqpHJafUda3w20yA=;
        b=KxtOAN5EGRk1RHPlr/hJl/IhICTvvvDlSbGnU5NU7hph1X9xFB4SYeKwHy54VkJJnO
         ntiz2JP/x9fbHpQOvRNnreOmnqlLPYq1bPXtEx8rnTT0JSppkqxA6MQrPi1gk1Kf7DvL
         SRhIiaZLJM+0sqbvOIoh2QvW8DkQqZHF7gh8+89cwT5nT4ni1j/HJc4XUiTUD6SSJC0h
         WKNnhVsvjhRBJkBxgiDQRTiU75yJjWnkmOIWAIggEna7GhZhU0tXJnT+fn5C5q5pZfNR
         ia6eFHro3WM4CO+7QHmJZOqW6Ug4x99Wrxv+TWryMoKjqlOJW33xSlkMnW1JquY8dGTA
         JqaA==
X-Gm-Message-State: AOAM532q9ONBqvLWJAGK+Oa5r8oStSSr2gXIfN8W3uxQq0Kora78uA7G
        htFv7vYLXhg2+/2AF496P6eubUKG+meifQ==
X-Google-Smtp-Source: ABdhPJzcezbjxklJkIU+4Qt1uounMx7yxjFV1OcTWMnTrZEweiCrpGhENCjT/HXjFf+epD6Fj6RWEQ==
X-Received: by 2002:aa7:904e:0:b029:25a:4469:222a with SMTP id n14-20020aa7904e0000b029025a4469222amr202315pfo.72.1619043983107;
        Wed, 21 Apr 2021 15:26:23 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id q6sm254702pfs.33.2021.04.21.15.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 15:26:22 -0700 (PDT)
Subject: Re: [RFC PATCH 00/42] SCSI result cleanup, part 2
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d1f52383-8435-276c-b69a-39edca853ee2@acm.org>
Date:   Wed, 21 Apr 2021 15:26:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> My plan here is move every driver to use accessors for the
> remaining bytes in the SCSI result, and with that move the
> SCSI result over into two separate values.

This patch series modifies scsi_execute() such that it either returns a 
negative Unix error code or a positive SCSI status value that includes 
the host byte and status byte. I think that a union is a good way to 
model such return values. I'd like to use something similar to the 
scsi_status union from my patch series to model such return values. I 
think that union is also appropriate as a replacement for the 'result' 
member of struct scsi_cmnd.

Thanks,

Bart.
