From: sagi grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 3/4] target/rd: T10-Dif: Add init/format support
Date: Sat, 29 Mar 2014 03:16:18 +0300
Message-ID: <533610D2.5030205@mellanox.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com> <1396047927-14189-4-git-send-email-quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:42180 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbaC2AQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 20:16:28 -0400
In-Reply-To: <1396047927-14189-4-git-send-email-quinn.tran@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

On 3/29/2014 2:05 AM, Quinn Tran wrote:
> This patch is borrow code from
>
> commit 0f5e2ec46dd64579c0770f3822764f94db4fa465
> Author: Nicholas Bellinger <nab@linux-iscsi.org>
> Date:   Sat Jan 18 09:32:56 2014 +0000
>
>      target/file: Add DIF protection init/format support
>
>      This patch adds support for DIF protection init/format support into
>      the FILEIO backend.
>
>      It involves using a seperate $FILE.protection for storing PI that is
>      opened via fd_init_prot() using the common pi_prot_type attribute.
>      The actual formatting of the protection is done via fd_format_prot()
>      using the common pi_prot_format attribute, that will populate the
>      initial PI data based upon the currently configured pi_prot_type.
>
>      Based on original FILEIO code from Sagi.
>
>      v1 changes:
>        - Fix sparse warnings in fd_init_format_buf (Fengguang)
>
>      Cc: Martin K. Petersen <martin.petersen@oracle.com>
>      Cc: Christoph Hellwig <hch@lst.de>
>      Cc: Hannes Reinecke <hare@suse.de>
>      Cc: Sagi Grimberg <sagig@mellanox.com>
>      Cc: Or Gerlitz <ogerlitz@mellanox.com>
>      Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_rd.c | 64 ++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 63 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> index 66a5aba..01dda0b 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -603,7 +603,7 @@ static int rd_init_prot(struct se_device *dev)
>   {
>   	struct rd_dev *rd_dev = RD_DEV(dev);
>   
> -        if (!dev->dev_attrib.pi_prot_type)
> +	if (!dev->dev_attrib.pi_prot_type)
>   		return 0;
>   
>   	return rd_build_prot_space(rd_dev, dev->prot_length);
> @@ -616,6 +616,67 @@ static void rd_free_prot(struct se_device *dev)
>   	rd_release_prot_space(rd_dev);
>   }
>   
> +static void rd_init_format_buf(struct se_device *dev, unsigned char *buf,
> +			       u32 unit_size, u32 *ref_tag, u16 app_tag,
> +			       bool inc_reftag)
> +{
> +	unsigned char *p = buf;
> +	int i;
> +
> +	for (i = 0; i < unit_size; i += dev->prot_length) {
> +		*((u16 *)&p[0]) = 0xffff;
> +		*((__be16 *)&p[2]) = cpu_to_be16(app_tag);
> +		*((__be32 *)&p[4]) = cpu_to_be32(*ref_tag);
> +
> +		if (inc_reftag)
> +			(*ref_tag)++;
> +
> +		p += dev->prot_length;
> +	}
> +}
> +
> +static int rd_format_prot(struct se_device *dev)
> +{
> +	struct rd_dev *rd_dev = RD_DEV(dev);
> +	u32 ref_tag = 0;
> +	int i,j;
> +	bool inc_reftag = false;
> +	struct rd_dev_sg_table *pt;
> +	struct scatterlist *sg;
> +	void *paddr;
> +
> +	if (!dev->dev_attrib.pi_prot_type) {
> +		pr_err("Unable to format_prot while pi_prot_type == 0\n");
> +		return -ENODEV;
> +	}
> +
> +	switch (dev->dev_attrib.pi_prot_type) {
> +	case TARGET_DIF_TYPE3_PROT:
> +		ref_tag = 0xffffffff;
> +		break;
> +	case TARGET_DIF_TYPE2_PROT:
> +	case TARGET_DIF_TYPE1_PROT:
> +		inc_reftag = true;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	for (i=0; i < rd_dev->sg_prot_count; i++) {
> +		pt= &rd_dev->sg_prot_array[i];
> +		for_each_sg(pt->sg_table, sg, pt->rd_sg_count, j) {
> +			paddr = kmap(sg_page(sg)) + sg->offset;
> +
> +			rd_init_format_buf(dev, paddr, sg->length, &ref_tag,
> +					0xffff, inc_reftag);
> +			kunmap(paddr);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +
>   static struct sbc_ops rd_sbc_ops = {
>   	.execute_rw		= rd_execute_rw,
>   };
> @@ -642,6 +703,7 @@ static struct se_subsystem_api rd_mcp_template = {
>   	.get_device_type	= sbc_get_device_type,
>   	.get_blocks		= rd_get_blocks,
>   	.init_prot		= rd_init_prot,
> +	.format_prot            = rd_format_prot,
>   	.free_prot		= rd_free_prot,
>   };
>   

This patch is redundant altogether. rd_mcp already init protection with 
escape values:
rc = rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0xff);
