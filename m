From: Sagi Grimberg <sagig@mellanox.com>
Subject: Re: [PATCH-v2 02/15] target: Add protected fabric + unprotected device
 support
Date: Mon, 13 Apr 2015 13:11:36 +0300
Message-ID: <552B9658.7030502@mellanox.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	 <1427686104-14231-3-git-send-email-nab@daterainc.com>
	 <yq1sicbh63q.fsf@sermon.lab.mkp.net>
	 <1428478828.18203.109.camel@haakon3.risingtidesystems.com>
	 <yq18ue1f02d.fsf@sermon.lab.mkp.net>
 <1428692341.20502.17.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428692341.20502.17.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 4/10/2015 9:59 PM, Nicholas A. Bellinger wrote:
> On Thu, 2015-04-09 at 17:45 -0400, Martin K. Petersen wrote:
>>>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
>>
>>>> How do you handle RDPROTECT/WRPROTECT values of 3 if the PI is not
>>>> persistent?
>>
>> nab> AFAICT, this would result in cmd->prot_op = TARGET_PROT_*_PASS and
>> cmd-> prot_checks = 0 for RDPROTECT/WRPROTECT == 0x3 in
>> nab> sbc_set_prot_op_checks() code.
>>
>> nab> Do DOUT_STRIP + DIN_INSERT need to be called if a protection buffer
>> nab> is present when RDPROTECT/WRPROTECT == 0x3 if fabric_prot was
>> nab> cleared..?  Or should the command be rejected when a protection
>> nab> buffer is present + RDPROTECT/WRPROTECT is non-zero if fabric_prot
>> nab> was cleared..?
>>
>> Depends how compliant you want to be.
>>
>> You can synthesize PI with RDPROTECT/WRPROTECT=1 as long as the
>> initiator doesn't rely on app tag escapes (we don't). Most non-HDD/SSD
>> targets work this way.
>>
>
> <nod>
>
>> I would suggest that you return invalid field in CDB for
>> RDPROTECT/WRPROTECT=3 unless the PI can be made persistent, however.
>>
>
> Ok, after thinking about this some more, here's what I've come up with..
>
> The following incremental patch saves the current sess_prot_type into
> se_node_acl, and will always reset sess_prot_type if a previous saved
> value exists.  So the PI setting for the fabric's session with backend
> devices not supporting PI is persistent across session restart.
>
> I also noticed the internal DIF emulation was not honoring
> se_cmd->prot_checks for the WRPROTECT/RDPROTECT == 0x3 case, so
> sbc_dif_v1_verify() has been updated to follow which checks have been
> calculated based on WRPROTECT/RDPROTECT in sbc_set_prot_op_checks().
>
> Finally in sbc_check_prot(), if PROTECT is non-zero for a backend device
> with DIF disabled, and sess_prot_type is not set go ahead and return
> INVALID_CDB_FIELD.
>
> WDYT..?
>
> --nab
>
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 315ff64..a75512f 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -697,9 +697,13 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
>   			pi_prot_type = cmd->se_sess->sess_prot_type;
>   			break;
>   		}
> +		if (!protect)
> +			return TCM_NO_SENSE;
>   		/* Fallthrough */
>   	default:
> -		return TCM_NO_SENSE;
> +		pr_err("Unable to determine pi_prot_type for CDB: 0x%02x "
> +		       "PROTECT: 0x%02x\n", cdb[0], protect);
> +		return TCM_INVALID_CDB_FIELD;
>   	}
>
>   	if (sbc_set_prot_op_checks(protect, fabric_prot, pi_prot_type, is_write, cmd))
> @@ -1221,6 +1227,9 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct se_dif_v1_tuple *sdt,
>   	int block_size = dev->dev_attrib.block_size;
>   	__be16 csum;
>
> +	if (!(cmd->prot_checks & TARGET_DIF_CHECK_GUARD))
> +		goto check_ref;
> +
>   	csum = cpu_to_be16(crc_t10dif(p, block_size));
>
>   	if (sdt->guard_tag != csum) {
> @@ -1230,6 +1239,10 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct se_dif_v1_tuple *sdt,
>   		return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
>   	}
>
> +check_ref:
> +	if (!(cmd->prot_checks & TARGET_DIF_CHECK_REFTAG))
> +		return 0;
> +
>   	if (cmd->prot_type == TARGET_DIF_TYPE1_PROT &&
>   	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
>   		pr_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x"
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index f884198..3ff38b2 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -329,11 +329,17 @@ void __transport_register_session(
>   	se_sess->fabric_sess_ptr = fabric_sess_ptr;
>   	/*
>   	 * Determine if fabric allows for T10-PI feature bits to be exposed
> -	 * to initiators for device backends with !dev->dev_attrib.pi_prot_type
> +	 * to initiators for device backends with !dev->dev_attrib.pi_prot_type.
> +	 *
> +	 * If so, then always save prot_type on a per se_node_acl node basis
> +	 * and re-instate the previous sess_prot_type to avoid disabling PI
> +	 * from below any previously initiator side registered LUNs.
>   	 */
> -	if (tfo->tpg_check_prot_fabric_only)
> -		se_sess->sess_prot_type = tfo->tpg_check_prot_fabric_only(se_tpg);
> -
> +	if (se_nacl->saved_prot_type)
> +		se_sess->sess_prot_type = se_nacl->saved_prot_type;
> +	else if (tfo->tpg_check_prot_fabric_only)
> +		se_sess->sess_prot_type = se_nacl->saved_prot_type =
> +				tfo->tpg_check_prot_fabric_only(se_tpg);
>   	/*
>   	 * Used by struct se_node_acl's under ConfigFS to locate active se_session-t
>   	 *
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 383110d..51dcf2b 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -590,6 +590,7 @@ struct se_node_acl {
>   	bool			acl_stop:1;
>   	u32			queue_depth;
>   	u32			acl_index;
> +	enum target_prot_type	saved_prot_type;
>   #define MAX_ACL_TAG_SIZE 64
>   	char			acl_tag[MAX_ACL_TAG_SIZE];
>   	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
>
>
>

This looks fine to me.

Acked-by: Sagi Grimberg <sagig@mellanox.com>
