From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/3] target: Fix sense data for out-of-bounds IO
 operations
Date: Wed, 13 Feb 2013 12:26:29 -0800
Message-ID: <1360787189.13707.54.camel@haakon2.linux-iscsi.org>
References: <1360365520-11972-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1360365520-11972-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

Hi Roland,

On Fri, 2013-02-08 at 15:18 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> We're supposed to return LOGICAL BLOCK ADDRESS OUT OF RANGE, not
> INVALID FIELD IN CDB.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Apologies for the delayed response.  Applied to target-pending/for-next.

Thank you,

--nab

>  drivers/target/target_core_sbc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index a664c66..170f1f7 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -486,7 +486,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>  		 */
>  		if (cmd->t_task_lba || sectors) {
>  			if (sbc_check_valid_sectors(cmd) < 0)
> -				return TCM_INVALID_CDB_FIELD;
> +				return TCM_ADDRESS_OUT_OF_RANGE;
>  		}
>  		cmd->execute_cmd = ops->execute_sync_cache;
>  		break;
