Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79587C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 566F6611C1
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhDZDfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:35:37 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:44825 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhDZDfe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:35:34 -0400
Received: by mail-pf1-f180.google.com with SMTP id m11so38044240pfc.11
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:34:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wBLoONiuqZTTDDuWt8pcjE6BHBtpz0zht6KcQdqJmAE=;
        b=eYAVE+DGsdqS53rJUtO5IwdPQcLaDaVKa7ga5CMYNeeJf06pzk5LjEPeYmqKjCqorJ
         cbH7PZ5aR606q61CDTaeA0jAjfC/X4EUwb1h3ME9zGtuuuQe5bhUKSatM3svDfuv6f7/
         UuihhjS13rfgl41FLI8dCfLxGFZ1EB17U8IcgBuIypkGBX1g1QzBjxGFmH9eQM7YnC30
         ScxDvbMWzzie4dh0yH/iv6/H5t3zSetppjiZFT/9Zf52lnYEhwRfeLqSIq1wOcuwY2pX
         BZH6pa2HhpAtsEn8dUKZaKByR+YLCbOWiM6lUyfjmNpyx0ng87ltEoPbmCIZ+cZhdqMZ
         Hwyg==
X-Gm-Message-State: AOAM5327gpC+sAerwuqAMLMbzN9eUub0AqS3fCzOeWqvQ4ybCXb7vTbc
        z7UidZFGIk/x2ANoIzMUxSiBY5O0OmXTPA==
X-Google-Smtp-Source: ABdhPJxUajW3QWdAJJZz4dXBIhO99W/sISsrCOXSKZHjpGqpRUdhPxUeVdi5JMNnXAUbI+Dp5cN9Jg==
X-Received: by 2002:a63:a42:: with SMTP id z2mr15078935pgk.52.1619408092141;
        Sun, 25 Apr 2021 20:34:52 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 187sm9530829pff.139.2021.04.25.20.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:34:51 -0700 (PDT)
Subject: Re: [PATCH 07/39] scsi: introduce scsi_status_is_check_condition()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-8-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9be002bc-f306-d56c-a8e0-5ed9663d81cb@acm.org>
Date:   Sun, 25 Apr 2021 20:34:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> Add a helper function scsi_status_is_check_condtion() to
                                             ^^^^^^^^ typo
> encapsulate the frequent checks for SAM_STAT_CHECK_CONDITION.

[ ... ]

> +/** scsi_status_is_check_condition - check the status return.
> + *
> + * @status: the status passed up from the driver (including host and
> + *          driver components)
> + *
> + * This returns true if the status code is SAM_STAT_CHECK_CONDITION.
> + */

Shouldn't the function name and the description appear on the second
line of the kernel-doc header?

> +static inline int scsi_status_is_check_condition(int status)
> +{
> +	if (status < 0)
> +		return false;
> +	status &= 0xfe;
> +	return (status == SAM_STAT_CHECK_CONDITION);
> +}

No parentheses around the expression in a return statement please.

Thanks,

Bart.
