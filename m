Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8A1C88CB6
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 15:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbjFLPfS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239723AbjFLPfL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 11:35:11 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8E410C3;
        Mon, 12 Jun 2023 08:35:10 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b025d26f4fso33124555ad.1;
        Mon, 12 Jun 2023 08:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686584110; x=1689176110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lEN7srUq/hzqlbzAzfVdun7z89LstT+9xetUuzGEmIA=;
        b=kV2DJffmxzx9TumdLn+UlMFPLNU2o2qZpI/F7+QiQ5TZYZg9ybTQ9KZaYSkZ4ZNiGC
         7q2JJvJTmq6GDfzEEA+19MgcxHU3DW691AOogXT/IA0uhuZX+bFJoaEJ4pPkfoCzRrkC
         w6scKVkmaGBhW+tDc3W5ErUMunlQiNGRdAHQL8yumQkXkvSI0WxTqSs/RRuF1aUkr41P
         5IMnbK+jEM1JXDHfL7pP+QP8f93+OcjXQIFrqW+sVbHna2NnWlJvJfX2F40NKgUMP+X6
         USdZU3D7KbE6JeDn0qyCdxup0NvZeWsX1Vp3UEfcj2kAnXoqD8ghzUi0vz8uXxncgqay
         ehEg==
X-Gm-Message-State: AC+VfDzmqvMYIbqyNm9KTQF0fL3fWO0jdc/mQOicXHVlbR4SrJnCsLIn
        BaEuzIqOst377ybYXseAdLk=
X-Google-Smtp-Source: ACHHUZ6jK23E7jHoSDwn8Dg15fIhfCbPFebK5pKwdlwGH7VMnaEkrY9M/wWFuSCFrJZ/kU4CIJ3crQ==
X-Received: by 2002:a17:902:c407:b0:1ac:8717:d436 with SMTP id k7-20020a170902c40700b001ac8717d436mr9283267plk.60.1686584109823;
        Mon, 12 Jun 2023 08:35:09 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id z7-20020a170902708700b001ae3b51269dsm8364060plk.262.2023.06.12.08.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 08:35:09 -0700 (PDT)
Message-ID: <50f5ba1e-8dc7-804f-7e43-cd838ff05ce7@acm.org>
Date:   Mon, 12 Jun 2023 08:35:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 3/6] scsi: merge scsi_internal_device_block() and
 device_block()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230612150309.18103-1-mwilck@suse.com>
 <20230612150309.18103-4-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230612150309.18103-4-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 08:03, mwilck@suse.com wrote:
> -static int scsi_internal_device_block(struct scsi_device *sdev)
> +static void scsi_device_block(struct scsi_device *sdev, void *data)
>   {
>   	int err;
>   
> @@ -2805,7 +2804,8 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
>   		scsi_stop_queue(sdev, false);
>   	mutex_unlock(&sdev->state_mutex);
>   
> -	return err;
> +	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
> +		  dev_name(&sdev->sdev_gendev), err);
>   }

Hmm ... shouldn't the WARN_ONCE() statement refer to scsi_device_block() 
instead of __scsi_internal_device_block_nowait()?

Thanks,

Bart.
