Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D32C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 21:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiF2Vtr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiF2Vtq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 17:49:46 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101A1DF3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2022 14:49:45 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d17so16276406pfq.9
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2022 14:49:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WaVTBb2h1YFOhUWrT6iks+4ugpDfwN45fCdQso1iNkc=;
        b=FoTy0Y4B35/2KY1urs7SF/G5J0L5A1BVfyCiJRP1z9yZdw6Uqt8iEWx4BYNzdFkgue
         ykQpwxrUOhg9NRiei6f8cNB5UhzPOqBj3eHj7z+uCjvzhldAm+4bC2O6UqaF2ktEP6Cs
         VQDCLv9paj8c26tEHslyjT+C8aGZw1oV9/qkyjO3jxprs9jZ45wqIhkDgae2BVWFxH8z
         Q9zgt76hCXLMgFn/JOo8/Chs04sOn5Z4J2R9qUoT7J1Kuc2oORJkm/9ekb7J0QtaH+px
         oybCJur7+mYS1PK/lSdzLyEv47nP3puJ7XAhYItK0xdG09b9BBrzhKIhGUdsuk3ONwCk
         vekw==
X-Gm-Message-State: AJIora/yWLw06KTCBtsNps0ZAwEAWkfHfnpyoBKYwP6gH5iTy9p+ZChO
        qJ5SPlsVIyezxL3Um0g/4mg=
X-Google-Smtp-Source: AGRyM1t571OCRnb/JTjGDKt6kHhtULJ2DfQ6c4RLx0dWSlqIIMoLJBC8w/ijflGULNM5Zs+kqLtw+A==
X-Received: by 2002:a63:8549:0:b0:40d:2864:e3b6 with SMTP id u70-20020a638549000000b0040d2864e3b6mr4593147pgd.301.1656539384416;
        Wed, 29 Jun 2022 14:49:44 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3841:49ce:cba5:1586? ([2620:15c:211:201:3841:49ce:cba5:1586])
        by smtp.gmail.com with ESMTPSA id 84-20020a621757000000b00524e8e48156sm12375911pfx.142.2022.06.29.14.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 14:49:32 -0700 (PDT)
Message-ID: <8e464697-e179-19f7-e417-be089821a861@acm.org>
Date:   Wed, 29 Jun 2022 14:49:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: core: Call blk_mq_free_tag_set() earlier
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
References: <20220628175612.2157218-1-bvanassche@acm.org>
 <YruoKUbpBZvAkZ4L@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YruoKUbpBZvAkZ4L@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/22 18:17, Ming Lei wrote:
> On Tue, Jun 28, 2022 at 10:56:12AM -0700, Bart Van Assche wrote:
>> There are two .exit_cmd_priv implementations. Both implementations use the
>> SCSI host pointer. Make sure that the SCSI host pointer is valid when
>> .exit_cmd_priv is called by moving the .exit_cmd_priv calls from
>> scsi_device_dev_release() to scsi_forget_host(). Moving
>> blk_mq_free_tag_set() from scsi_device_dev_release() to scsi_forget_host()
>> is safe because scsi_forget_host() drains all the request queues that use
>> the host tag set. This guarantees that no requests are in flight and also
>> that no new requests will be allocated from the host tag set.
> 
> Not sure scsi_forget_host really drains all queues since it bypasses
> sdev which state is SDEV_DEL, so removal for this sdev could be
> in-progress, not done yet.

Ah, that's right. How about making scsi_forget_host() wait until all request
activity on the associated queues has stopped, e.g. by replacing the current
scsi_forget_host() implementation by the one below?

/**
  * scsi_forget_host() - Remove all SCSI devices from a host.
  * @shost: SCSI host to remove devices from.
  *
  * Removes all SCSI devices that have not yet been removed. For the SCSI devices
  * for which removal started before scsi_forget_host(), wait until the
  * associated request queue has reached the "dead" state. In that state it is
  * guaranteed that no new requests will be allocated and also that no requests
  * are in progress anymore.
  */
void scsi_forget_host(struct Scsi_Host *shost)
{
	struct scsi_device *sdev;

	might_sleep();

  restart:
	spin_lock_irq(shost->host_lock);
	list_for_each_entry(sdev, &shost->__devices, siblings) {
		if (sdev->sdev_state == SDEV_DEL &&
		    blk_queue_dead(sdev->request_queue)) {
			continue;
		}
		if (sdev->sdev_state == SDEV_DEL) {
			get_device(&sdev->sdev_gendev);
			spin_unlock_irq(shost->host_lock);

			while (!blk_queue_dead(sdev->request_queue))
				msleep(10);

			spin_lock_irq(shost->host_lock);
			put_device(&sdev->sdev_gendev);
			goto restart;
		}
		spin_unlock_irq(shost->host_lock);
		__scsi_remove_device(sdev);
		goto restart;
	}
	spin_unlock_irq(shost->host_lock);
}

Thanks,

Bart.
