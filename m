Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABF7C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 16:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F32761373
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 16:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbhJDQZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 12:25:26 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:41677 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbhJDQZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 12:25:25 -0400
Received: by mail-pl1-f181.google.com with SMTP id x8so245083plv.8
        for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2021 09:23:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rFapn0aQFjtU8selLedyI5d7R8dHOeQJhqftHag7ujA=;
        b=k0eTTZrIusAxbbtoSc9FKx63ri/Yc7BLe+26fsu3dUKgxtxnSyReWqoeCH/2VD8jq2
         bhbrGoIKLv6cvNUsBpyyDn4TdX5uWRhtz2/VcewJnlNOv0TpS1Jc0kVD4Tl9Rpv3y8zk
         or6ZBmjwo6JPotDVAQNC1z8bYp3xEHG++Woe+JziFUSIoGPakAsLuRrM5/uf6YvKcRpO
         BIJpEH2Y26uSPW8mZ/jyHdlT7E/V3lbS5Xg0y7B4FgltGyOwTbzt+/Z87wMDYUb6fsCO
         erKGDjHFy67d6yneSe4qJt6UTgL/6+MpIKAy+6ejtwnsaimTIqixClB+NUdQZoIRwVuK
         TusA==
X-Gm-Message-State: AOAM530cpZ13Z32Q8TcCl+sYW5rdMzdMQCFvs5Zi1MHTxgwsKKEkOizW
        tLI8RWYSrznRPkKE7xDiMZ8=
X-Google-Smtp-Source: ABdhPJwFZJUJMtVSdMaXLaygU8xuLiYe3j7CtLnnYKeSW2vKSxPzrfilzvtSZck5ppJvGrdbrtvMPw==
X-Received: by 2002:a17:90a:f287:: with SMTP id fs7mr10060165pjb.98.1633364616430;
        Mon, 04 Oct 2021 09:23:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:1e3d:a218:87c6:1612])
        by smtp.gmail.com with ESMTPSA id t14sm14441650pga.62.2021.10.04.09.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 09:23:35 -0700 (PDT)
Subject: Re: [PATCH v2 28/84] dc395x: Call scsi_done() directly
To:     Oliver Neukum <oneukum@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-29-bvanassche@acm.org>
 <0b774aaf-1981-2934-adfa-c1d50e43386d@suse.com>
 <71cbada9-f98f-316a-9a58-04b4555234fd@acm.org>
 <0d29b6ea-0590-0c8e-e4d3-67c1f2c861e7@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9391106c-6142-3b49-7021-5d73f9029e36@acm.org>
Date:   Mon, 4 Oct 2021 09:23:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0d29b6ea-0590-0c8e-e4d3-67c1f2c861e7@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/21 2:44 AM, Oliver Neukum wrote:
> 
> On 30.09.21 18:04, Bart Van Assche wrote:
>> In other words, the 'done' argument can be derived easily from the
>> SCSI command pointer.
>> Do you want me to include a patch in this series that removes the
>> 'done' argument from
>> the queue_command_lck() functions?
>>
> Yes, if we pass a pointer, we should use it. If we should not use it, we
> should not pass it.
> Then the SCSI people can look at a patch and decide that issue.

Hi Oliver,

I will include a patch in the next version of this series that removes the
'done' argument from the queue_command_lck() functions.

Bart.
