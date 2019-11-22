Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004B1C43215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 16:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCDA72071F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 16:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IZiflNUx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKVQiW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:38:22 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:40249 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfKVQiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Nov 2019 11:38:22 -0500
Received: by mail-wm1-f46.google.com with SMTP id y5so8313140wmi.5
        for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2019 08:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=exJQAKAXPYEkCOTKekh5eN98bjCFwcLRAKxdVYgrjRc=;
        b=IZiflNUx6h5XTOVBmWN5MqfYDpYQNepaRjTvHhoCBFA+VTqQCPBHvvy0bJocUUq7Yz
         EHch2Hm+QCaV4rYixxETFv+kpu0KrzkiWS3fXKlyQc3m6uQxQETBqTc/ZvbB+cMgkOeF
         p8HD7VbCAIBE/6U8fRRJeoX4+3NfUR+dRoQJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=exJQAKAXPYEkCOTKekh5eN98bjCFwcLRAKxdVYgrjRc=;
        b=qIR4zIeRMBz1VxephOm1C8fkRsMpT2YYFbD4kioswBLNUTBI9i97FrzRwSmo0Sb/xP
         Z+3G34Ni8yCeBBIEiflaXbrLVKFy9cTJfcsff9wTrt26PDYIcKaVURxUwoqDjP3NRAtp
         JDZ4e/lK1l1LLbYeoAM5mh53QeX+Mz0IpTEGEPo//LQAvykv9o29SMYZG/dlfT5pKk+D
         e6mVH9L+uR75nO7rRUtGrpEMIQzs9LQRNwFsKq8DKFwvmQmQsBwkAEt9f/rHO/7AFPN4
         VA/8IlyBeCAbesZuqiRpRTgnIjxc1/4wpQJjyhb3Idc3dKHHulcb8nVDfWPPU8F9IqWW
         IeZw==
X-Gm-Message-State: APjAAAXq0eftjvG1uayH4mfwKgUzHG3gTuhHgz+YoSztTes2weKdCxM1
        I3cD3n7pfIPhNXpNAoRLx5/Esw==
X-Google-Smtp-Source: APXvYqxniHkc0Qq/b9AL+iWbsj2DymsP+xIJX6W68Y3cFgaQp+652aMlOOCWSIHLOxq0LLPsy/Vd4w==
X-Received: by 2002:a1c:46:: with SMTP id 67mr18237927wma.51.1574440699788;
        Fri, 22 Nov 2019 08:38:19 -0800 (PST)
Received: from [10.230.1.213] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id s131sm1840837wmf.48.2019.11.22.08.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 08:38:18 -0800 (PST)
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
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
 <44644664-f7b6-facd-d1bb-f7cfc9524379@acm.org>
 <20191121010730.GD24548@ming.t460p> <yq1pnhkbopi.fsf@oracle.com>
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Message-ID: <1eeb56b8-2b82-4add-8606-5912fe81fa84@broadcom.com>
Date:   Fri, 22 Nov 2019 09:38:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq1pnhkbopi.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>If we ignore the RAID controller use case where the controller
>>internally queues and arbitrates commands between many devices

These controllers should not be "ignored", but rather enabled. Many of them visualize both HDD and NVMe devices behind them, and thus forced to expose themselves as SCSI controllers.
However, they have their own queue management and IO merging capabilities. Many have capability of holding IO in queue and pull them as needed (just like NVMe), and thus does not bother if many IOs to a device or controller is sent or if there is congestion. In case of congestion, the IO will simply wait in queue, along with advanced timeout handling capabilities.
Besides, as Ming pointed out, Block layer (function hctx_may_queue) already limits IO on a per controller and per LUN basis.

Overall, if the proposal does not work for all cases, then at least it should be made optional for high end controller, so that they are not disadvantaged vis-a-vis NVMe, just because they expose themselves as SCSI in order to support a wide range of devices behind them.

thanks,
Sumanesh

On 11/21/2019 7:59 PM, Martin K. Petersen wrote:
> Ming,
>
>> I don't understand the motivation of ramp-up/ramp-down, maybe it is just
>> for fairness among LUNs.
> Congestion control. Devices have actual, physical limitations that are
> different from the tag context limitations on the HBA. You don't have
> that problem on NVMe because (at least for PCIe) the storage device and
> the controller are one and the same.
>
> If you submit 100000 concurrent requests to a SCSI drive that does 100
> IOPS, some requests will time out before they get serviced.
> Consequently we have the ability to raise and lower the queue depth to
> constrain the amount of requests in flight to a given device at any
> point in time.
>
> Also, devices use BUSY/QUEUE_FULL/TASK_SET_FULL to cause the OS to back
> off. We frequently see issues where the host can submit burst I/O much
> faster than the device can de-stage from cache. In that scenario the
> device reports BUSY/QF/TSF and we will back off so the device gets a
> chance to recover. If we just let the application submit new I/O without
> bounds, the system would never actually recover.
>
> Note that the actual, physical limitations for how many commands a
> target can handle are typically much, much lower than the number of tags
> the HBA can manage. SATA devices can only express 32 concurrent
> commands. SAS devices typically 128 concurrent commands per
> port. Arrays differ.
>
> If we ignore the RAID controller use case where the controller
> internally queues and arbitrates commands between many devices, how is
> submitting 1000 concurrent requests to a device which only has 128
> command slots going to work?
>
> Some HBAs have special sauce to manage BUSY/QF/TSF, some don't. If we
> blindly stop restricting the number of I/Os in flight in the ML, we may
> exceed either the capabilities of what the transport protocol can
> express or internal device resources.
>
