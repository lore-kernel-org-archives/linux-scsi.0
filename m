Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E481DC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B11F36128A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhDZDmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:42:09 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:37379 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhDZDmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:42:09 -0400
Received: by mail-pf1-f175.google.com with SMTP id y62so5401364pfg.4
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vippA1P7dNBm5tmvMpRTRUeTwjg/CK/QjKsV4Di2p3o=;
        b=LloajtEnKTYYHRqS4IHXNutPYSh49HuSQQeXI/ECc6H6byfS+Dhgf7SnZzfvBkxrzD
         /Ly3da3DTMUHrNU/4A/ETaXJcXI+BXHKUoTIHnLTsd/iOZewSqKen6wBPC+LUwCQq4hR
         fA7vtl3Gi1PlF6xC65pSC5N4ADDgaBNr1WteX2f7EI0/tgU2vClgI8+539LEZYzzG4g+
         8Jc5gAeBfTOaLq01GTqycaN0PKh5A4NU9fvgn1zM6av5Sx5NfxZyE1ImipVP+600vrVy
         cKbIdmqarIKzMZxigsDhf/HmjE6mDE9XsDNgaECl+Is3aS35Alsqp55gQsR/R3kRNgPa
         XIgg==
X-Gm-Message-State: AOAM531wqYn4Rsp46cfJEjY3wQiKVOE0ZM0RMCLISXuehe3xlY6xbvpY
        dY+OqjAkQC4FcpK3hYi9wl0G6D+Wjj8PUw==
X-Google-Smtp-Source: ABdhPJxPaHjqR+JazW0qBv58BcA+WHMvjBe+MIg0RRCBEqMlbClsADWxKSJsQFxTuTwQW5okG8mb4A==
X-Received: by 2002:a62:8f4a:0:b029:241:fc67:d425 with SMTP id n71-20020a628f4a0000b0290241fc67d425mr16306801pfd.21.1619408486287;
        Sun, 25 Apr 2021 20:41:26 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d132sm9556457pfd.136.2021.04.25.20.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:41:25 -0700 (PDT)
Subject: Re: [PATCH 08/39] scsi: Kill DRIVER_SENSE
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-9-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f7c35ab2-bfca-99e1-54d3-d869957f134d@acm.org>
Date:   Sun, 25 Apr 2021 20:41:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-9-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> Introduce scsi_status_is_check_condition()

Wasn't that macro introduced by patch 07/39?

> For backwards compability move the DRIVER_SENSE definition
                ^^^^^^^^^^^
                  typo?

> diff --git a/block/bsg.c b/block/bsg.c
> index bd10922d5cbb..a70bb25ab906 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -97,6 +97,8 @@ static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
>  	hdr->device_status = sreq->result & 0xff;
>  	hdr->transport_status = host_byte(sreq->result);
>  	hdr->driver_status = driver_byte(sreq->result);
> +	if (scsi_status_is_check_condition(sreq->result))
> +		hdr->driver_status |= DRIVER_SENSE;

If another value is already present in the driver_byte(), will |=
DRIVER_SENSE corrupt that value?

> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 99d58786e0d5..e59e1f70f3a5 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -257,6 +257,8 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>  	hdr->msg_status = msg_byte(req->result);
>  	hdr->host_status = host_byte(req->result);
>  	hdr->driver_status = driver_byte(req->result);
> +	if (hdr->status == SAM_STAT_CHECK_CONDITION)
> +		hdr->driver_status |= DRIVER_SENSE;

Same here: since "driver_status" is not a bitfield, "|=" seems
conceptually wrong to me.

Thanks,

Bart.
