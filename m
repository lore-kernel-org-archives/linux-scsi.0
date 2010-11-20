From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 12/16] BNX2I: Added feature to silently drop NOPOUT request
Date: Fri, 19 Nov 2010 23:07:32 -0600
Message-ID: <4CE75794.2050508@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1289430297-30221-13-git-send-email-eddie.wai@broadcom.com> <4CE4A030.7080004@cs.wisc.edu> <1290108358.6191.124.camel@ltirv-waie-lx1> <4CE584C6.7070300@cs.wisc.edu> <4CE586D6.3060803@cs.wisc.edu> <1290117557.6191.136.camel@ltirv-waie-lx1>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39527 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708Ab0KTE7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2010 23:59:37 -0500
In-Reply-To: <1290117557.6191.136.camel@ltirv-waie-lx1>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, Eddie Wai <waie@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

On 11/18/2010 03:59 PM, Eddie Wai wrote:
> As for the NOPOUT requests, since the NOPOUT send request failed, the
> last_ping jiffies count would not get updated.  Then the
> iscsi_check_transport_timeouts callback will just keeps getting called
> and stalling the system.
>
> Perhaps a better way to do this is to allow the last_ping jiffies to be
> updated but use a different ping_timeout value for failed nopout ping
> conditions.
>

If this is a hard error then we can just have xmit_task return a error, 
and then have iscsi_send_nopout call iscsi_conn_failure for the driver.

Is there any issue with starting the eh process at this time? Would the 
quicker swing around to ep_disconnect and ep_connect cause problems?
