From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 1/2] target/rd: reduce code duplication in rd_execute_rw()
Date: Mon, 06 Apr 2015 10:43:04 +0300
Message-ID: <55223908.6080607@dev.mellanox.co.il>
References: <1428245979-5432-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36510 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbbDFHnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2015 03:43:10 -0400
Received: by wizk4 with SMTP id k4so23449399wiz.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Apr 2015 00:43:08 -0700 (PDT)
In-Reply-To: <1428245979-5432-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, target-devel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 4/5/2015 5:59 PM, Akinobu Mita wrote:
> Factor out code duplication in rd_execute_rw() into a helper function
> rd_do_prot_rw().  This change is required to minimize the forthcoming
> fix in rd_do_prot_rw().
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: target-devel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> ---
> * v2
> - Pass dif_verify() function pointer to helper function instead of is_write,
>    suggested by Sagi Grimberg.
>
>   drivers/target/target_core_rd.c | 66 ++++++++++++++++++++---------------------
>   1 file changed, 32 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> index 98e83ac..ac5e8d2 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -382,6 +382,36 @@ static struct rd_dev_sg_table *rd_get_prot_table(struct rd_dev *rd_dev, u32 page
>   	return NULL;
>   }
>
> +typedef sense_reason_t (*dif_verify)(struct se_cmd *, sector_t, unsigned int,
> +				     unsigned int, struct scatterlist *, int);
> +
> +static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
> +{
> +	struct se_device *se_dev = cmd->se_dev;
> +	struct rd_dev *dev = RD_DEV(se_dev);
> +	struct rd_dev_sg_table *prot_table;
> +	struct scatterlist *prot_sg;
> +	u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
> +	u32 prot_offset, prot_page;
> +	u64 tmp;
> +	sense_reason_t rc;
> +
> +	tmp = cmd->t_task_lba * se_dev->prot_length;
> +	prot_offset = do_div(tmp, PAGE_SIZE);
> +	prot_page = tmp;
> +
> +	prot_table = rd_get_prot_table(dev, prot_page);
> +	if (!prot_table)
> +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +
> +	prot_sg = &prot_table->sg_table[prot_page -
> +					prot_table->page_start_offset];
> +
> +	rc = dif_verify(cmd, cmd->t_task_lba, sectors, 0, prot_sg, prot_offset);
> +
> +	return rc;

Nit, Given there is no action on the returned rc, this can be reduced to:
	return dif_verify();

> +}
> +
>   static sense_reason_t
>   rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>   	      enum dma_data_direction data_direction)
> @@ -420,23 +450,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>   			cmd->t_task_lba, rd_size, rd_page, rd_offset);
>
>   	if (cmd->prot_type && data_direction == DMA_TO_DEVICE) {
> -		struct rd_dev_sg_table *prot_table;
> -		struct scatterlist *prot_sg;
> -		u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
> -		u32 prot_offset, prot_page;
> -
> -		tmp = cmd->t_task_lba * se_dev->prot_length;
> -		prot_offset = do_div(tmp, PAGE_SIZE);
> -		prot_page = tmp;
> -
> -		prot_table = rd_get_prot_table(dev, prot_page);
> -		if (!prot_table)
> -			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> -
> -		prot_sg = &prot_table->sg_table[prot_page - prot_table->page_start_offset];
> -
> -		rc = sbc_dif_verify_write(cmd, cmd->t_task_lba, sectors, 0,
> -					  prot_sg, prot_offset);
> +		rc = rd_do_prot_rw(cmd, sbc_dif_verify_write);
>   		if (rc)
>   			return rc;
>   	}
> @@ -503,23 +517,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>   	sg_miter_stop(&m);
>
>   	if (cmd->prot_type && data_direction == DMA_FROM_DEVICE) {
> -		struct rd_dev_sg_table *prot_table;
> -		struct scatterlist *prot_sg;
> -		u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
> -		u32 prot_offset, prot_page;
> -
> -		tmp = cmd->t_task_lba * se_dev->prot_length;
> -		prot_offset = do_div(tmp, PAGE_SIZE);
> -		prot_page = tmp;
> -
> -		prot_table = rd_get_prot_table(dev, prot_page);
> -		if (!prot_table)
> -			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> -
> -		prot_sg = &prot_table->sg_table[prot_page - prot_table->page_start_offset];
> -
> -		rc = sbc_dif_verify_read(cmd, cmd->t_task_lba, sectors, 0,
> -					 prot_sg, prot_offset);
> +		rc = rd_do_prot_rw(cmd, sbc_dif_verify_read);
>   		if (rc)
>   			return rc;
>   	}
>

