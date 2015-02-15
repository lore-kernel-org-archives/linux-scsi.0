From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/8] target: Fail I/O with PROTECT bit when protection
 is unsupported
Date: Sun, 15 Feb 2015 10:33:40 +0200
Message-ID: <54E059E4.8070208@dev.mellanox.co.il>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com> <1423884463-16797-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1423884463-16797-4-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 2/14/2015 5:27 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds an explicit check for WRPROTECT + RDPROTECT bit usage
> within sbc_check_prot(), and fails with TCM_INVALID_CDB_FIELD if the
> backend device does not have protection enabled.
>
> Also, update sbc_check_prot() to return sense_reason_t in order to
> propigate up the correct sense ASQ.
>
> Cc: Martin Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_sbc.c | 51 +++++++++++++++++++++++++---------------
>   1 file changed, 32 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 17259c0..1bb8b4a 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -626,14 +626,21 @@ sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
>   	return 0;
>   }
>
> -static bool
> +static sense_reason_t
>   sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
>   	       u32 sectors, bool is_write)
>   {
>   	u8 protect = cdb[1] >> 5;
>
> -	if ((!cmd->t_prot_sg || !cmd->t_prot_nents) && cmd->prot_pto)
> -		return true;
> +	if (!cmd->t_prot_sg || !cmd->t_prot_nents) {
> +		if (protect && !dev->dev_attrib.pi_prot_type) {
> +			pr_err("CDB contains protect bit, but device does not"
> +			       " advertise PROTECT=1 feature bit\n");
> +			return TCM_INVALID_CDB_FIELD;
> +		}
> +		if (cmd->prot_pto)
> +			return TCM_NO_SENSE;
> +	}

I think this should indicate a strip operation rather than a failure.
Depends on what we reported in readcapacity wrt backend/frontend
support & setting.

>
>   	switch (dev->dev_attrib.pi_prot_type) {
>   	case TARGET_DIF_TYPE3_PROT:
> @@ -641,7 +648,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
>   		break;
>   	case TARGET_DIF_TYPE2_PROT:
>   		if (protect)
> -			return false;
> +			return TCM_INVALID_CDB_FIELD;
>
>   		cmd->reftag_seed = cmd->t_task_lba;
>   		break;
> @@ -650,12 +657,12 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
>   		break;
>   	case TARGET_DIF_TYPE0_PROT:
>   	default:
> -		return true;
> +		return TCM_NO_SENSE;
>   	}
>
>   	if (sbc_set_prot_op_checks(protect, dev->dev_attrib.pi_prot_type,
>   				   is_write, cmd))
> -		return false;
> +		return TCM_INVALID_CDB_FIELD;
>
>   	cmd->prot_type = dev->dev_attrib.pi_prot_type;
>   	cmd->prot_length = dev->prot_length * sectors;
> @@ -674,7 +681,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
>   		 __func__, cmd->prot_type, cmd->data_length, cmd->prot_length,
>   		 cmd->prot_op, cmd->prot_checks);
>
> -	return true;
> +	return TCM_NO_SENSE;
>   }
>
>   sense_reason_t
> @@ -698,8 +705,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>   		sectors = transport_get_sectors_10(cdb);
>   		cmd->t_task_lba = transport_lba_32(cdb);
>
> -		if (!sbc_check_prot(dev, cmd, cdb, sectors, false))
> -			return TCM_UNSUPPORTED_SCSI_OPCODE;
> +		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
> +		if (ret)
> +			return ret;
>
>   		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
>   		cmd->execute_rw = ops->execute_rw;
> @@ -709,8 +717,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>   		sectors = transport_get_sectors_12(cdb);
>   		cmd->t_task_lba = transport_lba_32(cdb);
>
> -		if (!sbc_check_prot(dev, cmd, cdb, sectors, false))
> -			return TCM_UNSUPPORTED_SCSI_OPCODE;
> +		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
> +		if (ret)
> +			return ret;
>
>   		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
>   		cmd->execute_rw = ops->execute_rw;
> @@ -720,8 +729,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>   		sectors = transport_get_sectors_16(cdb);
>   		cmd->t_task_lba = transport_lba_64(cdb);
>
> -		if (!sbc_check_prot(dev, cmd, cdb, sectors, false))
> -			return TCM_UNSUPPORTED_SCSI_OPCODE;
> +		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
> +		if (ret)
> +			return ret;
>
>   		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
>   		cmd->execute_rw = ops->execute_rw;
> @@ -739,8 +749,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>   		sectors = transport_get_sectors_10(cdb);
>   		cmd->t_task_lba = transport_lba_32(cdb);
>
> -		if (!sbc_check_prot(dev, cmd, cdb, sectors, true))
> -			return TCM_UNSUPPORTED_SCSI_OPCODE;
> +		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
> +		if (ret)
> +			return ret;
>
>   		if (cdb[1] & 0x8)
>   			cmd->se_cmd_flags |= SCF_FUA;
> @@ -752,8 +763,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>   		sectors = transport_get_sectors_12(cdb);
>   		cmd->t_task_lba = transport_lba_32(cdb);
>
> -		if (!sbc_check_prot(dev, cmd, cdb, sectors, true))
> -			return TCM_UNSUPPORTED_SCSI_OPCODE;
> +		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
> +		if (ret)
> +			return ret;
>
>   		if (cdb[1] & 0x8)
>   			cmd->se_cmd_flags |= SCF_FUA;
> @@ -765,8 +777,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>   		sectors = transport_get_sectors_16(cdb);
>   		cmd->t_task_lba = transport_lba_64(cdb);
>
> -		if (!sbc_check_prot(dev, cmd, cdb, sectors, true))
> -			return TCM_UNSUPPORTED_SCSI_OPCODE;
> +		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
> +		if (ret)
> +			return ret;
>
>   		if (cdb[1] & 0x8)
>   			cmd->se_cmd_flags |= SCF_FUA;
>
