From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 06/13] [scsi] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 21:24:48 +0000
Message-ID: <1237929888.3308.31.camel@localhost.localdomain>
References: <1237929168-15341-7-git-send-email-stoyboyker@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49674 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZCXVYu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 17:24:50 -0400
In-Reply-To: <1237929168-15341-7-git-send-email-stoyboyker@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

On Tue, 2009-03-24 at 16:12 -0500, stoyboyker@gmail.com wrote:
> From: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  drivers/scsi/osst.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
> index 0ea78d9..80e7e98 100644
> --- a/drivers/scsi/osst.c
> +++ b/drivers/scsi/osst.c
> @@ -4856,9 +4856,10 @@ static int os_scsi_tape_close(struct inode * inode, struct file * filp)
>  
> 
>  /* The ioctl command */
> -static int osst_ioctl(struct inode * inode,struct file * file,
> -	 unsigned int cmd_in, unsigned long arg)
> +static long osst_ioctl(struct file * file, unsigned int cmd_in,
> +	unsigned long arg)
>  {
> +	lock_kernel();

What necessitates the kernel locking?  When st was audited, it didn't
need it; since osst is in many ways a copy of st, I'm surprised it does.

James


