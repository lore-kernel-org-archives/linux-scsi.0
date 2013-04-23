From: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/9] fix max discard sectors limit
Date: Tue, 23 Apr 2013 14:16:28 +0900
Message-ID: <CAKYAXd-PUJ2YXr7QMMw9HWzSXzOO=Yb_CCo7AyfrT-_MP5Sa6Q@mail.gmail.com>
References: <1366389602-19313-1-git-send-email-linkinjeon@gmail.com>
	<20130422212324.GB4704@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20130422212324.GB4704@localhost>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=nbd-general>
List-Post: <mailto:nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org, adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cjb-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

2013/4/23, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>:
> On Sat, Apr 20, 2013 at 01:40:02AM +0900, Namjae Jeon wrote:
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
>
> Complete NACK - like James said, this fix is nonsensical. This should be
> fixed by just checking for overflow before merging requests, not with
> weird hacks in the drivers.
that agree to your opinion, and will change at only appropriate
place(James'change) and will send the updated patch soon.
Thanks.
>

------------------------------------------------------------------------------
Try New Relic Now & We'll Send You this Cool Shirt
New Relic is the only SaaS-based application performance monitoring service 
that delivers powerful full stack analytics. Optimize and monitor your
browser, app, & servers with just a few lines of code. Try New Relic
and get this awesome Nerd Life shirt! http://p.sf.net/sfu/newrelic_d2d_apr
