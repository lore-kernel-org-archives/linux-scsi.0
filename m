From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 09/27] target: use bio_is_full()
Date: Thu, 7 Apr 2016 12:07:07 +0800
Message-ID: <CACVXFVPL7x8aozVTnKfJUJAEpzKogdcjR8vAmJmd+BzuFzEnWg@mail.gmail.com>
References: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
	<1459857443-20611-10-git-send-email-tom.leiming@gmail.com>
	<20160405130223.GC32576@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33525 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbcDGEHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2016 00:07:08 -0400
In-Reply-To: <20160405130223.GC32576@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>

On Tue, Apr 5, 2016 at 9:02 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Apr 05, 2016 at 07:56:54PM +0800, Ming Lei wrote:
>> +++ b/drivers/target/target_core_pscsi.c
>> @@ -951,7 +951,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>>                       pr_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
>>                               bio->bi_vcnt, nr_vecs);
>>
>> -                     if (bio->bi_vcnt > nr_vecs) {
>> +                     if (bio_is_full(bio)) {
>>                               pr_debug("PSCSI: Reached bio->bi_vcnt max:"
>>                                       " %d i: %d bio: %p, allocating another"
>>                                       " bio\n", bio->bi_vcnt, i, bio);
>
> This check should be removed entirely - bio_add_pc_page takes care of
> it.

OK.


-- 
Ming Lei
