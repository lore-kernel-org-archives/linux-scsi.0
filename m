From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [RFC PATCH] libfc: Update rport reference counting
Date: Mon, 23 May 2016 08:44:34 -0700
Message-ID: <203057f8-2dfa-b84e-d563-b2fcecdf705f@sandisk.com>
References: <1463565156-103494-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0086.outbound.protection.outlook.com ([207.46.100.86]:5764
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752723AbcEWPon (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2016 11:44:43 -0400
In-Reply-To: <1463565156-103494-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@intel.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.com>

On 05/18/2016 02:52 AM, Hannes Reinecke wrote:
> Originally libfc would just be initializing the refcount to '1',
> and using the disc_mutex to synchronize if and when the final put
> should be happening.
> This has a race condition as the mutex might be delayed, causing
> other threads to access an invalid structure.
> This patch updates the rport reference counting to increase the
> reference every time 'rport_lookup' is called, and decreases
> the reference correspondingly.
> This removes the need to hold 'disc_mutex' when removing the
> structure, and avoids the above race condition.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/fcoe/fcoe_ctlr.c |  6 ------
>  drivers/scsi/libfc/fc_lport.c | 19 ++++++++++-------
>  drivers/scsi/libfc/fc_rport.c | 49 ++++++++++++++++++++++---------------------
>  3 files changed, 37 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> index 3e83d48..59b8476 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -2496,14 +2496,12 @@ static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *fip, u32 port_id, u8 *mac)
>  	struct fcoe_rport *frport;
>  	int ret = -1;
>
> -	rcu_read_lock();
>  	rdata = lport->tt.rport_lookup(lport, port_id);
>  	if (rdata) {
>  		frport = fcoe_ctlr_rport(rdata);
>  		memcpy(mac, frport->enode_mac, ETH_ALEN);
>  		ret = 0;
>  	}
> -	rcu_read_unlock();
>  	return ret;
>  }

Hello Hannes,

Although I'm not very familiar with the SCSI FC code, the approach of 
this patch makes sense to me. But it's not clear to me which code drops 
the reference that has been obtained by the rport_lookup() call in the 
above code?

Bart.
