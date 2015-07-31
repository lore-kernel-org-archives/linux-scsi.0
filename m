From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: allow underflow/overflow for PR OUT etc.
 commands
Date: Thu, 30 Jul 2015 23:44:23 -0700
Message-ID: <1438325063.16598.15.camel@haakon3.risingtidesystems.com>
References: <1437602898-15229-4-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437602898-15229-4-git-send-email-sbaugh@catern.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>
Cc: "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-07-22 at 15:08 -0700, Spencer Baugh wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> It's not necessarily a fatal error if a command with a data-out phase
> has a data length that differs from the transport data length (e.g.
> PERSISTENT RESERVE OUT might have a parameter list length in the CDB
> that's smaller than the FC_DL field), so allow these commands.  The
> Windows compliance test sends them.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> Signed-off-by: Spencer Baugh <sbaugh@catern.com>
> ---
>  drivers/target/target_core_transport.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index ac002a7..f6626bb 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1087,9 +1087,9 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
>  			" 0x%02x\n", cmd->se_tfo->get_fabric_name(),
>  				cmd->data_length, size, cmd->t_task_cdb[0]);
>  
> -		if (cmd->data_direction == DMA_TO_DEVICE) {
> -			pr_err("Rejecting underflow/overflow"
> -					" WRITE data\n");
> +		if (cmd->data_direction == DMA_TO_DEVICE &&
> +		    cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
> +			pr_err("Rejecting underflow/overflow WRITE data\n");
>  			return TCM_INVALID_CDB_FIELD;
>  		}
>  		/*

Applied to target-pending/for-next.

Thanks Roland & Co.
