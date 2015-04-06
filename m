From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 2/2] target/rd: Don't pass imcomplete scatterlist entries
 to sbc_dif_verify_*
Date: Mon, 06 Apr 2015 11:42:23 +0300
Message-ID: <552246EF.8050804@dev.mellanox.co.il>
References: <1428245979-5432-1-git-send-email-akinobu.mita@gmail.com> <1428245979-5432-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35785 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbbDFIm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2015 04:42:29 -0400
Received: by wgyo15 with SMTP id o15so10640402wgy.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Apr 2015 01:42:27 -0700 (PDT)
In-Reply-To: <1428245979-5432-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, target-devel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 4/5/2015 5:59 PM, Akinobu Mita wrote:
> The scatterlist for protection information which is passed to
> sbc_dif_verify_read() or sbc_dif_verify_write() requires that
> neighboring scatterlist entries are contiguous or chained so that they
> can be iterated by sg_next().
>
> However, the protection information for RD-MCP backends could be located
> in the multiple scatterlist arrays when the ramdisk space is too large.
> So if the read/write request straddles this boundary, sbc_dif_verify_read()
> or sbc_dif_verify_write() can't iterate all scatterlist entries.
>
> This fixes it by allocating temporary scatterlist if it is needed.
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
> * No change from v1
>
>   drivers/target/target_core_rd.c | 39 +++++++++++++++++++++++++++++++++++----
>   1 file changed, 35 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> index ac5e8d2..6e25eaa 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -390,11 +390,12 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
>   	struct se_device *se_dev = cmd->se_dev;
>   	struct rd_dev *dev = RD_DEV(se_dev);
>   	struct rd_dev_sg_table *prot_table;
> +	bool need_to_release = false;
>   	struct scatterlist *prot_sg;
>   	u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
> -	u32 prot_offset, prot_page;
> +	u32 prot_offset, prot_page, prot_npages;
>   	u64 tmp;
> -	sense_reason_t rc;
> +	sense_reason_t rc = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>
>   	tmp = cmd->t_task_lba * se_dev->prot_length;
>   	prot_offset = do_div(tmp, PAGE_SIZE);
> @@ -404,10 +405,40 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
>   	if (!prot_table)
>   		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>
> -	prot_sg = &prot_table->sg_table[prot_page -
> -					prot_table->page_start_offset];
> +	prot_npages = DIV_ROUND_UP(prot_offset + sectors * se_dev->prot_length,
> +				   PAGE_SIZE);
> +
> +	/* prot pages straddles multiple scatterlist tables */
> +	if (prot_table->page_end_offset < prot_page + prot_npages - 1) {
> +		int i;
> +
> +		prot_sg = kcalloc(prot_npages, sizeof(*prot_sg), GFP_KERNEL);
> +		if (!prot_sg)
> +			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +
> +		need_to_release = true;
> +		sg_init_table(prot_sg, prot_npages);
> +
> +		for (i = 0; i < prot_npages; i++) {
> +			if (prot_page + i > prot_table->page_end_offset) {
> +				prot_table = rd_get_prot_table(dev,
> +								prot_page + i);
> +				if (!prot_table)
> +					goto out;
> +				sg_unmark_end(&prot_sg[i - 1]);
> +			}
> +			prot_sg[i] = prot_table->sg_table[prot_page + i -
> +						prot_table->page_start_offset];
> +		}
> +	} else {
> +		prot_sg = &prot_table->sg_table[prot_page -
> +						prot_table->page_start_offset];
> +	}
>
>   	rc = dif_verify(cmd, cmd->t_task_lba, sectors, 0, prot_sg, prot_offset);
> +out:
> +	if (need_to_release)
> +		kfree(prot_sg);
>
>   	return rc;
>   }
>

Acked-by: Sagi Grimberg <sagig@mellanox.com>
