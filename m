From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [RESUBMIT][Patch] scsi_dh_rdac: retry IO for 06/3f/03 in
 rdac_check_sense fn
Date: Tue, 26 Oct 2010 11:55:28 -0700
Message-ID: <20101026185527.GB32464@us.ibm.com>
References: <B2FD678A64EAAD45B089B123FDFC3ED704BFE578@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39042 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab0JZSza (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 14:55:30 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o9QIu9NV006337
	for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2010 14:56:09 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o9QItTjc137904
	for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2010 14:55:29 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o9QItTtr001292
	for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2010 14:55:29 -0400
Content-Disposition: inline
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED704BFE578@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Chauhan, Vijay [Vijay.Chauhan@lsi.com] wrote:
> Resubmitting this patch to get the attention.
> 
> This patch adds retry for the IO returned with 06/3f/03((INQUIRY_DATA_CHANGED)) sense code  in rdac_check_sense(). IO returned with 06/3f/03 from controller are currently failed by scsi mid layer, as a reason momentarily path failure is noticed by DM multipath. 
> 
> Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>
> Reviewed-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> ---
> 
> diff -uprN linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh_rdac.c linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c
> --- linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-22 15:13:38.000000000 -0400
> +++ linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-27 12:13:58.000000000 -0400
> @@ -738,6 +738,11 @@ static int rdac_check_sense(struct scsi_
>  			 * Quiescence in progress , just retry.
>  			 */
>  			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
> +			/*
> +			 * INQUIRY DATA has changed, retry again.
> +			 */
> +			return ADD_TO_MLQUEUE;

The code looks fine.  Is this ASC/ASCQ code specific to RDAC devices? If
not, how about changing the scsi_error.c itself?

Thanks, Malahal.
