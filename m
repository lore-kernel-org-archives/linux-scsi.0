From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/3] hpsa: limit outstanding rescans
Date: Fri, 10 Mar 2017 14:29:56 +0100
Message-ID: <0ddeaa0f-bce7-275b-aad5-7610a8a977d0@redhat.com>
References: <148883542370.14177.274248778005931414.stgit@brunhilda>
 <148883548551.14177.13814884598789454770.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934524AbdCJNaC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Mar 2017 08:30:02 -0500
In-Reply-To: <148883548551.14177.13814884598789454770.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On 6.3.2017 22:24, Don Brace wrote:
> avoid rescan storms. No need to queue another
> if one is pending.
>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/hpsa.c |   16 +++++++++++++++-
>  drivers/scsi/hpsa.h |    1 +
>  2 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1adc4ec..a36d3a6 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -5558,7 +5558,7 @@ static void hpsa_scan_complete(struct ctlr_info *h)
>  
>  	spin_lock_irqsave(&h->scan_lock, flags);
>  	h->scan_finished = 1;
> -	wake_up_all(&h->scan_wait_queue);
> +	wake_up(&h->scan_wait_queue);
>  	spin_unlock_irqrestore(&h->scan_lock, flags);
>  }
>  
> @@ -5576,11 +5576,23 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
>  	if (unlikely(lockup_detected(h)))
>  		return hpsa_scan_complete(h);
>  
> +	/*
> +	 * If a scan is alreay waiting to run, no need to add another
> +	 */
> +	spin_lock_irqsave(&h->scan_lock, flags);
> +	if (h->scan_waiting) {
> +		spin_unlock_irqrestore(&h->scan_lock, flags);
> +		return;
> +	}
> +
> +	spin_unlock_irqrestore(&h->scan_lock, flags);
> +
>  	/* wait until any scan already in progress is finished. */
>  	while (1) {
>  		spin_lock_irqsave(&h->scan_lock, flags);

Placing the test to this place would save few lines
+               if (h->scan_waiting) {
+                       spin_unlock_irqrestore(&h->scan_lock, flags);
+                       return
but I agree with your version too.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
tomash
