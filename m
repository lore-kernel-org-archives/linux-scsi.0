Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D85AC43215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 20:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B4D52070E
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 20:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKVUqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 15:46:51 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34119 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVUqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Nov 2019 15:46:51 -0500
Received: by mail-pj1-f65.google.com with SMTP id bo14so3532636pjb.1;
        Fri, 22 Nov 2019 12:46:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tRGkdkyxPC2a5f5f/M+g90u8hYacc3x84KQ1p7aBVU4=;
        b=TWyfVppZaTP0UPBWTRVvBsAFyUOIDVwLXbBHk4w+gLwWjsst6W7E36kmrrHV95iACr
         Lxshsj0ZVIVq5+5dNRFqx5DAaay4fxFmSFodneot9YxT9dl5ficJ6FfNxa/auxsCPzOO
         9InQXuSvYnsOuQHaACFUI1MQIRgnhfoIPIveKuZNOqtrOHIQBFMfdWwosUz9z+86CZ3j
         a84WkPSDmfkGOenmqpW7V46gPCr+P1BtgvvtVRsH5O6r71APMs9axppcK1ayaLti8He0
         UzfHRRfE9ZeWXtwEKvIfghx9poZCNvmkiqhG6Hl5fuWdFSkbtRC1spY3NlhX/dgIxzme
         jW6g==
X-Gm-Message-State: APjAAAXnsox9+JiqFf8hlvDdNuYllBwAFpE8OV83Po04EtciqsQPucpj
        qBlc9B9kmbJ4wh4lnG3TWI8=
X-Google-Smtp-Source: APXvYqxfLvlo3WiX+qOjLmNaHg4A8/Yr5/bhutdBvifKdrbNoMEoX19ki5EIzgAh3KQps1ab5imAJw==
X-Received: by 2002:a17:902:8a8a:: with SMTP id p10mr16258912plo.300.1574455610529;
        Fri, 22 Nov 2019 12:46:50 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id k6sm8361051pfi.119.2019.11.22.12.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 12:46:49 -0800 (PST)
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
To:     James Smart <james.smart@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
 <20191121005323.GB24548@ming.t460p>
 <336f35fc-2e22-c615-9405-50297b9737ea@suse.de>
 <20191122080959.GC903@ming.t460p>
 <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
 <7e44d961-a089-e073-1e35-5890e75b0ba7@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1963d16a-a390-6a25-ec20-53c4b01dc98f@acm.org>
Date:   Fri, 22 Nov 2019 12:46:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <7e44d961-a089-e073-1e35-5890e75b0ba7@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/19 10:26 AM, James Smart wrote:
> On 11/22/2019 10:14 AM, Bart Van Assche wrote:
>> Thanks for having shared these numbers. I think this is very useful 
>> information. Do these results show the performance drop that happens 
>> if /sys/block/.../device/queue_depth exceeds .can_queue? What I am 
>> wondering about is how important these results are in the context of 
>> this discussion. Are there any modern SCSI devices for which a SCSI 
>> LLD sets scsi_host->can_queue and scsi_host->cmd_per_lun such that the 
>> device responds with BUSY? What surprised me is that only three SCSI 
>> LLDs call scsi_track_queue_full() (mptsas, bfa, esp_scsi). Does that 
>> mean that BUSY responses from a SCSI device or HBA are rare?
> 
> That's because most of the drivers, which had queue full ramp up/ramp 
> down in them and would have called scsi_track_queue_full() converted 
> over to the moved-queue-full-handling-in-the-mid-layer, indicated by 
> sht->track_queue_depth = 1.
> 
> Yes - it is still hit a lot!

Hi James,

In the systems that I have been working on myself I made sure that the 
BUSY condition is rarely or never encountered. Anyway, since there are 
setups in which this condition is hit frequently we need to make sure 
that these setups keep performing well. I'm wondering now whether we 
should try to come up with an algorithm for maintaining 
sdev->device_busy only if it improves performance and for not 
maintaining sdev->device_busy for devices/HBAs that don't need it.

Bart.
