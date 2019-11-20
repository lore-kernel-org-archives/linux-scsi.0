Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A22C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 16:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87E2020659
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 16:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbfKTQXJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:23:09 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35506 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbfKTQXI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 11:23:08 -0500
Received: by mail-pj1-f67.google.com with SMTP id s8so63270pji.2
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2019 08:23:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LK8dKyCsZHzUyR0L7wSoWF4DPUJLoX9GAi4LoWlYxCU=;
        b=dvqpLjnnU0mbOfbXZHxO13rTGh4CTFd9Slpo9crzZcvIUaLzsSrSbi8Fa5jpIJ3cWu
         IcDyCZ+HhSkk5ELfDzkzwRRRn9wTF6wdFKXZkGN0Z202ZBaAtEAXm5U3YLwXnb09HLay
         5zN4Hry70hpy4fgYtaBCTll5buEUYk5C1W5/ZDC23hb2X5A6tZbzs2feW0ZRaq991ffd
         WrQhatznj48KK03MwrWfGAHBMf8gDoECWFH0++W5drFb6GdJPtfBkjdtcKiSbT/3KqFm
         dGlvBp6evzkx1DqQKYhP2CDmZDar5UEirxACQSNhF68gVVZ6OIxPpXNZXRV4GxqwgMt1
         zA9Q==
X-Gm-Message-State: APjAAAWYsJ1FtHE+AfMoWqXH50+9P2GKI302nEfEqckXniSz1IZ24uIY
        EHK53Vx/udw96H+D4jficXg=
X-Google-Smtp-Source: APXvYqx7ju3x1xnIc53IhFMOLTc8uF6HtRllXLX6DXOT3ThaonDwohOev8wcdlbyoktS1MPgXVVrWw==
X-Received: by 2002:a17:902:d70a:: with SMTP id w10mr3834825ply.279.1574266987907;
        Wed, 20 Nov 2019 08:23:07 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w129sm14998734pgb.67.2019.11.20.08.23.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 08:23:07 -0800 (PST)
Subject: Re: [PATCH 08/11] aacraid: use scsi_host_quiesce() to wait for I/O to
 complete
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Balsundar P <balsundar.p@microsemi.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
References: <20191120103114.24723-1-hare@suse.de>
 <20191120103114.24723-9-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <459706f4-c16c-a2bc-9989-1e563696716b@acm.org>
Date:   Wed, 20 Nov 2019 08:23:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120103114.24723-9-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/20/19 2:31 AM, Hannes Reinecke wrote:
> Instead of waiting for all I/O to complete by monitoring the
> request tags we can as well call scsi_host_quiesce() and drop
> the hand-crafted helpers.
> 
> Cc: Balsundar P <balsundar.p@microsemi.com>
> Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/aacraid/comminit.c | 35 ++---------------------------------
>   1 file changed, 2 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index f75878d773cf..a01dca86eb37 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -272,38 +272,6 @@ static void aac_queue_init(struct aac_dev * dev, struct aac_queue * q, u32 *mem,
>   	q->entries = qsize;
>   }
>   
> -static void aac_wait_for_io_completion(struct aac_dev *aac)
> -{
> -	unsigned long flagv = 0;
> -	int i = 0;
> -
> -	for (i = 60; i; --i) {
> -		struct scsi_device *dev;
> -		struct scsi_cmnd *command;
> -		int active = 0;
> -
> -		__shost_for_each_device(dev, aac->scsi_host_ptr) {
> -			spin_lock_irqsave(&dev->list_lock, flagv);
> -			list_for_each_entry(command, &dev->cmd_list, list) {
> -				if (command->SCp.phase == AAC_OWNER_FIRMWARE) {
> -					active++;
> -					break;
> -				}
> -			}
> -			spin_unlock_irqrestore(&dev->list_lock, flagv);
> -			if (active)
> -				break;
> -
> -		}
> -		/*
> -		 * We can exit If all the commands are complete
> -		 */
> -		if (active == 0)
> -			break;
> -		ssleep(1);
> -	}
> -}
> -
>   /**
>    *	aac_send_shutdown		-	shutdown an adapter
>    *	@dev: Adapter to shutdown
> @@ -326,7 +294,7 @@ int aac_send_shutdown(struct aac_dev * dev)
>   		mutex_unlock(&dev->ioctl_mutex);
>   	}
>   
> -	aac_wait_for_io_completion(dev);
> +	scsi_host_quiesce(dev->scsi_host_ptr);
>   
>   	fibctx = aac_fib_alloc(dev);
>   	if (!fibctx)
> @@ -352,6 +320,7 @@ int aac_send_shutdown(struct aac_dev * dev)
>   	if (aac_is_src(dev) &&
>   	     dev->msi_enabled)
>   		aac_set_intx_mode(dev);
> +	scsi_host_resume(dev->scsi_host_ptr);
>   	return status;
>   }

Can aac_wait_for_io_completion() be called from inside the aacraid SCSI 
host reset handler? Is it safe to call scsi_host_quiesce() from inside a 
host reset handler? Sorry that I sent you in the wrong direction with a 
previous comment.

Bart.

