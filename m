From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH 12/16] BNX2I: Added feature to silently drop NOPOUT
 request
Date: Thu, 18 Nov 2010 11:25:57 -0800
Message-ID: <1290108358.6191.124.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1289430297-30221-13-git-send-email-eddie.wai@broadcom.com>
 <4CE4A030.7080004@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3188 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab0KRTYD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 14:24:03 -0500
In-Reply-To: <4CE4A030.7080004@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eddie Wai <waie@broadcom.com>, James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>


On Wed, 2010-11-17 at 19:40 -0800, Mike Christie wrote:
> On 11/10/2010 05:04 PM, Eddie Wai wrote:
> > In the case the chip is undergoing different invasive operation
> > which requires a chip reset, all NOPOUT request during this period
> 
> For these invasive operations that reset the chip, do we always end up 
> having to relogin the connection/session or once the reset is done are 
> we able to just go on happily like nothing ever happened?
Operations like mtu change/ifupdown/etc will require the chip to undergo
reset.  Prior to this, the connections will be cleaned up via the
conn_failure->ep_disconnect path and eventually put into the reopen
recovery path.  During this period, we must disallow any send pdu
requests to be queued to the chip for a more immediately connection tear
down time (so we don't have to wait for the pdu's completion).

We had to treat NOPOUT requests differently as the routine in libiscsi
would continuously loop until the NOPOUT send request returns with
success.  This is the why we added the NOPOUT workaround.

Once the chip reset is completed, the ep_connect requests from the
recovery path will be honored and the pre-existed connections will get
re-established.  
> 
> > must be silently dropped from queuing to the hardware.  This patch
> > will respond to libiscsi immediately with sent success.  Since the
> > request was not actually sent, the NOPIN wait timeout will get
> > triggered and another NOPOUT request will commence through the
> > proper channel.
> >
> > Signed-off-by: Eddie Wai<eddie.wai@broadcom.com>
> > Acked-by: Anil Veerabhadrappa<anilgv@broadcom.com>
> > ---
> >   drivers/scsi/bnx2i/bnx2i_iscsi.c |   16 ++++++++++++++++
> >   1 files changed, 16 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> > index b32baf8..507cd25 100644
> > --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> > +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> > @@ -1068,6 +1068,22 @@ static int bnx2i_iscsi_send_generic_request(struct iscsi_task *task)
> >   	char *buf;
> >   	int data_len;
> >
> > +	/*
> > +	 * Forcefully terminate all in progress connection recovery at the
> > +	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
> > +	 */
> > +	if (bnx2i_adapter_ready(bnx2i_conn->ep->hba)) {
> > +		if ((task->hdr->opcode&  ISCSI_OPCODE_MASK) ==
> > +		    ISCSI_OP_NOOP_OUT)
> > +			/* This is a WA to indicate to libiscsi that the nopout
> > +			 * request was sent successfully without actually
> > +			 * submitting to the hardware.
> > +			 * Just silently drop the nopout request
> > +			 */
> > +			return 0;
> > +		else
> > +			return -EIO;
> > +	}
> >   	bnx2i_iscsi_prep_generic_pdu_bd(bnx2i_conn);
> >   	switch (task->hdr->opcode&  ISCSI_OPCODE_MASK) {
> >   	case ISCSI_OP_LOGIN:
> 
> 


