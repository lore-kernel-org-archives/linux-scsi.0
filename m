Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCD1C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 02:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiCFCEd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 21:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCFCEd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 21:04:33 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8436F4B87F;
        Sat,  5 Mar 2022 18:03:41 -0800 (PST)
Received: by mail-pg1-f179.google.com with SMTP id t14so10664834pgr.3;
        Sat, 05 Mar 2022 18:03:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ee4Rx75AWTBQIBC6O+195WGJ4II7tW2POnHJ+emuk4A=;
        b=JQJ9f5HMP8yS+f5IvYgdOZN6Df6ENdsmylQw7nebwwRdGJIO302WRr+cKp27Eo6GM5
         lFwgNHFsAXeEwzYLwzXYkG8wfnAUJsZXjynnQNwMrUeUfntSb41w4E/bAfUkSkw3j3Xx
         woqA+CKiwqyrCZPEGUWwSUJBFQs9mOzFyZmEPL6CazGDkm+jnXmm3tqynAbBqt0vFV0S
         T/EgzwjGDe7t/4FGRLQcFVbgXupNX/Qa0tC+8YfHMvCZ5ytcxbC1IKVgCD8Ga7JnNWZT
         2PQvFABt2XIKR7xthjqw0NWoiyigol4kJy8FcaVmeE5plX4dQdlIeoQon/Di0+rTkJqZ
         gy8g==
X-Gm-Message-State: AOAM530jot7EGgtJIxySjmyqEOhMpgiAZvuEj2yl1bfKjVPfLgaL9Mz8
        8Fo6xAlwXrp6rJWDavWlihg=
X-Google-Smtp-Source: ABdhPJyXKS35lFpPPWrScnbkkTE8OL7uovnWg0ivjG6EWc9m90EoF6lEssymcRNPa7ZB4maKhaXuvA==
X-Received: by 2002:aa7:9253:0:b0:4e1:53d4:c2c6 with SMTP id 19-20020aa79253000000b004e153d4c2c6mr6290851pfp.62.1646532220839;
        Sat, 05 Mar 2022 18:03:40 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id i24-20020a056a00225800b004f6edabc9f4sm730459pfu.72.2022.03.05.18.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 18:03:40 -0800 (PST)
Message-ID: <75a6d617-a7f6-5895-c7dc-af726d932b98@acm.org>
Date:   Sat, 5 Mar 2022 18:03:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 07/14] sd: make use of ->free_disk to simplify refcounting
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-8-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
>   error_out:
> -	scsi_disk_put(sdkp);
> +	scsi_device_put(sdkp->device);
>   	return retval;	
>   }

Hmm ... why is the above scsi_device_put() call passed sdkp->device? Wouldn't 
it be more symmetric to pass 'sdev' to that function?

> @@ -1502,7 +1468,7 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
>   			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
>   	}
>   
> -	scsi_disk_put(sdkp);
> +	scsi_device_put(sdkp->device);
>   }

Same question here - why to pass sdkp->device instead of sdev?

> +static void scsi_disk_free_disk(struct gendisk *disk)
> +{
> +	struct scsi_disk *sdkp = disk->private_data;
> +
> +	put_device(&sdkp->disk_dev);
> +}

Can the body of the above function be written as 
put_device(&scsi_disk(disk)->disk_dev) ? I'm asking this because other parts of 
this patch use scsi_disk() instead of using disk->private_data directly.

Thanks,

Bart.
