From: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/9] fix max discard sectors limit
Date: Sun, 21 Apr 2013 10:37:39 +0900
Message-ID: <CAKYAXd95xE1S4J-kuGzKYxWHZMZrKh6=-iSgkNakmGe15_AF=g@mail.gmail.com>
References: <1366389602-19313-1-git-send-email-linkinjeon@gmail.com>
	<1366487439.1993.9.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1366487439.1993.9.camel@dabdike>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=nbd-general>
List-Post: <mailto:nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org, adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cjb-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

2013/4/21 James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>:
> On Sat, 2013-04-20 at 01:40 +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>
>> linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
>> commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9
>> (block: add plug for blkdev_issue_discard )
>>
>> For example,
>> 1) DISCARD rq-1 with size size 4GB
>> 2) DISCARD rq-2 with size size 1GB
>>
>> If these 2 discard requests get merged, final request size will be 5GB.
>>
>> In this case, request's __data_len field may overflow as it can store
>> max 4GB(unsigned int).
>>
>> This issue was observed while doing mkfs.f2fs on 5GB SD card:
>> https://lkml.org/lkml/2013/4/1/292
>>
>> # mkfs.f2fs /dev/mmcblk0p3
>> Info: sector size = 512
>> Info: total sectors = 11370496 (in 512bytes)
>> Info: zone aligned segment0 blkaddr: 512
>> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
>>
>> mkfs process gets stuck in D state and I see the following in the dmesg:
>>
>> [  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
>> [  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
>> [  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
>> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
>> [  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
>> [  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
>> [  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
>>
>> Few drivers(e.g. mmc, mtd..) set q->limits.max_discard_sectors
>> more than UINT_MAX >> 9 sectors which is incorrect and it may lead to overflow
>> of request's __data_len field if merged discard request's size exceeds 4GB.
>>
>> This patchset fixes this issue by updating helper function
>> blk_queue_max_discard_sectors which is used to set max_discard_sectors limit.
>>
>> This patchset also replaces "q->limits.max_discard_sector = max_discard_sectors"
>> with blk_queue_max_discard_sectors call in other drivers like mmc, mtd etc.
>
Hi. James.
> I really don't understand this explanation.  How can you be affected by
> the incorrect setting of q->limits.max_discard sectors when  n the
> blkdev_issue_discard() code you see:
>
>         max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >>
> 9);
>
> ?
>
> The problem is not that we issue discards bigger than __data_len can
> allow, the problem is that we merge them larger than __data_len will
> allow.  That means the merge code needs fixing to pay attention to
> max_discard_sectors, so isn't this the correct fix:
Yes, I agree. And the below patch looks good to fix this issue.
Thanks for your comment.

>
> James
>
> ---
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 78feda9..33f358f 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -838,7 +838,7 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
>                                                      unsigned int cmd_flags)
>  {
>         if (unlikely(cmd_flags & REQ_DISCARD))
> -               return q->limits.max_discard_sectors;
> +               return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
>
>         if (unlikely(cmd_flags & REQ_WRITE_SAME))
>                 return q->limits.max_write_same_sectors;
>
>

------------------------------------------------------------------------------
Precog is a next-generation analytics platform capable of advanced
analytics on semi-structured data. The platform includes APIs for building
apps and a phenomenal toolset for data science. Developers can use
our toolset for easy data analysis & visualization. Get a free account!
http://www2.precog.com/precogplatform/slashdotnewsletter
