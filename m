Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8229EB64D8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 21:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbjFNVrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 17:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjFNVrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 17:47:03 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6017B2689
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 14:47:02 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6668950b6c0so336356b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 14:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686779222; x=1689371222;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kft6/a03c9zrFaWsqvSQq6avClcNfxsxpXF8EpvvZqM=;
        b=HT+2Rtr+DuPyMv9Exn9JkNM7sWLaySXhS6sHJFQ3tUATDD7Oexgg189PrhN08M+Zzr
         F+tcKXZsUbqncPwIxjRrY4xX40tqeRBiQW1HBRD32UXD4L/BSqiiSUJ9xsHTMB6x4K9L
         cECUElZ4Gs1D6ACUYZYM4AY+siqnZ1OUe95NnluhWcw9toDY/dXZLWxme+JjgR30K21d
         5p3/+JQodqWc97X8pEC4lF52IqComEaU8ksGQvJH/aBGZAJnhKOP06KFdkz2GzSKAcU/
         I79b2W3y2VeUpXYUW8WQ+TJiu1f050cla2YBWvdC1lpTs8n8kLQf2OIg1WdrEAvEg1Nn
         YDMw==
X-Gm-Message-State: AC+VfDwAwrxzYV4zZNGA0TTr8iHjquPEajICM7lNhDd4piPbxqkuFIBt
        JYhS1a54T1LNqJdB8c0qTdQ=
X-Google-Smtp-Source: ACHHUZ5bd1fCdE59z4S3L5QWctNuvjrYBx2Uh86sEVpHI3iWUK5GiMywUmWjKc4F7N4snajHf5pABg==
X-Received: by 2002:a05:6a00:1415:b0:64d:4412:9923 with SMTP id l21-20020a056a00141500b0064d44129923mr3707684pfu.3.1686779221680;
        Wed, 14 Jun 2023 14:47:01 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id x7-20020aa793a7000000b0065da94fe917sm8963172pff.36.2023.06.14.14.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 14:47:01 -0700 (PDT)
Message-ID: <e576431b-7196-fdf6-9dbd-cb7630d4c8ff@acm.org>
Date:   Wed, 14 Jun 2023 14:46:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v8 15/33] scsi: spi: Fix sshdr use
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230614071719.6372-1-michael.christie@oracle.com>
 <20230614071719.6372-16-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230614071719.6372-16-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/14/23 00:17, Mike Christie wrote:
> If scsi_execute_cmd returns < 0 it will not have set the sshdr, so we
> can't access it.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_spi.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
> index 2442d4d2e3f3..2100c3adb456 100644
> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -126,7 +126,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
>   		 */
>   		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
>   					  DV_TIMEOUT, 1, &exec_args);
> -		if (result < 0 || !scsi_sense_valid(sshdr) ||
> +		if (result <= 0 || !scsi_sense_valid(sshdr) ||
>   		    sshdr->sense_key != UNIT_ATTENTION)
>   			break;
>   	}

Hmm ... why is this change necessary? If result == 0 and args->sshdr != 
0 then scsi_execute() has called scsi_normalize_sense(). The first 
function call in scsi_normalize_sense() is memset(sshdr, 0, 
sizeof(struct scsi_sense_hdr)). Does this mean that it is safe to access 
the contents of sshdr if scsi_execute_cmd() returns 0?

Thanks,

Bart.
