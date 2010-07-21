From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 03/28] libfc: IO errors on link down due to cable unplug
Date: Tue, 20 Jul 2010 22:29:10 -0500
Message-ID: <4C466986.5040801@cs.wisc.edu>
References: <20100720221904.17116.78553.stgit@localhost.localdomain> <20100720221920.17116.59505.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37948 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940Ab0GUDZl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 23:25:41 -0400
In-Reply-To: <20100720221920.17116.59505.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@intel.com>

On 07/20/2010 05:19 PM, Robert Love wrote:
> From: Vasu Dev<vasu.dev@intel.com>
>
> In this case, sync IO fails with EIO(5) errors as:-
>
> "Thread:1 System call error:5 - Input/output error (::pwrite() failed)".
>
> This is due to IO time out while libfc doing link down processing
> to block all rports and if timed out IO was at last retry
> attempt then it fails to user with EIO error followed by
> these log messages.
>
> [77848.612169] host2: rport bf0015: Delete port
> [77848.612221] host2: rport e10aef: work delete
> [77848.612232] host2: rport e10002: work event 3
> [77848.612422] sd 2:0:1:1: [sdi] Unhandled error code
> [77848.612426] sd 2:0:1:1: [sdi] Result: hostbyte=DID_ERROR
> driverbyte=DRIVER_OK
> [77848.612431] sd 2:0:1:1: [sdi] CDB: Write(10): 2a 00 00 00 11 20 00 00 20 00
> [77848.612445] end_request: I/O error, dev sdi, sector 4384
> [77848.612553] sd 2:0:1:2: [sdj] Unhandled error code
>
> To fix these EIO errors, such timed out incomplete IOs needs
> to be re-queued without counting retry attempt and this patch
> does that using DID_REQUEUE scsi code.
>
> Signed-off-by: Vasu Dev<vasu.dev@intel.com>
> Signed-off-by: Robert Love<robert.w.love@intel.com>
> ---
>   drivers/scsi/libfc/fc_fcp.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index a0a3ae7..61a1297 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -1971,6 +1971,11 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
>   		break;
>   	}
>
> +	if (lport->state != LPORT_ST_READY&&  fsp->status_code != FC_COMPLETE) {
> +		sc_cmd->result = (DID_REQUEUE<<  16);
> +		FC_FCP_DBG(fsp, "Returning DID_REQUEUE to scsi-ml\n");
> +	}
> +

If it is a tape command, you do not want to use DID_REQUEUE do you?

You are using the fc class API to delete the rport in this scenario, 
right? If so normally I think you would use DID_TRANSPORT_DISRUPTED. 
This is going to give you an error if it is the last retry like 
DID_ERROR though.

It seems weird to try and work around the IO erorr in this case because 
it is the last retry so it should fail. If the port keeps going down and 
up, then with your patch you could keep retrying the IO forever.

This isn't one of those races where you are blocking the rport, but the 
IO keeps coming around so the retries are used really quickly right (the 
driver looks like it has the fc class and internal state checks to 
prevent this but I wanted to make sure).
