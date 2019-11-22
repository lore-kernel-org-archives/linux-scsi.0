Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E28CC43215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 18:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 720692071B
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 18:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfKVSOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 13:14:54 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42278 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVSOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Nov 2019 13:14:54 -0500
Received: by mail-pl1-f196.google.com with SMTP id j12so3408249plt.9;
        Fri, 22 Nov 2019 10:14:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=55VA5utMsaCpnMBvNC7m6fZAbp1E5a9KUtFys5/MAWY=;
        b=bgilaGMtoySukqJ1WbOj29EzCHsSB0KdPGJ2CTINBW7sguo6XXMe8HNEs/DvDBO+5D
         Om8Y0A6Ts3sK6QALTWa1hW4e2zgB+Z+GKv91RXe+GC1uKtlAFYnLngpYVRDYFoI7luFT
         gE1eOYlB84y1mOeFHBVTzhgqOC+VczBdi9rhmmJzD38UYWDw+LpY+hBFuT6t85vrRsNZ
         xi2v4avkSh+Gd7WAmMJhaQSTwSsRVWKFPXmHGEEaaVye43i13m5aAw+Go6Jbb8nY7MG2
         YD33xk2TXeGA0PXm2TX8iKJ6bz9KFtfb7xd1fhWgHnnT3Vzc0rR7UNLJIOrWf0ryCBKa
         RXeQ==
X-Gm-Message-State: APjAAAV1WEIF2VEe3QR2iuBDMxhdtr7qTD86xXMvx165tfSYokUptACi
        u4DSd8dDxb1qTh6JiD1mM2H3G6DjqeY=
X-Google-Smtp-Source: APXvYqziXlxI76ejrLEHAfcNhLzhn96hXvZK5LIgs8RNfsQqmDBNfUVfKxQg4FHBQxVNXkuIUqKOCA==
X-Received: by 2002:a17:902:900b:: with SMTP id a11mr15185440plp.116.1574446493342;
        Fri, 22 Nov 2019 10:14:53 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id f24sm3634578pjp.12.2019.11.22.10.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 10:14:52 -0800 (PST)
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
To:     Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
Date:   Fri, 22 Nov 2019 10:14:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122080959.GC903@ming.t460p>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/19 12:09 AM, Ming Lei wrote:
> On Thu, Nov 21, 2019 at 04:45:48PM +0100, Hannes Reinecke wrote:
>> On 11/21/19 1:53 AM, Ming Lei wrote:
>>> On Wed, Nov 20, 2019 at 11:05:24AM +0100, Hannes Reinecke wrote:
>>>> I would far prefer if we could delegate any queueing decision to the
>>>> elevators, and completely drop the device_busy flag for all devices.
>>>
>>> If you drop it, you may create big sequential IO performance drop
>>> on HDD., that is why this patch only bypasses sdev->queue_depth on
>>> SSD. NVMe bypasses it because no one uses HDD. via NVMe.
>>>
>> I still wonder how much performance drop we actually see; what seems to
>> happen is that device_busy just arbitrary pushes back to the block
>> layer, giving it more time to do merging.
>> I do think we can do better then that...
> 
> For example, running the following script[1] on 4-core VM:
> 
> ------------------------------------------
>                      | QD:255    | QD: 32  |
> ------------------------------------------
> fio read throughput | 825MB/s   | 1432MB/s|
> ------------------------------------------
> 
> [ ... ]

Hi Ming,

Thanks for having shared these numbers. I think this is very useful 
information. Do these results show the performance drop that happens if 
/sys/block/.../device/queue_depth exceeds .can_queue? What I am 
wondering about is how important these results are in the context of 
this discussion. Are there any modern SCSI devices for which a SCSI LLD 
sets scsi_host->can_queue and scsi_host->cmd_per_lun such that the 
device responds with BUSY? What surprised me is that only three SCSI 
LLDs call scsi_track_queue_full() (mptsas, bfa, esp_scsi). Does that 
mean that BUSY responses from a SCSI device or HBA are rare?

Thanks,

Bart.
