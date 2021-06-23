Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C40DC49EA6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 16:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2889B611C9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 16:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhFWQL6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 12:11:58 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:44898 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhFWQL4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 12:11:56 -0400
Received: by mail-pg1-f178.google.com with SMTP id t13so2143898pgu.11
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 09:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gj6dYb/dDvQS7990nnwYIw5LCj0RlqsWgicXodrjM8I=;
        b=osrru+BhZYxQV0KiQ7+3gKuoDi//TDU49nFoKlRnkanZS9tlJ6H3u0L4Ob0DZqxxKS
         fTpYX40xx5OW83BtFxb17AG0Q4rN/Hm+uS4YfW2Qf2Hf9namiWDc/HHWltuTv8RwpzZW
         M/HuiF58jLREQyRCtVqPgIYm1/YvprnhPy88DxkxKiOSJjCwzR0TNzxWKomy3D4t9zah
         TbMWnVIk1BzXc3D4yIsOeNDqoSnJEeU525YB2b9jrRhwBZhjjxJOA8FUwfFZfiZPzJM/
         vfIcvpEOIzzolfkzoEv2udV6uHy1DaNqjNEiHopCtFMSr0nFkc637+RxSyZC7CY3ruX7
         faOg==
X-Gm-Message-State: AOAM530ag5SaFJEid5P2rmC2udzV2+Avu2mHYpoqLXFGbL9Z1Ud/PDmK
        wegbE4vzXZHbd27VA/mJUxFffimc8+k=
X-Google-Smtp-Source: ABdhPJw/QhEJekMwkZcriLfurK8DAfsNMKWaSj374cMXFHnJCH5Fy8sS7auWvp00k0hzASDNRG2Fxw==
X-Received: by 2002:aa7:8d01:0:b029:2f0:88da:1821 with SMTP id j1-20020aa78d010000b02902f088da1821mr447542pfe.67.1624464576652;
        Wed, 23 Jun 2021 09:09:36 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p14sm346677pgb.2.2021.06.23.09.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 09:09:36 -0700 (PDT)
Subject: Re: [PATCH 03/18] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-4-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cf177d09-fb2d-fc9f-b0ee-cdd75360413f@acm.org>
Date:   Wed, 23 Jun 2021 09:09:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210503150333.130310-4-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/21 8:03 AM, Hannes Reinecke wrote:
> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
> +	unsigned int op, blk_mq_req_flags_t flags)
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +
> +	WARN_ON_ONCE(((op & REQ_OP_MASK) != REQ_OP_SCSI_IN) &&
> +		     ((op & REQ_OP_MASK) != REQ_OP_SCSI_OUT));

Consider using blk_op_is_scsi() instead of open-coding it.

Thanks,

Bart.
