From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v2 1/4] qla2xxx_nvmet: Add files for FC-NVMe Target
 support
Date: Thu, 9 Nov 2017 07:36:22 -0800
Message-ID: <3cf657ee-67a7-1b33-9a79-a0415d7a651b@broadcom.com>
References: <20171109031754.10270-1-himanshu.madhani@cavium.com>
 <20171109031754.10270-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:50181 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbdKIPg0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 10:36:26 -0500
Received: by mail-qk0-f193.google.com with SMTP id p7so8152456qkd.7
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 07:36:25 -0800 (PST)
In-Reply-To: <20171109031754.10270-2-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, linux-nvme@lists.infradead.org, hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/8/2017 7:17 PM, Himanshu Madhani wrote:
> +static struct nvmet_fc_target_template qla_nvmet_fc_transport = {
> +	.targetport_delete	= qla_nvmet_targetport_delete,
> +	.xmt_ls_rsp		= qla_nvmet_ls_rsp,
> +	.fcp_op			= qla_nvmet_fcp_op,
> +	.fcp_abort		= qla_nvmet_fcp_abort,
> +	.fcp_req_release	= qla_nvmet_fcp_req_release,
> +	.max_hw_queues		= 8,
> +	.max_sgl_segments	= 128,
> +	.max_dif_sgl_segments	= 64,
> +	.dma_boundary		= 0xFFFFFFFF,
> +	.target_features	= NVMET_FCTGTFEAT_READDATA_RSP |
> +					NVMET_FCTGTFEAT_CMD_IN_ISR |
> +					NVMET_FCTGTFEAT_OPDONE_IN_ISR,
> +	.target_priv_sz	= sizeof(struct nvme_private),
> +};
>

 From the patch set prior:
 > Agree we do nvme_fc* callbacks in deferred context, but without the 
xxx_IN_ISR flag during NVMe Target template registration, we were 
running into crash due to recursive spin_lock held as part of CTIO 
response in our driver.

Can you look into removing this recursive spin lock ?    I don't think 
it's a good idea to be holding a spin lock when upcalling the transport.

-- james
