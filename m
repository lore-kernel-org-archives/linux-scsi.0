From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 3/6] scsi_debug: add multiple queue support
Date: Mon, 9 May 2016 09:12:28 -0700
Message-ID: <5730B6EC.90001@sandisk.com>
References: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
 <1462509629-24282-4-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0075.outbound.protection.outlook.com ([65.55.169.75]:48066
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752098AbcEIQMd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 May 2016 12:12:33 -0400
In-Reply-To: <1462509629-24282-4-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

On 05/05/2016 09:40 PM, Douglas Gilbert wrote:
>   static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
>   {
>   	unsigned long iflags;
> -	int k, qmax, r_qmax;
> +	int j, k, qmax, r_qmax;
> +	struct sdebug_queue *sqp;
>   	struct sdebug_queued_cmd *sqcp;
>   	struct sdebug_dev_info *devip;
>   	struct sdebug_defer *sd_dp;
>
> -	[ ... ]
> +	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
> +		spin_lock_irqsave(&sqp->qc_lock, iflags);
> +		qmax = sdebug_max_queue;
> +		r_qmax = atomic_read(&retired_max_queue);
> +		if (r_qmax > qmax)
> +			qmax = r_qmax;
> +		for (k = 0; k < qmax; ++k) {
> +			if (test_bit(k, sqp->in_use_bm)) {
> +				sqcp = &sqp->qc_arr[k];
> +				if (cmnd != sqcp->a_cmnd)
> +					continue;
> +				/* found */
> +				[ ... ]

It is not clear to me why a for-loop is used in this function to look up 
the sqp pointer instead of calling get_queue() or using sqa_idx?

>   static const char * scsi_debug_info(struct Scsi_Host * shp)
>   {
> -	sprintf(sdebug_info,
> -		"scsi_debug, version %s [%s], dev_size_mb=%d, opts=0x%x",
> -		SDEBUG_VERSION, sdebug_version_date, sdebug_dev_size_mb,
> -		sdebug_opts);
> +	int k;
> +
> +	k = scnprintf(sdebug_info, sizeof(sdebug_info),
> +		      "%s: version %s [%s], dev_size_mb=%d, opts=0x%x\n",
> +		      my_name, SDEBUG_VERSION, sdebug_version_date,
> +		      sdebug_dev_size_mb, sdebug_opts);
> +	if (k >= (sizeof(sdebug_info) - 1))
> +		return sdebug_info;
> +	scnprintf(sdebug_info + k, sizeof(sdebug_info) - k,
> +		  "%s: submit_queues=%d, statistics=%d\n", my_name,
> +		  submit_queues, (int)sdebug_statistics);
>   	return sdebug_info;
>   }

 From the comment above the definition of scnprintf(): "The return value 
is the number of characters written into @buf not including the trailing 
'\0'". Maybe you need snprintf() instead of scnprintf()?

Bart.
