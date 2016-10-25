From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Tue, 25 Oct 2016 15:16:17 -0700
Message-ID: <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0080.outbound.protection.outlook.com ([104.47.36.80]:29975
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752800AbcJYWQ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 18:16:27 -0400
In-Reply-To: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, gabriel@krisman.be, brking@linux.vnet.ibm.com

On 10/23/2016 08:20 PM, Gabriel Krisman Bertazi wrote:
> +
>  /**
>   * scsi_execute - insert request and wait for the result
>   * @sdev:	scsi device
> @@ -187,7 +197,14 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>  	struct request *req;
>  	int write = (data_direction == DMA_TO_DEVICE);
>  	int ret = DRIVER_ERROR << 24;
> +	unsigned char sense_buf[SCSI_SENSE_BUFFERSIZE];
>
> +	if (!sense) {
> +		sense = sense_buf;
> +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
> +	}
> +
> + retry:
>  	req = blk_get_request(sdev->request_queue, write, __GFP_RECLAIM);
>  	if (IS_ERR(req))
>  		return ret;
> @@ -210,6 +227,13 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>  	 */
>  	blk_execute_rq(req->q, NULL, req, 1);
>
> +	if (scsi_sense_unit_attention(sense) && req->retries > 0) {
> +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
> +		retries = req->retries - 1;
> +		blk_put_request(req);
> +		goto retry;
> +	}
> +
>  	/*
>  	 * Some devices (USB mass-storage in particular) may transfer
>  	 * garbage data together with a residue indicating that the data

 From scsi_io_completion():

	if (sense_valid && !sense_deferred) {
		switch (sshdr.sense_key) {
		case UNIT_ATTENTION:
			if (cmd->device->removable) {
				cmd->device->changed = 1;
				action = ACTION_FAIL;
			} else {
				action = ACTION_RETRY;
			}
			[ ... ]

Why do you think new retry code is needed in scsi_execute()?

Bart.

