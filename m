Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF5CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 02:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBE9860EFE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 02:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhJLCcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 22:32:32 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:44810 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbhJLCcc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 22:32:32 -0400
Received: by mail-pj1-f44.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so1386835pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 Oct 2021 19:30:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yFWZkloiIB4xqIesCAkRmaPN9vgf197vl7uQ4Dcu1tY=;
        b=wbZGbYGHr0P7QQ57PzbreUcSo8HdhkrHMR6WfTQDxMXIrL4mSlYoClwFl1Y57u7rm2
         jeflrJWNscxMlp7CTRbN+uk4TJQcDIN8NqlQ1lHaUnjWiqCVVY5yxFfYkrhxjn1UkShK
         0mxW47p3zFjdbTZWdJCPaKg1kpEjBo2YQUqp2UvVz5igzpnm5QNrXTghXNcKfYKsHZXT
         6nynUmvE11P23wy9jr+q/B5k7Z1510l6h5PclNlVNYrw1e4DQXw7uQTXJwTjSTvl+0nL
         Pf5UmOoqSSvSchxEtXaJg+OGqB0Sa2zUQ09QBJBmSohm5m31gvdRoA2WMmH1qWruteXn
         ZLwQ==
X-Gm-Message-State: AOAM532iLlth5FozZzDuWWUW+mfBtQ+5byyjZ2/TvB8JDAZikWrWaYGI
        mbDx909VxclofItAhlDlJyf/QXeKNx0=
X-Google-Smtp-Source: ABdhPJzQdFvROASC5TLsqgq60N/8n5iGTItHOldHO6F8uzcC3/FbnJq8XKqi4qHGf6donz7GtCtyZg==
X-Received: by 2002:a17:90a:3b49:: with SMTP id t9mr2952655pjf.218.1634005830269;
        Mon, 11 Oct 2021 19:30:30 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:aa63:4147:6517:753b? ([2601:647:4000:d7:aa63:4147:6517:753b])
        by smtp.gmail.com with ESMTPSA id p17sm721089pju.34.2021.10.11.19.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 19:30:29 -0700 (PDT)
Message-ID: <e58aab50-3fdd-9c87-297e-1e88e3be63e0@acm.org>
Date:   Mon, 11 Oct 2021 19:30:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re:
Content-Language: en-US
To:     jejb@linux.ibm.com, docfate111 <tdwilliamsiv@gmail.com>,
        linux-scsi@vger.kernel.org
References: <20211011231530.GA22856@t>
 <3d3ea15a938acca44e1e522ff06129dbcedfc30b.camel@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3d3ea15a938acca44e1e522ff06129dbcedfc30b.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/21 18:23, James Bottomley wrote:
> On Mon, 2021-10-11 at 19:15 -0400, docfate111 wrote:
>> linux-scsi@vger.kernel.org,
>> linux-kernel@vger.kernel.org,
>> martin.petersen@oracle.com
>> Bcc:
>> Subject: [PATCH] scsi_lib fix the NULL pointer dereference
>> Reply-To:
>>
>> scsi_setup_scsi_cmnd should check for the pointer before
>> scsi_command_size dereferences it.
> 
> Have you seen this?  As in do you have a trace?  This should be an
> impossible condition, so we need to see where it came from.  The patch
> as proposed is not right, because if something is setting cmd_len
> without setting the cmnd pointer we need the cause fixed rather than
> applying a band aid in scsi_setup_scsi_cmnd().

Hi James and Thelford,

This patch looks like a duplicate of a patch posted one month ago? I 
think Christoph agrees to remove the cmd_len == 0 check. See also 
https://lore.kernel.org/linux-scsi/20210904064534.1919476-1-qiulaibin@huawei.com/.

Thanks,

Bart.
