From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] block: bsg.c: Cleaning up missing null-terminate in
 conjunction with strncpy
Date: Tue, 29 Jul 2014 21:09:01 +0200
Message-ID: <CAFo99gY_eKF3Pbqte+WXSWXDg3d=NkFEswWMivgCjYT5-0m_vw@mail.gmail.com>
References: <1406383665-1670-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <x49sillpnbm.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:46426 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaG2TJW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2014 15:09:22 -0400
Received: by mail-oa0-f50.google.com with SMTP id g18so128912oah.37
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 12:09:21 -0700 (PDT)
In-Reply-To: <x49sillpnbm.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

2014-07-28 16:31 GMT+02:00 Jeff Moyer <jmoyer@redhat.com>:
> Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:
>
>> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  block/bsg.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/block/bsg.c b/block/bsg.c
>> index ff46add..b2688c5 100644
>> --- a/block/bsg.c
>> +++ b/block/bsg.c
>> @@ -790,7 +790,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
>>       mutex_lock(&bsg_mutex);
>>       hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
>>
>> -     strncpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name) - 1);
>> +     strlcpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name));
>>       dprintk("bound to <%s>, max queue %d\n",
>>               format_dev_t(buf, inode->i_rdev), bd->max_queue);
>
> NACK
>
> The bsg data structure is allocated using kzalloc, so that last byte
> will be zero.

Hi

Sorry.. I did not know bsg_alloc_device used kzalloc, right then
everything should be ok.

Kind regards
Rickard Strandqvist
