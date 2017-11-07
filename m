From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 1/4] qla2xxx_nvmet: Add files for FC-NVMe Target support
Date: Tue, 7 Nov 2017 09:05:38 -0800
Message-ID: <e24db463-4b2c-611a-ddef-e217fa23962a@broadcom.com>
References: <20171106195530.17408-1-himanshu.madhani@cavium.com>
 <20171106195530.17408-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:50219 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdKGRFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 12:05:41 -0500
Received: by mail-qk0-f180.google.com with SMTP id p7so2157169qkd.7
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2017 09:05:41 -0800 (PST)
In-Reply-To: <20171106195530.17408-2-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/6/2017 11:55 AM, Himanshu Madhani wrote:
> From: Anil Gurumurthy <anil.gurumurthy@cavium.com>
>
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
> +#endif
>

Do you really need the xxx_IN_ISR features ?  e.g. are you calling the 
nvmet_fc cmd receive and op done calls in ISR context or something that 
can't/shouldn't continue into the nvmet layers ?

I was looking to remove those flags and the work_q items behind it as I 
believed the qla2xxx driver called everything in a deferred callback.

-- james
