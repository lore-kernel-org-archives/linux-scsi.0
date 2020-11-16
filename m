Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A2FC4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 17:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4979120B80
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 17:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbgKPRv1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:51:27 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37332 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730167AbgKPRv0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 12:51:26 -0500
Received: by mail-pg1-f195.google.com with SMTP id m9so4266525pgb.4;
        Mon, 16 Nov 2020 09:51:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Mo82RwtW0tRIXQ3Gp5UPbF1urCl2OvzBDpL3xdxkBk=;
        b=bioVQadUwarsgVs/8Rt+0QJOeum7Le0UlEUvCkpddEZ9Y8frwo/1Q8MzU0i5vNpLds
         RRugMSo+2+JI0FrnddUNqvs/hWGhGm6AownpPsk+vhrcaLP6Rbr3oOAkZTCQFOpVvPCU
         Dw3Kapmbg4Dh5pOHz4GTzQ44rNgjBOdo97LkgWDs1v9hVkoiOk2TO6AyWf7MuhYc9CD0
         ZSmY5vdzCbMqL4oFFLIgzvWudrHs0GGNX5TLdjo0ZbloYNxmRElouT6Z99/0f2Fu6S56
         Hm2IDOphnqvG5R8VNWPXIphzh+ABHwgkym0TJeArdnuAKLgabDMjvwEncpgkCOtw3pbt
         XtCg==
X-Gm-Message-State: AOAM530M2jnk6YX1cuoHvEDPqHPQ6mheS84aYODtoaIFuChiPGjyUNot
        IDd5fv7k6NHdK1PPueuN7GI=
X-Google-Smtp-Source: ABdhPJzSzZUK4y7AifHwOnkJgtAlU6bO8F/yHhqsPtDvDMoOBkRfzh376MGm/+MZrnfcUXk0ZEo7MA==
X-Received: by 2002:a17:90b:30d0:: with SMTP id hi16mr58772pjb.144.1605549085961;
        Mon, 16 Nov 2020 09:51:25 -0800 (PST)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id t7sm32023pji.27.2020.11.16.09.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 09:51:24 -0800 (PST)
Subject: Re: [PATCH v2 7/9] scsi_transport_spi: Freeze request queues instead
 of quiescing
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>
References: <20201116030459.13963-1-bvanassche@acm.org>
 <20201116030459.13963-8-bvanassche@acm.org> <20201116172220.GG22007@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <41b15c94-6477-9f6e-b5b8-9b81a143d80f@acm.org>
Date:   Mon, 16 Nov 2020 09:51:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116172220.GG22007@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/20 9:22 AM, Christoph Hellwig wrote:
> On Sun, Nov 15, 2020 at 07:04:57PM -0800, Bart Van Assche wrote:
>> Instead of quiescing the request queues involved in domain validation,
>> freeze these. As a result, the struct request_queue pm_only member is no
>> longer set during domain validation. That will allow to modify
>> scsi_execute() such that it stops setting the BLK_MQ_REQ_PREEMPT flag.
>> Three additional changes in this patch are that scsi_mq_alloc_queue() is
>> exported, that scsi_device_quiesce() is no longer exported and that
>> scsi_target_{quiesce,resume}() have been changed into
>> scsi_target_{freeze,unfreeze}().
> 
> Can you explain why you need the new request_queue?  spi_dv_device seems
> to generally be called from ->slave_configure where no other I/O
> should ever be pending.

Hi Christoph,

I think that the following sysfs attribute, defined in 
drivers/scsi/scsi_transport_spi.c, allows to trigger SPI domain 
validation at any time:

static DEVICE_ATTR(revalidate, S_IWUSR, NULL, store_spi_revalidate);

>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1893,6 +1893,7 @@ struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev)
>>   	blk_queue_flag_set(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
>>   	return q;
>>   }
>> +EXPORT_SYMBOL_GPL(scsi_mq_alloc_queue);
> 
> I'd much rather open scsi_mq_alloc_queue in a new caller, especially
> given that __scsi_init_queue already is exported.

I will look into this.

Thanks,

Bart.


