From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/16] BNX2I: Updated the handling of NETEVENTs to alleviate
 recovery
Date: Wed, 17 Nov 2010 21:14:14 -0600
Message-ID: <4CE49A06.10903@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1289430297-30221-5-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33269 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab0KRDGY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 22:06:24 -0500
In-Reply-To: <1289430297-30221-5-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 11/10/2010 05:04 PM, Eddie Wai wrote:
>   	case NETDEV_GOING_DOWN:
> -		set_bit(ADAPTER_STATE_GOING_DOWN,&hba->adapter_state);
> -		iscsi_host_for_each_session(hba->shost,
> -					    bnx2i_drop_session);
> +		/* Suspend all data transmissions */
> +		for (i = 0; i<  hba->max_active_conns; i++) {
> +			bnx2i_conn = bnx2i_get_conn_from_id(hba, i);
> +			if (bnx2i_conn) {
> +				conn = bnx2i_conn->cls_conn->dd_data;
> +				session = conn->session;
> +				spin_lock_irqsave(&session->lock, flags);
> +				bnx2i_conn->prev_sess_state = session->state;
> +				if (conn->stop_stage == 0)
> +					session->state = ISCSI_STATE_FAILED;
> +				spin_unlock_irqrestore(&session->lock, flags);
> +				iscsi_suspend_queue(conn);
> +				set_bit(ISCSI_SUSPEND_BIT,&conn->suspend_rx);


How do you go from going down to down? What happens (does net layer 
shutdown connections running and have the net driver clean something 
up)? How long does it take?

You should not be digging into the session state and conn stop_stage and 
probably the suspend_rx bit.

Add some libiscsi function that just calls something like 
iscsi_conn_failure that does not initiate recovery. So basically just mv 
everything but the iscsi_conn_error_event call in iscsi_conn_failure to 
some new function iscsi_conn_suspend. Have iscsi_conn_failure call 
iscsi_conn_suspend and iscsi_conn_error_event, and then have your driver 
call iscsi_conn_suspend.
