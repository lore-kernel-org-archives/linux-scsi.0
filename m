From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/3] target: Fix error checking for UNMAP commands
Date: Wed, 13 Feb 2013 12:27:07 -0800
Message-ID: <1360787227.13707.55.camel@haakon2.linux-iscsi.org>
References: <1360365520-11972-1-git-send-email-roland@kernel.org>
	 <1360365520-11972-2-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50722 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760480Ab3BMU1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 15:27:09 -0500
In-Reply-To: <1360365520-11972-2-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

On Fri, 2013-02-08 at 15:18 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> SBC-3 (revision 35) says:
> 
>     The PARAMETER LIST LENGTH field specifies the length in bytes of the
>     UNMAP parameter list that is available to be transferred from the
>     Data-Out Buffer. If the parameter list length is greater than zero
>     and less than 0008h (i.e., eight), then the device server shall
>     terminate the command with CHECK CONDITION status with the sense key
>     set to ILLEGAL REQUEST and the additional sense code set to
>     PARAMETER LIST LENGTH ERROR. A PARAMETER LIST LENGTH set to zero
>     specifies that no data shall be sent.
> 
> so our sense code for too-short descriptors was wrong, and we were
> incorrectly failing commands that didn't transfer any descriptors.
> 
> While we're at it, also handle the UNMAP check:
> 
>     If the ANCHOR bit is set to one, and the ANC_SUP bit in the Logical
>     Block Provisioning VPD page (see 6.6.4) is set to zero, then the
>     device server shall terminate the command with CHECK CONDITION
>     status with the sense key set to ILLEGAL REQUEST and the additional
>     sense code set to INVALID FIELD IN CDB.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Applied with Chris Boot's cut+paste comment fix.

Thanks,

--nab

>  drivers/target/target_core_iblock.c    | 11 ++++++++++-
>  drivers/target/target_core_transport.c | 10 ++++++++++
>  include/target/target_core_base.h      |  1 +
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index b526d23..b72ca5b 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -390,10 +390,19 @@ iblock_execute_unmap(struct se_cmd *cmd)
>  	sense_reason_t ret = 0;
>  	int dl, bd_dl, err;
>  
> +	/* We never set ANC_SUP */
> +	if (cdb[1])
> +		return TCM_INVALID_CDB_FIELD;
> +
> +	if (cmd->data_length == 0) {
> +		target_complete_cmd(cmd, SAM_STAT_GOOD);
> +		return 0;
> +	}
> +
>  	if (cmd->data_length < 8) {
>  		pr_warn("UNMAP parameter list length %u too small\n",
>  			cmd->data_length);
> -		return TCM_INVALID_PARAMETER_LIST;
> +		return TCM_PARAMETER_LIST_LENGTH_ERROR;
>  	}
>  
>  	buf = transport_kmap_data_sg(cmd);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index bd587b7..82c4204 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1514,6 +1514,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
>  	case TCM_UNSUPPORTED_SCSI_OPCODE:
>  	case TCM_INVALID_CDB_FIELD:
>  	case TCM_INVALID_PARAMETER_LIST:
> +	case TCM_PARAMETER_LIST_LENGTH_ERROR:
>  	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
>  	case TCM_UNKNOWN_MODE_PAGE:
>  	case TCM_WRITE_PROTECTED:
> @@ -2674,6 +2675,15 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
>  		/* INVALID FIELD IN PARAMETER LIST */
>  		buffer[SPC_ASC_KEY_OFFSET] = 0x26;
>  		break;
> +	case TCM_PARAMETER_LIST_LENGTH_ERROR:
> +		/* CURRENT ERROR */
> +		buffer[0] = 0x70;
> +		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
> +		/* ILLEGAL REQUEST */
> +		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
> +		/* INVALID FIELD IN PARAMETER LIST */
> +		buffer[SPC_ASC_KEY_OFFSET] = 0x1a;
> +		break;
>  	case TCM_UNEXPECTED_UNSOLICITED_DATA:
>  		/* CURRENT ERROR */
>  		buffer[0] = 0x70;
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 4fa0f10..37e3baa 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -193,6 +193,7 @@ enum tcm_sense_reason_table {
>  	TCM_RESERVATION_CONFLICT		= R(0x10),
>  	TCM_ADDRESS_OUT_OF_RANGE		= R(0x11),
>  	TCM_OUT_OF_RESOURCES			= R(0x12),
> +	TCM_PARAMETER_LIST_LENGTH_ERROR		= R(0x13),
>  #undef R
>  };
>  


