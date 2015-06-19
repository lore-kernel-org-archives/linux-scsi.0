From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] target: Send UA upon LUN RESET tmr completion
Date: Fri, 19 Jun 2015 15:06:01 +0200
Message-ID: <20150619130601.GB7783@lst.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de> <1434009689-112909-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434009689-112909-6-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 11, 2015 at 10:01:28AM +0200, Hannes Reinecke wrote:
> SAM mandates that an BUS DEVICE RESET FUNCTION OCCURRED
> UA needs to be send after a LUN RESET tmr has completed.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_transport.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index a0e0d3a..bb60c0c4 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3064,6 +3064,17 @@ static void target_tmr_work(struct work_struct *work)
>  		ret = core_tmr_lun_reset(dev, tmr, NULL, NULL);
>  		tmr->response = (!ret) ? TMR_FUNCTION_COMPLETE :
>  					 TMR_FUNCTION_REJECTED;
> +		if (tmr->response == TMR_FUNCTION_COMPLETE) {
> +			struct se_dev_entry *deve;
> +
> +			rcu_read_lock();
> +			deve = target_nacl_find_deve(cmd->se_sess->se_node_acl,
> +						     cmd->orig_fe_lun);
> +			if (deve)
> +				core_scsi3_ua_allocate(deve, 0x29,
> +					ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
> +			rcu_read_unlock();

This should use the target_ua_allocate_lun helper.
