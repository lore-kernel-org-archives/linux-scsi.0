Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA5FC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B84F6121E
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbhDVQ3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:29:32 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:34686 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbhDVQ3Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 12:29:25 -0400
Received: by mail-pg1-f182.google.com with SMTP id z16so33200128pga.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Apr 2021 09:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0bW43a0s5kpbhnLFAW5m2OBcRVt4S8rVa0av4kVhF8Y=;
        b=Em09Ke5c1AjY4r0ZozLKtmuNDOp57IKwq8IoVH8e2rOh64nyZc0MfhvrZX1EBA2Sa2
         gjz8FhTXrbkugsIeC9HxnMTK7ZsCkYpyJ5mb/KVv/Dxp5njGmPr1boHmieD5MSDohh4A
         w2xuGTXjLE8S+HxzIxeg/oNlv0vjptdq0XSvzY6ki2rfXApIi5Vae7HH6EU1uTBTXqNt
         gJPahwn9tytDpBOzFbXBHt9BFHy1sVaDNe9blL3RzfpdFx/psudo2zmkDtqpU3SQ1asT
         D3KuF/wUeKDStAkF7QxJKdBjh3AZHPhyQjD2sJnbVg9KRIR75mRMt1HZxUiel3Nu7jTz
         zmNw==
X-Gm-Message-State: AOAM533dFYdrHjAXVTuCPeQdU6XSmLwV7jU7VKBloxglvI0Ry8G6CPrp
        uV03kaAsmxEXD0l+VLwBY5P2DXfIBY0=
X-Google-Smtp-Source: ABdhPJxsfx3IULqZTLHsIhLw5MoYxvEQh9YKhKvRufnZErYGmNG/CwGXvowrAVsl9G66P73UBS8zLQ==
X-Received: by 2002:a05:6a00:1a0d:b029:25f:7141:cb0 with SMTP id g13-20020a056a001a0db029025f71410cb0mr4198786pfv.44.1619108929267;
        Thu, 22 Apr 2021 09:28:49 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:ca3e:c761:2ef0:61cd? ([2601:647:4000:d7:ca3e:c761:2ef0:61cd])
        by smtp.gmail.com with ESMTPSA id y193sm2722877pfc.72.2021.04.22.09.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 09:28:48 -0700 (PDT)
Subject: Re: [RFC PATCH 00/42] SCSI result cleanup, part 2
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <d1f52383-8435-276c-b69a-39edca853ee2@acm.org>
 <6e79ed8c-f8bc-8f59-f1e1-82a9d734bcb4@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2a8fcc5f-d28d-6720-32d0-5efc68a2bd82@acm.org>
Date:   Thu, 22 Apr 2021 09:28:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <6e79ed8c-f8bc-8f59-f1e1-82a9d734bcb4@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 1:49 AM, Hannes Reinecke wrote:
> So the midlayer can be reduced to handling just the host byte and the
> status byte. Whether this is by means of a union or something else
> doesn't really matter; this patchset doesn't prevent any of this from
> happening.

Something that is important to mention is that struct scsi_request is
not only used by the SCSI code but also by the IDE code. Changing the
'result' member of struct scsi_request also affects the IDE code.

These are the SCSI and block layer calls in the IDE code that I am aware
of and that assume that a struct scsi_request immediately follows struct
request:
* scsi_req_init().
* scsi_cmd_blk_ioctl().

I have not yet tried to evaluate how much work it would take to split
the code in block/scsi_ioctl.c such that it supports different layouts
for the data that follows struct request for IDE and SCSI.

Thanks,

Bart.
