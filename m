From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] qla2x00t: Fix a memory leak in an error path
Date: Fri, 17 May 2013 14:03:47 +0200
Message-ID: <51961CA3.9060709@acm.org>
References: <F5D084D6342F9B479C34599BB0A03E4D3538B3ED@AVMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:48178 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3EQMDu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 May 2013 08:03:50 -0400
In-Reply-To: <F5D084D6342F9B479C34599BB0A03E4D3538B3ED@AVMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/17/13 07:00, Saurav Kashyap wrote:
> Instead of doing this I would move this check to the top of the function,
> something like this
> -----------------8<----------
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c
> b/drivers/scsi/qla2xxx/qla_bsg.c
> index 371bb86..b5f84ae 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -255,6 +255,12 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
>          int rval =  (DRIVER_ERROR << 16);
>          uint16_t nextlid = 0;
>
>
> +       if (!vha->flags.online) {
> +               ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
> +               rval = -EIO;
> +               goto done;
> +       }
> +
>          if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
>                  rport = bsg_job->rport;
>                  fcport = *(fc_port_t **) rport->dd_data;
> @@ -326,12 +332,6 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
>                          NPH_FABRIC_CONTROLLER : NPH_F_PORT;
>          }
>
>
> -       if (!vha->flags.online) {
> -               ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
> -               rval = -EIO;
> -               goto done;
> -       }
> -
>          req_sg_cnt =
>                  dma_map_sg(&ha->pdev->dev,
> bsg_job->request_payload.sg_list,
>                  bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
>
> ----------------8<---------

Hello Saurav,

I will update the patch, retest and repost it. Thanks for the feedback.

Bart.
