Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0749C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 726BB613C9
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhEDCxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 22:53:32 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:36622 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhEDCxc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 22:53:32 -0400
Received: by mail-pf1-f177.google.com with SMTP id p4so5998364pfo.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2021 19:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZjlRH6Scu8aBIHJjrLyXzMX0oSku2qO2O1nqDgpKJp4=;
        b=H9BA3WAX7i0DoDRPMQU0bgO5N2D1OqbgjdDnGuLs0h2b01f+Y+0FhOhUXzd0HVlP08
         jcXDsnh8W305QMimZkMygF0mEWNu1tictzrJgVyi8spqfEGXUKkIw1FVzxVGuout5LOp
         uEcZSx3ESYV7V0lW2SLVjzgTPZlkR4SsbfYp6pr+3hfZmfMqMadl4vnJFw/RXILUQaAE
         l8WxQH2BEe1cd8N5ms2aBvyGQ1n0QjlR6EK5ioUqNmb697mcSFtoPm7W8t2sEUvtdUGg
         CPjtZFWrBtJzjw9RC3zxzq0dbKrTbHwRl3usH/W3uEvZYS/85T+DIv2Y5zhG4Bw+atOz
         Ooqw==
X-Gm-Message-State: AOAM531+1P+0lMdwFp68bBWExeZKLqlTVKVCovNMu+LMimVw9AMPNWt8
        3kj9/7y+kvHyQUg2RhOZBcf6eP8mIlM=
X-Google-Smtp-Source: ABdhPJxWJwTbnQ9vHhC36bAIbrLf6wb5Lzu2j5LT3twnjD1YrAWtSFn5Oy29CWcpvtPGVHzph3Ca5Q==
X-Received: by 2002:a17:90a:488a:: with SMTP id b10mr24722912pjh.2.1620096756168;
        Mon, 03 May 2021 19:52:36 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6b81:314d:2541:7829? ([2601:647:4000:d7:6b81:314d:2541:7829])
        by smtp.gmail.com with ESMTPSA id u14sm1240673pjy.6.2021.05.03.19.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:52:35 -0700 (PDT)
Subject: Re: [PATCH 06/18] scsi: Use dummy inquiry data for the host device
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-7-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <07a29507-c33d-8385-d41b-dc7983617862@acm.org>
Date:   Mon, 3 May 2021 19:52:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503150333.130310-7-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/21 8:03 AM, Hannes Reinecke wrote:
> +/**
> + * scsi_device_is_host_dev - Check if a scsi device is a host device
> + * @sdev: SCSI device to test
> + *
> + * Returns: true if @sdev is a host device, false otherwise
> + */
> +bool scsi_device_is_host_dev(struct scsi_device *sdev)
> +{
> +	return ((const unsigned char *)sdev->inquiry == scsi_null_inquiry);
> +}

No parentheses around the expression in a return statement please.

> +EXPORT_SYMBOL_GPL(scsi_device_is_host_dev);

Does this mean that this function will be used outside the SCSI core?

Thanks,

Bart.
