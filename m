From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug support for rotation speed
Date: Thu, 19 Jun 2008 18:07:37 +0200
Message-ID: <485A8449.8020008@torque.net>
References: <20080619160258.GI4392@parisc-linux.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:36978 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYFSQHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2008 12:07:46 -0400
In-Reply-To: <20080619160258.GI4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> Add support for VPD page b1 to scsi_debug
> 
> SCSI VPD page b1 reports the nominal rotation speed of the device.
> Since scsi_debug is ram-based, claim to be a non-rotating medium.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Looks fine.

Signed-off-by: Douglas Gilbert <dougg@torque.net>


> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index f6600bf..91d7e05 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -646,6 +646,14 @@ static int inquiry_evpd_b0(unsigned char * arr)
>  	return sizeof(vpdb0_data);
>  }
>  
> +static int inquiry_evpd_b1(unsigned char *arr)
> +{
> +	memset(arr, 0, 0x3c);
> +	arr[0] = 0;
> +	arr[1] = 1;
> +
> +	return 0x3c;
> +}
>  
>  #define SDEBUG_LONG_INQ_SZ 96
>  #define SDEBUG_MAX_INQ_ARR_SZ 584
> @@ -701,6 +709,7 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
>  			arr[n++] = 0x88;  /* SCSI ports */
>  			arr[n++] = 0x89;  /* ATA information */
>  			arr[n++] = 0xb0;  /* Block limits (SBC) */
> +			arr[n++] = 0xb1;  /* Block characteristics (SBC) */
>  			arr[3] = n - 4;	  /* number of supported VPD pages */
>  		} else if (0x80 == cmd[2]) { /* unit serial number */
>  			arr[1] = cmd[2];	/*sanity */
> @@ -740,6 +749,9 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
>  		} else if (0xb0 == cmd[2]) { /* Block limits (SBC) */
>  			arr[1] = cmd[2];        /*sanity */
>  			arr[3] = inquiry_evpd_b0(&arr[4]);
> +		} else if (0xb1 == cmd[2]) { /* Block characteristics (SBC) */
> +			arr[1] = cmd[2];        /*sanity */
> +			arr[3] = inquiry_evpd_b1(&arr[4]);
>  		} else {
>  			/* Illegal request, invalid field in cdb */
>  			mk_sense_buffer(devip, ILLEGAL_REQUEST,

