From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH 1/7] BNX2I: Separated the hardware's cleanup
 procedure from ep_disconnect
Date: Tue, 29 Jun 2010 23:07:03 -0700
Message-ID: <1277878025.6535.289.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1277516372-469-2-git-send-email-eddie.wai@broadcom.com>
 <4C2ADBE1.2020204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3007 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab0F3GGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 02:06:06 -0400
In-Reply-To: <4C2ADBE1.2020204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eddie Wai <waie@broadcom.com>, James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

Hello Mike,

You're right. That extra checking for !hba was added recently as
defensive programming and it should never hit.  I'll remove it in v2.

Thanks,
Eddie

On Tue, 2010-06-29 at 22:53 -0700, Mike Christie wrote:
> On 06/25/2010 08:39 PM, Eddie Wai wrote:
> > +/**
> > + * bnx2i_ep_disconnect - executes TCP connection teardown process
> > + * @ep:		TCP connection (iscsi endpoint) handle
> > + *
> > + * executes  TCP connection teardown process
> > + */
> > +static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
> > +{
> > +	struct bnx2i_endpoint *bnx2i_ep;
> > +	struct bnx2i_conn *bnx2i_conn = NULL;
> > +	struct iscsi_conn *conn = NULL;
> > +	struct bnx2i_hba *hba;
> > +
> > +	bnx2i_ep = ep->dd_data;
> > +
> > +	/* driver should not attempt connection cleanup until TCP_CONNECT
> > +	 * completes either successfully or fails. Timeout is 9-secs, so
> > +	 * wait for it to complete
> > +	 */
> > +	while ((bnx2i_ep->state == EP_STATE_CONNECT_START)&&
> > +		!time_after(jiffies, bnx2i_ep->timestamp + (12 * HZ)))
> > +		msleep(250);
> > +
> > +	if (bnx2i_ep->conn) {
> > +		bnx2i_conn = bnx2i_ep->conn;
> > +		conn = bnx2i_conn->cls_conn->dd_data;
> > +		iscsi_suspend_queue(conn);
> > +	}
> > +	hba = bnx2i_ep->hba;
> > +	if (!hba)
> > +		goto out;
> 
> 
> Here you have a ep, so if you goto out you will not release it. Need to 
> call iscsi_destroy_endpoint at least. Can you hit this "if" even?
> 


