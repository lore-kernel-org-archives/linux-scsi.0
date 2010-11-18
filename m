From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 12/16] BNX2I: Added feature to silently drop NOPOUT request
Date: Thu, 18 Nov 2010 13:55:50 -0600
Message-ID: <4CE584C6.7070300@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1289430297-30221-13-git-send-email-eddie.wai@broadcom.com> <4CE4A030.7080004@cs.wisc.edu> <1290108358.6191.124.camel@ltirv-waie-lx1>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45537 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab0KRTr6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 14:47:58 -0500
In-Reply-To: <1290108358.6191.124.camel@ltirv-waie-lx1>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, Eddie Wai <waie@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

On 11/18/2010 01:25 PM, Eddie Wai wrote:
>
> On Wed, 2010-11-17 at 19:40 -0800, Mike Christie wrote:
>> On 11/10/2010 05:04 PM, Eddie Wai wrote:
>>> In the case the chip is undergoing different invasive operation
>>> which requires a chip reset, all NOPOUT request during this period
>>
>> For these invasive operations that reset the chip, do we always end up
>> having to relogin the connection/session or once the reset is done are
>> we able to just go on happily like nothing ever happened?
> Operations like mtu change/ifupdown/etc will require the chip to undergo
> reset.  Prior to this, the connections will be cleaned up via the
> conn_failure->ep_disconnect path and eventually put into the reopen
> recovery path.  During this period, we must disallow any send pdu
> requests to be queued to the chip for a more immediately connection tear
> down time (so we don't have to wait for the pdu's completion).
>
> We had to treat NOPOUT requests differently as the routine in libiscsi
> would continuously loop until the NOPOUT send request returns with
> success.  This is the why we added the NOPOUT workaround.

At this time, have you already called iscsi_conn or session failure? If 
so then I think it sounds like there is bug in iscsi_send_nopout or 
__iscsi_conn_send_pdu. If the conn/session has been failed, I think we 
want to add a check in __iscsi_conn_send_pdu where if the conn/session 
is down then we do not send NOPs. There is no point iSCSI RFC wise and 
it screws up drivers.
