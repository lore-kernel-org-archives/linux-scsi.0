From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_transport_fc: handle transient error on multipath
 environment
Date: Fri, 12 Feb 2010 11:46:28 -0600
Message-ID: <4B7593F4.2050102@cs.wisc.edu>
References: <4B750CB7.4030805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57461 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab0BLRqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2010 12:46:47 -0500
In-Reply-To: <4B750CB7.4030805@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org

On 02/12/2010 02:09 AM, Tomohiro Kusumi wrote:
> @@ -1953,6 +1987,13 @@
>   {
>   	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
> 
> +	if (rport->recover_transient_error) {
> +		fc_queue_work(scmd->device->host,&rport->rport_te_work);
> +		scmd->result = ((scmd->result&  0xFF00FFFF) |
> +				(DID_TRANSPORT_DISRUPTED<<  16));
> +		return BLK_EH_HANDLED;
> +	}
> +
>   	if (rport->port_state == FC_PORTSTATE_BLOCKED)
>   		return BLK_EH_RESET_TIMER;

- For the link down case you mentioned, would we see that the rport is
blocked here then we would return RESET_TIMER. If the fast_io_fail tmo
is set, then that would fail io quickly upwards (the fast io fail timo
would probably fire before the cmd even timed out).

What transport problems are you seeing where the rport is not blocked
and the scsi cmd timer fires? Would it be mostly buggy switches or
something like that?

- Maybe you want to instead hook something into the dm-mutlipath's
request (no more bios like in 2004 :)). Can you set a timer on that
level of request. If that times out then, dm-multipath could do
something like call blk_abort_queue.

I think the problem with blk_abort_queue might be that it stops all IO
to the entire host where you probably just want to work on the remote
port/path. For that you could call something like
recover_transient_error. Maybe it could just be a call to
terminate_rport_io from a workqueue though.
