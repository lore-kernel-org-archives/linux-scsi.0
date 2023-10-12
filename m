Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431ECCDB46E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Oct 2023 17:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379549AbjJLRmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Oct 2023 13:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344076AbjJLRmN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Oct 2023 13:42:13 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C27B8;
        Thu, 12 Oct 2023 10:42:10 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-692779f583fso1006206b3a.0;
        Thu, 12 Oct 2023 10:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697132530; x=1697737330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ndqa30CQIymFuT6Sso7sr9ap3JdzBFoNx9/TN24OZA=;
        b=p/D53b+TG6l29MdLDIjkTLLm3zSXwfCd7lnyRpR9Rj7TilQ++M9XsOTeWsGOIxBeHr
         Vl9c0kE+3zqD2LGOYehuDCuMud0bhufieU0I8BbFKoybEHEQh0AFK8m1nQ4Z45XeBWwR
         EY75QtA1KDp+pS7tnFJGjJc1Mwz+wdrMFh9odUCtVRdBHvNWNc7cEJ0ykPT7UD2tyLTj
         MilA16G4qLNPlpNoKlNNBZSynJiCKrvn2rsXqI3oTSKIL4mnXKTM5Q6TkCtpp/FzfE44
         NxoYv5R8rJ9I4vVjSSYvv1ar1jU7BIcCuPyJoBvPtMqirq+B/kMwOOxUqzk64Bg+0XYT
         BvYw==
X-Gm-Message-State: AOJu0YyaxCyVVZrfkopnOpvRMnT7cM+X9R6kq/VWbivRSv9ho6ik7Bin
        Y2+jsIbViozGEdkrJiCvg8M=
X-Google-Smtp-Source: AGHT+IGuSZ0jrtcDlQYNhibLnF4qw/wlJA70J2vp7mluVMdeCdB2FOOuxqQvednZKKWfpx5XDBNBoA==
X-Received: by 2002:a05:6a20:12c6:b0:174:63a9:293 with SMTP id v6-20020a056a2012c600b0017463a90293mr4307565pzg.48.1697132529924;
        Thu, 12 Oct 2023 10:42:09 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:414d:a1fb:8def:b3ee? ([2620:15c:211:201:414d:a1fb:8def:b3ee])
        by smtp.gmail.com with ESMTPSA id jk22-20020a170903331600b001bfd92ec592sm2258829plb.292.2023.10.12.10.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 10:42:09 -0700 (PDT)
Message-ID: <a490bc37-464e-4edc-b11a-91b11d24af6d@acm.org>
Date:   Thu, 12 Oct 2023 10:42:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/15] block: Make bio_set_ioprio() modify fewer
 bio->bi_ioprio bits
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Damien Le Moal <dlemoal@kernel.org>
References: <20231005194129.1882245-1-bvanassche@acm.org>
 <CGME20231005194156epcas5p14c65d7fbecc60f97624a9ef968bebf2e@epcas5p1.samsung.com>
 <20231005194129.1882245-2-bvanassche@acm.org>
 <28f21f46-60f1-1651-e6a9-938fd2340ff5@samsung.com>
 <bfb7e2be-79f8-4f5e-b87e-3045d9c937b4@acm.org>
 <fdf765a0-54a0-a9e9-fffa-3e733c2535b0@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fdf765a0-54a0-a9e9-fffa-3e733c2535b0@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/23 01:49, Kanchan Joshi wrote:
> Function does OR bio->bi_ioprio with whatever is the return of
> get_current_ioprio().

No, that's not what ioprio_set_class_and_level() does. It clears the 
hint bits before it performs a logical OR.

> So if lifetime bits were set in get_current_ioprio(), you will end up
> setting that in bio->bi_ioprio too.
I'm not sure there are any use cases where it is useful to set the data
lifetime for an entire process.

Anyway, how about replacing this patch with the patch below? This will
allow to set hint information for an entire process.

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e2d11183f62e..3419ca4c1bf4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2924,9 +2924,14 @@ static inline struct request 
*blk_mq_get_cached_request(struct request_queue *q,

  static void bio_set_ioprio(struct bio *bio)
  {
+	u16 cur_ioprio = get_current_ioprio();
+
  	/* Nobody set ioprio so far? Initialize it based on task's nice value */
  	if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) == IOPRIO_CLASS_NONE)
-		bio->bi_ioprio = get_current_ioprio();
+		bio->bi_ioprio |= cur_ioprio & IOPRIO_CLASS_LEVEL_MASK;
+	if (IOPRIO_PRIO_HINT(bio->bi_ioprio) == 0)
+		bio->bi_ioprio |= cur_ioprio &
+			(IOPRIO_HINT_MASK << IOPRIO_HINT_SHIFT);
  	blkcg_set_ioprio(bio);
  }

diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index 7578d4f6a969..5697832f35a3 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -71,4 +71,7 @@ static inline int ioprio_check_cap(int ioprio)
  }
  #endif /* CONFIG_BLOCK */

+#define IOPRIO_CLASS_LEVEL_MASK ((IOPRIO_CLASS_MASK << 
IOPRIO_CLASS_SHIFT) | \
+				 (IOPRIO_LEVEL_MASK << 0))
+
  #endif


>> ioprio_set_class_and_level() preserves the hint bits set by F2FS.
>>
>>> And what is the user interface you have in mind. Is it ioprio based, or
>>> write-hint based or mix of both?
>>
>> Since the data lifetime is encoded in the hint bits, the hint bits need
>> to be set by user space to set a data lifetime.
> 
> I asked because more than one way seems to emerge here. Parts of this
> series (Patch 4) are taking inode->i_write_hint (and not ioprio value)
> and putting that into bio.
> I wonder what to expect if application get to send one lifetime with
> fcntl (write-hints) and different one with ioprio. Is that not racy?

There is no race condition. F_SET_RW_HINT can be used to set 
inode->i_write_hint. The filesystem may use the inode->i_write_hint 
information. I think F2FS uses this information in its block allocator.

>> +            --prio=$((i<<6))
> 
> This will not work as prio can only take values between 0-7.
> Perhaps you want to use "priohint" to send lifetime.

Thanks for having mentioned the priohint option. The above works on my
test setup since I modified fio locally to accept larger prio values. I
will switch to the priohint option.

Bart.
