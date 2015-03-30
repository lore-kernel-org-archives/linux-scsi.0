From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 01/15] target: Convert DIF emulation to use cmd->prot_type
Date: Mon, 30 Mar 2015 10:38:37 +0300
Message-ID: <5518FD7D.8040209@dev.mellanox.co.il>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com> <1427686104-14231-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36906 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbbC3Hio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2015 03:38:44 -0400
Received: by wiaa2 with SMTP id a2so115580465wia.0
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2015 00:38:43 -0700 (PDT)
In-Reply-To: <1427686104-14231-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>

On 3/30/2015 6:28 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch changes existing DIF emulation to check the command descriptor's
> prot_type, instead of what the backend device is exposing in pi_prot_type.
>
> Since this value is already set in sbc_check_prot(), go ahead and use it to
> allow protected fabrics to function with unprotected devices.
>
> Cc: Martin Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_sbc.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 9a2f9d3..95a7a74 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -1167,7 +1167,7 @@ sbc_dif_generate(struct se_cmd *cmd)
>   			sdt = paddr + offset;
>   			sdt->guard_tag = cpu_to_be16(crc_t10dif(daddr + j,
>   						dev->dev_attrib.block_size));
> -			if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT)
> +			if (cmd->prot_type == TARGET_DIF_TYPE1_PROT)
>   				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
>   			sdt->app_tag = 0;
>
> @@ -1186,9 +1186,10 @@ sbc_dif_generate(struct se_cmd *cmd)
>   }
>
>   static sense_reason_t
> -sbc_dif_v1_verify(struct se_device *dev, struct se_dif_v1_tuple *sdt,
> +sbc_dif_v1_verify(struct se_cmd *cmd, struct se_dif_v1_tuple *sdt,
>   		  const void *p, sector_t sector, unsigned int ei_lba)
>   {
> +	struct se_device *dev = cmd->se_dev;
>   	int block_size = dev->dev_attrib.block_size;
>   	__be16 csum;
>
> @@ -1201,7 +1202,7 @@ sbc_dif_v1_verify(struct se_device *dev, struct se_dif_v1_tuple *sdt,
>   		return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
>   	}
>
> -	if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT &&
> +	if (cmd->prot_type == TARGET_DIF_TYPE1_PROT &&
>   	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
>   		pr_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x"
>   		       " sector MSB: 0x%08x\n", (unsigned long long)sector,
> @@ -1209,7 +1210,7 @@ sbc_dif_v1_verify(struct se_device *dev, struct se_dif_v1_tuple *sdt,
>   		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
>   	}
>
> -	if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE2_PROT &&
> +	if (cmd->prot_type == TARGET_DIF_TYPE2_PROT &&
>   	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
>   		pr_err("DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x"
>   		       " ei_lba: 0x%08x\n", (unsigned long long)sector,
> @@ -1293,7 +1294,7 @@ sbc_dif_verify_write(struct se_cmd *cmd, sector_t start, unsigned int sectors,
>   				 (unsigned long long)sector, sdt->guard_tag,
>   				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
>
> -			rc = sbc_dif_v1_verify(dev, sdt, daddr + j, sector,
> +			rc = sbc_dif_v1_verify(cmd, sdt, daddr + j, sector,
>   					       ei_lba);
>   			if (rc) {
>   				kunmap_atomic(paddr);
> @@ -1354,7 +1355,7 @@ __sbc_dif_verify_read(struct se_cmd *cmd, sector_t start, unsigned int sectors,
>   				continue;
>   			}
>
> -			rc = sbc_dif_v1_verify(dev, sdt, daddr + j, sector,
> +			rc = sbc_dif_v1_verify(cmd, sdt, daddr + j, sector,
>   					       ei_lba);
>   			if (rc) {
>   				kunmap_atomic(paddr);
>

Looks good.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
