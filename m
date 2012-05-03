From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] [SCSI] qla2xxx: qla2x00_probe_one kernel panic.
Date: Thu, 3 May 2012 07:38:06 -0400
Message-ID: <alpine.WNT.2.00.1205030736360.4316@N5102REMCQXM4BS.qlogic.org>
References: <1335975445-14595-1-git-send-email-jerry.hoemann@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1335975445-14595-1-git-send-email-jerry.hoemann@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Wed, 2 May 2012, Jerry Hoemann wrote:

> When qla2x00_probe_one fails, its back-out logic tries to free up
> resources already allocated.
>
> When qla2x00_probe_one fails at the steps for qla2x00_request_irqs
> or qla2x00_alloc_queues, it will call qla2x00_free_device.  This
> path eventually calls qla2x00_free_irqs which accesses ha->rsp_q_map.
> However, the rsp_q_map pointer hasn't been initialized yet.
>
> This causes a "NULL pointer dereference" panic.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c |    9 ++-------
> 1 files changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index a2f9992..7aeb5aa 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2420,7 +2420,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>       /* Set up the irqs */
>       ret = qla2x00_request_irqs(ha, rsp);
>       if (ret)
> -             goto probe_init_failed;
> +             goto probe_hw_failed;
>
>       pci_save_state(pdev);
>
> @@ -2429,7 +2429,7 @@ que_init:
>       if (!qla2x00_alloc_queues(ha)) {
>               ql_log(ql_log_fatal, base_vha, 0x003d,
>                   "Failed to allocate memory for queue pointers.. aborting.\n");
> -             goto probe_init_failed;
> +             goto probe_hw_failed;
>       }
>
>       ha->rsp_q_map[0] = rsp;
> @@ -2579,11 +2579,6 @@ skip_dpc:
>
>       return 0;
>
> -probe_init_failed:
> -     qla2x00_free_req_que(ha, req);
> -     qla2x00_free_rsp_que(ha, rsp);
> -     ha->max_req_queues = ha->max_rsp_queues = 0;
> -
> probe_failed:
>       if (base_vha->timer_active)
>               qla2x00_stop_timer(base_vha);
>

Hi Jerry,

Thanks for the patch.  We'll be sending a patch that fixes this issue soon
to the list.

--Chad

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
