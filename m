From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] cciss: use timeout to ensure scan thread exits
Date: Tue, 16 Jun 2009 14:10:07 -0700
Message-ID: <20090616141007.9b3852e7.akpm@linux-foundation.org>
References: <20090616204325.GA29502@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbZFPVKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2009 17:10:19 -0400
In-Reply-To: <20090616204325.GA29502@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 16 Jun 2009 15:43:25 -0500
"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> Patch 1 of 1
> 
> This patch implements wait_for_completion_interruptible_timeout in the
> scan_thread function to ensure it will exit cleanly during rmmod. Calling
> complete in cciss_remove_one caused a race condition. Using the wait with a
> timeout seems to work around that but it does fire the thread. The overhead
> should be minimal.
> 
> Changelog:
> Replace wait_for_completion_interruptible with
> wait_for_completion_interruptible_timeout in scan_thread().
> Use 5 second timeout value to avoid race.
> 
> Signed-off-by: Mike Miller
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 4d4d5e0..76e7c10 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3043,7 +3043,7 @@ static int scan_thread(void *data)
>  	h->rescan_wait = &wait;
>  
>  	for (;;) {
> -		rc = wait_for_completion_interruptible(&wait);
> +		rc = wait_for_completion_interruptible_timeout(&wait, 5);
>  		if (kthread_should_stop())
>  			break;
>  		if (!rc)

c'mon Mike, that's a hack.
