From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 03/17] target/sbc: Add DIF setup in sbc_check_prot
 + sbc_parse_cdb
Date: Sun, 19 Jan 2014 13:43:37 +0200
Message-ID: <52DBBA69.4040800@dev.mellanox.co.il>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com> <1390099480-29013-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64798 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaASLnp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2014 06:43:45 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so2878220eek.2
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2014 03:43:43 -0800 (PST)
In-Reply-To: <1390099480-29013-4-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

On 1/19/2014 4:44 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds sbc_check_prot() for performing various DIF
> related CDB sanity checks, along with setting cmd->prot_type
> once sanity checks have passed.
>
> Also, add calls in sbc_parse_cdb() for READ_[10,12,16] +
> WRITE_[10,12,16] to perform DIF sanity checking.
>
> v2 changes:
>    - Make sbc_check_prot defined as static (Fengguang + Wei)
>    - Remove unprotected READ/WRITE warning (mkp)
>    - Populate cmd->prot_type + friends (Sagi)
>    - Drop SCF_PROT usage
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_sbc.c |   62 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 62 insertions(+)
>
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 6863dbe..91a92f3 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -563,6 +563,44 @@ sbc_compare_and_write(struct se_cmd *cmd)
>   	return TCM_NO_SENSE;
>   }
>   
> +static bool
> +sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
> +	       u32 sectors)
> +{
> +	if (!cmd->t_prot_sg || !cmd->t_prot_nents)
> +		return true;
> +
> +	switch (dev->dev_attrib.pi_prot_type) {
> +	case TARGET_DIF_TYPE3_PROT:
> +		if (!(cdb[1] & 0xe0))
> +			return true;
> +
> +		cmd->reftag_seed = 0xffffffff;
> +		break;
> +	case TARGET_DIF_TYPE2_PROT:
> +		if (cdb[1] & 0xe0)
> +			return false;
> +
> +		cmd->reftag_seed = cmd->t_task_lba;
> +		break;
> +	case TARGET_DIF_TYPE1_PROT:
> +		if (!(cdb[1] & 0xe0))
> +			return true;
> +
> +		cmd->reftag_seed = cmd->t_task_lba;
> +		break;
> +	case TARGET_DIF_TYPE0_PROT:
> +	default:
> +		return true;
> +	}
> +
> +	cmd->prot_type = dev->dev_attrib.pi_prot_type;
> +	cmd->prot_length = dev->prot_length * sectors;
> +	cmd->prot_handover = PROT_SEPERATED;

I know that we are not planning to support interleaved mode at the 
moment, But I think
that the protection handover type is the backstore preference and should 
be taken from se_dev.
But it is not that important for now...

Sagi.
