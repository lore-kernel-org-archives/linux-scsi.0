Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF7FC88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 18:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbjFLSA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 14:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbjFLSAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 14:00:23 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E920DE57;
        Mon, 12 Jun 2023 11:00:22 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b3a6fc8067so14341495ad.3;
        Mon, 12 Jun 2023 11:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686592822; x=1689184822;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DtaKyGMMsO1d5IaBvOlYvD5aIurl50eNqjEgvky0SN0=;
        b=kKsvH9S4tEDKVcfGOWiw9WAr6P4eG49i4QBwVx/T/Xf0iM8CMjF6iB0YuX0WgnuQWm
         yfM6DSSYq4pet+egNTI2YY8Y5BIa1ECZWCE2wppj2ldCn4rO0+ixhrQPIW/H/1EDeN29
         7HkwPDqkIv6cgZyfpPahIMHS+9XD0ak/iKA2O925YxaTgYkZk7Wng9qLawAdbxcVhSBV
         PsAlw9JtsdRsZjDvIkpLREhlIMhh9gxDk/6lkg62WL7vLrd+HkH2vjPxPsIw9vKCXb8I
         40BZRcCU1wrWBh1PuOXP2q0JjAhHy7/VPQAWXbss8e4rbuUuDcd53dskh4CR3Z5uDySg
         ltug==
X-Gm-Message-State: AC+VfDx3yGjHYK3xszr3lfiVFhK1/Gjk+r2mDODksiEashwDjSyXET6l
        xwGWACwEq4Rm18xJt3Q7AEo=
X-Google-Smtp-Source: ACHHUZ5SQy4Ts+NFIvs2Cwje2NT9J9yvTizdY2ZR23/lLaAR2EwE0/oI919r/BKw8RG88hQ+F9YmhQ==
X-Received: by 2002:a17:902:ecc8:b0:1b1:d8ce:73cb with SMTP id a8-20020a170902ecc800b001b1d8ce73cbmr7427269plh.59.1686592822085;
        Mon, 12 Jun 2023 11:00:22 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b016313b1dsm3208788plb.86.2023.06.12.11.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 11:00:21 -0700 (PDT)
Message-ID: <31043005-eb42-1a03-676a-1544c3cbbe26@acm.org>
Date:   Mon, 12 Jun 2023 11:00:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v5 3/7] scsi: merge scsi_internal_device_block() and
 device_block()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230612165049.29440-1-mwilck@suse.com>
 <20230612165049.29440-4-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230612165049.29440-4-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 09:50, mwilck@suse.com wrote:
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

Hmm ... wasn't it your intention to change the reference to the
__scsi_internal_device_block_nowait() function in this message?

Thanks,

Bart.
