From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Recognize missing LUNs for non-standard devices
Date: Mon, 06 Feb 2006 16:55:23 -0600
Message-ID: <43E7D3DB.8060303@us.ibm.com>
References: <Pine.LNX.4.44L0.0602061649070.17052-100000@iolanthe.rowland.org>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39912 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932416AbWBFWz0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 17:55:26 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k16MtPmM001143
	for <linux-scsi@vger.kernel.org>; Mon, 6 Feb 2006 17:55:25 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k16MtPWC152744
	for <linux-scsi@vger.kernel.org>; Mon, 6 Feb 2006 17:55:25 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k16MtPS7026417
	for <linux-scsi@vger.kernel.org>; Mon, 6 Feb 2006 17:55:25 -0500
In-Reply-To: <Pine.LNX.4.44L0.0602061649070.17052-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> Some protocols (like USB UFI) or devices that don't adhere to the SCSI
> standard may indicate a nonexistent LUN by returning INQUIRY information
> with Peripheral Device Type set to 0x1f (unknown or none) and Peripheral
> Qualifier set to 0 instead of 3 as the spec requires.  This patch (as650)
> causes PDT = 0x1f to be recognized as no LUN present regardless of the
> qualifier value, if the SCSI level is equal to 0.

This patch will break the ipr driver. The ipr adapter firmware reports a
logical scsi device which is used for RAID configuration. It reports
a Peripheral Device Type of 0x1f and a scsi level of 0, since it does
not claim compliance with any scsi level. 

Brian

> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> James:
> 
> Since nobody objected when I proposed this last week, I'm now submitting 
> it as a real patch.
> 
> Alan Stern
> 
> 
> Index: usb-2.6/drivers/scsi/scsi_scan.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> +++ usb-2.6/drivers/scsi/scsi_scan.c
> @@ -873,6 +873,19 @@ static int scsi_probe_and_add_lun(struct
>  		goto out_free_result;
>  	}
>  
> +	/*
> +	 * Non-standard SCSI devices may set the PDT to 0x1f (unknown or
> +	 * no device type) instead of using the peripheral qualifier to
> +	 * indicate that no LUN is present.  For example, USB UFI does this.
> +	 */
> +	if (sdev->scsi_level == 0 && (result[0] & 0x1f) == 0x1f) {
> +		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
> +					"scsi scan: peripheral device type"
> +					" of 31, no device added\n"));
> +		res = SCSI_SCAN_TARGET_PRESENT;
> +		goto out_free_result;
> +	}
> +
>  	res = scsi_add_lun(sdev, result, &bflags);
>  	if (res == SCSI_SCAN_LUN_PRESENT) {
>  		if (bflags & BLIST_KEY) {
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
