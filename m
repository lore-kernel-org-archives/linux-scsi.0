Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF08BC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91736613AA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhEDDNc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 23:13:32 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:36636 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhEDDNc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 23:13:32 -0400
Received: by mail-pf1-f180.google.com with SMTP id p4so6037690pfo.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2021 20:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2z3F00TrO/MBQolzD6KCHbH4dAxKJL4Nesw5N5wsETQ=;
        b=J+5YWjpfbIJYxQNYVzvQB6dAQ+O4OdZszQw/+SySqNwyRNhpmzXdLB5z3gFYnOwGDz
         fRNzs9MCU16DhVyDiPb2FsCNUXyibSd6lqFppRe2q9te5XHMEYL69PMy1CVeW3OTvPhI
         b3VzpLhKiZUWJ4R5Xsam73gAV3/QlNKfQGZRpJbedjCgFgP0wSYS46b6pGkDKe9nk7gX
         PuJMqJ+cbeNjcHTnKOfvVq90XsKQ1XH0vrrnQ+xNeFGPr4peubVci6rIPC34MxGsK3vT
         JL4RACYbhfOlu2+JrKgT8NcBPQgkbvzwh60mfLTqMmUWBJT+Kys1ZqnpVL24AL2BVmTG
         8b7w==
X-Gm-Message-State: AOAM532+6J+S2cCAon/49Un9+Cf+duH7B77Tpr9R7n3yd/lNC7njNV+j
        decLWkOx0ZKKkmQ+I+Xzb0SI8Af1glw=
X-Google-Smtp-Source: ABdhPJzTnnoN7u8nbD7ksFnji0Y2PhXNrZzYteKMXuODt9vk7JFIxkqzvvhs1UOYvAq+DR4VPR3C8Q==
X-Received: by 2002:a65:6386:: with SMTP id h6mr19479862pgv.67.1620097956629;
        Mon, 03 May 2021 20:12:36 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6b81:314d:2541:7829? ([2601:647:4000:d7:6b81:314d:2541:7829])
        by smtp.gmail.com with ESMTPSA id d6sm3635565pjg.35.2021.05.03.20.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 20:12:36 -0700 (PDT)
Subject: Re: [PATCH 08/18] snic: use reserved commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-9-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c99e0b3c-ba06-db4b-1405-2b8ecbba9eab@acm.org>
Date:   Mon, 3 May 2021 20:12:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503150333.130310-9-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/21 8:03 AM, Hannes Reinecke wrote:
> @@ -2170,42 +2144,42 @@ snic_device_reset(struct scsi_cmnd *sc)
>  		goto dev_rst_end;
>  	}
>  
> -	/* There is no tag when lun reset is issue through ioctl. */
> -	if (unlikely(tag <= SNIC_NO_TAG)) {
> -		SNIC_HOST_INFO(snic->shost,
> -			       "Devrst: LUN Reset Recvd thru IOCTL.\n");
> +	reset_sc = scsi_get_internal_cmd(sc->device, REQ_OP_SCSI_IN,
> +					 BLK_MQ_REQ_NOWAIT);
> +	if (!reset_sc)
> +		goto dev_rst_end;

The SCSI error handler may call .eh_device_reset_handler and other error
handling callbacks if no tags are available. If no tags are available,
scsi_get_internal_cmd() will fail. If scsi_get_internal_cmd() fails,
snic_device_reset() will fail. Does that count as a regression?

Thanks,

Bart.
