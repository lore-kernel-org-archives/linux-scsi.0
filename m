From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix section mismatch in the Adaptec DPT SCSI Raid
 driver
Date: Fri, 17 Aug 2007 14:18:56 -0700
Message-ID: <20070817141856.5720ed38.akpm@linux-foundation.org>
References: <20070817205115.GA12416@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35202 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386AbXHQVTJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Aug 2007 17:19:09 -0400
In-Reply-To: <20070817205115.GA12416@tsunami.ccur.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Korty <joe.korty@ccur.com>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 16:51:15 -0400
Joe Korty <joe.korty@ccur.com> wrote:

> Fix section mismatch in the Adaptec DPT SCSI Raid driver.
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 
> Index: 2.6.23-rc3-git1/drivers/scsi/dpt_i2o.c
> ===================================================================
> --- 2.6.23-rc3-git1.orig/drivers/scsi/dpt_i2o.c	2007-08-17 16:36:05.000000000 -0400
> +++ 2.6.23-rc3-git1/drivers/scsi/dpt_i2o.c	2007-08-17 16:50:13.000000000 -0400
> @@ -3351,7 +3351,7 @@
>  	return count > 0 ? 0 : -ENODEV;
>  }
>  
> -static void __exit adpt_exit(void)
> +static void adpt_exit(void)
>  {
>  	while (hba_chain)
>  		adpt_release(hba_chain);

Please always provide at least a copy of the error message when providing
patches which fix warnings, or build errors, or section mismatches.

For section mismatches, an analysis of what caused the problem would help,
too.  It saves others from having to do the same thing.

In this case, I'd need to see what error is being fixed so that I can judge
the seriousness of the problem.  In this case I don't _think_ it'll be
terribly serious because iirc most architectures don't free exitcall memory.

