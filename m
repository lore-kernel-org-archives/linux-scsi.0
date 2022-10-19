Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FD5C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 22:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiJSWGF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 18:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiJSWGE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 18:06:04 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0A817FD4B
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:06:03 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id f9so80006plb.13
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 15:06:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C6s5ECPxe3Aqh2gGSYd9JKvVyBU8iq3n7oHfheGqDDQ=;
        b=UETOVxUdvFsY4fkyfDxIitETrdDhEGi7C8rRlkYeLKye0eLXZJdjDavXqESp09u2Xq
         qqG1Luzh//HNt6t+5hMciikReb5KI7g8550SRs+r2oBGbdtMJkYIVL5Kn04A/z+J3kBz
         73yw8c3Rcnj8pIhc31pYMu/qEWallFx2zQpIvEtclIsmjweNAWv8mFkjUzjZIsqgmMw7
         TeiGzPBsxhbBR351gDcVcv6SKpXBJwNFtREHNLhVzJXiCqkBq2kVcRfGP013ka6aqjWy
         pEA5SBt16w2rA0B3UhH1cZnS4do8gNxj52/D1DQ6IPBMInGFe2SyrO9MHsqX7WjqlBiF
         C7Bg==
X-Gm-Message-State: ACrzQf0P6wKlguia0/X1v1zc1s9fFnlrPC59EK9GiFGHhNupkrDedYdq
        U2D6YCnLHV7HkMhSoKCSXzo=
X-Google-Smtp-Source: AMsMyM6CaXPa0w3fv38WsP4Cs21jouOxtp29ulTZLF+1o4iJqRj5rCsbVRfJZyBth0SmsRt+L+RpkA==
X-Received: by 2002:a17:903:2cd:b0:182:f36b:31ef with SMTP id s13-20020a17090302cd00b00182f36b31efmr10425284plk.171.1666217162783;
        Wed, 19 Oct 2022 15:06:02 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8280:2606:af57:d34? ([2620:15c:211:201:8280:2606:af57:d34])
        by smtp.gmail.com with ESMTPSA id x17-20020a17090300d100b00182a9c27acfsm11014696plc.227.2022.10.19.15.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 15:06:02 -0700 (PDT)
Message-ID: <01d9407a-26d1-e00b-8e52-04760af4b65a@acm.org>
Date:   Wed, 19 Oct 2022 15:06:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 06/36] hwmon: drivetemp: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
 <20221016195946.7613-7-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221016195946.7613-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/22 12:59, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/hwmon/drivetemp.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
> index 5bac2b0fc7bb..ec208cac9c7f 100644
> --- a/drivers/hwmon/drivetemp.c
> +++ b/drivers/hwmon/drivetemp.c
> @@ -192,9 +192,14 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
>   	scsi_cmd[12] = lba_high;
>   	scsi_cmd[14] = ata_command;
>   
> -	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
> -				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
> -				NULL);
> +	return scsi_exec_req(((struct scsi_exec_args) {
> +					.sdev = st->sdev,
> +					.cmd = scsi_cmd,
> +					.data_dir = data_dir,
> +					.buf = st->smartdata,
> +					.buf_len = ATA_SECT_SIZE,
> +					.timeout = HZ,
> +					.retries = 5 }));
>   }
>   
>   static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,

Since Damien Le Moal is the ATA Maintainer, you may want to Cc him for 
ATA patches. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
