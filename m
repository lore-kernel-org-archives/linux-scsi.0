Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4E1C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 108E16140F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhDUVHH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 17:07:07 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:36458 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243870AbhDUVHG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 17:07:06 -0400
Received: by mail-pf1-f182.google.com with SMTP id c3so11278100pfo.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 14:06:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BkI8BfjpXO3l8P3X/V8S4ceOhfswcB8eaat6+seP+ak=;
        b=QSJOIx0o9OF97nVYD720/Fy6O2OgPeakgp1jD/8utN1qAbvqsCde3rbXLzaoYWGvBw
         ROFO8Rm+P9vOjetprB9UQMIo4RqSK/htHNXEbbtTm5vPUbgEZjxdonmKeEV8Ra0XdS6j
         8Kv7qpDGTW3euUEVhJ3wd2T8zFr5dzWYwJCXDvMZCFKVI6/qso3HY4tMFN7KfqNVXYhw
         7EsmYs3ISYgOXncgSwBDSh97Sv+Bx6Nk3cE0jq63Bkx2vDpLhjiHYyVhz2+msRCdcmWt
         f/1Mx3XBMiWlSK+c7wbjurWOwKVqx3nDQLyjTOXAs535Bh4CDBBCmw95D44YCArEEtSD
         UkgA==
X-Gm-Message-State: AOAM533bactUEtcSnMa+houg4DWUVvEpsGu9FD9H37wBbxaYvov4E+lx
        /HqD3v1d5hZE9cIu4gkfAfWyKcotUMkxYw==
X-Google-Smtp-Source: ABdhPJw3Mzu0vXLGuKkULyxH8Hf2aKbTlEKj1U7ZM7ERhGBqem/dlH9D4Oe4B6Tq9Rkp1+1qDvHQUA==
X-Received: by 2002:a63:4758:: with SMTP id w24mr95720pgk.33.1619039192753;
        Wed, 21 Apr 2021 14:06:32 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p22sm2918452pjg.39.2021.04.21.14.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 14:06:32 -0700 (PDT)
Subject: Re: [PATCH 07/42] scsi: Kill DRIVER_SENSE
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-8-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b365b179-c82c-57fc-1b4c-32bfbe003672@acm.org>
Date:   Wed, 21 Apr 2021 14:06:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> index 6a5b844a8499..2b6138a7c71f 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -2299,8 +2299,7 @@ megaraid_mbox_dpc(unsigned long devp)
>   				memcpy(scp->sense_buffer, pthru->reqsensearea,
>   						14);
>   
> -				scp->result = DRIVER_SENSE << 24 |
> -					DID_OK << 16 | CHECK_CONDITION << 1;
> +				scp->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
>   			}
>   			else {
>   				if (mbox->cmd == MBOXCMD_EXTPTHRU) {
> @@ -2308,9 +2307,8 @@ megaraid_mbox_dpc(unsigned long devp)
>   					memcpy(scp->sense_buffer,
>   						epthru->reqsensearea, 14);
>   
> -					scp->result = DRIVER_SENSE << 24 |
> -						DID_OK << 16 |
> -						CHECK_CONDITION << 1;
> +					scp->result = DID_OK << 16 |
> +						SAM_STAT_CHECK_CONDITION;
>   				} else
>   					scsi_build_sense(scp, 0,
>   							 ABORTED_COMMAND, 0, 0);

Since DID_OK == 0 I prefer to leave out the 'DID_OK << 16' expressions 
from code that is modified.

Thanks,

Bart.
