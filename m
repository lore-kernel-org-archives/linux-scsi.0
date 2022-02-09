Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7E7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 09:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiBIJWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 04:22:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiBIJWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 04:22:31 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E31DD94E6D;
        Wed,  9 Feb 2022 01:22:26 -0800 (PST)
Subject: Re: [PATCH 3/7] rnbd: drop WRITE_SAME support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644398508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G5r0Xdb8ikemnPVF5lI7cPng/XJyVvYg/5LzR+eCPl8=;
        b=SBWD6cBRt7Y057lo/4qj/+VF2PhBLswY5lpwyGDKDHGR+AtcS3+w+3Xw02pET5ANPPLSkF
        Pptp3sql6V14GuDWBtZUCNIa2ZQP4S6aLZJyfhxesJBpqDnH2UYJYVvuQSqRWRCcjszb+I
        FIAGH9YhhzQKy9IhE/O+9W6f2bb5gKc=
To:     Jinpu Wang <jinpu.wang@ionos.com>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        martin.petersen@oracle.com, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, target-devel@vger.kernel.org,
        haris.iqbal@ionos.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com,
        dm-devel@redhat.com
References: <20220209082828.2629273-1-hch@lst.de>
 <20220209082828.2629273-4-hch@lst.de>
 <4f1565b2-0f83-0cfa-58bd-86d5dee48e51@linux.dev>
 <CAMGffE=FmVj26PJtu5fwtr3rNbtE+-dcfxOrmT4hEt3sO7Kw2A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <0b8c9d4d-0fb0-1aee-97b2-f4381e124df2@linux.dev>
Date:   Wed, 9 Feb 2022 17:21:39 +0800
MIME-Version: 1.0
In-Reply-To: <CAMGffE=FmVj26PJtu5fwtr3rNbtE+-dcfxOrmT4hEt3sO7Kw2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2/9/22 5:13 PM, Jinpu Wang wrote:
>>> --- a/drivers/block/rnbd/rnbd-srv.c
>>> +++ b/drivers/block/rnbd/rnbd-srv.c
>>> @@ -548,8 +548,7 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
>>>                cpu_to_le16(rnbd_dev_get_max_segs(rnbd_dev));
>>>        rsp->max_hw_sectors =
>>>                cpu_to_le32(rnbd_dev_get_max_hw_sects(rnbd_dev));
>>> -     rsp->max_write_same_sectors =
>>> -             cpu_to_le32(bdev_write_same(rnbd_dev->bdev));
>>> +     rsp->max_write_same_sectors = 0;
>> IIUC, I think we can delete max_write_same_sectors from rsp as well given
>> the earlier change in setup_request_queue and rnbd_clt_set_dev_attr.
> No, I don't think it's a good idea, we need to keep the protocol
> compatible, so client for old kernel version
> won't be confused.

Fair enough. Then I guess it is better to add obsolete_ prefix like 
obsolete_rotational.

Thanks,
Guoqing
