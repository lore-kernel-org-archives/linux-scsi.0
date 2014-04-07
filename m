From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 8/9] target/sbc: Add sbc_dif_read_strip software emulation
Date: Mon, 07 Apr 2014 10:44:24 +0300
Message-ID: <53425758.8030001@dev.mellanox.co.il>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com> <1396517753-23546-9-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396517753-23546-9-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 4/3/2014 12:35 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> Split up __sbc_dif_verify_read() so that VERIFY READ emulation can
> perform target-core specific READ_STRIP, seperate from the existing
> FILEIO/RAMDISK backend emulation code.
>
> Also add sbc_dif_read_strip() in order to determine number of sectors
> using cmd->prot_length, and skip the extra sbc_dif_copy_prot().
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Cc: Quinn Tran <quinn.tran@qlogic.com>
> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_sbc.c     |   31 +++++++++++++++++++++++++++----
>   include/target/target_core_backend.h |    1 +
>   2 files changed, 28 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 97b207d..55c3526 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -1271,9 +1271,9 @@ sbc_dif_verify_write(struct se_cmd *cmd, sector_t start, unsigned int sectors,
>   }
>   EXPORT_SYMBOL(sbc_dif_verify_write);
>   
> -sense_reason_t
> -sbc_dif_verify_read(struct se_cmd *cmd, sector_t start, unsigned int sectors,
> -		    unsigned int ei_lba, struct scatterlist *sg, int sg_off)
> +static sense_reason_t
> +__sbc_dif_verify_read(struct se_cmd *cmd, sector_t start, unsigned int sectors,
> +		      unsigned int ei_lba, struct scatterlist *sg, int sg_off)
>   {
>   	struct se_device *dev = cmd->se_dev;
>   	struct se_dif_v1_tuple *sdt;
> @@ -1326,8 +1326,31 @@ sbc_dif_verify_read(struct se_cmd *cmd, sector_t start, unsigned int sectors,
>   		kunmap_atomic(paddr);
>   		kunmap_atomic(daddr);
>   	}
> -	sbc_dif_copy_prot(cmd, sectors, true, sg, sg_off);
>   
>   	return 0;
>   }
> +
> +sense_reason_t
> +sbc_dif_read_strip(struct se_cmd *cmd)
> +{
> +	struct se_device *dev = cmd->se_dev;
> +	u32 sectors = cmd->prot_length / dev->prot_length;
> +
> +	return __sbc_dif_verify_read(cmd, cmd->t_task_lba, sectors, 0,
> +				     cmd->t_prot_sg, 0);
> +}
> +
> +sense_reason_t
> +sbc_dif_verify_read(struct se_cmd *cmd, sector_t start, unsigned int sectors,
> +		    unsigned int ei_lba, struct scatterlist *sg, int sg_off)
> +{
> +	sense_reason_t rc;
> +
> +	rc = __sbc_dif_verify_read(cmd, start, sectors, ei_lba, sg, sg_off);
> +	if (rc)
> +		return rc;
> +
> +	sbc_dif_copy_prot(cmd, sectors, true, sg, sg_off);
> +	return 0;
> +}
>   EXPORT_SYMBOL(sbc_dif_verify_read);
> diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
> index 8e6eac6..68e2820 100644
> --- a/include/target/target_core_backend.h
> +++ b/include/target/target_core_backend.h
> @@ -78,6 +78,7 @@ sense_reason_t	sbc_dif_verify_write(struct se_cmd *, sector_t, unsigned int,
>   				     unsigned int, struct scatterlist *, int);
>   sense_reason_t	sbc_dif_verify_read(struct se_cmd *, sector_t, unsigned int,
>   				    unsigned int, struct scatterlist *, int);
> +sense_reason_t	sbc_dif_read_strip(struct se_cmd *);
>   
>   void	transport_set_vpd_proto_id(struct t10_vpd *, unsigned char *);
>   int	transport_set_vpd_assoc(struct t10_vpd *, unsigned char *);
Looks good to me.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
