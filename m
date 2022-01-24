Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C6BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 19:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345763AbiAXTML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 14:12:11 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:42801 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346569AbiAXTHC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2022 14:07:02 -0500
Received: by mail-pg1-f170.google.com with SMTP id g2so16243497pgo.9;
        Mon, 24 Jan 2022 11:07:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/in2Zquib1R/suhnfCwLcSUTOEiy16DahN9wbF1GO8Y=;
        b=KKMg71qplPyhpHjSrDdoe7Ulc4xadsgr9osJqmHV49DH42k42IxLskpd7dtI1wS01U
         wx1jritC6IBLuFsMptXzkkmfnVJ02m2NU77kHvxLkbl4dXUEXTRKLNkegbZsfeDdaQyx
         OyzpKwgmibolzOOsoGyddBgcmU2wJvaIObocZzH9C3hTSvIogMYa9OW3wkMLnZesp8We
         dhFko7FrKEasnQp0dCaTd7v8Tx7awPuD7AiQTpQLTdmEf2hlrdvf+Ne/CTfOmtWBf3n8
         hIOBYtkrBvee7cQpQ77sd4UrnmmGHUgvUjBHSbjJHLcbFWXtGLhaiKOUlQGrhTH+FkK6
         HuqA==
X-Gm-Message-State: AOAM533dFo4pC0Tnkrg/2TrrHAQR4B+csEq7bZ3+3j2Hae702nM/trPs
        778s12If2ZmgIJPKpbG/ETo=
X-Google-Smtp-Source: ABdhPJzN1Rt66uSagpGi52DoFvcrRKrO0D3D+xgF1VaFuvMpxo96ESUmfjIkXXXEsC3DFcDIUjMh4g==
X-Received: by 2002:a63:eb07:: with SMTP id t7mr12718988pgh.112.1643051221185;
        Mon, 24 Jan 2022 11:07:01 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t15sm110258pjy.17.2022.01.24.11.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 11:07:00 -0800 (PST)
Message-ID: <ea04773f-f92e-4f62-34a3-2f97a74dc6fe@acm.org>
Date:   Mon, 24 Jan 2022 11:06:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH V2 07/13] block: move q_usage_counter release into
 blk_queue_release
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-8-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220122111054.1126146-8-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/22/22 03:10, Ming Lei wrote:
> After blk_cleanup_queue() returns, disk may not be released yet, so
> probably bio may still be submitted and ->q_usage_counter may be
> touched, so far this way seems safe, but not good from API's viewpoint.
> 
> Move the release ofq_usage_counter into blk_queue_release().
                    ^^

Please change "ofq_usage_counter" into "of q_usage_counter".

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
