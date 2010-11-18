From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH 04/16] BNX2I: Updated the handling of NETEVENTs to
 alleviate recovery
Date: Thu, 18 Nov 2010 10:25:34 -0800
Message-ID: <1290104736.6191.95.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1289430297-30221-5-git-send-email-eddie.wai@broadcom.com>
 <4CE49A06.10903@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2688 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab0KRSXi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 13:23:38 -0500
In-Reply-To: <4CE49A06.10903@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eddie Wai <waie@broadcom.com>, James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

On Wed, 2010-11-17 at 19:14 -0800, Mike Christie wrote:
> On 11/10/2010 05:04 PM, Eddie Wai wrote:
> >   	case NETDEV_GOING_DOWN:
> > -		set_bit(ADAPTER_STATE_GOING_DOWN,&hba->adapter_state);
> > -		iscsi_host_for_each_session(hba->shost,
> > -					    bnx2i_drop_session);
> > +		/* Suspend all data transmissions */
> > +		for (i = 0; i<  hba->max_active_conns; i++) {
> > +			bnx2i_conn = bnx2i_get_conn_from_id(hba, i);
> > +			if (bnx2i_conn) {
> > +				conn = bnx2i_conn->cls_conn->dd_data;
> > +				session = conn->session;
> > +				spin_lock_irqsave(&session->lock, flags);
> > +				bnx2i_conn->prev_sess_state = session->state;
> > +				if (conn->stop_stage == 0)
> > +					session->state = ISCSI_STATE_FAILED;
> > +				spin_unlock_irqrestore(&session->lock, flags);
> > +				iscsi_suspend_queue(conn);
> > +				set_bit(ISCSI_SUSPEND_BIT,&conn->suspend_rx);
> 
> 
> How do you go from going down to down? What happens (does net layer 
> shutdown connections running and have the net driver clean something 
> up)? How long does it take?
All upper layer clean up will be conducted in another code path from the net layer via cnic.
This will do the actual iSCSI connection cleanup.
> You should not be digging into the session state and conn stop_stage and 
> probably the suspend_rx bit.
> 
> Add some libiscsi function that just calls something like 
> iscsi_conn_failure that does not initiate recovery. So basically just mv 
> everything but the iscsi_conn_error_event call in iscsi_conn_failure to 
> some new function iscsi_conn_suspend. Have iscsi_conn_failure call 
> iscsi_conn_suspend and iscsi_conn_error_event, and then have your driver 
> call iscsi_conn_suspend.
> 
Agreed.  Modifying the iscsi_conn_failure is a better solution.  We'll
defer this change for now.

Thanks,
Eddie


