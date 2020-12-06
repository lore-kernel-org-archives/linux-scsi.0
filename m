Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63AA2C4361B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 13:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C2CE2313F
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 13:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgLFN44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 08:56:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:36168 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbgLFN44 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 6 Dec 2020 08:56:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 27643AC55;
        Sun,  6 Dec 2020 13:56:14 +0000 (UTC)
Subject: Re: [PATCH 1/3] block: try one write zeroes request before going
 further
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20201206055332.3144-1-tom.ty89@gmail.com>
 <7987f7f1-d608-26d0-3f2f-86a7bd7cc03d@suse.de>
 <CAGnHSEmKsbgdprMebd-1gwpU52n4WkWb04cro1_z50g47-QjrQ@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ba469342-b94b-4d2d-4af0-085711979a52@suse.de>
Date:   Sun, 6 Dec 2020 14:56:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAGnHSEmKsbgdprMebd-1gwpU52n4WkWb04cro1_z50g47-QjrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/6/20 2:25 PM, Tom Yan wrote:
> I think you misunderstood it. The goal of this patch is to split the
> current situation into two chains (or one unchained bio + a series of
> chained bio). The first one is an attempt/trial which makes sure that
> the latter large bio chain can actually be handled (as per the
> "command capability" of the device).
> 
Oh, I think I do get what you're trying to do. And, in fact, I don't 
argue with what you're trying to achieve.

What I would like to see, though, is keep the current bio_chain logic 
intact (irrespective of your previous patch, which should actually be 
part of this series), and just lift the first check out of the loop:

@@ -262,9 +262,14 @@ static int __blkdev_issue_write_zeroes(struct 
block_device *bdev,

         if (max_write_zeroes_sectors == 0)
                 return -EOPNOTSUPP;
-
+       new = bio_alloc(gfp_mask, 0);
+       bio_chain(bio, new);
+       if (submit_bio_wait(bio) == BLK_STS_NOTSUPP) {
+               bio_put(new);
+               return -ENOPNOTSUPP;
+       }
+       bio = new;
         while (nr_sects) {
-               bio = blk_next_bio(bio, 0, gfp_mask);
                 bio->bi_iter.bi_sector = sector;
                 bio_set_dev(bio, bdev);
                 bio->bi_opf = REQ_OP_WRITE_ZEROES;
@@ -279,6 +284,7 @@ static int __blkdev_issue_write_zeroes(struct 
block_device *bdev,
                         bio->bi_iter.bi_size = nr_sects << 9;
                         nr_sects = 0;
                 }
+               bio = blk_next_bio(bio, 0, gfp_mask);
                 cond_resched();
         }

(The error checking from submit_bio_wait() could be improved :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
