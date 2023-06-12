Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF731C7EE2E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 18:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbjFLSCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 14:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbjFLSCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 14:02:42 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938B8E63;
        Mon, 12 Jun 2023 11:02:41 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-543a09ee32eso2560755a12.1;
        Mon, 12 Jun 2023 11:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686592961; x=1689184961;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YfB09GDpwwrSsxQLLhiD1AK5amyDc1dAmX/GkGO5nps=;
        b=i5hgEtNK5Mb8EevFulwbF07s08KQiqwJbW8UtW7Pub5NL14Epa53TaN7+b3XHf8uhq
         ND8yDo3CCDoMdv1AYIauRXAieTJkkFnSOucq3adVyGJRvReOaer//sFON0G65Hfz5V0D
         xwu8mKxIleQWDKT9iI6YDh/X9Z/uzEm3wTJwx0muZQvCP/PaS90RqT9WZKVQB2IG4riZ
         pRBin0QVfDK8EkMtQCLQw3gBOf1bmzKmmQNreVcGMeyzvp+1zvgME8Xs3+bNjLC3AbJP
         GfuTlveNEq+bO+Liemrcj0m3Mkbi2VsH2yUNkHLSs7IoVxMH6YwJWVpCJuppOtK36Hsy
         ckmw==
X-Gm-Message-State: AC+VfDxJXq/2jiDEXl7AlmQzGng0XzsBUSc91QfOYc9dqfGg271oZ/Xj
        Bk96PJEilJuomXuv5X8AsCgY2g1X/VOZVA==
X-Google-Smtp-Source: ACHHUZ48trZO03z+im9iymuH9bOIf7YpgkGxSd9AZwE7CPklZFXUPfExOtq5kKMhKSNajKK0P3jJyg==
X-Received: by 2002:a17:90a:404b:b0:25b:e25e:9bd7 with SMTP id k11-20020a17090a404b00b0025be25e9bd7mr4195712pjg.1.1686592960197;
        Mon, 12 Jun 2023 11:02:40 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 6-20020a17090a030600b0024dfb8271a4sm8378638pje.21.2023.06.12.11.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 11:02:39 -0700 (PDT)
Message-ID: <9887b6c0-04ef-a2c7-94be-d8558cdc44df@acm.org>
Date:   Mon, 12 Jun 2023 11:02:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v5 4/7] scsi: don't wait for quiesce in scsi_stop_queue()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230612165049.29440-1-mwilck@suse.com>
 <20230612165049.29440-5-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230612165049.29440-5-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 09:50, mwilck@suse.com wrote:
> @@ -2800,9 +2792,17 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
>   
>   	mutex_lock(&sdev->state_mutex);
>   	err = __scsi_internal_device_block_nowait(sdev);
> -	if (err == 0)
> -		scsi_stop_queue(sdev, false);
> -	mutex_unlock(&sdev->state_mutex);
> +	if (err == 0) {
> +		/*
> +		 * scsi_stop_queue() must be called with the state_mutex
> +		 * held. Otherwise a simultaneous scsi_start_queue() call
> +		 * might unquiesce the queue before we quiesce it.
> +		 */
> +		scsi_stop_queue(sdev);
> +		mutex_unlock(&sdev->state_mutex);
> +		blk_mq_wait_quiesce_done(sdev->request_queue->tag_set);
> +	} else
> +		mutex_unlock(&sdev->state_mutex);
>   
>   	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
>   		  dev_name(&sdev->sdev_gendev), err);

Has it been considered to modify the above code such that there is a
single mutex_unlock() call instead of two? I wouldn't mind if
blk_mq_wait_quiesce_done() would be called if err != 0 since performance
is not that important if this function fails.

Thanks,

Bart.
