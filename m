Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D92C43215
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 20:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A0F720726
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 20:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfKTU4Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 15:56:25 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34210 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfKTU4Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 15:56:25 -0500
Received: by mail-pl1-f193.google.com with SMTP id h13so377894plr.1;
        Wed, 20 Nov 2019 12:56:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HEys2DkeBYIN5T72aBPGFnMrwSnv2zVfQpB2I0oUeg8=;
        b=OoFi7gr5e3HceO/7iqt5PUQQfdb51OVDwjT2txrZhijB/V4QeGoOJ2o3UWZpEZdMtQ
         Yp7k6CnV2Axa9MgQbhh6RWEv8rI4qxJrvgqVWtY77Eu4yyxHSueGcfC/gBtDIdkUIwt4
         OvhPxgb8r6yPD1dAPypPW3ybRq/Vhwy3+Eenrl61SPhxBsirdkZe79Ot5Lqp/0el+t9l
         UPEY3x6eX0h5h/vRvorIjZhPpFcVGMuZqa5worwKyao2q8uovSkLpBuz22SXVvvgzilV
         FiDuZG2cAtK/NTOS9+P75Bhuq3y8j22pSxg8heObIKPvHdC9UoRmbjRGuB1Rq3R3fSQm
         J2vg==
X-Gm-Message-State: APjAAAVltTdL8gy3FtzB238dUieAJOJ6muqBn5NeSi+GY1Ikr08cfgne
        LcLk8NVuwKZ1TDF9nXqYKy0=
X-Google-Smtp-Source: APXvYqzn2wyZxdgXNccZdVCvuC5rhcR1jigkPb0fky9LmmhAR3+ZvxW+k34Pot7CfeL2K2OMHywA9Q==
X-Received: by 2002:a17:90a:1f4b:: with SMTP id y11mr6488204pjy.123.1574283384037;
        Wed, 20 Nov 2019 12:56:24 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id y22sm295361pfn.6.2019.11.20.12.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 12:56:22 -0800 (PST)
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
To:     "Ewan D. Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
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
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
 <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <44644664-f7b6-facd-d1bb-f7cfc9524379@acm.org>
Date:   Wed, 20 Nov 2019 12:56:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9bbcbbb42b659c323c9e0d74aa9b062a3f517d1f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/20/19 9:00 AM, Ewan D. Milne wrote:
> On Wed, 2019-11-20 at 11:05 +0100, Hannes Reinecke wrote:
>> I must admit I patently don't like this explicit dependency on
>> blk_nonrot(). Having a conditional counter is just an open invitation to
>> getting things wrong...
> 
> This concerns me as well, it seems like the SCSI ML should have it's
> own per-device attribute if we actually need to control this per-device
> instead of on a per-host or per-driver basis.  And it seems like this
> is something that is specific to high-performance drivers, so changing
> the way this works for all drivers seems a bit much.
> 
> Ordinarily I'd prefer a host template attribute as Sumanesh proposed,
> but I dislike wrapping the examination of that and the queue flag in
> a macro that makes it not obvious how the behavior is affected.
> (Plus Hannes just submitted submitted the patches to remove .use_cmd_list,
> which was another piece of ML functionality used by only a few drivers.)
> 
> Ming's patch does freeze the queue if NONROT is changed by sysfs, but
> the flag can be changed by other kernel code, e.g. sd_revalidate_disk()
> clears it and then calls sd_read_block_characteristics() which may set
> it again.  So it's not clear to me how reliable this is.

How about changing the default behavior into ignoring sdev->queue_depth 
and only honoring sdev->queue_depth if a "quirk" flag is set or if 
overridden by setting a sysfs attribute? My understanding is that the 
goal of the queue ramp-up/ramp-down mechanism is to reduce the number of 
times a SCSI device responds "BUSY". An alternative for queue 
ramp-up/ramp-down is a delayed queue re-run. I think if scsi_queue_rq() 
returns BLK_STS_RESOURCE that the queue is only rerun after a delay. 
 From blk_mq_dispatch_rq_list():

	[ ... ]
	else if (needs_restart && (ret == BLK_STS_RESOURCE))
		blk_mq_delay_run_hw_queue(hctx, BLK_MQ_RESOURCE_DELAY);

Bart.
