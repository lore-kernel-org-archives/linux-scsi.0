From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [Patch] scsi_dh_rdac: retry IO for 06/3f/03 in
 rdac_check_sense fn
Date: Mon, 09 Aug 2010 18:47:38 -0700
Message-ID: <1281404858.23351.6.camel@chandra-lucid.beaverton.ibm.com>
References: <1C9608B8A4CD534FB19C7C7543CBB24902991CCA21@inbmail02.lsi.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54208 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0HJBqK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2010 21:46:10 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o7A1SiUK025821
	for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2010 21:28:44 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o7A1jxFM389860
	for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2010 21:45:59 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o7A1jwjZ028382
	for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2010 22:45:59 -0300
In-Reply-To: <1C9608B8A4CD534FB19C7C7543CBB24902991CCA21@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, James Bottomley <James.Bottomley@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Vijay,

Since it has to be handled at SCSI (and it is a SCSI sense), shouldn't
we be retrying it at SCSI level. James, what is your opinion ?

It looks good to me as the effect is local to LSI rdac storage.

chandra

On Mon, 2010-08-02 at 13:07 +0530, Chauhan, Vijay wrote:
> Hi,
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
>  		break;
>  	}
>  	/* success just means we do not care what scsi-ml does */
> 
> --


