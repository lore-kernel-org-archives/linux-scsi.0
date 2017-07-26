From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 8/9] zfcp: fix waiting for rport(s) unblock in
 eh_host_reset_handler
Date: Wed, 26 Jul 2017 08:16:06 +0200
Message-ID: <a9be254e-c32d-4904-c3c0-9e7b021b0337@suse.de>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-9-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51152 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751011AbdGZGQI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 02:16:08 -0400
In-Reply-To: <20170725141427.35258-9-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> v2.6.30 commit 63caf367e1c9 ("[SCSI] zfcp: Improve reliability of SCSI eh
> handlers in zfcp") added calls to zfcp_erp_wait() within
> eh_abort_handler(), eh_device_reset_handler(), eh_target_reset_handler()
> in order to synchronize with zfcp recovery completion before returning
> from a scsi_eh callback (e.g. with SUCCESS) to prevent eh escalation.
> 
> v2.6.33 commit af4de36d911a ("[SCSI] zfcp: Block scsi_eh thread for rport
> state BLOCKED") introduced the use of fc_block_scsi_eh() for
> eh_abort_handler(), eh_device_reset_handler(), eh_target_reset_handler(),
> and eh_host_reset_handler(), because zfcp_erp_wait() from above commit is
> not sufficient.
> The use in zfcp_task_mgmt_function() is correct even for a LUN reset,
> as described in commit 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race
> with LUN recovery").
> However, the one call in zfcp_scsi_eh_host_reset_handler() waiting for
> just one arbitrary port of the arbitrary scsi_cmnd seems insufficient
> as the preceding adapter recovery could have recovered multiple ports
> for which we all should wait to unblock (or have run into FAST_IO_FAIL).
> 
> Therefore, we now wait for all ports of the adapter with this fix.
> 
> NB: We cannot easily wait for an event because there is a time window
> between zfcp_erp_wait() returned and zfcp_erp_try_rport_unblock() as part
> of zfcp_erp_action_cleanup() actually scheduled rport_work which will
> unblock an rport in zfcp_scsi_rport_work() asynchronously. Hence a
> flush_work() could come early before queue_work() was even done.
> 
> v2.6.35 commit a1dbfddd02d2 ("[SCSI] zfcp: Pass return code from
> fc_block_scsi_eh to scsi eh") fixed v2.6.33 for the FAST_IO_FAIL case.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Fixes: af4de36d911a ("[SCSI] zfcp: Block scsi_eh thread for rport state BLOCKED")
> Fixes: a1dbfddd02d2 ("[SCSI] zfcp: Pass return code from fc_block_scsi_eh to scsi eh")
> ---
>  drivers/s390/scsi/zfcp_scsi.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 8e96196fa877..11cf33ea8c14 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -338,16 +338,29 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>  	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
>  	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
>  	struct zfcp_port *port;
> -	int ret;
> +	int ret = SUCCESS;
>  
>  	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
>  	zfcp_erp_wait(adapter);
> -	port = zfcp_sdev->port;
> -	ret = port->rport ? fc_block_rport(port->rport) : 0;
> -	if (ret)
> -		return ret;
> +	/* after internal recovery, wait for async unblock of rport(s) */
> +	read_lock(&adapter->port_list_lock);
> +	list_for_each_entry(port, &adapter->port_list, list) {
> +		int fc_ret;
> +
> +		if (!port->rport)
> +			continue;
> +
> +		fc_ret = fc_block_rport(port->rport);
> +		/* Any rport ran into fast_io_fail_tmo: FAST_IO_FAIL.
> +		 * To let pending requests bubble up, even if too many
> +		 * because of other rports without this timeout.
> +		 */
> +		if (fc_ret)
> +			ret = fc_ret;
> +	}
> +	read_unlock(&adapter->port_list_lock);
>  
> -	return SUCCESS;
> +	return ret;
>  }
>  
>  struct scsi_transport_template *zfcp_scsi_transport_template;
> 
:-)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
