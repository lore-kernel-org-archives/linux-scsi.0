From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH]scsi_dh_rdac: Retry for Quiescence in Progress in rdac
	device handler
Date: Mon, 26 Jan 2009 13:04:18 -0800
Message-ID: <1233003858.3759.15.camel@chandra-ubuntu>
References: <0D1E8821739E724A86F4D16902CE275C13FF9AFFD6@inbmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:41371 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZAZVDD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 16:03:03 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n0QL0xLw002234
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 14:00:59 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0QL31jO206524
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 14:03:01 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0QL2xcv016980
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 14:03:01 -0700
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C13FF9AFFD6@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>


On Mon, 2009-01-26 at 21:29 +0530, Chauhan, Vijay wrote:
> During device discovery read capacity fails with 0x068b02 and sets the device size to 0. As a reason any I/O submitted to this path gets killed at sd_prep_fn with BLKPREP_KILL. This patch is to retry for 0x068b02. Please apply.
> 
> From: Vijay Chauhan<vijay.chauhan@lsi.com>
> 
> This patch adds retry for Quiescence in Progress in rdac device handler.
> 
> Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> ---
> --- linux-2.6.29-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig    2009-01-26 20:46:05.000000000 +0530
> +++ linux-2.6.29-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c 2009-01-26 20:47:34.000000000 +0530
> @@ -579,6 +579,11 @@ static int rdac_check_sense(struct scsi_
>                          * Power On, Reset, or Bus Device Reset, just retry.
>                          */
>                         return ADD_TO_MLQUEUE;
> +               if (sense_hdr->asc == 0x8b && sense_hdr->ascq == 0x02)
> +                       /*
> +                        * Quiescence in progress , just retry.
> +                        */
> +                       return ADD_TO_MLQUEUE;
>                 break;
>         }
>         /* success just means we do not care what scsi-ml does */
> --

