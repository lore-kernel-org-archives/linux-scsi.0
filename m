From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] SCSI: Scale up REPORT_LUNS timeout on failure
Date: Fri, 4 Sep 2015 08:00:45 -0700
Message-ID: <55E9B21D.8020508@sandisk.com>
References: <55D65082.6020504@linux.vnet.ibm.com> <55DDB8F3.3020308@suse.de>
 <55E70852.9050506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0077.outbound.protection.outlook.com ([207.46.100.77]:65315
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758700AbbIDPA4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Sep 2015 11:00:56 -0400
In-Reply-To: <55E70852.9050506@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hannes Reinecke <hare@suse.de>

On 09/02/15 07:31, Brian King wrote:
>
> This patch fixes an issue seen with an IBM 2145 (SVC) where, following an error
> injection test which results in paths going offline, when they came
> back online, the path would timeout the REPORT_LUNS issued during the
> scan. This timeout situation continued until retries were expired, resulting in
> falling back to a sequential LUN scan. Then, since the target responds
> with PQ=1, PDT=0 for all possible LUNs, due to the way the sequential
> LUN scan code works, we end up adding 512 LUNs for each target, when there
> is really only a small handful of LUNs that are actually present.
>
> This patch doubles the timeout used on the REPORT_LUNS for each retry
> after a timeout is seen on a REPORT_LUNS. This patch solves the issue
> of 512 non existent LUNs showing up after this event. Running the test
> with this patch still showed that we were regularly hitting two timeouts,
> but the third, and final, REPORT_LUNS was always successful.
>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>   drivers/scsi/scsi_scan.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff -puN drivers/scsi/scsi_scan.c~scsi_report_luns_timeout_escalate drivers/scsi/scsi_scan.c
> --- linux/drivers/scsi/scsi_scan.c~scsi_report_luns_timeout_escalate	2015-09-02 08:49:07.268243497 -0500
> +++ linux-bjking1/drivers/scsi/scsi_scan.c	2015-09-02 08:49:07.272243461 -0500
> @@ -1304,6 +1304,7 @@ static int scsi_report_lun_scan(struct s
>   	struct scsi_device *sdev;
>   	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
>   	int ret = 0;
> +	int timeout = SCSI_TIMEOUT + 4 * HZ;
>
>   	/*
>   	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
> @@ -1383,7 +1384,7 @@ retry:
>
>   		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
>   					  lun_data, length, &sshdr,
> -					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
> +					  timeout, 3, NULL);
>
>   		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
>   				"scsi scan: REPORT LUNS"
> @@ -1392,6 +1393,8 @@ retry:
>   				retries, result));
>   		if (result == 0)
>   			break;
> +		else if (host_byte(result) == DID_TIME_OUT)
> +			timeout = timeout * 2;
>   		else if (scsi_sense_valid(&sshdr)) {
>   			if (sshdr.sense_key != UNIT_ATTENTION)
>   				break;

This is somewhat of a hack, but anyway:

Reviewed-by: Bart Van Assche <bvanassche@sandisk.com>
