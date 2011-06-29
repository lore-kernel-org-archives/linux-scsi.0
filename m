From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/4 v2] BNX2I: Changed the nopout_wqe->lun memcpy to
 use sizeof instead
Date: Wed, 29 Jun 2011 16:53:32 -0500
Message-ID: <1309384412.13937.13.camel@mulgrave>
References: <Eddie Wai <eddie.wai@broadcom.com>
	 <1308869497-2709-4-git-send-email-eddie.wai@broadcom.com>
	 <4E04F19B.5080800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49556 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab1F2Vxg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2011 17:53:36 -0400
In-Reply-To: <4E04F19B.5080800@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Andy Grover <agrover@redhat.com>

On Fri, 2011-06-24 at 15:20 -0500, Mike Christie wrote:
> On 06/23/2011 05:51 PM, Eddie Wai wrote:
> > Modified the memcpy of nopout_wqe->lun to use sizeof(struct scsi_lun)
> > instead of the hardcoded value 8 as noted by review comments.
> > 
> > Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
> > ---
> >  drivers/scsi/bnx2i/bnx2i_hwi.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> > index 2a1bb9f..ba2f96e 100644
> > --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> > +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> > @@ -551,7 +551,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
> >  
> >  	nopout_wqe->op_code = nopout_hdr->opcode;
> >  	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
> > -	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
> > +	memcpy(nopout_wqe->lun, nopout_hdr->lun, sizeof(struct scsi_lun));
> >  
> >  	if (test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type)) {
> >  		u32 tmp = nopout_wqe->lun[0];
> 
> This patch and Andy your patch "[PATCH] iscsi: Use struct scsi_lun in
> iscsi structs instead of u8[8]" are going to conflict with each other.
> 
> And Eddie, I think you missed some other instances where 8 is hardcoded.

Agreed, I skipped this one for now ... please resubmit against scsi-misc
if more work is needed.

Thanks,

James


