From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 06/14] qla2xxx: Improve T10-DIF/PI handling in driver.
Date: Wed, 8 Feb 2017 18:57:16 +0000
Message-ID: <1486580223.16026.16.camel@sandisk.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
         <1486161655-2307-7-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:42852 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdBHTBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 14:01:11 -0500
In-Reply-To: <1486161655-2307-7-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <914A1B0E1EB3EC4DABF615433AA4F9F9@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>

On Fri, 2017-02-03 at 14:40 -0800, Himanshu Madhani wrote:
> +	/* Response code and sense key */
> +	((uint32_t *)ctio->u.status1.sense_data)[0] =
> +	    cpu_to_le32((0x70 << 24) | (sense_key << 8));
> +	/* Additional sense length */
> +	((uint32_t *)ctio->u.status1.sense_data)[1] = cpu_to_le32(0x0a);
> +	/* ASC and ASCQ */
> +	((uint32_t *)ctio->u.status1.sense_data)[3] =
> +	    cpu_to_le32((asc << 24) | (ascq << 16));

Please use put_unaligned_le32() instead of open-coding it.

>  struct qla_tgt_cmd {
> @@ -885,11 +895,25 @@ struct qla_tgt_cmd {
>  	struct list_head cmd_list;
>  
>  	struct atio_from_isp atio;
> -	/* t10dif */
> +
> +	/* T10-DIF */
> +#define DIF_ERR_NONE 0
> +#define DIF_ERR_GRD 1
> +#define DIF_ERR_REF 2
> +#define DIF_ERR_APP 3
> +	int8_t dif_err_code;
>  	struct scatterlist *prot_sg;
>  	uint32_t prot_sg_cnt;
> -	uint32_t blk_sz;
> +	uint32_t blk_sz, num_blks;
> +	uint8_t scsi_status, sense_key, asc, ascq;
> +
>  	struct crc_context *ctx;
> +	uint32_t	prot_op;
> +	uint32_t	prot_type;
> +	uint8_t		*cdb;
> +	uint64_t	lba;
> +	uint16_t	a_guard, e_guard, a_app_tag, e_app_tag;
> +	uint32_t	a_ref_tag, e_ref_tag;
>  
>  	uint64_t jiffies_at_alloc;
>  	uint64_t jiffies_at_free;

There are already equivalents of prot_op, prot_type, cdb and lba in struct
se_cmd. I think a few weeks ago Christoph had asked you not to duplicate
se_cmd fields into struct qla_tgt_cmd?

Bart.
