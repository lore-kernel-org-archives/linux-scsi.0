From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] scsi_dh_rdac: Retry for NOT_READY(02/04/01) in rdac
	device handler
Date: Mon, 27 Apr 2009 07:43:54 -0700
Message-ID: <1240843434.13132.0.camel@chandra-ubuntu>
References: <0D1E8821739E724A86F4D16902CE275C1410F4D4B1@inbmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:50600 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZD0P2J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 11:28:09 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3RFPeBV016390
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 09:25:40 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3RFS1GG065594
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 09:28:02 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3RFRxd3004370
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 09:28:00 -0600
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1410F4D4B1@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>


On Mon, 2009-04-20 at 18:14 +0530, Chauhan, Vijay wrote:
> This patch resolves the following issue. Please give your comment.
> 
> > I am having issue with scsi_io_completion routine. During 
> > device discovery, READ CAPACITY is failing with 02/04/01. It 
> > has been retried 5 times(with NEED_RETRY) but when retry gets 
> > exhausted ,scsi_io_completion simply ends the request without 
> > trying with delay retry.  
> > 
> > Here scsi_io_completion routine checks for deferred sense and if 
> > not found, it sets error with -EIO, which eventually ends the 
> > request and doesnot allow for any more retries. I am seeing 
> > deffered error being checked only for REQ_TYPE_BLOCK_PC 
> > command type. Does it meant that command with cmd_type 
> > REQ_TYPE_BLOCK_PC having current error sense should not be 
> > retried in scsi_io_completion? If yes, then would it be 
> > better to retry in rdac device handler in that case. 
> > 
> > 
> > On Tues, 2009-03-10 at 15:47, James Bottomley wrote:
> > > > +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
> > > > +			/* LUN Not Ready - Logical Unit Not 
> > > Ready and is in
> > > > +			 * the process of becoming ready
> > > > +			 * Just retry.
> > > > +			 */
> > > > +			return ADD_TO_MLQUEUE;
> > > > +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x04)
> > > > +			/* LUN Not Ready - Format In Progress
> > > > +			 *
> > > > +			 * Just retry.
> > > > +			 */
> > > > +			return ADD_TO_MLQUEUE;
> > > > +		if (sense_hdr->asc == 0x04  && sense_hdr->ascq == 0x07)
> > > > +			/* LUN Not Ready - Storage controller 
> > > cannot respond
> > > > +			 * immediately to a PRIN or PROUT command.
> > > > +			 * Just retry.
> > > > +			 */
> > > > +			return ADD_TO_MLQUEUE;
> > > 
> > > For all of these ... along with a few other not ready types, 
> > > we already
> > > do a delayed retry at the mid-layer (in 
> > scsi_io_completion).  Is there
> > > some problem that causes this to need to be handled here as well?
> 
> Thanks,
> Vijay
> 
> ---
> During device discovery read capacity fails with 0x020401 and sets the device size to 0. As a reason any I/O submitted to this path gets killed at sd_prep_fn with BLKPREP_KILL. This patch is to retry for 0x020401. NEED_RETRY in scsi_decide_disposition does not give sufficient time for the device to become ready. 
> 
> Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>

Acked-by: Chandra Seetahraman <sekharan@us.ibm.com>

> ---
> --- linux-2.6.30-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-04-20 23:07:14.000000000 +0530
> +++ linux-2.6.30-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-04-20 23:11:27.000000000 +0530
> @@ -561,6 +561,12 @@ static int rdac_check_sense(struct scsi_
>  	struct rdac_dh_data *h = get_rdac_data(sdev);
>  	switch (sense_hdr->sense_key) {
>  	case NOT_READY:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
> +			/* LUN Not Ready - Logical Unit Not Ready and is in
> +			* the process of becoming ready
> +			* Just retry.
> +			*/
> +			return ADD_TO_MLQUEUE;
>  		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x81)
>  			/* LUN Not Ready - Storage firmware incompatible
>  			 * Manual code synchonisation required.
> ----
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

