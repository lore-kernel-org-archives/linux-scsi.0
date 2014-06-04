From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 4/7] mptfusion: zero kernel-space source of copy_to_user
Date: Wed, 4 Jun 2014 12:58:36 -0400
Message-ID: <20140604125836.7845a92d@jlaw-desktop.mno.stratus.com>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
	<1401900589-19672-5-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o145.mxlogic.net ([208.65.145.78]:45580 "EHLO
	p02c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaFDQ6o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 12:58:44 -0400
In-Reply-To: <1401900589-19672-5-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Wed, 4 Jun 2014 12:49:46 -0400
Joe Lawrence <joe.lawrence@stratus.com> wrote:

> Fixes the following smatch warning:
> 
>   drivers/message/fusion/mptctl.c:1369 mptctl_getiocinfo() warn:
>     possible info leak 'karg'
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> ---
>  drivers/message/fusion/mptctl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
> index dcc8385..e6d8935 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -1261,7 +1261,7 @@ mptctl_getiocinfo (unsigned long arg, unsigned int data_size)
>  	else
>  		return -EFAULT;
>  
> -	karg = kmalloc(data_size, GFP_KERNEL);
> +	karg = kzalloc(data_size, GFP_KERNEL);
>  	if (karg == NULL) {
>  		printk(KERN_ERR MYNAM "%s::mpt_ioctl_iocinfo() @%d - no memory available!\n",
>  				__FILE__, __LINE__);

Hi Dan,

kzalloc silenced that smatch warning, but the code looks like:

  (calculate data_size)
  ...
  karg = kmalloc(data_size, GFP_KERNEL);
  ...
  if (copy_from_user(karg, uarg, data_size)) {
  ...
  if (copy_to_user((char __user *)arg, karg, data_size)) {

where 'data_size' once calculated, is unchanged.  Since the size
allocated is the same copied from the user and the same copied back out
to the user, would this really be considered an info leak?

Regards,

-- Joe
