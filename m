From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 5/5] target: core: Fix failed command sense data handling
Date: Wed, 28 Jun 2017 12:45:43 -0500
Message-ID: <0b946201-4472-19d8-a471-b07a37a11f1b@redhat.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
 <20170628055900.22889-6-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170628055900.22889-6-damien.lemoal@wdc.com>
Sender: target-devel-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A . Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On 06/28/2017 12:59 AM, Damien Le Moal wrote:
> For a target device without a transport->transport_complete method
> defined (e.g. target_core_user), target_complete_cmd() will always
> result in a failed command completion being processed through target
> failure completion work even when the command failure comes from the
> target processing and has valid sense data (and hence does not require
> sense data emulation as done in the failure work processing). To ensure
> that the failed command sense data is propagated as indicated by the
> target, make sure that the normal "ok" work completion path is used by
> moving the command SCF_TRANSPORT_TASK_SENSE flag test out of the
> transport_complete defined conditional.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/target/target_core_transport.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index f1b3a46..a18e4db 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -719,10 +719,11 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
>  		dev->transport->transport_complete(cmd,
>  				cmd->t_data_sg,
>  				transport_get_sense_buffer(cmd));
> -		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
> -			success = 1;
>  	}
>  
> +	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
> +		success = 1;
> +
>  	/*
>  	 * Check for case where an explicit ABORT_TASK has been received
>  	 * and transport_wait_for_tasks() will be waiting for completion..
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>
