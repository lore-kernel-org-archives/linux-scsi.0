Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0933EC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 20:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiCFUwh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 15:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiCFUwf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 15:52:35 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FF421E17;
        Sun,  6 Mar 2022 12:51:39 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id p17so12083570plo.9;
        Sun, 06 Mar 2022 12:51:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vzl12pZx3pZc62bRB0YYZ755WLWP2mygknHc9WfXALI=;
        b=tLI0wyt7VXWGE0RxAJ3ZeMbWX13mJJVkCbH0KMU2CAcYCA3IHFVo9MzeEcYyK92k6E
         KPhTH3R4GAwp6qFLy0OKoMISOmoinerYp6IGtMj3sF7beOBCTSP2TYzTt1pWLEdE0hf7
         QR0oNczJxKAokn0PpCSgkWbKaVzMK5UD9SNciBggLWuRkTBjjHmSndPNtgBHEeEW8SxH
         XTvNJq32pDXJMOLgPZn+rv8sZDdVYdGmgAoJKXWvWpt6igGUABisN5PwDOLwXkyLO/8X
         bG4VBjJDW31IlC12hY7JEjYSLZPndeYUlPss07Tjso3LI+LrLUulzVX6Ztha7bV9ljXh
         GGZQ==
X-Gm-Message-State: AOAM530bmB6bsvcbFVHqhwb5f9JO3X7Z1CudCxyUEgXNLbT4D8G4jR46
        EnScJeEVQxuKbYN8dfP6grI=
X-Google-Smtp-Source: ABdhPJz7jCEe/dC6w0cxWkL9mOwD2Zt9sUHnGd3XHUEEi5x1n5BlCE/JwTsXW5bmFqrx2g/sclZoNA==
X-Received: by 2002:a17:902:d50e:b0:151:b8a4:2a84 with SMTP id b14-20020a170902d50e00b00151b8a42a84mr8899446plg.17.1646599898685;
        Sun, 06 Mar 2022 12:51:38 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id f13-20020a056a001acd00b004f0f9a967basm13215227pfv.100.2022.03.06.12.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 12:51:38 -0800 (PST)
Message-ID: <85ea5b62-ac03-1d9a-f1bd-040e58235957@acm.org>
Date:   Sun, 6 Mar 2022 12:51:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 14/14] block: move rq_qos_exit() into disk_release()
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-15-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-15-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> There can't be FS IO in disk_release(), so it is safe to move rq_qos_exit()
> there.

The commit message only explains why it is safe to move rq_qos_exit() 
but not why moving that function call is useful. Please add an 
explanation of why moving that function call is useful and/or necessary.

> diff --git a/block/genhd.c b/block/genhd.c
> index 857e0a54da7dd..56f66c6fee943 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -627,7 +627,6 @@ void del_gendisk(struct gendisk *disk)
>   
>   	blk_mq_freeze_queue_wait(q);
>   
> -	rq_qos_exit(q);
>   	blk_sync_queue(q);
>   	blk_flush_integrity();
>   	/*
> @@ -1119,7 +1118,7 @@ static void disk_release_mq(struct request_queue *q)
>   		elevator_exit(q);
>   		mutex_unlock(&q->sysfs_lock);
>   	}
> -
> +	rq_qos_exit(q);
>   	__blk_mq_unfreeze_queue(q, true);
>   }

Commit 8e141f9eb803 ("block: drain file system I/O on del_gendisk") 
removed the rq_qos_exit() call from blk_cleanup_queue(). This patch 
series does not restore the rq_qos_exit() call in blk_cleanup_queue(). I 
think that call should be restored since rq_qos_add() can be called 
before add_disk() is called. I'm referring to the following call chain:

__alloc_disk_node()
   blkcg_init_queue()
     blk_iolatency_init()
       rq_qos_add()

sd_probe() is one of the functions that can take an error path after 
__alloc_disk_node() has returned and before device_add_disk() is called.

Thanks,

Bart.

