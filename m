Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837D4C3F2CD
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 16:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50F0B21556
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 16:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCBQWs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 11:22:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:50274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgCBQWr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 11:22:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5442AAECE;
        Mon,  2 Mar 2020 16:22:45 +0000 (UTC)
Date:   Mon, 2 Mar 2020 17:22:44 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 1/4] qla2xxx: Use raw_smp_processor_id() where appropriate
Message-ID: <20200302162244.uo52axk2kxipur6m@beryllium.lan>
References: <20200302033023.27718-1-bvanassche@acm.org>
 <20200302033023.27718-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302033023.27718-2-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Sun, Mar 01, 2020 at 07:30:20PM -0800, Bart Van Assche wrote:
> This patch fixes e.g. the following kernel complaint:

[...]

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 5b2deaa730bf..582fc5dcc98c 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -8992,7 +8992,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
>  		qpair->rsp->req = qpair->req;
>  		qpair->rsp->qpair = qpair;
>  		/* init qpair to this cpu. Will adjust at run time. */
> -		qla_cpu_update(qpair, smp_processor_id());
> +		qla_cpu_update(qpair, raw_smp_processor_id());

When this is updated later anway, why not inializing with a invalid id
from beginning? Because using raw_smp_processor_id() is just silencing
the report without addressing the problem.

>  		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
>  			if (ha->fw_attributes & BIT_4)
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 8d7a905f6247..a5aae276fbb2 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3217,8 +3217,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>  	if (!ha->flags.fw_started)
>  		return;
>  
> -	if (rsp->qpair->cpuid != smp_processor_id())
> -		qla_cpu_update(rsp->qpair, smp_processor_id());
> +	if (rsp->qpair->cpuid != raw_smp_processor_id())
> +		qla_cpu_update(rsp->qpair, raw_smp_processor_id());

If I read it correctly, qla24xx_processor_response_queue() can be
called from either IRQ context or from a threading context. So that
means complaint that smp_processor_id() is used in preemptable context
is correct. So again this is just silencing it.

>  
>  	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
>  		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 622e7337affc..c4c6a8e1b46d 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4368,7 +4368,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
>  		queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq, &cmd->work);
>  	} else if (ha->msix_count) {
>  		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
> -			queue_work_on(smp_processor_id(), qla_tgt_wq,
> +			queue_work_on(raw_smp_processor_id(), qla_tgt_wq,

As I understand the code this is the main reason why the code tries to
figure out on which CPU it is running. The first part of the
processing happens either in IRQ context or in the threading context
in which qla24xx_process_response_queue() runs and now the second part
of the processing happens in the work queue. And this code tries to
stick the processing context on the same CPU to avoid cash trashing.

At creation time of the qpair queues, the CPU on which they should be
processed should be noted. And in this code path we just would look up
on which queue we are and which CPU should be used.

This would also avoid the qla_cpu_update() call in
qla24xx_process_response_queue().

So far the theory, I tried to figure out how to implement this scheme
but I'm still strungling with the code base.

Thanks,
Daniel
