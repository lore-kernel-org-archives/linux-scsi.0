Return-Path: <SRS0=LfzD=YC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE05C47404
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 16:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA18620679
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 16:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbfJIQF3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:05:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43745 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731083AbfJIQF3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 12:05:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id f21so1252543plj.10
        for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2019 09:05:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QphEkQSPlY1RyrvBtQE0I45inaEiV8ZcNZrtsy7nikI=;
        b=gY508dTAc4r8Ir8YlqpMgEBFWhouR/jMd2DrQ5kvpHlxWSiLOAaQIV0/2maQ12Vyn4
         UzWUzi18cblHWuRhWCZbFAFC31m4Adi4zm1/UBQ48bGXdjXiCI98wS/1FCNRIRHoUYMf
         zi4sfcns+xuWYyxZR7SysxvPvceDSUBsDygk98DIhEmVoiB/38yfGkd47/rc2qlD8Mj3
         VVB7sjZkGJU/+hjtQnOJC0nlFpull2JrEXP2ZFCS27+eri3H7TdMvJBr9MwvZIEU8Tqk
         vx+FnhENkg1QgVvIFZDOdLTn3qWFEGnGQLDquDdCJOErqPvxKWaV1Rgec2nAgYkADV6W
         b6AQ==
X-Gm-Message-State: APjAAAXjEHjFkW4tipZQg52RCC+yJnzT5DZ/cO89jIffNbN5bep4cEOf
        bmHwrDyIK7RbTWtlNOSgI/U=
X-Google-Smtp-Source: APXvYqygSZjTCV1IaLLjF7lE1kLNMRISJO3M3ZzqQ9uKX4RllmjBRrg1BJWGhV2Lr7DFNuWKme7E0A==
X-Received: by 2002:a17:902:9305:: with SMTP id bc5mr4032801plb.238.1570637128554;
        Wed, 09 Oct 2019 09:05:28 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a8sm2701567pff.5.2019.10.09.09.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 09:05:27 -0700 (PDT)
Subject: Re: [RFC PATCH V4 2/2] scsi: core: don't limit per-LUN queue depth
 for SSD
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-3-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org>
Date:   Wed, 9 Oct 2019 09:05:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191009093241.21481-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/9/19 2:32 AM, Ming Lei wrote:
> @@ -354,7 +354,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>   	if (starget->can_queue > 0)
>   		atomic_dec(&starget->target_busy);
>   
> -	atomic_dec(&sdev->device_busy);
> +	if (!blk_queue_nonrot(sdev->request_queue))
> +		atomic_dec(&sdev->device_busy);
>   }
>   

Hi Ming,

Does this patch impact the meaning of the queue_depth sysfs attribute 
(see also sdev_store_queue_depth()) and also the queue depth ramp 
up/down mechanism (see also scsi_handle_queue_ramp_up())? Have you 
considered to enable/disable busy tracking per LUN depending on whether 
or not sdev->queue_depth < shost->can_queue?

The megaraid and mpt3sas drivers read sdev->device_busy directly. Is the 
current version of this patch compatible with these drivers?

Thanks,

Bart.
