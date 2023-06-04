Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397EFC77B73
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jun 2023 13:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjFDNzF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jun 2023 09:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbjFDNyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jun 2023 09:54:49 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85AFC4;
        Sun,  4 Jun 2023 06:54:48 -0700 (PDT)
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6af93a6166fso3713291a34.3;
        Sun, 04 Jun 2023 06:54:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685886888; x=1688478888;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=398DweTlvnrqAPgAmCkIV4gpM61hKO5ZN+p9g45ys7k=;
        b=kEnNEPqc8uAb25S7+zOR6sqQ/Yi5NCcYcWYtxXdv76t4GzrfK0aWHwMq3FIrHI6Ifo
         nl9oUsXEwU+syP2iNo0slwfzlojKHSVMMqa8gwFAbCpaGM3sYLG6TvuYpscjCbQYtBvB
         ky+UwC5fW525NkRdSCOUOglRZdus6Zkzm59gDSe6JcKeE8agtYX+W8wxVgi7nbvoyHY+
         xx2lN/eOyMid/O07jlPksxVnQltGO0I8vNhhHAUgJMT+upVWBmOkyISsbqxKdi0FHhh8
         txZk94qwY/55UXv82/35IpCaiwfF9BKMJsmR1/b4fFzvthHrEZGtfJI/sJaaGbzU7Q0r
         LB5w==
X-Gm-Message-State: AC+VfDwO+gRvMqeW6xGbMHg2dYFPEsPCq+a0FeHQ8SO+oyXd5qdmWcOJ
        8fIcPWlPwuicDzQMT0wyc6o=
X-Google-Smtp-Source: ACHHUZ7cwtzyt5D9RgMFE9Kn7oLD1/onCwsiUMOYyWBnMjsTLlIHqspvJXaE/284jkjorJbH/1BgWw==
X-Received: by 2002:a9d:590b:0:b0:6a6:5a48:1f9b with SMTP id t11-20020a9d590b000000b006a65a481f9bmr7408473oth.8.1685886887659;
        Sun, 04 Jun 2023 06:54:47 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id p30-20020a631e5e000000b00514256c05c2sm4230201pgm.7.2023.06.04.06.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 06:54:47 -0700 (PDT)
Message-ID: <59a03648-f65f-0c7c-b200-1b24f321c2d6@acm.org>
Date:   Sun, 4 Jun 2023 06:54:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 3/3] scsi: simplify scsi_stop_queue()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230602163845.32108-1-mwilck@suse.com>
 <20230602163845.32108-4-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230602163845.32108-4-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/23 09:38, mwilck@suse.com wrote:
> @@ -2910,6 +2904,13 @@ scsi_target_block(struct device *dev)
>   					device_block);
>   	else
>   		device_for_each_child(dev, NULL, target_block);
> +
> +	/*
> +	 * SCSI never enables blk-mq's BLK_MQ_F_BLOCKING flag,
> +	 * so blk_mq_wait_quiesce_done() comes down to just synchronize_rcu().
> +	 * Just calling it once is enough.
> +	 */
> +	synchronize_rcu();
>   }
>   EXPORT_SYMBOL_GPL(scsi_target_block);

The above comment is wrong. See also commit b125bb99559e ("scsi:
core: Support setting BLK_MQ_F_BLOCKING").

Bart.

