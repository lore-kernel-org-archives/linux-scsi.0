From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: RE: [PATCH]scsi_dh_rdac: Retry for NOT_READY check condition
	(0x02A102, 0x020401, 0x020404 and  0x020407) in rdac_check_sense
Date: Tue, 17 Mar 2009 18:51:40 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410DBBA51@inbmail01.lsi.com>
References: <1236699991.14822.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:52077 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbZCQNWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2009 09:22:06 -0400
In-Reply-To: <1236699991.14822.0.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "'sekharan@us.ibm.com'" <sekharan@us.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>

Hi James,

Thanks for your comment. I have updated the patch with your comments.
 
On Tues, 2009-03-10 21:17 +0530, James Bottomley wrote: 
> > +		if (sense_hdr->asc == 0xA1  && sense_hdr->ascq == 0x02)
> > +			/* LUN Not Ready - Quiescense in progress
> > +			 * or has been achieved
> > +			 * Just retry.
> > +			 */
> > +			return ADD_TO_MLQUEUE;
> 
> This is fine, being vendor specific, we don't handle it at 
> the mid-layer

> > +		if (sense_hdr->asc == 0x04  && sense_hdr->ascq == 0x07)
> > +			/* LUN Not Ready - Storage controller 
> cannot respond
> > +			 * immediately to a PRIN or PROUT command.
> > +			 * Just retry.
> > +			 */
> > +			return ADD_TO_MLQUEUE;
> 
> For all of these ... along with a few other not ready types, 
> we already
> do a delayed retry at the mid-layer (in scsi_io_completion).  Is there
> some problem that causes this to need to be handled here as well?
> 
Yes, I do agree. Submitting patch for 0x02A102 only.

Thanks,
Vijay

---
This patch adds retry for NOT_READY check condition - Quiescense in progress (02/A1/02)

Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>

---
--- linux-2.6.29-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-03-10 17:42:27.000000000 +0530
+++ linux-2.6.29-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-03-17 18:18:07.000000000 +0530
@@ -562,6 +562,12 @@ static int rdac_check_sense(struct scsi_
 			 * Just retry and wait.
 			 */
 			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0xA1  && sense_hdr->ascq == 0x02)
+			/* LUN Not Ready - Quiescense in progress
+			 * or has been achieved
+			 * Just retry.
+			 */
+			return ADD_TO_MLQUEUE;
 		break;
 	case ILLEGAL_REQUEST:
 		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01) {
