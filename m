From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH] compat_ioct: fix bsg SG_IO
Date: Fri, 22 Jan 2010 13:00:56 -0800
Message-ID: <79BF0CE4-4067-4F6E-ADF9-7CD8A073DF10@qlogic.com>
References: <20100105194104F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25453 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab0AVVA6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2010 16:00:58 -0500
In-Reply-To: <20100105194104F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: LinuxSCSI <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

James,

I don't see this patch from Fujita included in your scsi-rc- 
fixes-2.6.git. This is required to run 32 bit BSG application on 64  
bit system. Can u please include this.

Thanks,
Giridhar Malavali


On Jan 5, 2010, at 2:41 AM, FUJITA Tomonori wrote:

> bsg's SG_IO doesn't work on 32-bit userspace and 64-bit kernelspace.
>
> The problem is that both sg and bsg drivers use SG_IO
> ioctl. sg_ioctl_trans() does 32/64-bit conversion even against bsg
> header. It messes up bsg header. bsg driver gets garbage.
>
> This patch fixes sg_ioctl_trans to handle only sg header (struct
> sg_io_hdr).
>
> Reported-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
> fs/compat_ioctl.c |    6 ++++++
> 1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 332dd00..86690cf 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -301,6 +301,12 @@ static int sg_ioctl_trans(unsigned int fd,  
> unsigned int cmd,
> 	u32 data;
> 	void __user *dxferp;
> 	int err;
> +	int interface_id;
> +
> +	if (get_user(interface_id, &sgio32->interface_id))
> +		return -EFAULT;
> +	if (interface_id != 'S')
> +		return sys_ioctl(fd, cmd, (unsigned long)sgio32);
>
> 	if (get_user(iovec_count, &sgio32->iovec_count))
> 		return -EFAULT;
> -- 
> 1.5.6.5
>

