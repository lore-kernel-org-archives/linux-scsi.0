From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v2 7/7] blk-zoned: implement ioctls
Date: Mon, 26 Sep 2016 18:12:24 -0500
Message-ID: <CAJVOszCdwMhLyZAJAWDnDBziyAejxdwi5J-X197RXwNuvC82GA@mail.gmail.com>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com>
 <1474888483-29762-8-git-send-email-damien.lemoal@hgst.com> <20160926163752.GA13876@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:49186 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753980AbcIZXMq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Sep 2016 19:12:46 -0400
Received: from pps.filterd (m0075552.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8QN9Oi2008272
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 19:12:45 -0400
Received: from mail-yb0-f197.google.com (mail-yb0-f197.google.com [209.85.213.197])
        by mx0a-00003501.pphosted.com with ESMTP id 25q9p611wt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 19:12:45 -0400
Received: by mail-yb0-f197.google.com with SMTP id e2so347436970ybi.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 16:12:45 -0700 (PDT)
In-Reply-To: <20160926163752.GA13876@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Damien Le Moal <damien.lemoal@hgst.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>

On Mon, Sep 26, 2016 at 11:37 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> +     zones = kzalloc(sizeof(struct blk_zone) * rep.nr_zones,
>> +                     GFP_KERNEL);
>> +     if (!zones)
>> +             return -ENOMEM;
>
> This should use kcalloc to get us underflow checking for the user
> controlled allocation size.

Ah. yes. Will fix that.

>> +     if (copy_to_user(argp, &rep, sizeof(struct blk_zone_report))) {
>> +             ret = -EFAULT;
>> +             goto out;
>> +     }
>> +
>> +     if (rep.nr_zones) {
>> +             if (copy_to_user(argp + sizeof(struct blk_zone_report), zones,
>> +                              sizeof(struct blk_zone) * rep.nr_zones))
>> +                     ret = -EFAULT;
>> +     }
>
> We could actually do this with a single big copy_to_user.  Not that
> it really matters, though..

Except our source locations are disjoint (stack and kcalloc'd).

>> -/*
>> - * Zone type.
>> - */
>> -enum blk_zone_type {
>> -     BLK_ZONE_TYPE_UNKNOWN,
>> -     BLK_ZONE_TYPE_CONVENTIONAL,
>> -     BLK_ZONE_TYPE_SEQWRITE_REQ,
>> -     BLK_ZONE_TYPE_SEQWRITE_PREF,
>> -};
>
> Please don't move this code around after it was added just two
> patches earlier.  I'd say just split adding the new blkzoned.h
> uapi header into a patch of it's own and add that before the
> core block code.

Sounds good. Will reshuffle the patchset tonight.

Thanks!
-- 
Shaun Tancheff
