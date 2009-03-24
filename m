From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH]scsi_dh_rdac: Retry for NOT_READY check condition
	(0x02A102, 0x020401, 0x020404 and  0x020407) in rdac_check_sense
Date: Tue, 24 Mar 2009 12:38:29 -0700
Message-ID: <1237923509.24723.0.camel@chandra-ubuntu>
References: <0D1E8821739E724A86F4D16902CE275C1410DBBA51@inbmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:55161 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbZCXTfY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 15:35:24 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2OJXxj5008972
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 13:33:59 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2OJZIqA187082
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 13:35:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2OJZHhF005128
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2009 13:35:18 -0600
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1410DBBA51@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>


On Tue, 2009-03-17 at 18:51 +0530, Chauhan, Vijay wrote:
> Hi James,
> 
> Thanks for your comment. I have updated the patch with your comments.
> 
> On Tues, 2009-03-10 21:17 +0530, James Bottomley wrote: 
> > > +		if (sense_hdr->asc == 0xA1  && sense_hdr->ascq == 0x02)
> > > +			/* LUN Not Ready - Quiescense in progress
> > > +			 * or has been achieved
> > > +			 * Just retry.
> > > +			 */
> > > +			return ADD_TO_MLQUEUE;
> > 
> > This is fine, being vendor specific, we don't handle it at 
> > the mid-layer
> 
> > > +		if (sense_hdr->asc == 0x04  && sense_hdr->ascq == 0x07)
> > > +			/* LUN Not Ready - Storage controller 
> > cannot respond
> > > +			 * immediately to a PRIN or PROUT command.
> > > +			 * Just retry.
> > > +			 */
> > > +			return ADD_TO_MLQUEUE;
> > 
> > For all of these ... along with a few other not ready types, 
> > we already
> > do a delayed retry at the mid-layer (in scsi_io_completion).  Is there
> > some problem that causes this to need to be handled here as well?
> > 
> Yes, I do agree. Submitting patch for 0x02A102 only.
> 
> Thanks,
> Vijay
> 
> ---
> This patch adds retry for NOT_READY check condition - Quiescense in progress (02/A1/02)
> 
> Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

> 
> ---
> --- linux-2.6.29-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-03-10 17:42:27.000000000 +0530
> +++ linux-2.6.29-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-03-17 18:18:07.000000000 +0530
> @@ -562,6 +562,12 @@ static int rdac_check_sense(struct scsi_
>  			 * Just retry and wait.
>  			 */
>  			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0xA1  && sense_hdr->ascq == 0x02)
> +			/* LUN Not Ready - Quiescense in progress
> +			 * or has been achieved
> +			 * Just retry.
> +			 */
> +			return ADD_TO_MLQUEUE;
>  		break;
>  	case ILLEGAL_REQUEST:
>  		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01) {
> ----
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

