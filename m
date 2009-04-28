From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] fc-transport: Close state transition-window during
	rport deletion.
Date: Tue, 28 Apr 2009 09:01:10 -0700
Message-ID: <20090428160110.GI16413@plap4-2.qlogic.org>
References: <20090428140152.GA16413@plap4-2.qlogic.org> <49F71006.4060703@cs.wisc.edu> <20090428143746.GE16413@plap4-2.qlogic.org> <49F71A52.5090802@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20568 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761902AbZD1QBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2009 12:01:11 -0400
Content-Disposition: inline
In-Reply-To: <49F71A52.5090802@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>

On Tue, 28 Apr 2009, Mike Christie wrote:

> Andrew Vasquez wrote:
> > On Tue, 28 Apr 2009, Mike Christie wrote:
> > 
> >> Andrew Vasquez wrote:
> >>> After an rport's state has transitioned to FC_PORTSTATE_BLOCKED,
> >>> but, prior to making the upcall to 'block' the scsi-target
> >>> associated with an rport, queued commands can recycle and
> >>> ultimately run out of retries causing failures to propagate to
> >>> upper-level drivers.  Close this transition-window by returning
> >>> the non-'retries' modifying DID_IMM_RETRY status for submitted
> >>> I/Os.
> >>>
> >>> Issue seen during continuous LIP-injection.
> >>>
> >>> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> >>>
> >>> ---
> >>>
> >>> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> >>> index c9184f7..d189e0e 100644
> >>> --- a/include/scsi/scsi_transport_fc.h
> >>> +++ b/include/scsi/scsi_transport_fc.h
> >>> @@ -687,6 +687,8 @@ fc_remote_port_chkready(struct fc_rport *rport)
> >>>  	case FC_PORTSTATE_BLOCKED:
> >>>  		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
> >>>  			result = DID_TRANSPORT_FAILFAST << 16;
> >>> +		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
> >>> +			result = DID_IMM_RETRY << 16;
> >>>  		else
> >>>  			result = DID_TRANSPORT_DISRUPTED << 16;
> >> I think you can just remove this DID_TRANSPORT_DISRUPTED. The deletion, 
> >> role change or re-addition code will do the right thing with the IO when 
> >> it finishes the transition for this case.
> > 
> > Just to be clear here, you're proposing this as an alternate?
> > 
> > -- av
> > 
> > diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> > index c9184f7..a53a0fd 100644
> > --- a/include/scsi/scsi_transport_fc.h
> > +++ b/include/scsi/scsi_transport_fc.h
> > @@ -688,7 +688,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
> >  		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
> >  			result = DID_TRANSPORT_FAILFAST << 16;
> >  		else
> > -			result = DID_TRANSPORT_DISRUPTED << 16;
> > +			result = DID_IMM_RETRY << 16;
> 
> Yeah, I think that is what we want. We originally had only 
> DID_IMM_RETRY. When I added DID_TRANSPORT_DISRUPTED, it initially had 
> infinite retries like DID_IMM_RETRY so the behavior was not changed. 
> When I fixed DID_TRANSPORT_DISRUPTED to follow the cmd retries/allowed, 
> I should have changed this code back to use DID_IMM_RETRY.

Ok, here's a final one with an updated commit message.

---

fc-transport: Close state transition-window during rport deletion.

After an rport's state has transitioned to FC_PORTSTATE_BLOCKED,
but, prior to making the upcall to 'block' the scsi-target
associated with an rport, queued commands can recycle and
ultimately run out of retries causing failures to propagate to
upper-level drivers.  Close this transition-window by returning
the non-'retries' modifying DID_IMM_RETRY status for submitted
I/Os.

Issue seen during continuous LIP-injection.

Mike Christie (michaelc@cs.wisc.edu) also notes that this is a
partial revert of f46e307da925a7b71a0018c0510cdc6e588b87fc
([SCSI] fc class: Add support for new transport errors), as
follow-on transport changes now have DID_TRANSPORT_* statuses
follow a command's retries/allowed values.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

--

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index c9184f7..a53a0fd 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -688,7 +688,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
 		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
 			result = DID_TRANSPORT_FAILFAST << 16;
 		else
-			result = DID_TRANSPORT_DISRUPTED << 16;
+			result = DID_IMM_RETRY << 16;
 		break;
 	default:
 		result = DID_NO_CONNECT << 16;

