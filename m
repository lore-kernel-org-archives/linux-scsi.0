From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH 12/16] BNX2I: Added feature to silently drop NOPOUT
 request
Date: Thu, 18 Nov 2010 13:59:15 -0800
Message-ID: <1290117557.6191.136.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1289430297-30221-13-git-send-email-eddie.wai@broadcom.com>
 <4CE4A030.7080004@cs.wisc.edu>
 <1290108358.6191.124.camel@ltirv-waie-lx1>
 <4CE584C6.7070300@cs.wisc.edu> <4CE586D6.3060803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2480 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271Ab0KRV5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 16:57:22 -0500
In-Reply-To: <4CE586D6.3060803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, Eddie Wai <waie@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>


On Thu, 2010-11-18 at 12:04 -0800, Mike Christie wrote:
> On 11/18/2010 01:55 PM, Mike Christie wrote:
> > On 11/18/2010 01:25 PM, Eddie Wai wrote:
> >>
> >> On Wed, 2010-11-17 at 19:40 -0800, Mike Christie wrote:
> >>> On 11/10/2010 05:04 PM, Eddie Wai wrote:
> >>>> In the case the chip is undergoing different invasive operation
> >>>> which requires a chip reset, all NOPOUT request during this period
> >>>
> >>> For these invasive operations that reset the chip, do we always end up
> >>> having to relogin the connection/session or once the reset is done are
> >>> we able to just go on happily like nothing ever happened?
> >> Operations like mtu change/ifupdown/etc will require the chip to undergo
> >> reset. Prior to this, the connections will be cleaned up via the
> >> conn_failure->ep_disconnect path and eventually put into the reopen
> >> recovery path. During this period, we must disallow any send pdu
> >> requests to be queued to the chip for a more immediately connection tear
> >> down time (so we don't have to wait for the pdu's completion).
> >>
> >> We had to treat NOPOUT requests differently as the routine in libiscsi
> >> would continuously loop until the NOPOUT send request returns with
> >> success. This is the why we added the NOPOUT workaround.
> >
> > At this time, have you already called iscsi_conn or session failure? If
> > so then I think it sounds like there is bug in iscsi_send_nopout or
> > __iscsi_conn_send_pdu. If the conn/session has been failed, I think we
> > want to add a check in __iscsi_conn_send_pdu where if the conn/session
> > is down then we do not send NOPs. There is no point iSCSI RFC wise and
> > it screws up drivers.
> 
> We actually have a check in __iscsi_conn_send_pdu. There is the 
> session->state == ISCSI_STATE_LOGGED_IN, so I guess you have not called 
> one of the iscsi failure functions.
> 
The check is correct, but its just that the conn failures were not being
called prior to these inflight send_pdu calls.  We want to terminate
these calls immediately before they get queued up to the chip.

As for the NOPOUT requests, since the NOPOUT send request failed, the
last_ping jiffies count would not get updated.  Then the
iscsi_check_transport_timeouts callback will just keeps getting called
and stalling the system.

Perhaps a better way to do this is to allow the last_ping jiffies to be
updated but use a different ping_timeout value for failed nopout ping
conditions.

> At this time, is just the apdater_state getting changed? What code path 
> is that?
> 
> Maybe related... For bnx2i_get_link_state ADAPTER_STATE_LINK_DOWN, I 
> think you will want to call the iscsi_suspend_queue function discussed 
> in the other mail. When the link state comes back up though, do we 
> always have to reconnect and relogin to the target or are their cases 
> where we can just restart the queues?
> 


