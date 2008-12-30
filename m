From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix sg_io_hdr.info corruption.
Date: Tue, 30 Dec 2008 15:46:03 -0800
Message-ID: <20081230154603.4fd60167.akpm@linux-foundation.org>
References: <20081228144946.30288.67559.stgit@zaytsev.su>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243AbYL3XqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2008 18:46:17 -0500
In-Reply-To: <20081228144946.30288.67559.stgit@zaytsev.su>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On Sun, 28 Dec 2008 17:50:35 +0300
Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> sizeof(unsigned (short)) is actually sizeof(function), == 1.
> Spotted by sparse.
> 
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> ---
>  fs/compat_ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 5235c67..7c2d617 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -784,7 +784,7 @@ static int sg_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
>  
>  	if (copy_in_user(&sgio->status, &sgio32->status,
>  			 (4 * sizeof(unsigned char)) +
> -			 (2 * sizeof(unsigned (short))) +
> +			 (2 * sizeof(unsigned short)) +
>  			 (3 * sizeof(int))))
>  		return -EFAULT;

gack.

akpm:/home/akpm> cat t.c
main()
{
	        printf("%d\n", sizeof(unsigned (short)));
	        printf("%d\n", sizeof(unsigned short));
}
akpm:/home/akpm> ./a.out
1
2


the code has been like this for years and years.  Why hasn't anyone
noticed?  
