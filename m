From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI: add check for host busy in scsi_run_queue()
Date: Mon, 20 Sep 2010 12:56:10 -0500
Message-ID: <1285005370.2973.272.camel@mulgrave.site>
References: <AANLkTi=jMYEsMtTQmnMSKxwYNzpwCLLkgsEvHAxWj8ui@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52517 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab0ITR4Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2010 13:56:16 -0400
In-Reply-To: <AANLkTi=jMYEsMtTQmnMSKxwYNzpwCLLkgsEvHAxWj8ui@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Sun, 2010-09-19 at 20:53 +0800, Hillf Danton wrote:
> It seems that check for host busy is deserved before scanning the starved list.
> And list operation is simplified.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- o/linux-2.6.36-rc4/drivers/scsi/scsi_lib.c	2010-09-13
> 07:07:38.000000000 +0800
> +++ m/linux-2.6.36-rc4/drivers/scsi/scsi_lib.c	2010-09-19
> 20:32:34.000000000 +0800
> @@ -399,18 +399,20 @@ static inline int scsi_host_is_busy(stru
>   */
>  static void scsi_run_queue(struct request_queue *q)
>  {
> -	struct scsi_device *sdev = q->queuedata;
> +	struct scsi_device *sdev = q->queuedata, *safe;
>  	struct Scsi_Host *shost = sdev->host;
> -	LIST_HEAD(starved_list);
>  	unsigned long flags;
> 
>  	if (scsi_target(sdev)->single_lun)
>  		scsi_single_lun_run(sdev);
> 
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	list_splice_init(&shost->starved_list, &starved_list);
> -
> -	while (!list_empty(&starved_list)) {
> +	if (scsi_host_is_busy(shost)) {
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		return;
> +	}

To be honest, there's no real gain from this micro-optimisation.

> +	list_for_each_entry_safe(sdev, safe, &shost->starved_list,
> +					starved_entry) {

And this is definitely wrong.  The list is altered in flight so the
whole purpose of the static copy is to process only what existed before
we began; otherwise you can get a livelock.

James


