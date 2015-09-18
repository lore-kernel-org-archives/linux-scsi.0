From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 03/30] cxlflash: Fix read capacity timeout
Date: Thu, 17 Sep 2015 20:21:19 -0500
Message-ID: <55FB670F.6060208@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1442438806-49198-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:47065 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbbIRBVa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 21:21:30 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 17 Sep 2015 21:21:30 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id E71A6C90043
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2015 21:12:30 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8I1LRLH62849086
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 01:21:27 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8I1LPCO030984
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2015 21:21:27 -0400
In-Reply-To: <1442438806-49198-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, Manoj Kumar <kumarmn@us.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 09/16/2015 04:26 PM, Matthew R. Ochs wrote:
> @@ -296,7 +296,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
>  	int rc = 0;
>  	int result = 0;
>  	int retry_cnt = 0;
> -	u32 tout = (MC_DISCOVERY_TIMEOUT * HZ);
> +	u32 to = (CMD_TIMEOUT * HZ);
> 
>  retry:
>  	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
> @@ -315,8 +315,7 @@ retry:
>  		retry_cnt ? "re" : "", scsi_cmd[0]);
> 
>  	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
> -			      CMD_BUFSIZE, sense_buf, tout, CMD_RETRIES,
> -			      0, NULL);
> +			      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES, 0, NULL);
> 
>  	if (driver_byte(result) == DRIVER_SENSE) {
>  		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
> @@ -1376,8 +1375,8 @@ out_attach:
>  	attach->block_size = gli->blk_len;
>  	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
>  	attach->last_lba = gli->max_lba;
> -	attach->max_xfer = (sdev->host->max_sectors * MAX_SECTOR_UNIT) /
> -		gli->blk_len;
> +	attach->max_xfer = (sdev->host->max_sectors * MAX_SECTOR_UNIT);
> +	attach->max_xfer /= gli->blk_len;

This change and the one above are not really part of the patch. Not a big deal, but
in future would be good to either call out the fact that there are a couple of unrelated
formatting changes, or keep them out and stick them in a separate cleanup patch.

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

