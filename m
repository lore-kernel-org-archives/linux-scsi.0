Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A15C432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 22:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C861620740
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 22:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DNpsh1i/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfKYWOY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 17:14:24 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38324 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfKYWOY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 17:14:24 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so20150136wro.5
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2019 14:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=cFSgLy2TuMFDMMdY4q4kzIcm2M8S2prnLzNPmhY7P2I=;
        b=DNpsh1i/ZU3egvur64u+T0Q/1zHAbWHt4pqB1dIvyq2m6cSSCWKpAJ/CtshycUykVA
         s/+X769Fh/Rm0FRbUSIVq2NB9NvNSmN1+KYAC3HzxDz9oaS6cFH4fFgcmHf06BPwpER+
         TMGHzODshGOA6WxdcsKgD+TPFe0Z8FzRzgZwA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cFSgLy2TuMFDMMdY4q4kzIcm2M8S2prnLzNPmhY7P2I=;
        b=ACYi/Ghc1jdi+rI8AT0eJ+HCswD89IDcJUfP0GENBoD/5B8OYDf39kJQnsj7lLQVdy
         fYxKAiY4q87selGto143JnD9+dtzY/ZjbowgkjHfotNyK9qenH7psogvjVAHdK2oEIdJ
         Qq+wzLjEtXLFVmvSKbIYoox7hBxYLjO+w6dRgznjIII2FBytz3uBjK+UONULxkCcLQq4
         KDReDqum7Q63+HNysjBT3DH/dQMUdOM/CECZZXxiPTOa8UvUtQkpO0KlmFVruJpQP7z8
         Md2C20bFmovYlzrly7XY7PU8jjaarTgG/sbAyze6Ho5Pot6N7yp+nGY/RrimHq2MYS94
         TeoQ==
X-Gm-Message-State: APjAAAXJCf318THt8f51m5tD5VYdz5ySKeWyT4cuj/SBRscfZQBvcK6w
        nxoDJF+TO++gHr/JBLqFKuTIGw==
X-Google-Smtp-Source: APXvYqxUNT2UwHQigKZg6LBI/eY8Dohm500ZmzJb++rusw/YW0yxVsBBtsLtzLhHkynox7CHetO9yQ==
X-Received: by 2002:adf:cd0a:: with SMTP id w10mr24439922wrm.4.1574720060300;
        Mon, 25 Nov 2019 14:14:20 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 11sm762595wmb.34.2019.11.25.14.14.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Nov 2019 14:14:19 -0800 (PST)
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
To:     "Ewan D. Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
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
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
 <20191121005323.GB24548@ming.t460p>
 <336f35fc-2e22-c615-9405-50297b9737ea@suse.de>
 <20191122080959.GC903@ming.t460p>
 <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
 <e9cb5e75681537443b393ed1631857df81b8894d.camel@redhat.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <3dda34b8-31fb-b9dd-c087-177192c7d686@broadcom.com>
Date:   Mon, 25 Nov 2019 14:14:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <e9cb5e75681537443b393ed1631857df81b8894d.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/2019 10:28 AM, Ewan D. Milne wrote:
> On Fri, 2019-11-22 at 10:14 -0800, Bart Van Assche wrote:
>> Hi Ming,
>>
>> Thanks for having shared these numbers. I think this is very useful
>> information. Do these results show the performance drop that happens if
>> /sys/block/.../device/queue_depth exceeds .can_queue? What I am
>> wondering about is how important these results are in the context of
>> this discussion. Are there any modern SCSI devices for which a SCSI LLD
>> sets scsi_host->can_queue and scsi_host->cmd_per_lun such that the
>> device responds with BUSY? What surprised me is that only three SCSI
>> LLDs call scsi_track_queue_full() (mptsas, bfa, esp_scsi). Does that
>> mean that BUSY responses from a SCSI device or HBA are rare?
>>
> Some FC HBAs end up returning busy from ->queuecommand() but I think
> this is more commonly due to there being and issue with the rport rather
> than the device.
>
> -Ewan
>

True - but I would assume busy from queuecommand() is different from 
BUSY/QUEUE_FULL via a SCSI response.

Adapter queuecommand busy's can be for out-of-resource limits in the 
driver - such as I_T io count limits enforced by the driver are reached, 
or if some other adapter resource limit is reached as well. Canqueue 
covers most of those - but we sometimes overcommit the adapter with a 
canqueue on physical port as well as per npiv ports, or scsi and nvme on 
the same port.

Going back to Bart's question - with SANS and multiple initiators 
sharing a target and lots of luns on that target, it's very common to 
hit bursty conditions where the target may reply with QUEUE_FULL.  Many 
arrays provide think tuning guides on how to set up values on multiple 
hosts, but it's mainly to help the target avoid being completely overrun 
as some didn't do so well.   In the end, it's very hard to predict 
multi-initiator load and in a lot of cases, things are usually left a 
bit overcommitted as the performance downside otherwise is significant.

-- james

