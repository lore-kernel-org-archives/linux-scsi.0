From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH] LIBISCSI: Alleviate NOP transmission request upon
 xmit failure
Date: Wed, 14 Mar 2012 23:53:43 -0700
Message-ID: <1331794423.5058.751.camel@dhcp-10-12-137-160.irv.broadcom.com>
References: <eddie.wai@broadcom.com>
 <1331769005-1767-1-git-send-email-eddie.wai@broadcom.com>
 <4F614AC1.2080906@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2213 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2COGxC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2012 02:53:02 -0400
In-Reply-To: <4F614AC1.2080906@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <jbottomley@parallels.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>


On Wed, 2012-03-14 at 20:49 -0500, Mike Christie wrote:
> On 03/14/2012 06:50 PM, Eddie Wai wrote:
> > During heavy I/O transmission, it was observed that network packets
> > can get dropped when no link flow control is enabled.  When this happens,
> > I/O completions can exceed the default NOP transmission of 5s while the
> > hw send queue resource backs up.  When the queue gets full, NOP
> > transmission requests will also get blocked.  It was observed that
> > the NOP transmission requests will keep repeatedly try to send out
> > the NOP while holding the session lock.  This is very intrusive as the
> > requests are being called on every timer execution since the last_ping
> > parameter doesn't get updated upon transmission failure.  This creates a
> > tremendous bottleneck especially when the connection is about to get torn down.
> > 
> > This patch alleviates the pounding of the NOP transmission in the
> > iscsi_check_transport_timeouts routine by injecting an artifical 1s delay
> > in between each NOP transmission requests due to failures upon timeout.
> > 
> > There is no need to keep pounding on to request this data provoking NOP
> > transmission continuously when the transmit queue is full.
> > 
> > Please review and comment.  Thanks.
> > 
> > 
> > Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
> > ---
> >  drivers/scsi/libiscsi.c |   13 +++++++++----
> >  1 files changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> > index 82c3fd4..f1141a8 100644
> > --- a/drivers/scsi/libiscsi.c
> > +++ b/drivers/scsi/libiscsi.c
> > @@ -940,13 +940,14 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
> >  	wake_up(&conn->ehwait);
> >  }
> >  
> > -static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
> > +static struct iscsi_task *iscsi_send_nopout(struct iscsi_conn *conn,
> > +					    struct iscsi_nopin *rhdr)
> >  {
> >          struct iscsi_nopout hdr;
> >  	struct iscsi_task *task;
> >  
> >  	if (!rhdr && conn->ping_task)
> > -		return;
> > +		return NULL;
> >  
> >  	memset(&hdr, 0, sizeof(struct iscsi_nopout));
> >  	hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
> > @@ -967,6 +968,7 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
> >  		conn->ping_task = task;
> >  		conn->last_ping = jiffies;
> >  	}
> > +	return task;
> >  }
> >  
> >  static int iscsi_nop_out_rsp(struct iscsi_task *task,
> > @@ -2059,8 +2061,11 @@ static void iscsi_check_transport_timeouts(unsigned long data)
> >  	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
> >  		/* send a ping to try to provoke some traffic */
> >  		ISCSI_DBG_CONN(conn, "Sending nopout as ping\n");
> > -		iscsi_send_nopout(conn, NULL);
> > -		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
> > +		if (iscsi_send_nopout(conn, NULL))
> > +			next_timeout = conn->last_ping +
> > +				       (conn->ping_timeout * HZ);
> 
> Once we send a ping, we should not run this timer again until it has
> timed out Why is the ping not timing out and then why are not hitting
> the check above this that just returns?
The problem is that it is the right time to send the ping but the
request was not successful due to a lack of task resources.  The
send_pdu will then returned a NULL task which prevented the
conn->last_ping parameter from being updated.  So when this timer
routine exits, it comes right back with the last_recv and last_ping both
being the old value since there wasn't any new completions either.
> 
> Is the timer firing early, so we keep hitting the iscsi_send_nopout path?
> 


