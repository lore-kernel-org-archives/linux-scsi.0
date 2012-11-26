From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 03/11] IB/srp: don't send anything on a bad QP
Date: Mon, 26 Nov 2012 10:17:35 +0100
Message-ID: <50B333AF.6040509@acm.org>
References: <cover.1353903448.git.dillowda@ornl.gov> <90b21916a384281682d520302b594834e010671b.1353903448.git.dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:52645 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2KZJRi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2012 04:17:38 -0500
In-Reply-To: <90b21916a384281682d520302b594834e010671b.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, roland@purestorage.com

On 11/26/12 05:44, David Dillow wrote:
> Once we know we have an issue with the QP, there is no point trying to
> send anything else down the pipe. This also allows us to consolidate
> code in the SCSI EH path.
>
[ ... ]
> @@ -1683,7 +1681,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
>   	struct srp_iu *iu;
>   	struct srp_tsk_mgmt *tsk_mgmt;
>
> -	if (srp_is_removed(target))
> +	if (target->state)
>   		return -1;
>

Hi Dave,

After I posted the patch on which the above patch has been based I 
realized that testing the connection state at the start of 
srp_send_tsk_mgmt() is not sufficient to avoid QPN use-after-free. If a 
DREQ is received by the initiator after the above test has been 
performed and before the task management function has been sent it is 
still possible to send a task management function over a closed QP. I'd 
like to address this in a different way - see also the thread called 
"SCSI LLDs, the SCSI error handler and host resource lifetime" on the 
linux-scsi mailing list (November 20, 
http://marc.info/?t=135342155500003&r=1). Sorry for the confusion I caused.

Bart.
