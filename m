From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH][RESUBMIT] scsi_dh_rdac: Retry mode select for
	NO_SENSE, ABORTED_COMMAND, UNIT_ATTENTION, NOT_READY(02/04/01)
Date: Tue, 10 Mar 2009 11:48:44 -0700
Message-ID: <1236710924.2178.4.camel@chandra-ubuntu>
References: <0D1E8821739E724A86F4D16902CE275C140E25C59C@inbmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:40446 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZCJSqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2009 14:46:16 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2AIfx5Q001160
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2009 12:41:59 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2AIk5sx060860
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2009 12:46:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2AIk1TL015583
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2009 12:46:05 -0600
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C140E25C59C@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>


On Wed, 2009-03-04 at 12:17 +0530, Chauhan, Vijay wrote:
> ---
> 
> This patch is to add retry for  mode select if mode select command is returned with sense NO_SENSE,
> UNIT_ATTENTION, ABORTED_COMMAND, NOT_READY(02/04/01). This patch reorganise the sense keys from
> if-else to switch-case format for better maintainability.
> 
> Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

> ---
> 
> --- linux-2.6.29-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-02-14 05:01:30.000000000 +0530
> +++ linux-2.6.29-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-03-04 11:25:19.000000000 +0530
> @@ -449,28 +449,40 @@ static int mode_select_handle_sense(stru
>  				    unsigned char *sensebuf)
>  {
>  	struct scsi_sense_hdr sense_hdr;
> -	int sense, err = SCSI_DH_IO, ret;
> +	int err = SCSI_DH_IO, ret;
> 
>  	ret = scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE, &sense_hdr);
>  	if (!ret)
>  		goto done;
> 
>  	err = SCSI_DH_OK;
> -	sense = (sense_hdr.sense_key << 16) | (sense_hdr.asc << 8) |
> -			sense_hdr.ascq;
> -	/* If it is retryable failure, submit the c9 inquiry again */
> -	if (sense == 0x59136 || sense == 0x68b02 || sense == 0xb8b02 ||
> -			    sense == 0x62900) {
> -		/* 0x59136    - Command lock contention
> -		 * 0x[6b]8b02 - Quiesense in progress or achieved
> -		 * 0x62900    - Power On, Reset, or Bus Device Reset
> -		 */
> -		err = SCSI_DH_RETRY;
> -	}
> 
> -	if (sense)
> +	switch (sense_hdr.sense_key) {
> +	case NO_SENSE:
> +	case ABORTED_COMMAND:
> +	case UNIT_ATTENTION:
> +		err= SCSI_DH_RETRY;
> +		break;
> +	case NOT_READY:
> +		if (sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x01)
> +			/* LUN Not Ready and is in the Process of Becoming
> +			 * Ready
> +			 */
> +			err = SCSI_DH_RETRY;
> +		break;
> +	case ILLEGAL_REQUEST:
> +		if (sense_hdr.asc == 0x91 && sense_hdr.ascq == 0x36)
> +			/*
> +			 * Command Lock contention
> +			 */
> +			err = SCSI_DH_RETRY;
> +		break;
> +	default:
>  		sdev_printk(KERN_INFO, sdev,
> -			"MODE_SELECT failed with sense 0x%x.\n", sense);
> +			"MODE_SELECT failed with sense %02x/%02x/%02x.\n",sense_hdr.sense_key,
> +			 sense_hdr.asc, sense_hdr.ascq );
> +	}
> +
>  done:
>  	return err;
>  }--
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

