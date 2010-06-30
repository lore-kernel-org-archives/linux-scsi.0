From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/7] BNX2I: Fixed the TCP graceful termination initiation
Date: Wed, 30 Jun 2010 01:20:14 -0500
Message-ID: <4C2AE21E.60808@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1277516372-469-6-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39615 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab0F3GRZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 02:17:25 -0400
In-Reply-To: <1277516372-469-6-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 06/25/2010 08:39 PM, Eddie Wai wrote:
>   		if (session) {
>   			spin_lock_bh(&session->lock);
> -			if (session->state == ISCSI_STATE_LOGGING_OUT)
> +			if (bnx2i_ep->state != EP_STATE_TCP_FIN_RCVD) {
> +				if (session->state == ISCSI_STATE_LOGGING_OUT) {
> +					if (bnx2i_ep->state ==
> +					    EP_STATE_LOGOUT_SENT) {
> +						/* Logout sent, but no resp */
> +						printk(KERN_ALERT "bnx2i - "
> +						"WARNING logout response"
> +						" was not received!\n");
> +					} else if (bnx2i_ep->state ==
> +						   EP_STATE_LOGOUT_RESP_RCVD)
> +						close = 1;
> +				}
> +			} else
>   				close = 1;
> +

I think you can make this chunk easier to read if you did

If (!test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic))
	goto out;

then do the:

if (session) {
	........

It gives you an extra tab so you do not have break up some lines, the 
tabbing/spacing will be right on the printk text, and and your eyes do 
not get crammed looking at the far right corner so much.
