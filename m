From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fcoe: Remove redundant 'less than zero' check
Date: Mon, 9 Jul 2012 16:29:39 -0700
Message-ID: <20120709162939.9d0481e7.akpm@linux-foundation.org>
References: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
	<20120705145225.21808.62255.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2GIX3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2012 19:29:41 -0400
In-Reply-To: <20120705145225.21808.62255.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org

On Thu, 05 Jul 2012 07:52:25 -0700
Robert Love <robert.w.love@intel.com> wrote:

> strtoul returns an 'unsigned long' so there is no
> reason to check if the value is less than zero.
> 
> strtoul already checks for the '-' character deep
> in its bowels. It will return an error if the user
> has provided a negative value and fcoe_str_to_dev_loss
> will return that error to its caller.

huh, I never knew that.  So if we feed -1 to kstrtoul() it gets treated
as an error?  That seems a bit surprising.  You're sure about that?

> This patch fixes the following Coverity reported warning:
> 
> CID 703581 -  NO_EFFECT Unsigned compared against 0 - This
> less-than-zero comparison of an unsigned value is never true. "*val < 0UL".
> drivers/scsi/fcoe/fcoe_sysfs.c:105
> 
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> ---
>  drivers/scsi/fcoe/fcoe_sysfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
> index 2bc1631..5e75168 100644
> --- a/drivers/scsi/fcoe/fcoe_sysfs.c
> +++ b/drivers/scsi/fcoe/fcoe_sysfs.c
> @@ -102,7 +102,7 @@ static int fcoe_str_to_dev_loss(const char *buf, unsigned long *val)
>  	int ret;
>  
>  	ret = kstrtoul(buf, 0, val);
> -	if (ret || *val < 0)
> +	if (ret)
>  		return -EINVAL;
>  	/*
>  	 * Check for overflow; dev_loss_tmo is u32
