Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3C3C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 21:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00DFC61166
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 21:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbhKIVM2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 16:12:28 -0500
Received: from mail-pl1-f169.google.com ([209.85.214.169]:33549 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhKIVM2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 16:12:28 -0500
Received: by mail-pl1-f169.google.com with SMTP id y7so1002690plp.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 13:09:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tZHN1azO17LHNLfrG2Yw3KqzsUa+sVQT0GQ6pE0a+cE=;
        b=tb3zBX28HosbdlEpJOB1Hlq2IYpZBz/w2cORHaDyqvJDiHdumppUQKXpYzVVPs0JQ2
         xQBavYxu3JnRLDCTVuxDSzAz+Z/sMjd6a7fOFHP8YUBwnHz8Iy7UBqgW88UN/HJpKDAr
         u2iIVWY5CnVMGa3Ntar6kUpGvFQOo173xg0fbtY2Wr4d9Z7b98QM6yglX8EgGcMgqayp
         bttuSnq4jUixvFWXdPxOZ/p67nsrZBgU+UJhN2Mip3S7ets3xz5KGIgSG0AuoMSjbA/T
         SKhbh2YD8I87aMnSoWhqMUjvluZyhsona5a+JWw+gr/c8DgclHe6mysDsUYROGwu5onC
         Wi1A==
X-Gm-Message-State: AOAM530QM2YZJ9giY6UrgZIybnWNoNtm10eyGc048f2rhLyAvnz6ULmK
        Jj4gSHGyZjmiY+hNBxrhz/M=
X-Google-Smtp-Source: ABdhPJwUCEzW2d3ZdKoXVJqSXiNn0pwvbneN5ArSsbCZ1ugyaGYvlVzCUh6j6euEIg8G3vEWZ8Vovw==
X-Received: by 2002:a17:90a:f481:: with SMTP id bx1mr10973460pjb.117.1636492181162;
        Tue, 09 Nov 2021 13:09:41 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id t4sm20428010pfj.166.2021.11.09.13.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 13:09:40 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: core: Add support for reserved tags
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-2-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4266c58a-8a49-0ef3-d532-7aa1465571ae@acm.org>
Date:   Tue, 9 Nov 2021 13:09:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211103000529.1549411-2-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/21 5:05 PM, Bart Van Assche wrote:
> Allow SCSI LLDs to allocate reserved tags by passing the BLK_MQ_REQ_RESERVED
> flag to blk_get_request().

(replying to my own email)

Hannes and John, please help with reviewing this patch.

Thanks,

Bart.
