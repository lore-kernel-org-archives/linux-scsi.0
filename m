From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/10] zfcp: close window with unblocked rport during
 rport gone
Date: Thu, 11 Aug 2016 13:21:25 +0200
Message-ID: <6ecb9f8d-1021-e8f9-7317-1389b47f4d42@suse.de>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
 <1470846653-90691-4-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1470846653-90691-4-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "#2 . 6 . 32+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/10/2016 06:30 PM, Steffen Maier wrote:
> On a successful end of reopen port forced,
> zfcp_erp_strategy_followup_success() re-uses the port erp_action
> and the subsequent zfcp_erp_action_cleanup() now
> sees ZFCP_ERP_SUCCEEDED with
> erp_action->action==ZFCP_ERP_ACTION_REOPEN_PORT
> instead of ZFCP_ERP_ACTION_REOPEN_PORT_FORCED
> but must not perform zfcp_scsi_schedule_rport_register().
> 
> We can detect this because the fresh port reopen erp_action
> is in its very first step ZFCP_ERP_STEP_UNINITIALIZED.
> 
> Otherwise this opens a time window with unblocked rport
> (until the followup port reopen recovery would block it again).
> If a scsi_cmnd timeout occurs during this time window
> fc_timed_out() cannot work as desired and such command
> would indeed time out and trigger scsi_eh. This prevents
> a clean and timely path failover.
> This should not happen if the path issue can be recovered
> on FC transport layer such as path issues involving RSCNs.
> 
> Also, unnecessary and repeated DID_IMM_RETRY for pending and
> undesired new requests occur because internally zfcp still
> has its zfcp_port blocked.
> 
> As follow-on errors with scsi_eh, it can cause,
> in the worst case, permanently lost paths due to one of:
> sd <scsidev>: [<scsidisk>] Medium access timeout failure. Offlining disk!
> sd <scsidev>: Device offlined - not ready after error recovery
> 
> For fix validation and to aid future debugging with other recoveries
> we now also trace (un)blocking of rports.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Fixes: 5767620c383a ("[SCSI] zfcp: Do not unblock rport from REOPEN_PORT_FORCED")
> Fixes: a2fa0aede07c ("[SCSI] zfcp: Block FC transport rports early on errors")
> Fixes: 5f852be9e11d ("[SCSI] zfcp: Fix deadlock between zfcp ERP and SCSI")
> Fixes: 338151e06608 ("[SCSI] zfcp: make use of fc_remote_port_delete when target port is unavailable")
> Fixes: 3859f6a248cb ("[PATCH] zfcp: add rports to enable scsi_add_device to work again")
> Cc: <stable@vger.kernel.org> #2.6.32+
> Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_dbf.h  |  7 ++++++-
>  drivers/s390/scsi/zfcp_erp.c  | 12 +++++++++---
>  drivers/s390/scsi/zfcp_scsi.c |  8 +++++++-
>  3 files changed, 22 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
