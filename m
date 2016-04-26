From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 07/12] scsi_debug: use likely hints on fast path
Date: Tue, 26 Apr 2016 15:14:24 -0700
Message-ID: <571FE840.1010304@sandisk.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-8-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0060.outbound.protection.outlook.com ([157.56.110.60]:50786
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752280AbcDZWOc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 18:14:32 -0400
In-Reply-To: <1461600999-28893-8-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
> -	if ((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
> -	    (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
> -	    ((lba + num) > OPT_MEDIUM_ERR_ADDR)) {
> +	if (unlikely((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
> +		     (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
> +		     ((lba + num) > OPT_MEDIUM_ERR_ADDR))) {
 > [ ... ]
> -	if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
> +	if (unlikely((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE))) {
 > [ ... ]
> -	if ((qdepth > 0) && (num_in_q >= qdepth)) {
> +	if (unlikely((qdepth > 0) && (num_in_q >= qdepth))) {
 > [ ... ]
> -	} else if ((sdebug_every_nth != 0) &&
> -		   (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
> -		   (scsi_result == 0)) {
> +	} else if (unlikely((sdebug_every_nth != 0) &&
> +			    (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
> +			    (scsi_result == 0))) {

Since you are modifying this code, please remove the superfluous 
parentheses.

 > -	struct sdebug_host_info * sdbg_host;
 > -	struct sdebug_dev_info * open_devip = NULL;
 > -	struct sdebug_dev_info * devip =
 > -			(struct sdebug_dev_info *)sdev->hostdata;
 > +	struct sdebug_host_info *sdbg_host;
 > +	struct sdebug_dev_info *open_devip = NULL;
 > +	struct sdebug_dev_info *devip;
 >
 > -	if (devip)
 > -		return devip;

Has this change been described in the patch description?

> @@ -4632,9 +4617,11 @@ static int __init scsi_debug_init(void)
>   	switch (sdebug_dif) {
>
>   	case SD_DIF_TYPE0_PROTECTION:
> +		break;
>   	case SD_DIF_TYPE1_PROTECTION:
>   	case SD_DIF_TYPE2_PROTECTION:
>   	case SD_DIF_TYPE3_PROTECTION:
> +		have_dif_prot = true;
>   		break;

Same comment for this code: has this change been explained in the patch 
description?

Bart.
