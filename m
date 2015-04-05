From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/2] target/rd: reduce code duplication in rd_execute_rw()
Date: Sun, 05 Apr 2015 13:01:07 +0300
Message-ID: <552107E3.4000504@dev.mellanox.co.il>
References: <1428150268-30260-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33371 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbbDEKBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2015 06:01:13 -0400
Received: by wgin8 with SMTP id n8so6900174wgi.0
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2015 03:01:11 -0700 (PDT)
In-Reply-To: <1428150268-30260-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, target-devel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Asias He <asias@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 4/4/2015 3:24 PM, Akinobu Mita wrote:
> Factor out code duplication in rd_execute_rw() into a helper function
> rd_do_prot_rw().  This change is required to minimize the forthcoming
> fix in rd_do_prot_rw().
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Asias He <asias@redhat.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: target-devel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/target/target_core_rd.c | 66 ++++++++++++++++++++---------------------
>   1 file changed, 32 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> index 98e83ac..4d614c9 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -382,6 +382,36 @@ static struct rd_dev_sg_table *rd_get_prot_table(struct rd_dev *rd_dev, u32 page
>   	return NULL;
>   }
>
> +static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_write)
> +{
> +	struct se_device *se_dev = cmd->se_dev;
> +	struct rd_dev *dev = RD_DEV(se_dev);
> +	struct rd_dev_sg_table *prot_table;
> +	struct scatterlist *prot_sg;
> +	u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
> +	u32 prot_offset, prot_page;
> +	u64 tmp;
> +	sense_reason_t rc;
> +	sense_reason_t (*dif_verify)(struct se_cmd *, sector_t, unsigned int,
> +			unsigned int, struct scatterlist *, int) =
> +		is_write ?  sbc_dif_verify_write : sbc_dif_verify_read;

Hi Akinobu,

I think it would make more sense to pass the dif_verify() function
pointer instead of is_write (only used for that anyway).
