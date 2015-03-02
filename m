From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/9] target: Convert DIF emulation to use cmd->prot_type
Date: Mon, 02 Mar 2015 13:30:56 +0200
Message-ID: <54F449F0.9090805@dev.mellanox.co.il>
References: <1425119766-11878-1-git-send-email-nab@daterainc.com> <1425119766-11878-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36626 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbbCBLbB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2015 06:31:01 -0500
Received: by wevk48 with SMTP id k48so32653742wev.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2015 03:31:00 -0800 (PST)
In-Reply-To: <1425119766-11878-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>

On 2/28/2015 12:35 PM, Nicholas A. Bellinger wrote:
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

This reminds me, I wander if the dif verify needed checks should be
driven from the cmd->prot_type or from cmd->prot_checks (set at
sbc_set_prot_op_checks()). AFAICT, the protection type simply
determines the way we treat the tags. Although I guess the target is
allowed to check protection even if it wasn't requested to (for example
when the fabric is unprotected and the backend is protected...).

MKP?

Sagi.
