From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 33/47] cxlflash: use dedicated reset command in send_tmf()
Date: Wed, 28 Jun 2017 11:29:06 -0500
Message-ID: <73788589-5F91-499A-AD63-D9D02D2DBAC1@linux.vnet.ibm.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-34-git-send-email-hare@suse.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50945 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751587AbdF1Q3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 12:29:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5SGSiUI079473
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 12:29:14 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bccv0j4vw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 12:29:13 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Wed, 28 Jun 2017 10:29:12 -0600
In-Reply-To: <1498638793-44672-34-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Hi Hannes,

We actually just reworked these paths in a series that
was pulled in on Monday. While testing, I came across a
bug in that series and was planning on sending out a fix
for it. I'll include some patches that will ease the burden
of incorporating your EH updates for cxlflash.

Many thanks for leading this effort, it really helps to clean
up the SCSI EH paths! =)


-matt

> On Jun 28, 2017, at 3:32 AM, Hannes Reinecke <hare@suse.de> wrote:
> 
> From: Hannes Reinecke <hare@suse.com>
> 
> Reduce the queue depth by 1, and use this command as a dedicated
> reset command send_tmf().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
> drivers/scsi/cxlflash/common.h |  3 ++-
> drivers/scsi/cxlflash/main.c   | 23 ++++++++++++++++-------
> 2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
> index 6d95e8e..b2b3bdc 100644
> --- a/drivers/scsi/cxlflash/common.h
> +++ b/drivers/scsi/cxlflash/common.h
> @@ -54,7 +54,8 @@
> 
> /* Command management definitions */
> #define CXLFLASH_MAX_CMDS               256
> -#define CXLFLASH_MAX_CMDS_PER_LUN       CXLFLASH_MAX_CMDS
> +#define CXLFLASH_MAX_CMDS_PER_LUN       CXLFLASH_MAX_CMDS - 1
> +#define CXLFLASH_RESET_CMD              255
> 
> /* RRQ for master issued cmds */
> #define NUM_RRQ_ENTRY                   CXLFLASH_MAX_CMDS
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 462e8fc..b33e3e7 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -23,6 +23,7 @@
> 
> #include <scsi/scsi_cmnd.h>
> #include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> #include <uapi/scsi/cxlflash_ioctl.h>
> 
> #include "main.h"
> @@ -460,15 +461,16 @@ static u32 cmd_to_target_hwq(struct Scsi_Host *host, struct scsi_cmnd *scp,
> /**
>  * send_tmf() - sends a Task Management Function (TMF)
>  * @afu:	AFU to checkout from.
> - * @scp:	SCSI command from stack describing target.
> + * @sdev:	SCSI device to reset.
>  * @tmfcmd:	TMF command to send.
>  *
>  * Return:
>  *	0 on success, SCSI_MLQUEUE_HOST_BUSY or -errno on failure
>  */
> -static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
> +static int send_tmf(struct afu *afu, struct scsi_device *sdev, u64 tmfcmd)
> {
> -	struct Scsi_Host *host = scp->device->host;
> +	struct scsi_cmnd *scp;
> +	struct Scsi_Host *host = sdev->host;
> 	struct cxlflash_cfg *cfg = shost_priv(host);
> 	struct afu_cmd *cmd = NULL;
> 	struct device *dev = &cfg->dev->dev;
> @@ -498,14 +500,21 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
> 	cfg->tmf_active = true;
> 	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
> 
> +	scp = scsi_host_find_tag(host, CXLFLASH_RESET_CMD);
> +	scp->device = sdev;
> +	cmd = sc_to_afucz(scp);
> +	hwq_index = cmd_to_target_hwq(host, scp, afu);
> +	hwq = get_hwq(afu, hwq_index);
> +
> +	cmd->scp = scp;
> 	cmd->parent = afu;
> 	cmd->cmd_tmf = true;
> 	cmd->hwq_index = hwq_index;
> 
> 	cmd->rcb.ctx_id = hwq->ctx_hndl;
> 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
> -	cmd->rcb.port_sel = CHAN2PORTMASK(scp->device->channel);
> -	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
> +	cmd->rcb.port_sel = CHAN2PORTMASK(sdev->channel);
> +	cmd->rcb.lun_id = lun_to_lunid(sdev->lun);
> 	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
> 			      SISL_REQ_FLAGS_SUP_UNDERRUN |
> 			      SISL_REQ_FLAGS_TMF_CMD);
> @@ -2448,7 +2457,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
> retry:
> 	switch (cfg->state) {
> 	case STATE_NORMAL:
> -		rcr = send_tmf(afu, scp, TMF_LUN_RESET);
> +		rcr = send_tmf(afu, sdev, TMF_LUN_RESET);
> 		if (unlikely(rcr))
> 			rc = FAILED;
> 		break;
> @@ -3139,7 +3148,7 @@ static ssize_t mode_show(struct device *dev,
> 	.eh_host_reset_handler = cxlflash_eh_host_reset_handler,
> 	.change_queue_depth = cxlflash_change_queue_depth,
> 	.cmd_per_lun = CXLFLASH_MAX_CMDS_PER_LUN,
> -	.can_queue = CXLFLASH_MAX_CMDS,
> +	.can_queue = CXLFLASH_MAX_CMDS - 1,
> 	.cmd_size = sizeof(struct afu_cmd) + __alignof__(struct afu_cmd) - 1,
> 	.this_id = -1,
> 	.sg_tablesize = 1,	/* No scatter gather support */
> -- 
> 1.8.5.6
> 
