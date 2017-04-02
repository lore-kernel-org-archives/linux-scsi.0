From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/user: PGR Support
Date: Sun, 02 Apr 2017 15:09:10 -0700
Message-ID: <1491170950.8846.26.camel@haakon3.risingtidesystems.com>
References: <1490885269-47274-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1490885269-47274-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: mchristi@redhat.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Bryant,

On Thu, 2017-03-30 at 09:47 -0500, Bryant G. Ly wrote:
> This adds PGR support for just TCMU, since tcmu doesn't
> have the necessary IT_NEXUS info to process PGR in userspace,
> so have those commands be processed in kernel.

I don't have a objection to adding PASSTHROUGH_PGR so TCMU can use
target_core_pr.c logic, following what MNC has already done with
PASSTHROUGH_ALUA.

Just one comment on the patch below.

> 
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_configfs.c | 10 +++++-----
>  drivers/target/target_core_device.c   | 27 +++++++++++++++++++++++++++
>  drivers/target/target_core_pr.c       |  2 +-
>  drivers/target/target_core_pscsi.c    |  3 ++-
>  include/target/target_core_backend.h  |  1 +
>  5 files changed, 36 insertions(+), 7 deletions(-)
> 

<SNIP>

> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index c754ae3..83c0d77 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -1076,6 +1077,32 @@ passthrough_parse_cdb(struct se_cmd *cmd,
>  		return TCM_NO_SENSE;
>  	}
>  
> +	/*
> +	 * For PERSISTENT RESERVE IN/OUT, RELEASE, and RESERVE we need to
> +	 * emulate the response, since tcmu does not have the information
> +	 * required to process these commands.
> +	 */
> +	if (!(dev->transport->transport_flags &
> +	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
> +		if (cdb[0] == PERSISTENT_RESERVE_IN) {
> +			cmd->execute_cmd = target_scsi3_emulate_pr_in;
> +			return TCM_NO_SENSE;
> +		}
> +		if (cdb[0] == PERSISTENT_RESERVE_OUT) {
> +			cmd->execute_cmd = target_scsi3_emulate_pr_out;
> +			return TCM_NO_SENSE;
> +		}
> +
> +		if (cdb[0] == RELEASE || cdb[0] == RELEASE_10) {
> +			cmd->execute_cmd = target_scsi2_reservation_release;
> +			return TCM_NO_SENSE;
> +		}
> +		if (cdb[0] == RESERVE || cdb[0] == RESERVE_10) {
> +			cmd->execute_cmd = target_scsi2_reservation_reserve;
> +			return TCM_NO_SENSE;
> +		}
> +	}
> +

Following what spc_parse_cdb() does wrt extracting the allocation length
out of the CDB, calling target_cmd_size_check() to check for overflow +
underflow + residual_count vs. fabric provided se_cmd->data_length, I'm
wonder if we're getting to the point in passthrough_parse_cdb() where
target_cmd_size_check() should be happening too.

Historically, we've never done these checks for PSCSI, but given TCMU
will be using this path for setting up full in-kernel PR, it's probably
a good idea to do target_cmd_size_check() for the PASSTHROUGH_PGR
special cases here.
