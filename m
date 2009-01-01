From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] Fix sg_io_hdr.info corruption.
Date: Thu, 01 Jan 2009 09:54:00 -0500
Message-ID: <495CD908.6050700@interlog.com>
References: <20081231180759X.fujita.tomonori@lab.ntt.co.jp> <20090101110133.14065.98145.stgit@zaytsev.su>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33807 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbZAAOyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jan 2009 09:54:10 -0500
In-Reply-To: <20090101110133.14065.98145.stgit@zaytsev.su>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@hansenpartnership.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

Alexey Zaytsev wrote:
> [resending in case you missed the one I sent with broken headers]
> 
> On Wed, Dec 31, 2008 at 12:08, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>> On Tue, 30 Dec 2008 15:46:03 -0800
>> Andrew Morton <akpm@linux-foundation.org> wrote:
> [...]
>>> the code has been like this for years and years.  Why hasn't anyone
>>> noticed?
>> The members from 'status' in struct sg_io_hdr to the last are used to
>> transfer information from kernel to user space. The values that user
>> space sets are just ignored.
>>
> 
> Then probably there is no need to copy those fields, right?

Correct.

Doug Gilbert

> There should be no data leak from the kernel, as sgio is
> allocated on the userspace stack, and the appropriate ioctl
> handler should set/zero all those fields anyway, as it expects
> them to come directly from the user (did not check).
> So, in the worst case the user gets his own garbage insted of
> the values he left in the fields that the kernel was supposed
> to set.
> 
> If so, please drop my previous patch and take this one.
> 
> From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> Subject: [PATCH] Don't perform unneeded copy.
> 
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> says:
> 
> The members from 'status' in struct sg_io_hdr to the last are used to
> transfer information from kernel to user space. The values that user
> space sets are just ignored.
> 
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> ---
>  fs/compat_ioctl.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 5235c67..23b1f5a 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -782,12 +782,6 @@ static int sg_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
>  	if (put_user(compat_ptr(data), &sgio->usr_ptr))
>  		return -EFAULT;
>  
> -	if (copy_in_user(&sgio->status, &sgio32->status,
> -			 (4 * sizeof(unsigned char)) +
> -			 (2 * sizeof(unsigned (short))) +
> -			 (3 * sizeof(int))))
> -		return -EFAULT;
> -
>  	err = sys_ioctl(fd, cmd, (unsigned long) sgio);
>  
>  	if (err >= 0) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

