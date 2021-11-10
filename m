Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B644C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 01:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10DC96112F
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 01:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhKJBj0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 20:39:26 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:59422 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbhKJBjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 20:39:25 -0500
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 1CDEA2EAA0D;
        Tue,  9 Nov 2021 20:36:36 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id AitXvYCCv9Tb; Tue,  9 Nov 2021 20:36:35 -0500 (EST)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id E323C2EAA0B;
        Tue,  9 Nov 2021 20:36:34 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 11/11] scsi: ufs: Implement polling support
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-12-bvanassche@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <b921b85e-1685-da71-2ee7-806d8e75ce9d@interlog.com>
Date:   Tue, 9 Nov 2021 20:36:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110004440.3389311-12-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-11-09 7:44 p.m., Bart Van Assche wrote:
> The time spent in io_schedule() is significant when submitting direct
> I/O to a UFS device. Hence this patch that implements polling support.
> User space software can enable polling by passing the RWF_HIPRI flag to
> the preadv2() system call or the IORING_SETUP_IOPOLL flag to the
> io_uring interface.

There have been some changes recently (i.e. in linux-stable now),
"HIPRI" seems to be on the out, replaced by "POLLED". [I'm using
poll_lld in my sg rewrite to refer to this type of polling, as "poll"
is an overloaded term in the kernel].

REQ_HIPRI has become REQ_POLLED and blk_poll() is now bio_poll().
That said RWF_HIPRI is still in fs.h and there is no RWF_POLLED (yet).

LL_POLL or LOW_POLL would be more indicative of what is happening,
rather than POLLED, IMO.


Not sure if the new bio_poll() code is working, I'm looking at an
NULL pointer dereference at: RIP: 0010:bio_poll+0x17/0xe0

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 45 +++++++++++++++++++++++----------------
>   1 file changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 36df89e8a575..70f128f12445 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5250,6 +5250,31 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>   	}
>   }
>   
> +/*
> + * Returns > 0 if one or more commands have been completed or 0 if no
> + * requests have been completed.
> + */
> +static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
> +{
> +	struct ufs_hba *hba = shost_priv(shost);
> +	unsigned long completed_reqs, flags;
> +	u32 tr_doorbell;
> +
> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
> +	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
> +	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> +		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
> +		  hba->outstanding_reqs);
> +	hba->outstanding_reqs &= ~completed_reqs;
> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +
> +	if (completed_reqs)
> +		__ufshcd_transfer_req_compl(hba, completed_reqs);
> +
> +	return completed_reqs;
> +}
> +
>   /**
>    * ufshcd_transfer_req_compl - handle SCSI and query command completion
>    * @hba: per adapter instance
> @@ -5260,9 +5285,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>    */
>   static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
>   {
> -	unsigned long completed_reqs, flags;
> -	u32 tr_doorbell;
> -
>   	/* Resetting interrupt aggregation counters first and reading the
>   	 * DOOR_BELL afterward allows us to handle all the completed requests.
>   	 * In order to prevent other interrupts starvation the DB is read once
> @@ -5277,21 +5299,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
>   	if (ufs_fail_completion())
>   		return IRQ_HANDLED;
>   
> -	spin_lock_irqsave(&hba->outstanding_lock, flags);
> -	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
> -	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> -		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
> -		  hba->outstanding_reqs);
> -	hba->outstanding_reqs &= ~completed_reqs;
> -	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> -
> -	if (completed_reqs) {
> -		__ufshcd_transfer_req_compl(hba, completed_reqs);
> -		return IRQ_HANDLED;
> -	} else {
> -		return IRQ_NONE;
> -	}
> +	return ufshcd_poll(hba->host, 0) ? IRQ_HANDLED : IRQ_NONE;
>   }
>   
>   int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
> @@ -8112,6 +8120,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>   	.name			= UFSHCD,
>   	.proc_name		= UFSHCD,
>   	.queuecommand		= ufshcd_queuecommand,
> +	.mq_poll		= ufshcd_poll,
>   	.slave_alloc		= ufshcd_slave_alloc,
>   	.slave_configure	= ufshcd_slave_configure,
>   	.slave_destroy		= ufshcd_slave_destroy,
> 

