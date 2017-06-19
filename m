From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 3/6] qla2xxx: Add FC-NVMe F/W initialization and transport
 registration
Date: Mon, 19 Jun 2017 14:22:51 -0700
Message-ID: <41e7e61c-b91c-b9f9-79df-0f196970d971@broadcom.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-4-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38454 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdFSVW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jun 2017 17:22:57 -0400
Received: by mail-wm0-f54.google.com with SMTP id u195so4196264wmd.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jun 2017 14:22:56 -0700 (PDT)
In-Reply-To: <20170616224744.3681-4-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

On 6/16/2017 3:47 PM, Himanshu Madhani wrote:
> From: Duane Grigsby <duane.grigsby@cavium.com>
>
> This code provides the interfaces to register remote and local ports
> of FC4 type 0x28 with the FC-NVMe transport and transports the
> requests (FC-NVMe FC link services and FC-NVMe commands IUs) to the
> fabric. It also provides the support for allocating h/w queues and
> aborting FC-NVMe FC requests.
>
> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
>
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +extern int nvme_fc_register_remoteport(struct nvme_fc_local_port *,
> +    struct nvme_fc_port_info *, struct nvme_fc_remote_port **);
> +extern int nvme_fc_register_localport(struct nvme_fc_port_info *,
> +    struct nvme_fc_port_template *, struct device *,
> +    struct nvme_fc_local_port **);
> +extern int nvme_fc_unregister_localport(struct nvme_fc_local_port *);
> +#endif

There should be no need for these. They are in the 
include/linux/nvme-fc-driver.h header.


> +static void qla_nvme_sp_ls_done(void *ptr, int res)
> +{
> +	srb_t *sp = ptr;
> +	struct srb_iocb *nvme;
> +	struct nvmefc_ls_req   *fd;
> +	struct nvme_private *priv;
> +
> +	if (atomic_read(&sp->ref_count) == 0) {
> +		ql_log(ql_log_warn, sp->fcport->vha, 0x2123,
> +		    "SP reference-count to ZERO on LS_done -- sp=%p.\n", sp);
> +		return;
> +	}
> +
> +	if (!atomic_dec_and_test(&sp->ref_count))
> +		return;
> +
> +	if (res)
> +		res = NVME_SC_FC_TRANSPORT_ERROR;

LS request failures status should be -Exxx values, not nvme status codes 
(which don't apply to LS's).
The api probably wasn't super clear on this.

> +
> +	nvme = &sp->u.iocb_cmd;
> +	fd = nvme->u.nvme.desc;
> +	priv = fd->private;
> +	priv->comp_status = res;
> +	schedule_work(&priv->ls_work);
> +	/* work schedule doesn't need the sp */
> +	qla2x00_rel_sp(sp);
> +}
> +
> +static void qla_nvme_sp_done(void *ptr, int res)
> +{
> +	srb_t *sp = ptr;
> +	struct srb_iocb *nvme;
> +	struct nvmefc_fcp_req *fd;
> +
> +	nvme = &sp->u.iocb_cmd;
> +	fd = nvme->u.nvme.desc;
> +
> +	if (!atomic_dec_and_test(&sp->ref_count))
> +		return;
> +
> +	if (!(sp->fcport->nvme_flag & NVME_FLAG_REGISTERED))
> +		goto rel;
> +
> +	if (unlikely((nvme->u.nvme.comp_status) || res))
> +		fd->status = NVME_SC_FC_TRANSPORT_ABORTED;
> +	else
> +		fd->status = 0;

FCP req failures status should be -Exxx values, not nvme status codes. 
This is clear in the api header.

-- james
