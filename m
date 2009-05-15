From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 09/11] drivers/scsi: Convert #ifdef DEBUG
	printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 18:56:46 +0000
Message-ID: <1242413806.22585.2.camel@mulgrave.int.hansenpartnership.com>
References: <cover.1242407227.git.joe@perches.com>
	 <d6d5dc09d259cc1da0fef2b1e9c6b7588cccf0b4.1242407227.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59746 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbZEOS4q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 May 2009 14:56:46 -0400
In-Reply-To: <d6d5dc09d259cc1da0fef2b1e9c6b7588cccf0b4.1242407227.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2009-05-15 at 10:59 -0700, Joe Perches wrote:
> From: Joe Perches <joe@perches.com>
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/aha1542.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index 8059494..29d5118 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -509,9 +509,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
>  		if (mbistatus == 3)
>  			continue;	/* Aborted command not found */
>  
> -#ifdef DEBUG
> -		printk(KERN_DEBUG "...done %d %d\n", mbo, mbi);
> -#endif
> +		pr_debug("...done %d %d\n", mbo, mbi);

This one looks dangerous ... that's a per trigger printk from interrupt
context.  That's a lot of stuff to bung in the log buffer for a normal
operating case (which is pretty interrupt heavy).  What does this do to
system responsiveness?

James


